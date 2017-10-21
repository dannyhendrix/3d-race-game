part of webgl;

abstract class GLCamera{
  GlMatrix get cameraMatrix;
}
class GlCameraWithPerspective{
  GlMatrix perspective;
  GlMatrix get cameraMatrix => perspective;
  void setPerspective({double fieldOfViewRadians:0.5, double aspect:1.0, double zNear:1.0, double zFar:2000.0}){
    perspective = GlMatrix.perspectiveMatrix(fieldOfViewRadians, aspect, zNear, zFar);
  }
}

class GlCameraDistanseToTarget extends GlCameraWithPerspective{
  GlMatrix viewProjectionMatrix;

  GlMatrix get cameraMatrix => viewProjectionMatrix;

  void setCameraAngleAndOffset(GlVector targetPosition, {double rx:0.0, double ry:0.0, double rz:0.0, double offsetX : 0.0, double offsetY : 0.0, double offsetZ : 0.0}){
    GlMatrix cameraMatrix = GlMatrix.identityMatrix();
    cameraMatrix = cameraMatrix.translate(targetPosition.x, targetPosition.y, targetPosition.z);
    // 1 rotate camera on 0,0
    cameraMatrix = cameraMatrix.rotateX(rx);
    cameraMatrix = cameraMatrix.rotateY(ry);
    cameraMatrix = cameraMatrix.rotateZ(rz);
    // 2 move camera away from 0,0
    cameraMatrix = cameraMatrix.translate(offsetX,offsetY,offsetZ);
    // 3 make camera 0,0 and reverse the world
    GlMatrix viewMatrix = cameraMatrix.inverse();
    viewProjectionMatrix = perspective*viewMatrix;
  }
}

class GlCameraPositionToTarget extends GlCameraWithPerspective{
  GlMatrix viewProjectionMatrix;

  GlMatrix get cameraMatrix => viewProjectionMatrix;

  void setCameraPositionAndTargetPosition(GlVector targetPosition, GlVector cameraPosition){
    // 1 create camera
    GlVector up = new GlVector(0.0,1.0,0.0);
    GlMatrix cameraMatrix = GlMatrix.lookAtMatrix(cameraPosition, targetPosition, up);

    // 2 make camera 0,0 and reverse the world
    GlMatrix viewMatrix = cameraMatrix.inverse();
    viewProjectionMatrix = perspective*viewMatrix;
  }
}