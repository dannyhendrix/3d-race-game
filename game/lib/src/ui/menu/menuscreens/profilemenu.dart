part of game.menu;


class ProfileMenu extends GameMenuMainScreen{
  GameSettings _settings;
  TextureGenerator _textureGenerator;
  ColorSelection _colorSelectionMain;
  ColorSelection _colorSelectionSub;
  ImageElement _el_vehiclePreview;
  UiPanelForm _form;
  UiInputText _inUsername;

  VehicleThemeColor _colorCache1;
  VehicleThemeColor _colorCache2;

  ProfileMenu(ILifetime lifetime) : super(lifetime, GameMainMenuPage.Profile){
    _settings = lifetime.resolve();
    _textureGenerator = lifetime.resolve();
    _colorSelectionMain = lifetime.resolve();
    _colorSelectionSub = lifetime.resolve();
    _form = lifetime.resolve();
    _inUsername = lifetime.resolve();
    _el_vehiclePreview = new ImageElement();

    showClose = false;
    showBack = true;
    title = "Profile";
  }

  @override
  void build(){
    super.build();
    _colorSelectionMain.onValueChange = (VehicleThemeColor newColor){
      _settings.user_color1.v = newColor;
      _onColorChange();
      _settings.saveToCookie();
    };
    _colorSelectionSub.onValueChange = (VehicleThemeColor newColor){
      _settings.user_color2.v = newColor;
      _onColorChange();
      _settings.saveToCookie();
    };

    _inUsername..changeLabel("Username")..onValueChange = (String newValue){
      _settings.user_name.v = newValue;
      _settings.saveToCookie();
    };

    _form.appendElement(_el_vehiclePreview);
    _form.append(_colorSelectionMain);
    _form.append(_colorSelectionSub);
    _form.append(_inUsername);
    append(_form);
  }

  @override
  void enterMenu(GameMenuStatus status){
    _colorSelectionMain.setValue(_settings.user_color1.v);
    _colorSelectionSub.setValue(_settings.user_color2.v);
    _inUsername.setValue(_settings.user_name.v);
    _onColorChange();
    super.enterMenu(status);
  }

  void _onColorChange(){

    if(_colorCache1 == _settings.user_color1.v && _colorCache2 == _settings.user_color2.v) return;
    _colorCache1 = _settings.user_color1.v;
    _colorCache2 = _settings.user_color2.v;
    _el_vehiclePreview.src = _createPreviewFromModel(new GlModel_Vehicle(), colorMappingGl[_settings.user_color1.v], colorMappingGl[_settings.user_color2.v]);

    if(_settings.client_changeCSSWithThemeChange.v)
    {
      LinkElement theme1 = document.querySelector("#css_theme1");
      theme1.href = "theme1/${colorMappingText[_settings.user_color1.v].toLowerCase()}.css";
      LinkElement theme2 = document.querySelector("#css_theme2");
      theme2.href = "theme2/${colorMappingText[_settings.user_color2.v].toLowerCase()}.css";
    }
  }

  String _createPreviewFromModel(dynamic model, GlColor c1, GlColor c2){
    GlPreview preview = new GlPreview(200.0,150.0,(GlModelCollection modelCollection){
      model.loadModel(modelCollection);
      var instance = model.getModelInstance(modelCollection, c1, c2, new GlColor(0.7, 0.7, 0.9),"car");

      return [instance];

    },_settings.client_renderType.v == GameRenderType.Textures);
    preview.ox = 0.0;
    preview.oy = 26.0;
    preview.oz = 200.0;
    preview.rx = 1.0;
    preview.ry = 2.6;
    preview.rz = 5.8;
    preview.lx = 0.0;
    preview.ly = 0.5;
    preview.lz = -1.0;
    preview.lightImpact = 0.3;

    preview.create();
    preview.layer.setTexture("car", _textureGenerator.CreateTexture(c1, c2,"textures/texture_vehicle1").canvas);
    preview.draw();
    return preview.layer.canvas.toDataUrl("image/png");
  }
}


