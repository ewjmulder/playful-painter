public class DesktopMouseDownChecker implements MouseDownChecker {
 
  public boolean isMouseDown() {
    return mouseButton == LEFT || mouseButton == RIGHT || mouseButton == CENTER;
  }
 
}
