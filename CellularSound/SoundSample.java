import processing.sound.*;
public class SoundSample implements Playable{
  private SoundFile sound;
  public SoundSample(SoundFile sound){
    this.sound=sound;
  }
  public void play(){
    sound.play();
  }
  public void stop(){
    sound.stop();
  }
}
