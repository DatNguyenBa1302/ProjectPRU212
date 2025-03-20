using UnityEngine;

public class ItemPickup : MonoBehaviour
{
    private AudioManager audioManager;

    private void Awake()
    {
        audioManager = FindAnyObjectByType<AudioManager>();
    }
    public enum ItemType
	{
		ExtraBomb,
		BlastRadius,
		SpeedIncrease,
	}
	public ItemType type;

	private void OnItemPickup(GameObject player)
	{
		switch (type)
		{
			case ItemType.ExtraBomb:
				player.GetComponent<BombController>().AddBomb();
				break;
			case ItemType.BlastRadius:
				player.GetComponent<BombController>().explosionRadius++;
				break;
			case ItemType.SpeedIncrease:
				player.GetComponent<MovementController>().speed++;
				break;
		}
	}

	private void OnTriggerEnter2D(Collider2D other)
	{
		if (other.CompareTag("Player"))
		{
			audioManager.PlaySFX(audioManager.getItem);
			OnItemPickup(other.gameObject);
			Destroy(this.gameObject);
		}
	}
}
