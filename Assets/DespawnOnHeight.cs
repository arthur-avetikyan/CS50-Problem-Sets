using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{
    void Awake()
    {
        DontDestroy.instance.GetComponents<AudioSource>()[0].Play();
    }


    // Update is called once per framew
    void Update()
    {
        if (gameObject.transform.position.y < -15)
        {
            LevelIdentifier.currentLevel = 1;
            DontDestroy.instance.GetComponents<AudioSource>()[2].Play();
            DontDestroy.instance.GetComponents<AudioSource>()[0].Stop();

            SceneManager.LoadScene("Game Over");
        }
    }
}
