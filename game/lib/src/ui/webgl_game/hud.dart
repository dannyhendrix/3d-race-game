part of webgl_game;

//TODO: move this to something generic
Map<VehicleThemeColor, String> colorMappingCss = {
  VehicleThemeColor.Black   : "#333",
  VehicleThemeColor.White   : "#FFF",
  VehicleThemeColor.Gray    : "#999",
  VehicleThemeColor.Red     : "#F00",
  VehicleThemeColor.Green   : "#0F0",
  VehicleThemeColor.Blue    : "#00F",
  VehicleThemeColor.Yellow  : "#FF0",
  VehicleThemeColor.Orange  : "#F80",
  VehicleThemeColor.Pink    : "#F4F",
};
Map<VehicleThemeColor, String> colorMappingText = {
  VehicleThemeColor.Black   : "Black",
  VehicleThemeColor.White   : "White",
  VehicleThemeColor.Gray    : "Gray",
  VehicleThemeColor.Red     : "Red",
  VehicleThemeColor.Green   : "Green",
  VehicleThemeColor.Blue    : "Blue",
  VehicleThemeColor.Yellow  : "Yellow",
  VehicleThemeColor.Orange  : "Orange",
  VehicleThemeColor.Pink    : "Pink",
};
Map<VehicleThemeColor, GlColor> colorMappingGl = {
  VehicleThemeColor.Black : new GlColor(0.2,0.2,0.2),
  VehicleThemeColor.White : new GlColor(1.0,1.0,1.0),
  VehicleThemeColor.Gray : new GlColor(0.7,0.7,0.7),
  VehicleThemeColor.Red : new GlColor(1.0,0.0,0.0),
  VehicleThemeColor.Green : new GlColor(0.0,1.0,0.0),
  VehicleThemeColor.Blue : new GlColor(0.0,0.0,1.0),
  VehicleThemeColor.Yellow : new GlColor(1.0,1.0,0.0),
  VehicleThemeColor.Orange : new GlColor(1.0,0.5,0.0),
  VehicleThemeColor.Pink : new GlColor(1.0,0.3,1.0),
};

class PlayerStats{
  Element element;
  Element el_position;
  Player player;
  PlayerStats(this.player){
    element = _createElement();
  }
  void setPosition(int position){
    el_position.text = "$position";
  }
  Element _createElement(){
    DivElement el = new DivElement();
    if(player is HumanPlayer)
      el.className = "humanplayer player";
    else
      el.className = "player";
    Element el_name = new DivElement();
    el_position = new DivElement();
    el_position.className = "position";
    el_name.className = "playername";
    el_name.text = player.name;
    Element el_color = new DivElement();
    el_color.className = "color";
    Element el_color1 = new DivElement();
    el_color1.className = "color1";
    el_color1.style.background = "${colorMappingCss[player.theme.color1]}";
    Element el_color2 = new DivElement();
    el_color2.className = "color2";
    el_color2.style.background = "${colorMappingCss[player.theme.color2]}";
    el_color.append(el_color1);
    el_color.append(el_color2);
    el.append(el_position);
    el.append(el_color);
    el.append(el_name);
    return el;
  }
}