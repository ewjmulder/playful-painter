public class EffectType {
    
  private String name;
  private int iconX;
  private int iconY;
  private PImage icon;
  private List<SliderData> sliders;
  
  public EffectType(String name, int iconX, int iconY, PImage icon) {
    this.name = name;
    this.iconX = iconX;
    this.iconY = iconY;
    this.icon = icon;
    this.sliders = new ArrayList<SliderData>();
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
  
  public void addSlider(String name, float min, float max) {
    sliders.add(new SliderData(name, min, max));
  } 
  
  public List<SliderData> getSliders() {
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
