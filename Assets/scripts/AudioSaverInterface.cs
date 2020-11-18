using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UniversalDragDrop;
using TMPro;
using SFB;
using System.IO;
public class AudioSaverInterface : MonoBehaviour
{

    public TMP_Dropdown resolutionDropdown;
    public TMP_Dropdown framerateDropdown;
    public Text fileText;

    public Text sizeText;
    public Text estimatedBakeTime;

    public AudioClip clip;

    public AudioSource source;

    public AudioAnalyser analyser;

    public string audioFilePath;
    // Start is called before the first frame update
    void Start()
    {
        UniversalDragDrop.DragDrop.onDrop( OnFileDrop );
        fileText.text = "drag in a .wav";

        resolutionDropdown.onValueChanged.AddListener(delegate
        {
            OnResolutionChange(resolutionDropdown);
        });
        OnResolutionChange(resolutionDropdown);

        framerateDropdown.onValueChanged.AddListener(delegate
        {
            OnFramerateChange(framerateDropdown);
        });
        OnFramerateChange(framerateDropdown);
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    public async void OnFileDrop(string[] paths){
        

        if( paths.Length > 1 ){
            fileText.text = "Only 1 file at a time please";
        }else if( paths.Length == 0 ){
            fileText.text = "Hmmm nothing dropped...";
        }else{
            fileText.text = paths[0];

            audioFilePath = paths[0];

            string[] val = audioFilePath.Split(new string[] { ".wav" }, System.StringSplitOptions.None);
            print( val );

            if( val.Length == 2 ){
                LoadSong();
            }else{
                fileText.text = "Not a .wav I think sorry";
            }


        }



    }

    public void OnResolutionChange( TMP_Dropdown dropdown ){

        int res = 4;
        if( dropdown.value == 0 ){
            res = 4;
        }else if( dropdown.value == 1 ){
            res  = 8;
        }else if( dropdown.value == 2 ){
            res  = 16;
        }else if( dropdown.value == 3 ){
            res  = 32;
        }else if( dropdown.value == 4 ){
            res  = 64;
        }else if( dropdown.value == 5 ){
            res  = 128;
        }else if( dropdown.value == 6 ){
            res  = 256;
        }else if( dropdown.value == 7 ){
            res  = 512;
        }else if( dropdown.value == 8 ){
            res  = 1024;
        }else{
            res = 4;
        }
        print( dropdown.value );
        analyser.resolution = res;SetStats();
    }



    public void OnFramerateChange( TMP_Dropdown dropdown ){

        int res = 8;
        if( dropdown.value == 0 ){
            res = 8;
        }else if( dropdown.value == 1 ){
            res  = 12;
        }else if( dropdown.value == 2 ){
            res  = 24;
        }else if( dropdown.value == 3 ){
            res  = 30;
        }else if( dropdown.value == 4 ){
            res  = 60;
        }else if( dropdown.value == 5 ){
            res  = 120;
        }else{
            res = 8;
        }
        print( dropdown.value );

        
        analyser.framerate = res;

        analyser.GetIterations();
        SetStats();

    }



    public void BakeButtonClick(){

        print(Time.time);

        float t = Time.time;
    
    print("helllo song finishedLoading");
    analyser.GetIterations();
    print( analyser.iterations );
    sizeText.text = "SIZE: " + analyser.resolution + " X " + analyser.iterations;
        analyser.Analyze();
        source.Play();

        print( "TTB:" + (Time.time - t));
    }


public void LoadSong()
{
    StartCoroutine(LoadSongCoroutine());    
}


public void SaveTexture(){
    string path = StandaloneFileBrowser.SaveFilePanel("Save File", "", "", "");

       byte[] bytes = analyser.textureFull.EncodeToPNG();


        File.WriteAllBytes(path + "_FFT.png", bytes);

        
       bytes = analyser.textureWaveform.EncodeToPNG();
       File.WriteAllBytes(path + "_Power.png", bytes);

    print( path );

    
}
IEnumerator LoadSongCoroutine()
{
    string url = string.Format("file://{0}", audioFilePath); 
    WWW www = new WWW(url);
    yield return www;

    clip = www.GetAudioClip(false, false);

    OnSongFinishedLoading();
}


public void OnSongFinishedLoading(){
    source.clip = clip;
    analyser.clip = clip;
    analyser.GetIterations();
    SetStats();
}


public void SetStats(){
    
    sizeText.text = "SIZE: " + analyser.resolution + " X " + analyser.iterations;
    
    int val = analyser.resolution * analyser.resolution * analyser.iterations / 1000;
    string bt = "FOREVER";
    if( val < 10000){
        bt = "Short";
    }else if( val < 100000 ){
        bt = "Medium";
    }else if( val < 1000000 ){
        bt ="Long";
    }else if( val < 2000000 ){
        bt ="Longer";
    }else if( val < 4000000){
        bt ="Very Long";
    }else{
        bt ="FOREVER";
    }
    estimatedBakeTime.text = "Bake Time: " + bt;
}

}
