using UnityEngine;

public class Destructible : MonoBehaviour
{
    public float destructionTime = 1f;

    [Range(0f, 1f)]
    public float itemSpawnChance = 0.2f;

    public GameObject[] spawnAbleItems;
    private void Start()
    {
        Destroy(gameObject, destructionTime);
    }

	private void OnDestroy()
	{
		if(spawnAbleItems.Length > 0 && Random.value < itemSpawnChance)
        {
            int randomIndex =  Random.Range(0,spawnAbleItems.Length);
            Instantiate(spawnAbleItems[randomIndex], transform.position, Quaternion.identity);
        }
	}
}
