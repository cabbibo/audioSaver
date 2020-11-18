using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UniversalDragDrop{

    public class DragDrop 
    {
        private static Action function_onDragEnter;
        private static Action function_onDragExit;
        private static Action<string[]> function_onDrop;
        private static bool DragDropEnabled;


        public static void onDragEnter(Action function){
            #if UNITY_STANDALONE_WIN && !UNITY_EDITOR
                WINDragDropWrapper.onDragEnter( function );
            #endif
            #if UNITY_STANDALONE_OSX && !UNITY_EDITOR
                OSXDragDropWrapper.onDragEnter( function );
            #endif

            enabledDragDrop();
        }

        public static void onDragExit(Action function){
            #if UNITY_STANDALONE_WIN && !UNITY_EDITOR
                WINDragDropWrapper.onDragExit(function);
            #endif
            #if UNITY_STANDALONE_OSX && !UNITY_EDITOR
                OSXDragDropWrapper.onDragExit(function);
            #endif

            enabledDragDrop();
        }

        public static void onDrop(Action<string[]> function){
            #if UNITY_STANDALONE_WIN && !UNITY_EDITOR
                WINDragDropWrapper.onDrop(function);
            #endif
            #if UNITY_STANDALONE_OSX && !UNITY_EDITOR
                OSXDragDropWrapper.onDrop(function);
            #endif

            enabledDragDrop();
        }

        private static void enabledDragDrop(){
            
            if(!DragDropEnabled){

                #if UNITY_STANDALONE_WIN && !UNITY_EDITOR
                    WINDragDropWrapper._initialiseDragDrop();
                    WINDragDropWrapper.setCallbacks();
                    DragDropEnabled = true;
                #endif

                #if UNITY_STANDALONE_OSX && !UNITY_EDITOR 
                    OSXDragDropWrapper.setCallbacks();
                    OSXDragDropWrapper._initialiseDragDrop();
                    DragDropEnabled = true;
                #endif

                #if UNITY_EDITOR
                    Debug.Log("Drag & Drop is only available on standolane build");
                #endif

            }
        }
    }
}
