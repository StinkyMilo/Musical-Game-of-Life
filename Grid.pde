public class Grid{
  private int minX;
  private int minY;
  private int maxX;
  private  int maxY;
  private int xSquares;
  private int ySquares;
  private int squareSize;
  private final String[] noteNames = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"};
  private final String[] noteNamesScalar = {"A","B","C","D","E","F","G"};
  //gridValues[x][y] instead of [y][x] to more easily get columns.
  private GridValue[][] originalValues;
  private GridValue[][] gridValues;
  public GridEvaluator gridEvaluator;
  public boolean allowChromatic;
  
  public Grid(int x, int y, int xSquares, int ySquares, int w, GridEvaluator evaluator, boolean allowChromatic){
    minX=x;
    minY=y;
    this.xSquares = xSquares;
    this.ySquares=ySquares;
    squareSize=w/xSquares;
    maxX = x+squareSize*xSquares;
    maxY = y+squareSize*ySquares;
    gridValues = new GridValue[xSquares][ySquares];
    gridEvaluator = evaluator;
    this.allowChromatic=allowChromatic;
  }
  
  public void drawGrid(){
    stroke(255);
    for(int i = minX; i <= maxX; i+=squareSize){
      line(i,minY,i,maxY);
    }
    textSize(11);
    fill(255);
    String[] theseNames = allowChromatic?noteNames:noteNamesScalar;
    for(int i = 0; i <= ySquares; i++){
      int y = minY+i*squareSize;
      line(minX,y,maxX,y);
      if(i!=0){
        int reverseI = ySquares-i;
        text(theseNames[reverseI%theseNames.length]+((reverseI/theseNames.length)+3),minX-20,y-2);
      }
    }
    for(int i = 0; i < gridValues.length; i++){
      for(int j = 0; j < gridValues[i].length; j++){
        if(gridValues[i][j]!=null){
          gridValues[i][j].drawShape(minX+i*squareSize,minY+j*squareSize,squareSize+1,squareSize+1);
        }
      }
    }
  }
  
  public GridValue getSquareByIndex(int x, int y){
    return gridValues[x][y];
  }
  
  public GridValue getSquareClicked(int x, int y){
    return getSquareByIndex((x-minX)/squareSize,(y-minY)/squareSize);
  }
  
  public void setSquareAtIndex(GridValue val, int x, int y){
    gridValues[x][y]=val;
  }
  
  public void removeSquareAtIndex(int x, int y){
    gridValues[x][y]=null;
  }
  
  public Point getIndex(int x, int y){
    return new Point((x-minX)/squareSize,(y-minY)/squareSize);
  }
  
  public boolean isInGrid(int x, int y){
    return x >= minX && y >= minY && x < maxX && y < maxY;
  }
  
  public GridValue[] getColumn(int i){
    return gridValues[i];
  }
  
  public void clearGrid(){
    gridValues = new GridValue[xSquares][ySquares];
  }
  
  public int columnCount(){
    return xSquares;
  }
  
  public void drawLine(int playX){
    stroke(255,0,0);
    int xVal = minX+playX*squareSize;
    line(xVal,minY,xVal,maxY);
  }
  
  public void backupGrid(){
    originalValues = new GridValue[xSquares][ySquares];
    for(int i = 0; i < xSquares; i++){
      for(int j = 0; j < ySquares; j++){
        originalValues[i][j]=gridValues[i][j];
      }
    }
  }
  
  public void restoreBackup(){
    gridValues=originalValues;
  }
  
  public void iterateGrid(){
    gridValues = gridEvaluator.iterate(gridValues);
  }
}
