
public class UIButton{
  private PShape icon;
  private int x;
  private int y;
  private int w;
  private int h;
  private color strokeColor;
  private color fillColor;
  public boolean isHovered;
  public UIButton(PShape icon, int x, int y, int w, int h){
    this.icon = icon;
    icon.disableStyle();
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    strokeColor = color(0);
    fillColor = color(0);
  }
  public boolean isInButton(int mx, int my){
    return mx >= x && my >= y && mx <= x+w && my <= y+w;
  }
  public void onHoverBegin(){
    fillColor = color(255,255,0);
    strokeColor = color(128,128,0);
    isHovered = true;
  }
  public void onHoverEnd(){
    strokeColor = color(0);
    fillColor = color(0);
    isHovered = false;
  }
  public void drawButton(){
    stroke(strokeColor);
    fill(fillColor);
    shape(icon,x,y,w,h);
  }
}
