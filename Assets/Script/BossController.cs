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

	// Thay thế logic cũ bằng logic di chuyển "từng ô"
	public float timeToChangeDirection = 2f;
	private float changeDirTimer;
	private Vector2 moveDirection;       // hướng đang đi
	private Vector2 targetCellPos;       // ô đích đang hướng tới
	private bool isMovingToCell = false; // đang di chuyển đến ô đích?

	[Header("===== BOMB SETTINGS =====")]
	public GameObject bombPrefab;
	public float bombFuseTime = 2f;
	public int bombAmount = 3;
	public int enragedBombAmount = 6;
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

	// Các biến hỗ trợ
	private AnimationSpritesRender activeSpriteRender;
	private Rigidbody2D rb;
	private bool isEnragedAnimating = false;
	private bool isStunned = false;
	private bool isDead = false;
	private float damageCooldown = 0.5f;
	private float lastDamageTime;

	void Start()
	{
		rb = GetComponent<Rigidbody2D>();

		// Set HP & HealthBar
		currentHealth = maxHealth;
		healthBar.UpdateHealthBar(currentHealth, maxHealth);

		// Tốc độ hiện tại = normalSpeed (chờ enraged sau)
		currentSpeed = normalSpeed;

		// Thiết lập animation ban đầu
		DisableAllRenderers();
		activeSpriteRender = spriteRenderDown;
		activeSpriteRender.enabled = true;

		// Timer đổi hướng lần đầu
		changeDirTimer = timeToChangeDirection;

		// Chọn hướng lần đầu
		ChooseDirectionBasedOnEnvironment();

		// Hẹn giờ đặt bom
		nextBombTime = Random.Range(minBombInterval, maxBombInterval);
	}

	void Update()
	{
		// Đặt bom
		bombTimer += Time.deltaTime;
		if (bombTimer >= nextBombTime)
		{
			TryPlaceBomb();
			bombTimer = 0f;
			nextBombTime = Random.Range(minBombInterval, maxBombInterval);
		}
		if (isDead) 
			return;
		


		// Kiểm tra Enraged
		if (!isEnraged && currentHealth < maxHealth / 2)
		{
			EnterEnragedState();
		}
		// Animation (chỉ cập nhật sprite - di chuyển để trong FixedUpdate)
		UpdateAnimation();
	}

	// => Chuyển logic di chuyển sang FixedUpdate (giống TankEnemyController)
	void FixedUpdate()
	{
		if (isDead || isEnragedAnimating || isStunned) return;

		// Cập nhật tốc độ (dựa trên enraged?)
		currentSpeed = isEnraged ? enragedSpeed : normalSpeed;

		// Nếu chưa di chuyển đến ô nào
		if (!isMovingToCell)
		{
			// Kiểm tra hướng hiện tại có bị chặn không
			if (!IsBlocked(moveDirection))
			{
				// Tính ô đích (targetCellPos)
				targetCellPos = rb.position + moveDirection;
				targetCellPos.x = Mathf.Round(targetCellPos.x);
				targetCellPos.y = Mathf.Round(targetCellPos.y);

				isMovingToCell = true;
			}
			else
			{
				// Nếu bị chặn => chọn hướng khác
				ChooseDirectionBasedOnEnvironment();
			}
		}
		else
		{
			// Đang di chuyển đến ô đích -> di chuyển từ từ
			Vector2 newPos = Vector2.MoveTowards(
				rb.position,
				targetCellPos,
				currentSpeed * Time.fixedDeltaTime
			);
			rb.MovePosition(newPos);

			// Khi tới rất sát ô đích => "chốt" vị trí & cho phép chọn hướng mới
			if (Vector2.Distance(rb.position, targetCellPos) < 0.01f)
			{
				rb.MovePosition(targetCellPos);
				isMovingToCell = false;
			}
		}

		// Giảm timer, nếu hết thời gian => thử chọn hướng mới
		changeDirTimer -= Time.fixedDeltaTime;
		if (changeDirTimer <= 0f && !isMovingToCell)
		{
			ChooseDirectionBasedOnEnvironment();
			changeDirTimer = timeToChangeDirection;
		}
	}

	void ChooseDirectionBasedOnEnvironment()
	{
		List<Vector2> possibleDirections = new List<Vector2>();

		if (!IsBlocked(Vector2.up)) possibleDirections.Add(Vector2.up);
		if (!IsBlocked(Vector2.down)) possibleDirections.Add(Vector2.down);
		if (!IsBlocked(Vector2.left)) possibleDirections.Add(Vector2.left);
		if (!IsBlocked(Vector2.right)) possibleDirections.Add(Vector2.right);

		if (possibleDirections.Count == 0)
		{
			// Không thể đi hướng nào => đứng yên
			moveDirection = Vector2.zero;
		}
		else if (possibleDirections.Count == 1)
		{
			// Chỉ còn 1 hướng => đi thẳng
			moveDirection = possibleDirections[0];
		}
		else
		{
			// Nhiều hướng => random
			moveDirection = possibleDirections[Random.Range(0, possibleDirections.Count)];
		}
	}


	bool IsBlocked(Vector2 direction)
	{
		if (direction == Vector2.zero) return false; // Không có hướng => không clear

		// Giả sử boss có kích thước 3x3 và mỗi ô có kích thước 1 đơn vị,
		// ta dùng offset = 1 để dịch sang trái và phải.
		float offset = 1f;

		// Lấy vị trí tâm của boss
		Vector2 centerOrigin = transform.position;
		centerOrigin.y = centerOrigin.y - 1;

		// Tính các vị trí bắn ray:
		// Nếu boss di chuyển theo 'direction', các ray sẽ được bắn từ:
		// - trung tâm,
		// - bên trái: dịch sang trái theo hướng ngang của boss (transform.right)
		// - bên phải: dịch sang phải theo hướng ngang của boss (transform.right)
		Vector2 leftOrigin = centerOrigin - (Vector2)transform.right * offset;
		Vector2 rightOrigin = centerOrigin + (Vector2)transform.right * offset;

		// Bắn ray từ 3 vị trí theo cùng 1 hướng với khoảng cách obstacleCheckDistance
		bool centerClear = Physics2D.Raycast(centerOrigin, direction, obstacleCheckDistance, obstacleLayer).collider != null;
		bool leftClear = Physics2D.Raycast(leftOrigin, direction, obstacleCheckDistance, obstacleLayer).collider != null;
		bool rightClear = Physics2D.Raycast(rightOrigin, direction, obstacleCheckDistance, obstacleLayer).collider != null;

		/*Debug.Log("direction  " + direction);
		Debug.Log("centerOrigin " + centerOrigin);
		Debug.Log("leftOrigin " + leftOrigin);
		Debug.Log("rightOrigin " + rightOrigin);
		Debug.Log("centerClear " + centerClear);
		Debug.Log("leftClear " + leftClear);
		Debug.Log("rightClear " + rightClear);
		Debug.DrawRay(centerOrigin, direction * obstacleCheckDistance, Color.red);
		Debug.DrawRay(leftOrigin, direction * obstacleCheckDistance, Color.red);
		Debug.DrawRay(rightOrigin, direction * obstacleCheckDistance, Color.red);*/
		return centerClear || leftClear || rightClear;
		
	}

	void UpdateAnimation()
	{
		if (isEnragedAnimating || isStunned) return;

		// Tùy theo moveDirection để đặt renderer
		if (moveDirection == Vector2.up) SetActiveRenderer(spriteRenderUp);
		else if (moveDirection == Vector2.down) SetActiveRenderer(spriteRenderDown);
		else if (moveDirection == Vector2.left) SetActiveRenderer(spriteRenderLeft);
		else if (moveDirection == Vector2.right) SetActiveRenderer(spriteRenderRight);
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

	// Enraged
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

	// Đặt bom
	void TryPlaceBomb()
	{
		//if (isDead) return;

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
		// Lấy vị trí của Boss làm trụ sở đặt bom, làm tròn để đảm bảo khớp với lưới
		Vector2 placePos = transform.position;
		placePos.x = Mathf.Round(placePos.x);
		placePos.y = Mathf.Round(placePos.y);

		// Tạo danh sách lưu các bom được instantiate
		List<GameObject> bombList = new List<GameObject>();

		// Giả sử boss đặt 3 quả bom theo hàng dọc, với mỗi ô cách nhau 1 đơn vị.
		// Vị trí: dưới, giữa, trên (offset -1, 0, +1 trên trục Y)
		for (int i = -1; i <= 1; i++)
		{
			Vector2 bombPos = placePos + new Vector2(0, i);
			GameObject bomb = Instantiate(bombPrefab, bombPos, Quaternion.identity);
			bombList.Add(bomb);
			bombsOnField++;
		}

		// Chờ thời gian hoà nổ của bom
		yield return new WaitForSeconds(bombFuseTime);

		int explosionRange = isEnraged ? enragedExplosionRadius : normalExplosionRadius;

		// Với từng quả bom, thực hiện hiệu ứng nổ
		foreach (GameObject bomb in bombList)
		{
			Vector2 explosionPos = bomb.transform.position;

			// Tạo vụ nổ trung tâm tại vị trí của bom
			Explosion centerExp = Instantiate(explosionPrefab, explosionPos, Quaternion.identity);
			centerExp.explosionOwner = "Boss";
			centerExp.SetActiveRenderer(centerExp.start);
			centerExp.DestroyAfter(explosionDuration);

			// Lan vụ nổ theo 4 hướng
			Explode(explosionPos, Vector2.up, explosionRange);
			Explode(explosionPos, Vector2.down, explosionRange);
			Explode(explosionPos, Vector2.left, explosionRange);
			Explode(explosionPos, Vector2.right, explosionRange);

			Destroy(bomb);
			bombsOnField--;
		}
	}

	void Explode(Vector2 pos, Vector2 direction, int length)
	{
		if (length <= 0) return;
		pos += direction;

		// Nếu trúng tile cản/hết => dừng
		if (Physics2D.OverlapBox(pos, Vector2.one * 0.5f, 0f, explosionLayerMask))
		{
			ClearDestructible(pos);
			return;
		}

		Explosion exp = Instantiate(explosionPrefab, pos, Quaternion.identity);
		if (length > 1)
			exp.SetActiveRenderer(exp.middle);
		else
			exp.SetActiveRenderer(exp.end);

		exp.SetDirection(direction);
		exp.DestroyAfter(explosionDuration);

		Explode(pos, direction, length - 1);
	}

	void ClearDestructible(Vector2 position)
	{
		Vector3Int cell = destructibleTiles.WorldToCell(position);
		TileBase tile = destructibleTiles.GetTile(cell);

		if (tile != null)
		{
			Instantiate(destructiblePrefab, position, Quaternion.identity);
			destructibleTiles.SetTile(cell, null);
		}
	}

	// Boss nhận damage
	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = collision.GetComponent<Explosion>();

			// Boss chỉ nhận damage nếu explosionOwner = Player
			if (explosion != null && explosion.explosionOwner == "Player")
			{
				if (Time.time >= lastDamageTime + damageCooldown)
				{
					lastDamageTime = Time.time;
					TakeDamage(1);
				}
			}
		}
	}

	public void TakeDamage(int damage)
	{
		if (isDead) return;
		currentHealth -= damage;
		healthBar.UpdateHealthBar(currentHealth, maxHealth);

		if (currentHealth <= 0)
		{
			healthBar.gameObject.SetActive(false);
			DeathSequence();
		}
		else
		{
			TriggerHitEffect();
		}
	}

	private void DeathSequence()
	{
		enabled = false;
		if (isDead) return;
		isDead = true;

		DisableAllRenderers();
		spriteRenderDeath.enabled = true;

		Invoke(nameof(OnDeathSequenceEnded), 1.25f);
	}

	private void OnDeathSequenceEnded()
	{
		gameObject.SetActive(false);
		FindObjectOfType<GameManager>().CheckWinState();
	}

	void TriggerHitEffect()
	{
		// Mỗi lần trúng đạn => tạm stun + hiển thị sprite trúng
		isStunned = true;

		if (moveDirection == Vector2.up) SetActiveRenderer(spriteRenderHitUp);
		else if (moveDirection == Vector2.down) SetActiveRenderer(spriteRenderHitDown);
		else if (moveDirection == Vector2.left) SetActiveRenderer(spriteRenderHitLeft);
		else SetActiveRenderer(spriteRenderHitRight);

		StartCoroutine(EndHitEffect());
	}

	System.Collections.IEnumerator EndHitEffect()
	{
		yield return new WaitForSeconds(0.5f);
		isStunned = false;
		UpdateAnimation(); // phục hồi sprite di chuyển
	}
}
