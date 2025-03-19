using UnityEngine;
using UnityEngine.UI;

public class PlayerHealthBar : MonoBehaviour
{
	public MovementController Player;
	public Image healthBarTotal;
	public Image healthBarCurrent;
	// Start is called once before the first execution of Update after the MonoBehaviour is created
	void Start()
	{
		healthBarTotal.fillAmount = Player.currentHealth / 10f;
	}

	// Update is called once per frame
	void Update()
	{
		healthBarCurrent.fillAmount = Player.currentHealth / 10f;
	}
}
