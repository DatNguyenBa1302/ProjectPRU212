using UnityEngine;

public class ChasingEnemyController : MonoBehaviour
{
	private AudioManager audioManager;
	public float speed = 3f;
	public float chaseSpeed = 4.5f;
	public float detectionRange = 5f;
	public LayerMask obstacleLayer;

	[Header("Animation Sprite Renders")]
	public AnimationSpritesRender spriteRenderUp;
	public AnimationSpritesRender spriteRenderDown;
	public AnimationSpritesRender spriteRenderLeft;
	public AnimationSpritesRender spriteRenderRight;

	[Header("Chasing Mode Sprites")]
	public AnimationSpritesRender spriteRenderChaseUp;
	public AnimationSpritesRender spriteRenderChaseDown;
	public AnimationSpritesRender spriteRenderChaseLeft;
	public AnimationSpritesRender spriteRenderChaseRight;

	[Header("Death Animation")]
	public AnimationSpritesRender spriteRenderDeath;

	[Header("Patrol Path")]
	public Transform[] patrolPoints;
	private int currentPointIndex = 0;
	private bool reversePath = false;

	private Rigidbody2D rb;
	private Vector2 currentDirection;
	private AnimationSpritesRender activeSprite;

	private Transform player;
	private bool isChasing = false;
	private bool lostPlayer = false;

	private float stuckTimer = 0f;
	private const float stuckThreshold = 1f;

    private void Awake()
    {
        audioManager = GameObject.FindGameObjectWithTag("Audio").GetComponent<AudioManager>();
    }

    void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		player = GameObject.FindGameObjectWithTag("Player").transform;

