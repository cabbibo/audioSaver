using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;

using DSPLib;
using System.Numerics;

[ExecuteAlways]
[RequireComponent(typeof(AudioSource))]
public class AudioAnalyser : MonoBehaviour
{


    public AudioClip clip;
    public AudioSource source;
    
    public bool remakeOnEnable;


    public int framerate = 60;
    public int resolution = 256;

    public float pixelMultiplier = 4;
    public float powerFunction = .5f;



    public Texture2D textureFull;
    public Texture2D textureWaveform;

    public bool updateInEdit;

    public Renderer frameDebugRenderer;
    public Renderer framePowerDebugRenderer;
    public Renderer fullDebugRenderer;
    public Renderer waveformDebugRenderer;


    private float[] multiChannelSamples;
    public int numChannels;
    public int numTotalSamples;
    public float clipLength;
    public int sampleRate;

    public int samplesPerSecond;

    private double[] scaledFFTSpectrum;
    private float[] preProcessedSamples;
    private Color[] colors;

    public int iterations;

    
    private MaterialPropertyBlock mpbWaveform;
    private MaterialPropertyBlock mpbFull;


    private SpectralFluxAnalyzer preProcessedSpectralFluxAnalyzer;

    // Start is called before the first frame update
    void OnEnable()
    {

        mpbWaveform = new MaterialPropertyBlock();
        mpbFull = new MaterialPropertyBlock();


    


    }


void LateUpdate(){

    if( source != null && source.clip != null ){
        mpbFull.SetFloat("_TimeInClip", source.time / source.clip.length);
        frameDebugRenderer.SetPropertyBlock(mpbFull);
        framePowerDebugRenderer.SetPropertyBlock( mpbFull);
    }

}

    public void GetIterations(){

        iterations = (int)(source.clip.length * (float)framerate);
        
    }



