using UnityEngine;

public class AnimationSpritesRender : MonoBehaviour
{
    private SpriteRenderer spriteRender;

    public Sprite idleSprite;
    public Sprite[] animationSprites;
    public float animationTime = 0.25f;
    private int animationFrame;

    public bool loop = true;
    public bool idle = true;
    public void Awake()
    {
        spriteRender = GetComponent<SpriteRenderer>();

    }

    private void OnEnable()
    {
        spriteRender.enabled = true;
    }
    private void OnDisable()
    {
        spriteRender.enabled = false;
    }
    private void Start()
    {
        InvokeRepeating(nameof(NextFrame), animationTime, animationTime);
    }

    private void NextFrame()
    {
        animationFrame++;
        if(loop && animationFrame >= animationSprites.Length) 
        {
            animationFrame = 0;
        }
        if (idle)
        {
            spriteRender.sprite = idleSprite;
        }else if(animationFrame >= 0 && animationFrame < animationSprites.Length) { }
        {
            spriteRender.sprite = animationSprites[animationFrame];
        }
    }
}
