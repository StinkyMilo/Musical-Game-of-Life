import processing.sound.*;
public class PlayableOscillator implements Playable{
  private Oscillator osc;
  public PlayableOscillator(Oscillator osc){
    this.osc=osc;
  }
  public void play(){
    osc.play();
  }
  public void stop(){
    osc.stop();
  }
}
