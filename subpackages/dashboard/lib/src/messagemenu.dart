part of menu;

class MessageMenu<T extends Menu> extends MenuScreen<T>
{
  //TODO: known bug: if 2 messages are shown in 1 menusession, the message/title is overwritten
  MessageMenu(T m): super(m,"Message");
  Element txt_message;

  Element setupFields()
  {
    Element el = super.setupFields();
    txt_message = new SpanElement();
    el.append(txt_message);
    return el;
  }

  void setMessage(String title, String message,[bool viewCloseButton = true, bool viewBackButton = false])
  {
    this.title = title;
    txt_message.innerHtml = message;
    this.backbutton = viewBackButton;
    this.closebutton = viewCloseButton;
  }
}