using System;
using UnityEngine;

public class MovementController : MonoBehaviour
{
    public new Rigidbody2D rigidbody {  get; private set; }
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
    private AnimationSpritesRender activeSpriteRender;
    public void Awake()
    {
        rigidbody = GetComponent<Rigidbody2D>();
        activeSpriteRender = spriteRenderDown;
    }

    private void Update()
    {
        if(Input.GetKey(inputUp)) 
        {
            SetDirection(Vector2.up, spriteRenderUp);
        }else if(Input.GetKey(inputDown))
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
            SetDirection(Vector2.zero,activeSpriteRender);
        }
    }

    private void FixedUpdate()
    {
        Vector2 position = rigidbody.position;
        Vector2 translation = speed * Time.fixedDeltaTime * direction;

        rigidbody.MovePosition(position + translation);
    }

    private void SetDirection(Vector2 newDirection, AnimationSpritesRender animationSpritesRender)
    {
        direction = newDirection;

        spriteRenderUp.enabled = animationSpritesRender == spriteRenderUp;
        spriteRenderDown.enabled = animationSpritesRender == spriteRenderDown;
        spriteRenderLeft.enabled = animationSpritesRender == spriteRenderLeft;
        spriteRenderRight.enabled = animationSpritesRender == spriteRenderRight;

        activeSpriteRender = animationSpritesRender;
        activeSpriteRender.idle = direction == Vector2.zero;

    }
}
