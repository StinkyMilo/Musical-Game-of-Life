import processing.sound.*;
import java.util.HashMap;
import java.io.File;
import java.util.List;
import java.util.ArrayList;

/*
TODO:
- Allow time to be adjustable
- Allow switching between instruments
+ Do grid iteration between each run
+ Reset iteration button
- Save to file
- Load from file
- Checkbox to allow/disallow wrapping
- Other iteration rules
- System to change iteration rules
- Sampling support, get some prettier instruments
+ Pause button
- allow keyboard shortcuts

- automata to implement:
  - brian's brain
  - game of life but the neighbors are a chess knight's move away.
  - game of life but the neighbors are always a whole step away
*/



//TODO for sample compatibility. For now just generate
HashMap<String, SoundFile> sampleFiles;

HashMap<String, PShape> icons;
List<UIButton> buttons;
File dir;
UIButton playButton;
UIButton clearButton;
UIButton stopButton;
UIButton pauseButton;
final int WIDTH = 640;
final int HEIGHT = 480;
Grid grid;
GridValue defaultGridValue;
boolean wasPressed = false;
boolean placing=true;
//Interval between each note (ms)
int timeInterval = 120;
boolean playing=false;
SampleWave sineWave;
SampleWave sawWave;
SampleWave triWave;
SampleWave wooSound;
SampleWave pianoSound;
int nextTime = 0;
int playX = 0;
int maxNote = 35;
GridValue[] column;
boolean paused;

void setup(){
  size(640,480);
  icons = new HashMap<String,PShape>();
  sampleFiles = new HashMap<String,SoundFile>();
  buttons = new ArrayList<UIButton>();
  dir = new File(sketchPath("/icons/"));
  File[] files = dir.listFiles();
  for(int i = 0; i < files.length; i++){
    String path = files[i].getAbsolutePath();
    String fullName = files[i].getName();
    String name = fullName.substring(0,fullName.indexOf(".svg"));
    PShape shape = loadShape(path);
    icons.put(name,shape);
  }
  dir = new File(sketchPath("/samples/"));
  files = dir.listFiles();
  for(int i = 0; i < files.length; i++){
    String path = files[i].getAbsolutePath();
    String fullName = files[i].getName();
    String name = fullName.substring(0,fullName.indexOf("."));
    SoundFile file = new SoundFile(this,path);
    sampleFiles.put(name,file);
  }
  //Buttons
  playButton = new UIButton(icons.get("bx-play-circle"),WIDTH-40,0,40,40);
  buttons.add(playButton);
  pauseButton = new UIButton(icons.get("bx-pause-circle"),WIDTH-80,0,40,40);
  buttons.add(pauseButton);
  stopButton = new UIButton(icons.get("bx-stop-circle"),WIDTH-120,0,40,40);
  buttons.add(stopButton);
  clearButton = new UIButton(icons.get("bx-trash"),WIDTH-160,0,40,40);
  buttons.add(clearButton);
  
  SampleWave.parent=this;
  sineWave = SampleWave.sine(36);
  sawWave = SampleWave.saw(36);
  triWave = SampleWave.saw(36);
  wooSound = SampleWave.sound("/samples/woo.wav",36,true);
  pianoSound = SampleWave.sound("/samples/piano.wav",36,false);
  
  defaultGridValue = new GridValue(icons.get("bxs-square-rounded"),color(255),pianoSound,0);
  grid = new Grid(20,60,36,24,WIDTH,new GameOfLife(true,defaultGridValue),false);
}

void drawIcon(String icon, int x, int y, int w, int h){
    PShape thisShape = icons.get(icon);
    shape(thisShape,x,y,w,h);
}

void drawButtons(){
  for(int i = 0; i < buttons.size(); i++){
    UIButton button = buttons.get(i);
    boolean isIn = button.isInButton(mouseX,mouseY);
    if(!button.isHovered && isIn){
      button.onHoverBegin();
    }else if(button.isHovered && !isIn){
      button.onHoverEnd();
    }
    button.drawButton();
  }
}

void draw(){
  int time = millis();
  background(0, 14, 36);
  noStroke();
  fill(254,255,233);
  rect(0,0,WIDTH,40);
  drawButtons();
  grid.drawGrid();
  if(mousePressed){
    if(grid.isInGrid(mouseX,mouseY)){
      Point index = grid.getIndex(mouseX,mouseY);
      GridValue val = grid.getSquareByIndex(index.x,index.y);
      if(!wasPressed){
        placing = val == null;
      }
      if(placing){
        grid.setSquareAtIndex(defaultGridValue.duplicate(),index.x,index.y);
      }else{
        grid.setSquareAtIndex(null,index.x,index.y);
      }
    }
  }
  if(playing){
    grid.drawLine(playX);
    if(time>=nextTime){
      stopAllInstruments();
      column = grid.getColumn(playX);
      for(int i = 0; i < column.length; i++){
        if(column[i]!=null){
          column[i].play(maxNote-i);
        }
      }
      nextTime+=timeInterval;
      playX=(playX+1)%grid.columnCount();
      if(playX==0){
        grid.iterateGrid();
      }
    }
  }
  wasPressed = mousePressed;
}

void stopAllInstruments(){
  sineWave.stopAll();
  triWave.stopAll();
  sawWave.stopAll();
  wooSound.stopAll();
  pianoSound.stopAll();
}

void mouseClicked(){
  if(clearButton.isInButton(mouseX,mouseY)){
    grid.clearGrid();
  }else if(playButton.isInButton(mouseX,mouseY)){
    nextTime = millis();
    playX = 0;
    playing=true;
    if(!paused){
       grid.backupGrid(); 
    }
    paused=false;
  }else if(stopButton.isInButton(mouseX,mouseY)){
    playing=false;
    stopAllInstruments();
    grid.restoreBackup();
    paused=false;
  }else if(pauseButton.isInButton(mouseX,mouseY)){
    playing=false;
    stopAllInstruments();
    paused=true;
  }
}
