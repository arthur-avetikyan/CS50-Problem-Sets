using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{
    public GameObject[] gems;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SpawnGems());
    }


    // Update is called once per frame
    void Update()
    {

    }

    IEnumerator SpawnGems()
    {
        while (true)
        {
            Instantiate(gems[0],
                new Vector3(26, Random.Range(-10, 8), 10),
                Quaternion.identity);
            yield return new WaitForSeconds(Random.Range(10, 15));
        }
    }
}
