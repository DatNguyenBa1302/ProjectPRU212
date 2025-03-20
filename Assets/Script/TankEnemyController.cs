using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TankEnemyController : MonoBehaviour
{
	public float speed = 3f;
	public float changeDirectionInterval = 2f; // Th?i gian ??i h??ng b?t ch?t
	public LayerMask obstacleLayer;

	[Header("Animation Sprite Renders")]
	public AnimationSpritesRender spriteRenderUp;
	public AnimationSpritesRender spriteRenderDown;
	public AnimationSpritesRender spriteRenderLeft;
	public AnimationSpritesRender spriteRenderRight;
	public AnimationSpritesRender spriteRenderDeath;
	private AnimationSpritesRender activeSpriteRender;

	private Rigidbody2D rb;
	private Vector2 currentDirection;
	private Vector2 targetCellPosition;
	private AnimationSpritesRender activeSprite;
	private float changeDirectionTimer;
	private bool isMovingToCell = false;
	private bool isDead = false;

	public HealthBar healthBar;
	private float health, maxHealth = 3f;


	private float damageCooldown = 0.5f; 
	private float lastDamageTime;

	private void Awake()
	{
		healthBar = GetComponentInChildren<HealthBar>();
	}
	void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		ChooseDirectionBasedOnEnvironment();
		changeDirectionTimer = changeDirectionInterval;
		health = maxHealth;
		healthBar.UpdateHealthBar(health, maxHealth);
	}

	void FixedUpdate()
	{
		if (isDead) return;

		if (!isMovingToCell)
		{
			// Chọn ô đích tiếp theo dựa trên hướng hiện tại
			if (!IsBlocked(currentDirection))
			{
				targetCellPosition = rb.position + currentDirection;
				targetCellPosition.x = Mathf.Round(targetCellPosition.x);
				targetCellPosition.y = Mathf.Round(targetCellPosition.y);
				isMovingToCell = true;
			}
			else
			{
				ChooseDirectionBasedOnEnvironment();
			}
		}
		else
		{
			Vector2 newPos = Vector2.MoveTowards(rb.position, targetCellPosition, speed * Time.fixedDeltaTime);
			rb.MovePosition(newPos);

			if (Vector2.Distance(rb.position, targetCellPosition) < 0.01f)
			{
				rb.MovePosition(targetCellPosition);
				isMovingToCell = false;
			}
		}

		// Đổi hướng ngẫu nhiên sau một khoảng thời gian
		changeDirectionTimer -= Time.fixedDeltaTime;
		if (changeDirectionTimer <= 0f && !isMovingToCell)
		{
			ChooseDirectionBasedOnEnvironment();
			changeDirectionTimer = changeDirectionInterval;
		}
	}

	// Ch?n h??ng di chuy?n d?a trên môi tr??ng xung quanh
	void ChooseDirectionBasedOnEnvironment()
	{
		List<Vector2> possibleDirections = new List<Vector2>();

		if (!IsBlocked(Vector2.up)) possibleDirections.Add(Vector2.up);
		if (!IsBlocked(Vector2.down)) possibleDirections.Add(Vector2.down);
		if (!IsBlocked(Vector2.left)) possibleDirections.Add(Vector2.left);
		if (!IsBlocked(Vector2.right)) possibleDirections.Add(Vector2.right);

		if (possibleDirections.Count == 0)
		{
			currentDirection = Vector2.zero; // Không có ???ng nào ? ??ng yên
		}
		else if (possibleDirections.Count == 1)
		{
			currentDirection = possibleDirections[0]; // Ch? còn 1 ???ng tr?ng ? ?i vào ngay
		}
		else
		{
			currentDirection = possibleDirections[Random.Range(0, possibleDirections.Count)]; // Ngã t? ? Ch?n h??ng ng?u nhiên
		}

		SetAnimationDirection(currentDirection);
	}

	bool IsBlocked(Vector2 direction)
	{
		RaycastHit2D hit = Physics2D.Raycast(rb.position, direction,1f, obstacleLayer);
		return hit.collider != null;
	}

	private void SetAnimationDirection(Vector2 dir)
	{
		// Vô hi?u hóa t?t c? sprite render tr??c
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;

		if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
		{
			if (dir.x > 0)
				activeSprite = spriteRenderRight;
			else
				activeSprite = spriteRenderLeft;
		}
		else
		{
			if (dir.y > 0)
				activeSprite = spriteRenderUp;
			else
				activeSprite = spriteRenderDown;
		}

		activeSprite.enabled = true;
		activeSprite.idle = false;
	}
	private void OnTriggerEnter2D(Collider2D other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = other.GetComponent<Explosion>();

			if (explosion != null && explosion.explosionOwner == "Player")
			{
				if (Time.time >= lastDamageTime + damageCooldown)
				{
					lastDamageTime = Time.time;
					health--;
					healthBar.UpdateHealthBar(health, maxHealth);

					if (health <= 0)
					{
						healthBar.gameObject.SetActive(false);
						DeathSequence();
					}
				}
				
			}
		}
	}
	

	private void DeathSequence()
	{
		enabled = false;
		//GetComponent<BombController>().enabled = false;

		spriteRenderDown.enabled = false;
		spriteRenderUp.enabled = false;
		spriteRenderRight.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderDeath.enabled = true;

		Invoke(nameof(OnDeathSequenceEnded), 1.25f);
	}

	private void OnDeathSequenceEnded()
	{
		gameObject.SetActive(false);
		FindObjectOfType<GameManager>().CheckWinState();
	}
}
