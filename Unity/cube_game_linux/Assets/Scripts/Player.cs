using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public float force = 5f;
    public float maxVelocity = 4f;

    private Rigidbody playerRB;

    // Start is called before the first frame update
    void Start()
    {
        playerRB = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        var horizontalInput = Input.GetAxis("Horizontal");

        // magnitude -> 'Global' velocity of object
        if (playerRB.velocity.magnitude <= maxVelocity)
        {
            playerRB.AddForce(new Vector3(horizontalInput * force, 0, 0));
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Hazard"))
        {
            Destroy(gameObject); 
        }
    }
}
