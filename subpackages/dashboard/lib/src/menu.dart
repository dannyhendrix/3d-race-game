part of menu;

class MenuScreen<T>{
  String title = "Title";
  T id;
  bool showBack = false;
  bool showClose = false;
  UiContainer element;
}

class MenuHistory<T>
{
  List<T> _queue = [];

  void goTo(T id){
    if(any() && _queue.last == id) return;
    _queue.add(id);
  }

  T goBack(){
    return any() ? _queue.removeLast() : null;
  }

  bool any(){
    return _queue.isNotEmpty;
  }

  T current() => _queue.last;

  void clear(){
    _queue.clear();
  }
}

