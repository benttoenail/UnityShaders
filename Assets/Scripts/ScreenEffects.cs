using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScreenEffects : MonoBehaviour {

    #region VARIABLES
    public Shader currentShader;
    public float grayScaleAmount = 1.0f;
    public float depthPower = 1.0f;
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
            material.SetFloat("_DepthPower", depthPower);

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
        //grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        depthPower = Mathf.Clamp(depthPower, 0, 5);
	}


    void OnDisable()
    {
        if (currentMaterial)
        {
            DestroyImmediate(currentMaterial);
        }
    }

}
