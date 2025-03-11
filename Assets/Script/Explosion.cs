using UnityEngine;

public class Explosion : MonoBehaviour
{
    public AnimationSpritesRender start;
    public AnimationSpritesRender middle;
    public AnimationSpritesRender end;

    public void SetActiveRenderer(AnimationSpritesRender renderer)
    {
        start.enabled = renderer == start;
        Debug.Log("start.enabled: " + start.enabled);
        middle.enabled = renderer == middle;
        end.enabled = renderer == end;
    }

    public void SetDirection(Vector2 direction)
    {
        float angle = Mathf.Atan2(direction.y, direction.x);
        transform.rotation = Quaternion.AngleAxis(angle * Mathf.Rad2Deg, Vector3.forward);
    }

    public void DestroyAfter(float seconds)
    {
        Destroy(gameObject,seconds);
    }
}
