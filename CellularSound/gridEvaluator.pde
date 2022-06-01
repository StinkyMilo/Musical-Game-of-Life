public abstract class GridEvaluator{
  public abstract GridValue[][] iterate(GridValue[][] grid);
}

public class GameOfLife extends GridEvaluator{
  protected boolean wrap;
  protected GridValue defaultValue;
  public Point[] directions = {new Point(-1,0),new Point(-1,-1), new Point(0,-1), new Point(1,-1), new Point(1,0), new Point(1,1), new Point(0,1), new Point(-1,1)};
  public GameOfLife(boolean wrap, GridValue defaultValue){
    this.wrap=wrap;
    this.defaultValue=defaultValue;
  }
  
  public GridValue[][] iterate(GridValue[][] grid){
    GridValue[][] newGrid = new GridValue[grid.length][grid[0].length];
    for(int i = 0; i < grid.length; i++){
      for(int j = 0; j < grid[0].length; j++){
        int neighborCount = getNeighbors(grid,i,j);
        if(neighborCount<=1 || neighborCount >= 4){
          newGrid[i][j]=null;
        }else if(grid[i][j]==null && neighborCount==3){
          newGrid[i][j]=defaultValue.duplicate();
        }else{
          newGrid[i][j]=grid[i][j];
        }
      }
    }
    return newGrid;
  }
  
  private int getNeighbors(GridValue[][] grid, int x, int y){
    int neighbors = 0;
    for(int i = 0; i < directions.length; i++){
      int nx = x+directions[i].x;
      int ny = y+directions[i].y;
      if(nx < 0){
        if(wrap){
          nx=grid.length-1;
        }else{
          continue;
        }
      }else if(nx >= grid.length){
        if(wrap){
          nx=0;
        }else{
          continue;
        }
      }
      if(ny < 0){
        if(wrap){
          ny = grid[0].length - 1;
        }else{
          continue;
        }
      }else if(ny >= grid[0].length){
        if(wrap){
          ny=0;
        }else{
          continue;
        }
      }
      if(grid[nx][ny]!=null){
        neighbors++;
      }
    }
    return neighbors;
  }
}
