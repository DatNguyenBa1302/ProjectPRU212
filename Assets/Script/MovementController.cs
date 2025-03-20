using System;
using System.Collections;
using System.Security.Cryptography;
using Unity.VisualScripting;
using UnityEngine;

public class MovementController : MonoBehaviour
{
	public new Rigidbody2D rigidbody { get; private set; }
	private Vector2 direction = Vector2.down;
	public float speed = 5f;

	public KeyCode inputUp = KeyCode.W;
	public KeyCode inputDown = KeyCode.S;
	public KeyCode inputLeft = KeyCode.A;
	public KeyCode inputRight = KeyCode.D;

	public AnimationSpritesRender spriteRenderUp;
	public AnimationSpritesRender spriteRenderDown;
	public AnimationSpritesRender spriteRenderLeft;
	public AnimationSpritesRender spriteRenderRight;
	public AnimationSpritesRender spriteRenderDeath;
	private AnimationSpritesRender activeSpriteRender;

	public int currentHealth { get; set; }
	public int startingHealth;

	private float damageCooldown = 2f;
	private float lastDamageTime;
	private bool canMove = true;


	private Collider2D playerCollider;
	public void Awake()
	{
		rigidbody = GetComponent<Rigidbody2D>();
		playerCollider = GetComponent<Collider2D>();
		currentHealth = startingHealth;
		activeSpriteRender = spriteRenderDown;
	}

	private void Update()
	{
		if (!canMove)
		{
			// Đảm bảo animation ở trạng thái idle
			SetDirection(Vector2.zero, activeSpriteRender);
			return;
		}

		if (Input.GetKey(inputUp))
		{
			SetDirection(Vector2.up, spriteRenderUp);
		}
		else if (Input.GetKey(inputDown))
		{
			SetDirection(Vector2.down, spriteRenderDown);
		}
		else if (Input.GetKey(inputLeft))
		{
			SetDirection(Vector2.left, spriteRenderLeft);
		}
		else if (Input.GetKey(inputRight))
		{
			SetDirection(Vector2.right, spriteRenderRight);
		}
		else
		{
			SetDirection(Vector2.zero, activeSpriteRender);
		}
	}

	private void FixedUpdate()
	{
		Vector2 position = rigidbody.position;
		Vector2 translation = speed * Time.fixedDeltaTime * direction;

		rigidbody.MovePosition(position + translation);
	}

	public void SetDirection(Vector2 newDirection, AnimationSpritesRender animationSpritesRender)
	{
		direction = newDirection;

		spriteRenderUp.enabled = animationSpritesRender == spriteRenderUp;
		spriteRenderDown.enabled = animationSpritesRender == spriteRenderDown;
		spriteRenderLeft.enabled = animationSpritesRender == spriteRenderLeft;
		spriteRenderRight.enabled = animationSpritesRender == spriteRenderRight;

		activeSpriteRender = animationSpritesRender;
		activeSpriteRender.idle = direction == Vector2.zero;

	}

	private void OnTriggerEnter2D(Collider2D other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Explosion") || other.gameObject.layer == LayerMask.NameToLayer("Enermy"))
		{
			if (Time.time >= lastDamageTime + damageCooldown)
			{

				if (currentHealth > 0)
				{
					lastDamageTime = Time.time;
					currentHealth--;
					// Chỉ gọi chuỗi chết khi máu đã hết
					if (currentHealth <= 0)
					{
						DeathSequence();
					}
				}
				else
				{
					// Trường hợp đã hết máu
					DeathSequence();
				}
			}

		}
	}
	private void OnCollisionEnter2D(Collision2D other)
	{
		if (other.gameObject.layer == LayerMask.NameToLayer("Enermy"))
		{
			if (Time.time >= lastDamageTime + damageCooldown)
			{
				lastDamageTime = Time.time;
				playerCollider.isTrigger = true; // cho đi xuyên tạm
				TakeDamage(1);

				if (currentHealth > 0)
				{
					// Nếu chưa chết, tự bật tắt collider lại
					StartCoroutine(TurnOnTrigger());
				}
			}
		}
	}
	private void TakeDamage(int amount)
	{
		currentHealth -= amount;

		// Gọi stun 0.5s mỗi lần dính đòn
		StartCoroutine(DisableMovement(0.5f));

		// Nếu máu hết => DeathSequence
		if (currentHealth <= 0)
		{
			playerCollider.isTrigger = true; // tránh kẹt
			DeathSequence();
		}
	}

	private IEnumerator TurnOnTrigger()
	{
		yield return new WaitForSeconds(0.5f);
		playerCollider.isTrigger = false;
	}

	private IEnumerator DisableMovement(float duration)
	{
		canMove = false;
		direction = Vector2.zero; 
		yield return new WaitForSeconds(duration);
		canMove = true;
	}


	private void DeathSequence()
	{
		enabled = false;
		GetComponent<BombController>().enabled = false;

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
