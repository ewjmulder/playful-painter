public class EffectType {
    
  private String name;
  private int iconX;
  private int iconY;
  private PImage icon;
  private List<HScrollbar> sliders;
  
  public EffectType(String name, int iconX, int iconY) {
    this.name = name;
    this.iconX = iconX;
    this.iconY = iconY;
    this.icon = null;
    this.sliders = new ArrayList<HScrollbar>();
  }
  
  public String getName() {
    return this.name;
  }
  
  public int getIconX() {
    return this.iconX;
  }

  public int getIconY() {
    return this.iconY;
  }

  public PImage getIcon() {
    return this.icon;
  }
  
  public void setIcon(PImage icon) {
    this.icon = icon;
  }
  
  public void addSlider(HScrollbar slider) {
    sliders.add(slider);
  } 
  
  public List<HScrollbar> getSliders() {
    return this.sliders;
  }
  
}

public class SliderData {
  public SliderData(String name, float min, float max) {
    this.name = name;
    this.min = min;
    this.max = max;
  }
  public String name;
  public float min;
  public float max;
}
