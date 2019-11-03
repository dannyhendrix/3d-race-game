part of uihelper;

class UiIcon extends UiElement{
  String icon;
  UiIcon(this.icon);
  Element createElement() {
    var iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon;
    return iel;
  }
  void changeIcon(String icon){
    element.text = icon;
  }
}







