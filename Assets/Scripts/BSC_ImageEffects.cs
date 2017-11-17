using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BSC_ImageEffects : MonoBehaviour {

    #region VARIABLES
    public Shader currentShader;
    public float brightness = 1.0f;
    public float contrast = 1.0f;
    public float saturation = 1.0f;
    private Material currentMaterial;
    #endregion


    #region PROPERTIES
    Material material
    {
        get
        {
            if(currentMaterial == null)
            {
                currentMaterial = new Material(currentShader);
                currentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return currentMaterial;
        }
    }
    #endregion


    void Start ()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }	

        if(!currentShader && !currentShader.isSupported)
        {
            enabled = false;
        }
	}
	

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if(currentShader != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Contrast", contrast);
            material.SetFloat("_Saturation", saturation);

            //Copy the render texture to the destiniation texture
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }


	// Update is called once per frame
	void Update ()
    {

        brightness = Mathf.Clamp(brightness, 0.0f, 2.0f);
        contrast = Mathf.Clamp(contrast, 0.0f, 3.0f);
        saturation = Mathf.Clamp(saturation, 0.0f, 2.0f);
    }


    void OnDisable()
    {
        if (currentMaterial)
        {
            DestroyImmediate(currentMaterial);
        }
    }

}
