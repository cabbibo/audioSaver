using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using AOT;
using UnityEngine;

public class OSXDragDropWrapper
{

    private static Action<string> function_onReceiveLog;
    private static Action function_onDragEnter;
    private static Action function_onDragExit;
    private static Action<string[]> function_onDrop;
    


    /*******************************************************************
    *                        Listenner Unity
    *
    *******************************************************************/
    public static void onReceiveLog(Action<string> function){
        function_onReceiveLog = function;
    }

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
    *                       Destroy OSX subview
    *
    *******************************************************************/
    [RuntimeInitializeOnLoadMethod]
    static void RunOnStart()
    {
        Application.quitting += Quit;
    }

    static void Quit()
    {
        #if UNITY_STANDALONE_OSX && !UNITY_EDITOR
            //Debug.Log("[Unity] application quit");
            _destroyDragDrop();
        #endif   
    }



    /*******************************************************************
    *                        Unity -> Objective C
    *
    *******************************************************************/
    [DllImport ("DragDrop" , CallingConvention = CallingConvention.Cdecl)]
    public static extern string _printHello();

    [DllImport ("DragDrop" , CallingConvention = CallingConvention.Cdecl)]
    public static extern void _initialiseDragDrop();

    [DllImport ("DragDrop" , CallingConvention = CallingConvention.Cdecl)]
    public static extern void  _destroyDragDrop();

    /*******************************************************************
    *                        Objective C -> Unity
    *
    *******************************************************************/

    /*-----------------------------------------
    * Declaration des types de fonction 
    -----------------------------------------*/
    private delegate void Callback_void();
    private delegate void Callback_int(int arg0);
    private delegate void Callback_string(string arg0);
    private delegate void Callback_intArray(IntPtr arg0);
    private delegate void Callback_stringArray(IntPtr arg0, IntPtr arg1, int arg2);


    /*-----------------------------------------
    * Implémentation des fonctions de callback
    * (passé en paramettre a l'objective C et 
    * appelé depuis l'objetive C)
    -----------------------------------------*/
    [MonoPInvokeCallback (typeof (Callback_int))]
    private static void function_sendLogInUnity(string value){
        Debug.Log("[XCode] : "+value);
        function_onReceiveLog?.Invoke(value);
    }


    [MonoPInvokeCallback (typeof (Callback_void))]
    private static void function_sendDragEnterEventInUnity(){
        function_onDragEnter?.Invoke();
    }

    [MonoPInvokeCallback (typeof (Callback_void))]
    private static void function_sendDragExitEventInUnity(){
        function_onDragExit?.Invoke();

    }

    [MonoPInvokeCallback (typeof (Callback_stringArray))]
    private static void function_sendDopEventInUnity(IntPtr arrayStringPtr , IntPtr arrayLengthPtr, int size){

        string[] array = new string[size];
        
        int[] arraylength = new int[size]; //taille de chaque string
        Marshal.Copy(arrayLengthPtr, arraylength, 0, size);

        IntPtr[] arrayString = new IntPtr[size];
        Marshal.Copy(arrayStringPtr, arrayString, 0, size);
        
        for(int i = 0;i<size;i++){
            int currentStringLength = arraylength[i];
            byte[] tmpString  = new byte[currentStringLength];
            Marshal.Copy(arrayString[i], tmpString, 0, currentStringLength);

            array[i] = Encoding.Default.GetString(tmpString);
        }
        function_onDrop?.Invoke(array);
    }


    /*-----------------------------------------
    * Fonction objective C qui servira a passer les adresses 
    * des fonctions Unity a Objective C 
    -----------------------------------------*/
    [DllImport  ("DragDrop" , CallingConvention = CallingConvention.Cdecl)]
    private static extern void _setCallbacks(Callback_string function_sendLogInUnity, Callback_void function_sendDragEnterEventInUnity, Callback_void function_sendDragExitEventInUnity, Callback_stringArray function_sendDopEventInUnity);


    /*-----------------------------------------
    * Fonction Objective C classique qui envoie 
    * les adresses des fonctions Unity a Objective c
    -----------------------------------------*/
    public static void setCallbacks(){
        _setCallbacks(function_sendLogInUnity, function_sendDragEnterEventInUnity, function_sendDragExitEventInUnity, function_sendDopEventInUnity);
    }

}
