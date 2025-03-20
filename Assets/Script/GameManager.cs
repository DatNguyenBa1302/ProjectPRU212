using NUnit.Framework;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    private AudioManager audioManager;
    [Header("Player & Enemy References")]
	public GameObject[] players;   // Danh sách player
	public GameObject[] enemies;   // Danh sách quái

	[Header("UI References")]
	[SerializeField] TextMeshProUGUI timerText;
	float elapsedTime;

	[Header("Game over screen")]
	public GameObject gameOverScreen;
	public TextMeshProUGUI timerTextGameOverScreen;

	[Header("Winner screen")]
	public GameObject winnerScreen;
	public TextMeshProUGUI timerTextWinnerScreen;

	[Header("Play With Friend screen")]
	public GameObject playWithFriendScreen;
	public TextMeshProUGUI textPlayWithFriendScreen;

	private MapTimerList mapTimerList = new MapTimerList();
	private bool isPlayingWithFriendMode = false;

    private void Awake()
    {
        audioManager = GameObject.FindGameObjectWithTag("Audio").GetComponent<AudioManager>();
    }

    private void Start()
	{
		LoadData();
		gameOverScreen.SetActive(false);
		winnerScreen.SetActive(false);
		playWithFriendScreen.SetActive(false);
		isPlayingWithFriendMode = players.Count() == 2;
		if (isPlayingWithFriendMode)
			timerText.text = "";
	}

	private void Update()
	{
		// Cập nhật timer
		elapsedTime += Time.deltaTime;
		int minutes = Mathf.FloorToInt(elapsedTime / 60);
		int seconds = Mathf.FloorToInt(elapsedTime % 60);
		timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
	}

	public void CheckWinState()
	{
		int alivePlayers = 0;
		foreach (GameObject player in players)
		{
			if (player.activeSelf)
			{
				
				alivePlayers++;
				Debug.Log(player.name);
			}
		}
		if (isPlayingWithFriendMode)
		{
			if (alivePlayers == 1)
			{
				DisplayPlayWithFriend(players.Where(x=>x.activeSelf).FirstOrDefault().name.ToUpper() + " WIN");
				return;
			}
		}
		else
		{
			if (alivePlayers == 0)
			{
				DisplayGameOver();
				return;
			}
		}
		

		int aliveEnemies = 0;
		foreach (GameObject enemy in enemies)
		{
			if (enemy.activeSelf)
			{
				aliveEnemies++;
			}
		}

		if (aliveEnemies == 0)
		{
			DisplayWinner();
		}
	}
	private void DisplayPlayWithFriend(string text)
	{
		playWithFriendScreen.SetActive(true);
		textPlayWithFriendScreen.text = text;
	}

	private void DisplayGameOver()
	{
		SaveToJson();
		gameOverScreen.SetActive(true);
		timerTextGameOverScreen.text = timerText.text;
		//SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
		audioManager.PlaySFX(audioManager.lose);
	}

	public void RestartButton()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
	}
	public void PlayAgainButton()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
	}
	private void DisplayWinner()
	{
		SaveToJson();
		winnerScreen.SetActive(true);
		timerTextWinnerScreen.text = timerText.text;
		audioManager.PlaySFX(audioManager.win);
	}

	public void NextButton()
	{
		string mapCurrent = SceneManager.GetActiveScene().name;
		switch (mapCurrent)
		{
			case "Map1":
				SceneManager.LoadSceneAsync("Map2");
				break;
			case "Map2":
				SceneManager.LoadSceneAsync("Map3");
				break;
			case "Map3":
				SceneManager.LoadSceneAsync("Map4");
				break;
		}
	}
	public void MainMenuButton()
	{
		winnerScreen.SetActive(true);
	}

	public void SaveToJson()
	{
		if (mapTimerList.data == null)
		{
			mapTimerList.data = new List<MapTimer>
			{
			new MapTimer("Map 1", "00:00"),
			new MapTimer("Map 2", "00:00"),
			new MapTimer("Map 3", "00:00"),
			new MapTimer("Map 4", "00:00")
			};
		}
		string mapCurrent = SceneManager.GetActiveScene().name;
		switch (mapCurrent){
			case "Map1":
				mapTimerList.data[0].Timer = timerText.text;
				break;
			case "Map2":
				mapTimerList.data[1].Timer = timerText.text;
				break;
			case "Map3":
				mapTimerList.data[2].Timer = timerText.text;
				break;
			case "Map4":
				mapTimerList.data[3].Timer = timerText.text;
				break;
		}
		string json = JsonUtility.ToJson(mapTimerList, true);
		File.WriteAllText(Application.dataPath + "/Data.json", json);
	}

	public void LoadData()
	{
		string filePath = Application.dataPath + "/Data.json";

		if (File.Exists(filePath))
		{
			string json = File.ReadAllText(filePath);

			mapTimerList = JsonUtility.FromJson<MapTimerList>(json);
		}
		else
		{
			Debug.LogError("File cannot read: " + filePath);
		}
	}
}
[System.Serializable]
public class MapTimer
{
	public string Map;
	public string Timer;
	public MapTimer(string Map, string Timer)
	{
		this.Map = Map;
		this.Timer = Timer;
	}
}
[System.Serializable]  // Cần thêm thuộc tính này để dữ liệu có thể serialize
public class MapTimerList
{
	public List<MapTimer> data;
}

