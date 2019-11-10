part of uihelper;

class UiIcon extends UiElement{
  String icon;
  UiIcon(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<ElementFactory>().createTag('i');
  }
  @override
  void build(){
    super.build();
    element.className = "material-icons";
    element.text = icon;
  }
  void changeIcon(String icon){
    element.text = icon;
  }
}







