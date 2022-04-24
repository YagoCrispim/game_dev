using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hazard : MonoBehaviour
{
    Vector3 rotation;

    private void Start()
    {
        var xRotation = Random.Range(1.5f, 2.5f);
        rotation = new Vector3(xRotation, 0, 0);
    }

    private void Update()
    {
        transform.Rotate(rotation);
    }

    private void OnCollisionEnter(Collision collision)
    {
        Destroy(gameObject);
    }

}
