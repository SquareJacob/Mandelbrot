using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explorer : MonoBehaviour{
    public Material mat;
    public Vector2 pos, other;
    public float scale, inf, ite;

    private void UpdateShader(){
        float aspect = (float)Screen.width / (float)Screen.height;
        float scaleX = scale;
        float scaleY = scale;
        if(aspect > 1f){
            scaleY /= aspect;
        }
        else{
            scaleX *= aspect;
        }
        mat.SetVector("_Area", new Vector4(pos.x, pos.y, scaleX, scaleY));
        mat.SetFloat("_Inf", inf);
        mat.SetFloat("_Ite", ite);
        mat.SetVector("_Other", new Vector4(other.x, other.y, 0, 0));
    }

    private void HandleInputs(){
        //Zoom using Q and E
        if(Input.GetKey(KeyCode.Q)) scale *= .98f;
        if(Input.GetKey(KeyCode.E)) scale /= .98f; 
        //Move around using WASD
        if(Input.GetKey(KeyCode.W)) pos.y += .01f * scale; 
        if(Input.GetKey(KeyCode.A)) pos.x -= .01f * scale; 
        if(Input.GetKey(KeyCode.S)) pos.y -= .01f * scale; 
        if(Input.GetKey(KeyCode.D)) pos.x += .01f * scale;
        //Change number of iterations using T and R
        if(Input.GetKey(KeyCode.T) && ite < 1000) ite += 1; 
        if(Input.GetKey(KeyCode.R) && ite > 0) ite -= 1;
        //Move the color using Y and U
        if(Input.GetKey(KeyCode.Y)) inf -= 1; 
        if(Input.GetKey(KeyCode.U)) inf += 1;
        //Change the Other coordinate used with arrows
        if(Input.GetKey(KeyCode.UpArrow)) other.y += .001f; 
        if(Input.GetKey(KeyCode.LeftArrow)) other.x -= .001f; 
        if(Input.GetKey(KeyCode.DownArrow)) other.y -= .001f; 
        if(Input.GetKey(KeyCode.RightArrow)) other.x += .001f;   
    }
    void FixedUpdate(){
        HandleInputs();
        UpdateShader();
    }
}
