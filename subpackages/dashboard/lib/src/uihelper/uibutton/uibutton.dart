part of uihelper;

typedef void OnButtonClick();

abstract class UiButton extends UiElement{
  Element _createButton()
  {
    var btn = new ButtonElement();
    btn.className = "button";
    btn.onClick.listen((MouseEvent e){ _onButtonClick(e); return false; });
    btn.onTouchStart.listen((TouchEvent e){ _onButtonClick(e); return false; });
    return btn;
  }
  void _onButtonClick(Event e);
}