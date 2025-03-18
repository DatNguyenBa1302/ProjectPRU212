using NUnit.Framework;
using System.Collections.Generic;
using System.IO;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
	public GameObject[] players;
	[SerializeField] TextMeshProUGUI timerText;
	float elapsedTime;
	private void Update()
	{
		elapsedTime += Time.deltaTime;
		int minutes = Mathf.FloorToInt(elapsedTime / 60);
		int seconds = Mathf.FloorToInt(elapsedTime % 60);
		timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
	}
	public void CheckWinState()
	{
		int aliveCount = 0;
		foreach (GameObject player in players)
		{
			if (player.activeSelf)
			{
				aliveCount++;
			}
		}

		if (aliveCount <= 1)
		{
			Invoke(nameof(NewRound), 3f);
		}
	}
	private void NewRound()
	{
		SaveToJson();
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
	}

	public void SaveToJson()
	{
		MapTimerList mapTimerList = new MapTimerList();
		mapTimerList.data = new List<MapTimer>
		{
		new MapTimer("Map 1", "00:00"),
		new MapTimer("Map 2", "00:00"),
		new MapTimer("Map 3", "00:00"),
		new MapTimer("Map 4", "00:00")
		};

		mapTimerList.data[0].Timer = timerText.text;

		string json = JsonUtility.ToJson(mapTimerList, true);
		File.WriteAllText(Application.dataPath + "/Data.json", json);
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

