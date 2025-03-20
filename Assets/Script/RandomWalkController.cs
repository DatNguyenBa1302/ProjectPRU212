using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomWalkController : MonoBehaviour
{
	private AudioManager audioManager;
	public float speed = 3f;
	public float changeDirectionInterval = 2f;
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
	private float changeDirectionTimer;
	private bool isMovingToCell = false;
	private bool isDead = false;

    public void Awake()
    {
        audioManager = GameObject.FindGameObjectWithTag("Audio").GetComponent<AudioManager>();
    }

    void Start()
	{
		rb = GetComponent<Rigidbody2D>();

		// Làm tròn vị trí ban đầu về đúng ô Tilemap
		Vector2 startPos = rb.position;
		startPos.x = Mathf.Round(startPos.x);
		startPos.y = Mathf.Round(startPos.y);
		rb.position = startPos;

		ChooseDirectionBasedOnEnvironment();
		changeDirectionTimer = changeDirectionInterval;
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

	void ChooseDirectionBasedOnEnvironment()
	{
		List<Vector2> possibleDirections = new List<Vector2>();

		if (!IsBlocked(Vector2.up)) possibleDirections.Add(Vector2.up);
		if (!IsBlocked(Vector2.down)) possibleDirections.Add(Vector2.down);
		if (!IsBlocked(Vector2.left)) possibleDirections.Add(Vector2.left);
		if (!IsBlocked(Vector2.right)) possibleDirections.Add(Vector2.right);

		if (possibleDirections.Count == 0)
		{
			currentDirection = Vector2.zero;
		}
		else if (possibleDirections.Count == 1)
		{
			currentDirection = possibleDirections[0];
		}
		else
		{
			currentDirection = possibleDirections[Random.Range(0, possibleDirections.Count)];
		}

		SetAnimationDirection(currentDirection);
	}

	bool IsBlocked(Vector2 direction)
	{
		RaycastHit2D hit = Physics2D.Raycast(rb.position, direction, 0.8f, obstacleLayer);
		return hit.collider != null;
	}

	private void SetAnimationDirection(Vector2 dir)
	{
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;

		if (dir == Vector2.zero) return;

		if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
		{
			activeSpriteRender = dir.x > 0 ? spriteRenderRight : spriteRenderLeft;
		}
		else
		{
			activeSpriteRender = dir.y > 0 ? spriteRenderUp : spriteRenderDown;
		}

		activeSpriteRender.enabled = true;
		activeSpriteRender.idle = false;
	}
	private void OnTriggerEnter2D(Collider2D other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Explosion"))
		{
			Explosion explosion = other.GetComponent<Explosion>();

			if (explosion != null && explosion.explosionOwner == "Player")
			{
                if (audioManager != null && audioManager.random != null)
                {
                    audioManager.PlaySFX(audioManager.random);
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

	private void DisableAllSprites()
	{
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;

		spriteRenderDeath.enabled = false;
	}
}
