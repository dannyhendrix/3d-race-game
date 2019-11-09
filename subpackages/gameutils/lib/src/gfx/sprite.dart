/**
@author Danny Hendrix
**/
part of gameutils.gfx;

abstract class Sprite
{
  int spritex;
  int spritey;
  int framew;
  int frameh;

  Sprite(this.spritex, this.spritey, this.framew, this.frameh);

  void drawOnPosition(int x, int y, int frameX, int frameY, RenderLayer targetlayer);
}

class ImageSprite extends Sprite
{
  ImageElement img;
  ImageSprite(this.img, int spritex, int spritey, int framew, int frameh) : super(spritex, spritey, framew, frameh);
  void drawOnPosition(int x, int y, int frameX, int frameY, RenderLayer targetlayer)
  {
      targetlayer.drawImagePart(img,x,y,frameX * framew + spritex,frameY * frameh + spritey, framew,frameh);
  }
}

class LayerSprite extends Sprite
{
  RenderLayer layer;
  LayerSprite(this.layer, int spritex, int spritey, int framew, int frameh) : super(spritex, spritey, framew, frameh);
  
  void drawOnPosition(int x, int y, int frameX, int frameY, RenderLayer targetlayer)
  {
      targetlayer.drawLayerPart(layer,x,y,frameX * framew + spritex,frameY * frameh + spritey, framew,frameh);
  }
}