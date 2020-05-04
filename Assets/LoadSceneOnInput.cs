using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetAxis("Submit") == 1)
        {
            var sceneName = SceneManager.GetActiveScene().name;
            if (sceneName == "Title")
            {
                SceneManager.LoadScene("Play");
            }
            else
            {
                SceneManager.LoadScene("Title");
            }

        }
    }
}
