part of game.menu;

typedef void OnEnterKey(int keyId);

class EnterKey
{
  void requestKey(OnEnterKey callback)
  {
    showEnterKeyWindow(true);

    List<StreamSubscription> streams;
    var cancelStreams = (){streams.forEach((StreamSubscription s){ s.cancel(); });};

    StreamSubscription<MouseEvent> onBodyClick;
    StreamSubscription<MouseEvent> onBodyContext;
    StreamSubscription<KeyboardEvent> onBodyKeyPress;
    StreamSubscription<TouchEvent> onBodyTouch;

    var onKey = (Event e, int key){
      e.preventDefault();
      e.stopPropagation();
      cancelStreams();
      showEnterKeyWindow(false);
      if(key != null)
        callback(key);
    };
    var onClick = (MouseEvent e){ onKey(e, convertMouseClickToKeyIndex(e)); };
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
  Element _el_EnterKey;

  Element createEnterKeyScreen()
  {
    DivElement el = new DivElement();
    el.id = "enterkey";
    el.text = "Press prefered key or mouse button";
    _el_EnterKey = el;
    showEnterKeyWindow(false);
    return el;
  }

  void showEnterKeyWindow(bool show)
  {
    _el_EnterKey.style.display = show ? "block" : "none";
  }
}