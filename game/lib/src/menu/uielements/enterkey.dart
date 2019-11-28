part of game.menu;

typedef void OnEnterKey(int keyId);

class EnterKey extends UiPanel
{
  UiText _txtInfo;

  EnterKey(ILifetime lifetime) : super(lifetime){
    _txtInfo = lifetime.resolve();
  }

  @override build(){
    super.build();
    setStyleId("enterkey");
    append(_txtInfo);
    hide();
  }

  void _updateText(bool allowMouse){
    var txt = "Press prefered key";
    if(allowMouse) txt += " or mouse button";
    _txtInfo.changeText(txt);
  }

  void requestKey(OnEnterKey callback, bool allowMouse)
  {
    _updateText(allowMouse);
    show();

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
      hide();
      if(key != null)
        callback(key);
    };
    var onClick = (MouseEvent e){ onKey(e, allowMouse ? _convertMouseClickToKeyIndex(e) : null); };
    var onKeyDown = (KeyboardEvent e){ onKey(e, e.keyCode); };
    var onTouchStart = (TouchEvent e){ onKey(e, null); };

    onBodyClick = document.body.onClick.listen(onClick);
    onBodyContext = document.body.onContextMenu.listen(onClick);
    onBodyKeyPress = document.body.onKeyDown.listen(onKeyDown);
    onBodyTouch = document.body.onTouchStart.listen(onTouchStart);

    streams = [onBodyClick,onBodyContext,onBodyKeyPress,onBodyTouch];
  }

  int _convertMouseClickToKeyIndex(MouseEvent e)
  {
    return -(e.button+1);
  }
}