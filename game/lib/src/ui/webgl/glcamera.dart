part of webgl;

class GlCamera{
  double x=0.0, y=0.0, z=0.0;
  double tx=0.0, ty=0.0, tz=0.0;

  double fieldOfViewRadians = 2.0;
  double aspect = 1.0;
  double zFar = 2000.0, zNear = 1.0;

  GlCamera(this.aspect){

  }

  GlMatrix createMatrix(){
    //1 set perspective
    GlMatrix perspective = GlMatrix.perspectiveMatrix(fieldOfViewRadians, aspect, zNear, zFar);

    //2 create camera
    GlMatrix cameraMatrix = GlMatrix.identityMatrix();
    cameraMatrix = cameraMatrix.translate(x,y,z);

    var targetPosition = new GlVector(tx,ty,tz);
    var cameraPosition = new GlVector(cameraMatrix.val(3,0),cameraMatrix.val(3,1), cameraMatrix.val(3,2));
    var up = new GlVector(0.0,1.0,0.0);
    cameraMatrix = GlMatrix.lookAtMatrix(cameraPosition, targetPosition, up);

    GlMatrix viewMatrix = cameraMatrix.inverse();
    GlMatrix viewProjectionMatrix = perspective*viewMatrix;
    return viewProjectionMatrix;
  }
}