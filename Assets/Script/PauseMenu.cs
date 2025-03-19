using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
	public GameObject pauseMenu;

	void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			pauseMenu.SetActive(true);
			Time.timeScale = 0.0f;
		}
	}

	public void Home()
	{
		SceneManager.LoadScene(0);
		Time.timeScale = 1.0f;
	}

	public void Resume()
	{
		pauseMenu.SetActive(false);
		Time.timeScale = 1.0f;
	}

	public void Restart()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
		Time.timeScale = 1.0f;
	}
}
