part of webgl_game;

class TextureGenerator{
  ResourceManager _resourceManager;
  TextureGenerator(this._resourceManager);

  RenderLayer CreateTexture(GlColor color1, GlColor color2, [String texture = "texture_vehicle"]){
    var layer = new RenderLayer.withSize(256,256);
    layer.drawImage(_resourceManager.getTexture(texture), 0, 0);
    var newColors = _constructReplaceColors(_getColorInts(color1),_getColorInts(color2));
    var oldColors = _constructReplaceColors([90,240,0,255],[240,0,180,255]);
    _replaceColors(layer,oldColors, newColors);
    return layer;
  }

  List<List<int>> _constructReplaceColors(List<int> newColor1Ints, List<int> newColor2Ints){
    return [newColor1Ints, _getColorIntsDark(newColor1Ints, 20),_getColorIntsDark(newColor1Ints, 40),
    newColor2Ints, _getColorIntsDark(newColor2Ints, 20),_getColorIntsDark(newColor2Ints, 40)];
  }

  void _replaceColors(RenderLayer layer,List<List<int>> oldColors, List<List<int>> newColors) {
    var imgdata = layer.ctx.getImageData(0, 0, layer.actualwidth, layer.actualheight);
    List<int> newColor;
    List<int> color;

    for (int i = 0; i < imgdata.data.length; i += 4) {
      for (int j = 0; j < newColors.length; j++) {
        newColor = newColors[j];
        color = oldColors[j];
        if (imgdata.data[i] == color[0] && imgdata.data[i + 1] == color[1] && imgdata.data[i + 2] == color[2] && imgdata.data[i + 3] == color[3]) {
          imgdata.data[i] = newColor[0];
          imgdata.data[i + 1] = newColor[1];
          imgdata.data[i + 2] = newColor[2];
          imgdata.data[i + 3] = newColor[3];
        }
      }
    }
    layer.ctx.putImageData(imgdata, 0, 0);
  }
  List<int> _getColorInts(GlColor color){
    return [_getColorInt(color.r),_getColorInt(color.g),_getColorInt(color.b),_getColorInt(color.a)];
  }
  int _getColorInt(double percentage){
    return (percentage*255).toInt();
  }
  List<int> _getColorIntsDark(List<int> color, int darkness){
    return [_applyDarkness(color[0],darkness),_applyDarkness(color[1],darkness),_applyDarkness(color[2],darkness),color[3]];
  }
  int _applyDarkness(int value, int darkness){
    return Math.max(value-darkness, 0);
  }
}