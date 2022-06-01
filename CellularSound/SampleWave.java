import processing.sound.*;
import java.lang.Math;
public class SampleWave{
  public static processing.core.PApplet parent;
  private Playable[] instruments;
  private static final double TWO_PI = 6.28318530718f;
  private static final int BASE_FREQ = 128;
  private int notes;
  public static boolean allowChromatic = true;
  
  public SampleWave(Playable[] instruments, int notes,boolean chromatic){
    this.instruments = instruments;
    this.notes=notes;
    allowChromatic=chromatic;
  }
  public void stopAll(){
    for(int j = 0; j < 3; j++){
      for(int i =0 ; i < instruments.length; i++){
        instruments[i].stop();
      }
    }
  }
  public void play(int note){
    instruments[note].play();
  }
  //The first 3 of these don't work when disabling chromatic!
  public static SampleWave sine(int notes){
    Playable[] _instruments = new Playable[notes];
    for(int i = 0; i < notes; i++){
      SinOsc osc = new SinOsc(parent);
      osc.freq((float)(BASE_FREQ*Math.pow(2,(double)i/12.0)));
      _instruments[i]=new PlayableOscillator(osc);
    }
    return new SampleWave(_instruments,notes,true);
  }
  
  public static SampleWave saw(int notes){
    Playable[] _oscillators = new Playable[notes];
    for(int i = 0; i < notes; i++){
      SawOsc osc = new SawOsc(parent);
      osc.freq((float)(BASE_FREQ*Math.pow(2,(double)i/12.0)));
      _oscillators[i]=new PlayableOscillator(osc);
    }
    return new SampleWave(_oscillators,notes,true);
  }
  
  public static SampleWave tri(int notes){
    Playable[] _oscillators = new Playable[notes];
    for(int i = 0; i < notes; i++){
      TriOsc osc = new TriOsc(parent);
      osc.freq((float)(BASE_FREQ*Math.pow(2,(double)i/12.0)));
      _oscillators[i]=new PlayableOscillator(osc);
    }
    return new SampleWave(_oscillators,notes,true);
  }
  
  public static SampleWave sound(String filename, int notes, boolean chromatic){
    //Takes file as playing middle C.
    allowChromatic=chromatic;
    final int offset = 0;
    Playable[] samples = new Playable[notes];
    final int[] steps = {2,2,1,2,2,2,1};
    //final int[] steps = {1,2,2,2,1,2,2};
    int step = 0;
    for(int i = 0; i < notes; i++){
      SoundFile file = new SoundFile(parent,filename);
      float pitch;
      if(allowChromatic){
        pitch = (float)Math.pow(2,(double)(i+offset)/12.0)/4;
      }else{
        pitch = (float)Math.pow(2,(double)(step+offset)/12.0)/4;
        System.out.println(i + " " + step + " " + steps[i%steps.length] + " " + pitch);
        step+=steps[i%steps.length];
      }
      file.rate(pitch);
      SoundSample sample = new SoundSample(file);
      samples[i]=sample;
    }
    return new SampleWave(samples,notes,chromatic);
  }
}
