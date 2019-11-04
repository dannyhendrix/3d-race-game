part of game.menu;

typedef void OnEnterKey(int keyId);

class EnterKey
{
  bool _allowMouse;
  EnterKey([this._allowMouse = true]);

  void requestKey(OnEnterKey callback)
  {
    print("request key");
    showEnterKeyWindow(true);

    List<StreamSubscription> streams;
    var cancelStreams = (){streams.forEach((StreamSubscription s){ s.cancel(); });};

    StreamSubscription<MouseEvent> onBodyClick;
    StreamSubscription<MouseEvent> onBodyContext;
    StreamSubscription<KeyboardEvent> onBodyKeyPress;
    StreamSubscription<TouchEvent> onBodyTouch;

    var onKey = (Event e, int key){
      print("press $key");
      e.preventDefault();
      e.stopPropagation();
      cancelStreams();
      showEnterKeyWindow(false);
      if(key != null)
        callback(key);
    };
    var onClick = (MouseEvent e){ onKey(e, _allowMouse ? convertMouseClickToKeyIndex(e) : null); };
    var onKeyDown = (KeyboardEvent e){ onKey(e, e.keyCode); };
    var onTouchStart = (TouchEvent e){ onKey(e, null); };

    onBodyClick = document.body.onClick.listen(onClick);
    onBodyContext = document.body.onContextMenu.listen(onClick);
    onBodyKeyPress = document.body.onKeyDown.listen(onKeyDown);
    onBodyTouch = document.body.onTouchStart.listen(onTouchStart);

    streams = [onBodyClick,onBodyContext,onBodyKeyPress,onBodyTouch];
  }

  int convertMouseClickToKeyIndex(MouseEvent e)
  {
    return -(e.button+1);
  }

  /**
   * Press key screen
   */
  UiElement _el_EnterKey;

  UiElement createEnterKeyScreen()
  {
    var el = new UiPanel();
    el.element.id = "enterkey";
    var txt = "Press prefered key";
    if(_allowMouse) txt += " or mouse button";
    _el_EnterKey = el;
    el.append(UiText(txt));
    showEnterKeyWindow(false);
    return el;
  }

  void showEnterKeyWindow(bool show)
  {
    print(show);
    _el_EnterKey.display(show);
  }
}