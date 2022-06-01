public class GridValue{
 private color col;
 private PShape _shape;
 private SampleWave wave;
 private int typeId;
 public GridValue(PShape _shape, color col,SampleWave wave, int typeId){
   this.col=col;
   this._shape=_shape;
   _shape.disableStyle();
   this.wave = wave;
   this.typeId = typeId;
 }
 public GridValue duplicate(){
   return new GridValue(_shape,col,wave, typeId);
 }
 public void drawShape(int x, int y, int w, int h){
   fill(col);
   shape(_shape,x,y,w,h);
 }
 
 public void play(int note){
   wave.play(note);
 }
 
 public SampleWave getSampleWave(){
   return wave;
 }
 
 public int getType(){
   return typeId;
 }
}
