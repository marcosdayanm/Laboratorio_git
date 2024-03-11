using System.Collections;
using UnityEngine;
using UnityEngine.UI; // Para image

public class SimonButton : MonoBehaviour
{
    Color originalColor;
    bool isInitialized = false;

     public void Initialize()
    {
        if (!isInitialized)
        {
            originalColor = GetComponent<Image>().color;
            isInitialized = true;
        }
    }

    public void Highlight()
    {
        StartCoroutine(ChangeColor());
        // Debug.Log("Color original asignado: " + originalColor.ToString(), this);
    }

    IEnumerator ChangeColor()
    {
        GetComponent<Image>().color = Color.white;
        yield return new WaitForSeconds(0.3f); // Ésto de "f" es para decir que es un float, un double un poco más chico
        // Debug.Log("Restaurando color original: " + originalColor.ToString(), this);
        GetComponent<Image>().color = originalColor;
    }


}
