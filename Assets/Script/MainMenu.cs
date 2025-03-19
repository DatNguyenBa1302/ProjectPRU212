using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;
using TMPro;

public class MainMenu : MonoBehaviour
{
	public TextMeshProUGUI map1Text;
	public TextMeshProUGUI map2Text;
	public TextMeshProUGUI map3Text;
	public TextMeshProUGUI map4Text;

	public void PlayGame()
	{
		SceneManager.LoadSceneAsync(1);
	}

	public void PlayWithFriend()
	{
		SceneManager.LoadSceneAsync(1);
	}

	public void QuitGame()
	{
#if UNITY_EDITOR
		UnityEditor.EditorApplication.isPlaying = false;
#else
			Application.Quit(); // Thoát game khi build thành file th?c thi
#endif
	}

	public void LoadData()
	{
		string filePath = Application.dataPath + "/Data.json";

		if (File.Exists(filePath))
		{
			string json = File.ReadAllText(filePath);

			MapTimerList mapTimerList = JsonUtility.FromJson<MapTimerList>(json);

			if (mapTimerList.data != null && mapTimerList.data.Count >= 4)
			{
				map1Text.text = $"{mapTimerList.data[0].Timer}";
				map2Text.text = $"{mapTimerList.data[1].Timer}";
				map3Text.text = $"{mapTimerList.data[2].Timer}";
				map4Text.text = $"{mapTimerList.data[3].Timer}";
			}
			else
			{
				Debug.LogWarning("JSON not enough 4 elements");
			}
		}
		else
		{
			Debug.LogError("File cannot read: " + filePath);
		}
	}

}