		GoToNextPatrolPoint();
	}

	void FixedUpdate()
	{
		float speedToUse = isChasing ? chaseSpeed : speed;

		if (currentDirection != Vector2.zero)
		{
			Vector2 newPosition = rb.position + currentDirection * speedToUse * Time.fixedDeltaTime;

			if (!IsBlocked(newPosition))
			{
				rb.MovePosition(newPosition);
				stuckTimer = 0f;
			}
			else
			{
				stuckTimer += Time.fixedDeltaTime;
				if (stuckTimer >= stuckThreshold)
				{
					TryChangeDirection();
					stuckTimer = 0f;
				}
			}
		}

		if (player != null && player.gameObject.activeInHierarchy && Vector2.Distance(transform.position, player.position) <= detectionRange)
		{
			isChasing = true;
			lostPlayer = false;
			ChasePlayer();
		}
		else
		{
			if (isChasing)
			{
				isChasing = false;
				lostPlayer = true;
			}

			if (lostPlayer)
			{
				ReturnToClosestPatrolPoint();
			}
			else
			{
				Patrol();
			}
		}
	}

	void Patrol()
	{
		Transform targetPoint = patrolPoints[currentPointIndex];
		currentDirection = GetDirectionToTarget(targetPoint.position);

		if (Vector2.Distance(transform.position, targetPoint.position) < 0.2f)
		{
			if (!reversePath)
			{
				if (currentPointIndex == patrolPoints.Length - 1)
				{
					reversePath = true;
					currentPointIndex--;
				}
				else
				{
					currentPointIndex++;
				}
			}
			else
			{
				if (currentPointIndex == 0)
				{
					reversePath = false;
					currentPointIndex++;
				}
				else
				{
					currentPointIndex--;
				}
			}

			GoToNextPatrolPoint();
		}
	}

	void GoToNextPatrolPoint()
	{
		Transform nextPoint = patrolPoints[currentPointIndex];
		currentDirection = GetDirectionToTarget(nextPoint.position);

		SetAnimationDirection(currentDirection);
	}

	void ChasePlayer()
	{
		currentDirection = GetDirectionToTarget(player.position);
		SetAnimationDirection(currentDirection);
	}

	void ReturnToClosestPatrolPoint()
	{
		Transform closestPoint = GetClosestPatrolPoint();
		Vector2 desiredDirection = GetDirectionToTarget(closestPoint.position);

		// Nếu đường trực tiếp bị chặn, thử tìm hướng khác gần với mục tiêu
		if (IsBlocked(rb.position + desiredDirection))
		{
			TryChangeDirectionForTarget(closestPoint.position);
		}
		else
		{
			currentDirection = desiredDirection;
		}

		// Nếu đã đến gần điểm mục tiêu, kết thúc trạng thái lostPlayer
		if (Vector2.Distance(transform.position, closestPoint.position) < 0.2f)
		{
			lostPlayer = false;
		}

		SetAnimationDirection(currentDirection);
	}

	// Hàm này thử các hướng (up, down, left, right) và chọn hướng nào đưa con quái về gần target nhất.
	void TryChangeDirectionForTarget(Vector2 targetPosition)
	{
		Vector2[] directions = { Vector2.up, Vector2.down, Vector2.left, Vector2.right };
		Vector2 bestDirection = Vector2.zero;
		float bestDistance = float.MaxValue;

		foreach (var direction in directions)
		{
			// Kiểm tra nếu không bị chặn ở hướng này
			if (!IsBlocked(rb.position + direction))
			{
				float dist = Vector2.Distance((Vector2)transform.position + direction, targetPosition);
				if (dist < bestDistance)
				{
					bestDistance = dist;
					bestDirection = direction;
				}
			}
		}

		if (bestDirection != Vector2.zero)
			currentDirection = bestDirection;
		else
			currentDirection = -currentDirection; // Nếu tất cả hướng đều bị chặn, quay lại hướng ngược lại
	}

	Transform GetClosestPatrolPoint()
	{
		Transform closestPoint = patrolPoints[0];
		float closestDistance = Vector2.Distance(transform.position, closestPoint.position);

		foreach (var point in patrolPoints)
		{
			float distance = Vector2.Distance(transform.position, point.position);
			if (distance < closestDistance)
			{
				closestDistance = distance;
				closestPoint = point;
			}
		}

		return closestPoint;
	}

	Vector2 GetDirectionToTarget(Vector2 targetPosition)
	{
		Vector2 direction = targetPosition - rb.position;

		if (Mathf.Abs(direction.x) > Mathf.Abs(direction.y))
		{
			return direction.x > 0 ? Vector2.right : Vector2.left;
		}
		else
		{
			return direction.y > 0 ? Vector2.up : Vector2.down;
		}
	}
	bool IsBlocked(Vector2 targetPosition)
	{
		RaycastHit2D hit = Physics2D.Raycast(rb.position, targetPosition - rb.position, 0.5f, obstacleLayer);
		return hit.collider != null;
	}

	void TryChangeDirection()
	{
		Vector2[] directions = { Vector2.up, Vector2.down, Vector2.left, Vector2.right };

		foreach (var direction in directions)
		{
			Vector2 newPos = rb.position + direction;

			if (!IsBlocked(newPos))
			{
				currentDirection = direction;
				SetAnimationDirection(currentDirection);
				return;
			}
		}

		currentDirection = -currentDirection;
		SetAnimationDirection(currentDirection);
	}

	private void SetAnimationDirection(Vector2 dir)
	{
		DisableAllSprites();

		activeSprite = dir.y > 0 ? spriteRenderUp :
					  dir.y < 0 ? spriteRenderDown :
					  dir.x > 0 ? spriteRenderRight : spriteRenderLeft;

		activeSprite.enabled = true;
		activeSprite.idle = false;
	}

	private void DisableAllSprites()
	{
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;

		spriteRenderChaseUp.enabled = false;
		spriteRenderChaseDown.enabled = false;
		spriteRenderChaseLeft.enabled = false;
		spriteRenderChaseRight.enabled = false;

		spriteRenderDeath.enabled = false;
	}
	private void OnTriggerEnter2D(Collider2D other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = other.GetComponent<Explosion>();

			if (explosion != null && explosion.explosionOwner == "Player")
			{
                if (audioManager != null && audioManager.ghost != null)
                {
                    audioManager.PlaySFX(audioManager.ghost);
                }
                DeathSequence();
			}
		}
	}

	private void DeathSequence()
	{
		enabled = false;
		//GetComponent<BombController>().enabled = false;

		DisableAllSprites();
		spriteRenderDeath.enabled = true;

		Invoke(nameof(OnDeathSequenceEnded), 1.25f);
	}

	private void OnDeathSequenceEnded()
	{
		gameObject.SetActive(false);
		FindObjectOfType<GameManager>().CheckWinState();
	}

}
