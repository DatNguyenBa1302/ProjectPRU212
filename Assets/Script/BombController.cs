using System.Collections;
using UnityEngine;

public class NewMonoBehaviourScript : MonoBehaviour
{
    public GameObject bombPrefab;
    public KeyCode inputKey = KeyCode.Space;
    public float bombFuseTime = 3f;
    public int bombAmount = 1;

    private int bombsRemaining = 0;

    private void OnEnable()
    {
        bombsRemaining = bombAmount;
    }

    private void Update()
    {
        if(Input.GetKeyDown(inputKey) && bombsRemaining > 0) 
        {
            StartCoroutine(PlaceBomb());
        }
    }

    private IEnumerator PlaceBomb()
    {
        Vector2 position = transform.position;
        position.x = Mathf.Round(position.x);
        position.y = Mathf.Round(position.y);

        GameObject bomb =  Instantiate(bombPrefab, position, Quaternion.identity);
        bombsRemaining--;

        yield return new WaitForSeconds(bombFuseTime);

        Destroy(bomb );
        bombsRemaining++;   
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("Bomb"))
        {
            other.isTrigger = false;
        }
    }
     
}
