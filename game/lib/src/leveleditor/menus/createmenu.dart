part of game.leveleditor;

class CreateMenu extends EditorMenu {
  UiButtonText _buttonCheckpoint;
  UiButtonText _buttonWall;
  UiButtonText _buttonTree;

  CreateMenu(ILifetime lifetime) : super(lifetime) {
    _buttonCheckpoint = lifetime.resolve();
    _buttonWall = lifetime.resolve();
    _buttonTree = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    changeTitle("Add objects");

    _buttonCheckpoint
      ..changeText("New checkpoint")
      ..setOnClick(() {
        _editor._addNewCheckpoint(10.0, 10.0);
      });
    _buttonWall
      ..changeText("New wall")
      ..setOnClick(() {
        _editor._addNewWall(10.0, 10.0);
      });
    _buttonTree
      ..changeText("New tree")
      ..setOnClick(() {
        _editor._addNewStaticObject(10.0, 10.0);
      });

    append(_buttonCheckpoint);
    append(_buttonWall);
    append(_buttonTree);
  }
}
