using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class BossController : MonoBehaviour
{
	[Header("===== BOSS STATS =====")]
	public int maxHealth = 30;
	public int currentHealth;
	public bool isEnraged = false;
	public HealthBar healthBar;

	[Header("===== MOVEMENT =====")]
	public float normalSpeed = 2f;
	public float enragedSpeed = 4f;
	private float currentSpeed;
	public float obstacleCheckDistance = 1f;
	public LayerMask obstacleLayer;

	public float timeToChangeDirection = 2f;
	private float changeDirTimer;
	private Vector2 moveDirection;
	private Rigidbody2D rb;

	[Header("===== BOMB SETTINGS =====")]
	public GameObject bombPrefab;
	public float bombFuseTime = 2f;
	public int bombAmount = 2;
	public int enragedBombAmount = 4;
	private int bombsOnField = 0;

	public float minBombInterval = 2f;
	public float maxBombInterval = 5f;
	private float bombTimer;
	private float nextBombTime;
	public int normalExplosionRadius = 2;
	public int enragedExplosionRadius = 3;

	[Header("===== EXPLOSION SETTINGS =====")]
	public Explosion explosionPrefab;
	public LayerMask explosionLayerMask;
	public float explosionDuration = 1f;

	[Header("===== DESTRUCTIBLE SETTINGS =====")]
	public Tilemap destructibleTiles;
	public Destructible destructiblePrefab;

	[Header("===== PLAYER DETECT =====")]
	public Transform playerTransform;
	public float playerDetectRange = 4f;

	[Header("===== ANIMATION SETTINGS =====")]
	public AnimationSpritesRender spriteRenderUp;
	public AnimationSpritesRender spriteRenderDown;
	public AnimationSpritesRender spriteRenderLeft;
	public AnimationSpritesRender spriteRenderRight;
	public AnimationSpritesRender spriteRenderDeath;

	[Header("===== HIT ANIMATIONS =====")]
	public AnimationSpritesRender spriteRenderHitUp;
	public AnimationSpritesRender spriteRenderHitDown;
	public AnimationSpritesRender spriteRenderHitLeft;
	public AnimationSpritesRender spriteRenderHitRight;

	[Header("===== ENRAGED ANIMATION =====")]
	public AnimationSpritesRender spriteRenderEnraged;

	private AnimationSpritesRender activeSpriteRender;
	private Vector2 lastMoveDir; // Lưu hướng di chuyển cuối cùng
	private HashSet<int> explosionsHit = new HashSet<int>();
	private bool isEnragedAnimating = false;
	private bool isStunned = false;
	private bool isDead = false;
	private Vector2 targetCellPos;
	private bool isMovingToCell = false;


	void Start()
	{
		rb = GetComponent<Rigidbody2D>();

		healthBar = GetComponentInChildren<HealthBar>();
		currentHealth = maxHealth;
		healthBar.UpdateHealthBar(currentHealth, maxHealth);

		currentSpeed = normalSpeed;
		moveDirection = PickRandomDirection();

		DisableAllRenderers();
		activeSpriteRender = spriteRenderDown;
		activeSpriteRender.enabled = true;

		nextBombTime = Random.Range(minBombInterval, maxBombInterval);
	}

	void Update()
	{
		if (isDead) return;
		if (!isEnraged && currentHealth < maxHealth / 2)
		{
			EnterEnragedState();
		}

		if (!isEnragedAnimating)
		{
			changeDirTimer += Time.deltaTime;
			if (changeDirTimer >= timeToChangeDirection)
			{
				changeDirTimer = 0f;
				moveDirection = PickRandomDirection();
			}
		}

		MoveAndCheckObstacle();

		UpdateAnimation();

		bombTimer += Time.deltaTime;
		if (bombTimer >= nextBombTime)
		{
			TryPlaceBomb();
			bombTimer = 0f;
			nextBombTime = Random.Range(minBombInterval, maxBombInterval);
		}
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = collision.GetComponent<Explosion>();

			// Kiểm tra nếu vụ nổ là của Player thì mới nhận sát thương
			if (explosion != null && explosion.explosionOwner == "Player")
			{
				if (!explosionsHit.Contains(explosion.explosionID))
				{
					explosionsHit.Add(explosion.explosionID); // Thêm ID vụ nổ vào danh sách
					TakeDamage(1);
				}
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = collision.GetComponent<Explosion>();
			if (explosion != null)
			{
				explosionsHit.Remove(explosion.explosionID); // Loại bỏ ID vụ nổ khỏi danh sách
			}
		}
	}

	void MoveAndCheckObstacle()
	{
		if (isEnragedAnimating || isStunned || isDead) return;

		if (!isMovingToCell)
		{
			CircleCollider2D circleCollider = GetComponent<CircleCollider2D>();
			float radius = circleCollider ? circleCollider.radius : 0.5f;
			Vector2 checkPos = rb.position + moveDirection;

			RaycastHit2D hit = Physics2D.CircleCast(transform.position, radius, moveDirection, obstacleCheckDistance, obstacleLayer);
			if (hit.collider != null)
			{
				moveDirection = PickRandomDirection();
				return;
			}

			targetCellPos = new Vector2(Mathf.Round(checkPos.x), Mathf.Round(checkPos.y));
			isMovingToCell = true;
		}
		else
		{
			// Di chuyển từ từ đến ô đích
			Vector2 newPos = Vector2.MoveTowards(rb.position, targetCellPos, currentSpeed * Time.fixedDeltaTime);
			rb.MovePosition(newPos);

			if (Vector2.Distance(rb.position, targetCellPos) < 0.01f)
			{
				rb.MovePosition(targetCellPos);
				isMovingToCell = false; // tới ô đích thì kết thúc bước di chuyển
			}
		}
	}

	Vector2 PickRandomDirection()
	{
		int rand = Random.Range(0, 4);
		switch (rand)
		{
			case 0: return Vector2.up;
			case 1: return Vector2.down;
			case 2: return Vector2.left;
			default: return Vector2.right;
		}
	}

	void TryPlaceBomb()
	{
		if (isDead) return;
		int maxBombCanUse = isEnraged ? enragedBombAmount : bombAmount;
		if (bombsOnField >= maxBombCanUse) return;

		float distToPlayer = Vector2.Distance(playerTransform.position, transform.position);
		bool playerIsClose = distToPlayer <= playerDetectRange;

		float chance = playerIsClose ? 0.9f : 0.3f;
		if (Random.value <= chance)
		{
			StartCoroutine(PlaceBombRoutine());
		}
	}

	IEnumerator PlaceBombRoutine()
	{
		Vector2 placePos = transform.position;
		placePos.x = Mathf.Round(placePos.x);
		placePos.y = Mathf.Round(placePos.y);

		GameObject bomb = Instantiate(bombPrefab, placePos, Quaternion.identity);

		bombsOnField++;

		yield return new WaitForSeconds(bombFuseTime);

		Vector2 explosionPos = bomb.transform.position;

		int explosionID = Random.Range(0, int.MaxValue);

		Explosion explosion = Instantiate(explosionPrefab, explosionPos, Quaternion.identity);
		explosion.explosionID = explosionID;
		explosion.explosionOwner = "Boss"; // Đặt ID vụ nổ là của Boss
		explosion.SetActiveRenderer(explosion.start);
		explosion.DestroyAfter(explosionDuration);

		int explosionRange = isEnraged ? enragedExplosionRadius : normalExplosionRadius;
		Explode(explosionPos, Vector2.up, explosionRange, explosionID);
		Explode(explosionPos, Vector2.down, explosionRange, explosionID);
		Explode(explosionPos, Vector2.left, explosionRange, explosionID);
		Explode(explosionPos, Vector2.right, explosionRange, explosionID);

		Destroy(bomb);
		bombsOnField--;
	}
	void Explode(Vector2 pos, Vector2 direction, int length, int explosionID)
	{
		if (length <= 0) return;

		pos += direction;

		if (Physics2D.OverlapBox(pos, Vector2.one * 0.5f, 0f, explosionLayerMask))
		{
			ClearDestructible(pos);
			return;
		}

		Explosion exp = Instantiate(explosionPrefab, pos, Quaternion.identity);
		exp.explosionID = explosionID;  // Gán ID để nhận diện vụ nổ
		exp.SetActiveRenderer(length > 1 ? exp.middle : exp.end);
		exp.SetDirection(direction);
		exp.DestroyAfter(explosionDuration);

		Explode(pos, direction, length - 1, explosionID);
	}

	void ClearDestructible(Vector2 position)
	{
		Vector3Int cell = destructibleTiles.WorldToCell(position);
		TileBase tile = destructibleTiles.GetTile(cell);

		if (tile != null)
		{
			Instantiate(destructiblePrefab, position, Quaternion.identity);
			destructibleTiles.SetTile(cell, null); // Loại bỏ tile khỏi map
		}
	}

	void EnterEnragedState()
	{
		isEnraged = true;
		currentSpeed = enragedSpeed;

		if (spriteRenderEnraged)
		{
			isEnragedAnimating = true;
			DisableAllRenderers();
			spriteRenderEnraged.enabled = true;
			StartCoroutine(DisableEnragedEffect());
		}
	}

	IEnumerator DisableEnragedEffect()
	{
		yield return new WaitForSeconds(2f);
		spriteRenderEnraged.enabled = false;
		isEnragedAnimating = false;
	}

	public void TakeDamage(int damage)
	{
		if (isDead) return;
		currentHealth -= damage;
		healthBar.UpdateHealthBar(currentHealth, maxHealth);
		if (currentHealth <= 0)
		{
			healthBar.gameObject.SetActive(false);
			Die();
		}
		else
		{
			TriggerHitEffect();
		}
	}

	void Die()
	{
		if (isDead) return;  // Tránh gọi lại hàm Die nhiều lần
		isDead = true;

		DisableAllRenderers();
		spriteRenderDeath.enabled = true;
		Destroy(gameObject, 2f);
	}

	void TriggerHitEffect()
	{
		if (isEnragedAnimating) return;
		isStunned = true;
		Debug.Log("Đã vào hàm isStunned: " + isStunned);
		if (moveDirection == Vector2.up) SetActiveRenderer(spriteRenderHitUp);
		else if (moveDirection == Vector2.down) SetActiveRenderer(spriteRenderHitDown);
		else if (moveDirection == Vector2.left) SetActiveRenderer(spriteRenderHitLeft);
		else SetActiveRenderer(spriteRenderHitRight);

		StartCoroutine(EndHitEffect());
	}
	IEnumerator EndHitEffect()
	{
		yield return new WaitForSeconds(0.5f);  // Dừng trong 1 giây
		isStunned = false;
		ResetAnimation();
	}

	void UpdateAnimation()
	{
		if (isEnragedAnimating || isStunned) return;
		if (moveDirection == Vector2.up) SetActiveRenderer(spriteRenderUp);
		else if (moveDirection == Vector2.down) SetActiveRenderer(spriteRenderDown);
		else if (moveDirection == Vector2.left) SetActiveRenderer(spriteRenderLeft);
		else SetActiveRenderer(spriteRenderRight);
	}

	void ResetAnimation()
	{
		UpdateAnimation();
	}

	void SetActiveRenderer(AnimationSpritesRender newRenderer)
	{
		if (activeSpriteRender != null)
			activeSpriteRender.enabled = false;
		activeSpriteRender = newRenderer;
		activeSpriteRender.enabled = true;
		activeSpriteRender.idle = false;
	}

	void DisableAllRenderers()
	{
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;
		spriteRenderHitUp.enabled = false;
		spriteRenderHitDown.enabled = false;
		spriteRenderHitLeft.enabled = false;
		spriteRenderHitRight.enabled = false;
		spriteRenderDeath.enabled = false;
		spriteRenderEnraged.enabled = false;
	}
}
