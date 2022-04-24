using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public GameObject hazardPrefab;
    public int maxHazards = 4;

    // Start is called before the first frame update
    void Start()
    {
        // StartCoroutine(SpawnHazards());
        InvokeRepeating("SpawnHazards", 0, 1f);
    }

    private void SpawnHazards()
    {
        var hazardsToSpawn = Random.Range(1, maxHazards);

        for (int i = 0; i <= hazardsToSpawn; i++)
        {
            var x = Random.Range(-8, 8);
            var drag = Random.Range(0f, 2f);
            var hazard = Instantiate(hazardPrefab, new Vector3(x, 11, 0), Quaternion.identity);

            hazard.GetComponent<Rigidbody>().drag = drag;
        }

        // yield return new WaitForSeconds(1);

        // yield return SpawnHazards();
    }
}