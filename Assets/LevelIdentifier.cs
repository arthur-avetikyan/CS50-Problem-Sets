using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelIdentifier : MonoBehaviour
{
    public static int currentLevel = 1;
    public Text instruction;

    void Awake()
    {
        instruction.text = string.Format("You are on maze {0}", currentLevel);
    }
}
