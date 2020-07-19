using UnityEngine;
using System.Collections;

public class TestDot : MonoBehaviour {

	public float dot_Left;
	public float dot_Right;
	void Start () {
		dot_Left = Vector3.Dot(Vector3.left, Vector3.back);
		dot_Right = Vector3.Dot(Vector3.right, Vector3.back);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
