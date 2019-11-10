part of menu;
//TODO: this is not optimal for the menuhistory construction yet
abstract class MessageMenu extends MenuScreen
{
  //TODO: known bug: if 2 messages are shown in 1 menusession, the message/title is overwritten
  UiTextHtml _txt_message;

  MessageMenu(ILifetime lifetime, String lifetimeKey){
    _txt_message = lifetime.resolve(key:lifetimeKey);
    element = lifetime.resolve<UiPanel>(key:lifetimeKey);
  }

  void build(){
    element.append(_txt_message);
  }

  void setMessage(String title, String message,[bool viewCloseButton = true, bool viewBackButton = false])
  {
    _txt_message.changeText(message);
    showBack = viewBackButton;
    showClose = viewCloseButton;
  }
}