    public void Analyze()
    {

        GetIterations();
        source.clip = clip;

        preProcessedSpectralFluxAnalyzer = new SpectralFluxAnalyzer ();
      

        multiChannelSamples = new float[source.clip.samples * source.clip.channels];
        numChannels = source.clip.channels;
        numTotalSamples = source.clip.samples;
        clipLength = source.clip.length;

        // We are not evaluating the audio as it is being played by Unity, so we need the clip's sampling rate
        sampleRate = source.clip.frequency;

        source.clip.GetData(multiChannelSamples, 0);
        // We only need to retain the samples for combined channels over the time domain
        preProcessedSamples = new float[numTotalSamples];

        int numProcessed = 0;
        float combinedChannelAverage = 0f;
        for (int i = 0; i < multiChannelSamples.Length; i++)
        {
            combinedChannelAverage += multiChannelSamples[i];

            // Each time we have processed all channels samples for a point in time, we will store the average of the channels combined
            if ((i + 1) % numChannels == 0)
            {
                preProcessedSamples[numProcessed] = combinedChannelAverage / numChannels;
                numProcessed++;
                combinedChannelAverage = 0f;
            }
        }

        int samplesPerPixel = preProcessedSamples.Length / 4096;

    int width = iterations;
    int height = 1;


/*

    Makes our waveform texture!

*/
    Color col = Color.red;
 Texture2D tex = new Texture2D(width, height, TextureFormat.RGBA32, false);
 textureWaveform = new Texture2D(width, height,  TextureFormat.RGBA32, false);
    
    
    float[] waveform = new float[width];

      int packSize = ( numTotalSamples / width )+1;
      int s = 0;
      float maxVal = 0;
      
      for (int i = 0; i < numTotalSamples-packSize; i += packSize) {

          float miniMax = 0;
          for( int j = 0; j < packSize; j++ ){

              if( i+j >= preProcessedSamples.Length ){
                  print( "i" + i);
                  print( "j" + j);
                  print( "ps" + packSize);
                  print( "pp" + preProcessedSamples.Length);
              }
                miniMax = Mathf.Max( miniMax ,Mathf.Abs(preProcessedSamples[i+j]) );
          }
          maxVal = Mathf.Max( maxVal ,miniMax) ;
          waveform[s] = miniMax;
          s++;
      }
 
      for (int x = 0; x < width; x++) {
        Color c = new Color( waveform[x]/maxVal, waveform[x]/maxVal, waveform[x]/maxVal, waveform[x]/maxVal );
        tex.SetPixel(x, 0, c);
      }

      tex.Apply();

      Graphics.CopyTexture(tex , textureWaveform );//textureWaveform.Copy( tex );
      textureWaveform.Apply();

 
     


/*

    Makes our FFT Texture

*/


        int spectrumSampleSize = resolution * 4 * 2;

        print( iterations);

        FFT fft = new FFT();
        fft.Initialize((UInt32)spectrumSampleSize);



        double[] sampleChunk = new double[spectrumSampleSize];


        samplesPerSecond = (int)(sampleRate / iterations);

        colors = new Color[iterations * resolution];
        for (int i = 0; i < iterations; i++)
        {

            int startingValue =  (int)(((float)i / (float)iterations) * (float)numTotalSamples);
            
            startingValue -= spectrumSampleSize / 2;

            if( startingValue < 0 ){
                startingValue = 0;
            }

            if( startingValue + spectrumSampleSize  > numTotalSamples ){
                startingValue = numTotalSamples - spectrumSampleSize - spectrumSampleSize/2;
            }


            // Grab the current 1024 chunk of audio sample data
            Array.Copy(preProcessedSamples, startingValue, sampleChunk, 0, spectrumSampleSize);

            // Apply our chosen FFT Window
            double[] windowCoefs = DSP.Window.Coefficients(DSP.Window.Type.Hanning, (uint)spectrumSampleSize);
            double[] scaledSpectrumChunk = DSP.Math.Multiply(sampleChunk, windowCoefs);
            double scaleFactor = DSP.Window.ScaleFactor.Signal(windowCoefs);

            // Perform the FFT and convert output (complex numbers) to Magnitude
            Complex[] fftSpectrum = fft.Execute(scaledSpectrumChunk);
            scaledFFTSpectrum = DSPLib.DSP.ConvertComplex.ToMagnitude(fftSpectrum);
            scaledFFTSpectrum = DSP.Math.Multiply(scaledFFTSpectrum, scaleFactor);

            // These 1024 magnitude values correspond (roughly) to a single point in the audio timeline
            float curSongTime = getTimeFromIndex(i) * spectrumSampleSize;


		
            for (int j = 0; j < resolution; j++)
            {
                float r =Mathf.Pow((float)scaledFFTSpectrum[j * 4 + 0], powerFunction ) * pixelMultiplier;// *Mathf.Pow( (float)j / (float)resolution , .2f);// * pixelMultiplier;
                float g =Mathf.Pow((float)scaledFFTSpectrum[j * 4 + 1], powerFunction ) * pixelMultiplier;// *Mathf.Pow( (float)j / (float)resolution , .2f);// * pixelMultiplier;
                float b =Mathf.Pow((float)scaledFFTSpectrum[j * 4 + 2], powerFunction ) * pixelMultiplier;// *Mathf.Pow( (float)j / (float)resolution , .2f);// * pixelMultiplier;
                float a =Mathf.Pow((float)scaledFFTSpectrum[j * 4 + 3], powerFunction ) * pixelMultiplier;// *Mathf.Pow( (float)j / (float)resolution , .2f);// * pixelMultiplier;
                colors[i * resolution + j] = new Color(r, g, b, a);

            }

            // Send our magnitude data off to our Spectral Flux Analyzer to be analyzed for peaks
            //preProcessedSpectralFluxAnalyzer.analyzeSpectrum (Array.ConvertAll (scaledFFTSpectrum, x => (float)x), curSongTime);
        }


        textureFull = new Texture2D(resolution, iterations, TextureFormat.RGBA32, false);
        //textureFull.filterMode = FilterMode.Point;
        textureFull.wrapMode = TextureWrapMode.Clamp;
        textureFull.SetPixels(colors);
        textureFull.Apply();

     






SetMPB();




       // Save();



    }


    public void Save(){
  //then Save To Disk as PNG
        byte[] bytes = textureFull.EncodeToPNG();
        var dirPath = Application.dataPath;
        if (!Directory.Exists(dirPath))
        {
            Directory.CreateDirectory(dirPath);
        }

        print(dirPath);
        File.WriteAllBytes(dirPath + "/Image" + ".png", bytes);
    }

    public void SetMPB(){

           mpbWaveform.SetTexture("_MainTex", textureWaveform);
        waveformDebugRenderer.SetPropertyBlock(mpbWaveform);
           mpbFull.SetTexture("_MainTex", textureFull);
           mpbFull.SetTexture("_PowerTex", textureWaveform);
        fullDebugRenderer.SetPropertyBlock(mpbFull);
        frameDebugRenderer.SetPropertyBlock(mpbFull);
        framePowerDebugRenderer.SetPropertyBlock(mpbFull);
    }
    public int getIndexFromTime(float curTime)
    {
        float lengthPerSample = clipLength / (float)numTotalSamples;

        return Mathf.FloorToInt(curTime / lengthPerSample);
    }

    public float getTimeFromIndex(int index)
    {
        return ((1f / (float)sampleRate) * index);
    }

    


    
    
   
    void SetDebugTime(){

    }

    // Updates in Edit Mode!
    void OnDrawGizmos()
    {

        #if UNITY_EDITOR
            // Ensure continuous Update calls.
            if (!Application.isPlaying && updateInEdit )
            {
        
                UnityEditor.EditorApplication.QueuePlayerLoopUpdate();
                UnityEditor.SceneView.RepaintAll();
            }
        #endif

    }
}
