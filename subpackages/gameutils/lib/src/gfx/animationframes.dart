/**
@author Danny Hendrix
**/

part of gameutils.gfx;

/**
Simple class for holding animation indexes
**/
class AnimationFrames
{
  final int start;
  final int end;
  final bool repeat;

  const AnimationFrames(this.start,this.end,[this.repeat = true]);
}
