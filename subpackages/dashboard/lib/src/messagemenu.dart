part of menu;
//TODO: this is not optimal for the menustatus construction yet
abstract class MessageMenu<H extends MenuStatus> extends MenuScreen<H>
{
  //TODO: known bug: if 2 messages are shown in 1 menusession, the message/title is overwritten
  UiTextHtml txt_message;

  UiContainer setupFields()
  {
    var el = super.setupFields();
    txt_message = new UiTextHtml("");
    el.append(txt_message);
    return el;
  }

  void setMessage(String title, String message,[bool viewCloseButton = true, bool viewBackButton = false])
  {
    txt_message.changeText(message);
    this.backbutton = viewBackButton;
    this.closebutton = viewCloseButton;
  }
}