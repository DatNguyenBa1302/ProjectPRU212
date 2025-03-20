using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;

public class BombController : MonoBehaviour
{
    [Header("Boom")]
    public GameObject bombPrefab;
    public KeyCode inputKey = KeyCode.Space;
    public float bombFuseTime = 3f;
    public int bombAmount = 1;
    public int bombsRemaining = 0;

    [Header("Explosion")]
    public Explosion explosionPrefab;
    public LayerMask explosionLayerMask;
    public float explosionDuration = 1;
    public int explosionRadius = 1;

    [Header("Destructible")]
    public Tilemap destructibleTiles;
    public Destructible destructiblePrefab;

	private HashSet<Vector2> bombPositions = new HashSet<Vector2>();
	private bool bombPlacementInProgress = false;
    private AudioManager audioManager;
    private void Awake()
    {
        audioManager = FindAnyObjectByType<AudioManager>();
    }

    private void OnEnable()
    {
        bombsRemaining = bombAmount;
    }

    private void Update()
    {
        if(Input.GetKeyDown(inputKey) && bombsRemaining > 0 && !bombPlacementInProgress) 
        {
            StartCoroutine(PlaceBomb());
        }
    }
	public void TriggerBomb()
	{
		if (bombsRemaining > 0 && !bombPlacementInProgress)
		{
			StartCoroutine(PlaceBomb());
		}
	}

	private IEnumerator PlaceBomb()
    {
        Vector2 position = transform.position;
        position.x = Mathf.Round(position.x);
        position.y = Mathf.Round(position.y);

		if (bombPositions.Contains(position))
		{
			yield break; // Dừng coroutine nếu vị trí đã có bom
		}

		GameObject bomb =  Instantiate(bombPrefab, position, Quaternion.identity);
		bombPositions.Add(position);
		bombsRemaining--;
        audioManager.PlaySFX(audioManager.bomb);

        yield return new WaitForSeconds(bombFuseTime);

        position = bomb.transform.position;
        position.x = Mathf.Round(position.x);
        position.y = Mathf.Round(position.y);

		int explosionID = Random.Range(0, int.MaxValue);

		Explosion explosion = Instantiate(explosionPrefab, position, Quaternion.identity);
		explosion.explosionOwner = "Player";
		explosion.SetActiveRenderer(explosion.start);
        explosion.DestroyAfter(explosionDuration);

        audioManager.PlaySFX(audioManager.boomBreak);

		Explode(position, Vector2.up, explosionRadius, explosionID);
		Explode(position, Vector2.down, explosionRadius, explosionID);
		Explode(position, Vector2.left, explosionRadius, explosionID);
		Explode(position, Vector2.right, explosionRadius, explosionID);

		bombPositions.Remove(position);

		Destroy(bomb);
        bombsRemaining++;   
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("Bomb"))
        {
            other.isTrigger = false;
        }
    } 

    private void Explode(Vector2 position, Vector2 direction, int length, int explosionID)
    {
        if (length <= 0)
        {
            return;
        }

        position += direction;

        if(Physics2D.OverlapBox(position, Vector2.one / 2f, 0f, explosionLayerMask))
        {
            
            ClearDestructible(position);
            return;
        }else
        {
            Explosion explosion = Instantiate(explosionPrefab, position, Quaternion.identity);
			explosion.explosionOwner = "Player";
			explosion.SetActiveRenderer(length > 1 ? explosion.middle : explosion.end);
            explosion.SetDirection(direction);
            explosion.DestroyAfter(explosionDuration);
        }

		Explode(position, direction, length - 1, explosionID);
	}

    private void ClearDestructible(Vector2 position)
    {
        Vector3Int cell = destructibleTiles.WorldToCell(position);
        TileBase tile = destructibleTiles.GetTile(cell);

        if(tile != null)
        {
            Instantiate(destructiblePrefab, position, Quaternion.identity);
            destructibleTiles.SetTile(cell, null);
        }
    }

    public void AddBomb()
    {
        bombAmount++;
        bombsRemaining++;   
    }
     
}
