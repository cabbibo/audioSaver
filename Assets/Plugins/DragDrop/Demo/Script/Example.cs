using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UniversalDragDrop;

public class Example : MonoBehaviour
{
    public GameObject panelHover;
    public GameObject listContent;
    public GameObject prefabText;

    private List<GameObject> debugGO;

    void Start()
    {
        UniversalDragDrop.DragDrop.onDragEnter(showPanelHover);

        UniversalDragDrop.DragDrop.onDragExit(hidePanelHover);

        UniversalDragDrop.DragDrop.onDrop( appendScrollView);
    }

    public void showPanelHover(){
            panelHover.SetActive(true);
    }

    public void hidePanelHover(){
            panelHover.SetActive(false);
    }

    public void appendScrollView(string[] paths){
        
        hidePanelHover();
        for(int i = 0; i < paths.Length; i++)
        {
            GameObject line = Instantiate(prefabText, new Vector3(0, 0, 0), Quaternion.identity, listContent.transform );
            line.SetActive(true);      
            line.transform.localScale = Vector3.one;
            line.GetComponent<Text>().text = paths[i];
    
        }
    }

}
