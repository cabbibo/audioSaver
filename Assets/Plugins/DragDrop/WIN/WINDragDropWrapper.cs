using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class WINDragDropWrapper 
{

    private static Action function_onDragEnter;
    private static Action function_onDragExit;
    private static Action<string[]> function_onDrop;

    /*******************************************************************
    *                        Listenner Unity
    *
    *******************************************************************/
    public static void onDragEnter(Action function){
        function_onDragEnter = function;
    }

    public static void onDragExit(Action function){
        function_onDragExit = function;
    }

    public static void onDrop(Action<string[]> function){
        function_onDrop = function;
    }

    /*******************************************************************
    *                 Destroy Drag drop on app quit
    *
    *******************************************************************/
    [RuntimeInitializeOnLoadMethod]
    static void RunOnStart()
    {
        Application.quitting += Quit;
    }

    static void Quit()
    {
        #if UNITY_STANDALONE_WIN && !UNITY_EDITOR
            //Debug.Log("[Unity] application quit");
            _destroyDragDrop();  
        #endif 
    }

    /*******************************************************************
    *                       Unity -> dll
    *
    *******************************************************************/
    

    public static void _initialiseDragDrop ()
    {
        DragDrop._initialiseDragDrop();
    }
    static void _destroyDragDrop()
    {
        DragDrop._destroyDragDrop();
    }


    /*******************************************************************
    *                       dll -> Unity
    *
    *******************************************************************/

    private static void function_sendDragEnterEventInUnity(){
        function_onDragEnter?.Invoke();
    }

    private static void function_sendDragExitEventInUnity(){
        function_onDragExit?.Invoke();

    }

    private static void function_sendDopEventInUnity(List<string> arrayString)
    {
        function_onDrop?.Invoke(arrayString.ToArray());
    }

    /*-----------------------------------------
    * Set callbacks for Drop/Enter/Exit events
    -----------------------------------------*/
    public static void setCallbacks(){
        DragDrop.OnDroppedFiles += function_sendDopEventInUnity;
    }
}
