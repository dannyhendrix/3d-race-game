part of game.leveleditor;

class ClickAddMenu extends EditorMenu {
  UiInputOptionRadio _selection;
  ClickAddMenu(ILifetime lifetime) : super(lifetime) {
    _selection = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    changeTitle("Add new");
    _selection
      ..changeLabel("Add on click")
      ..onValueChange = (item) {
        _editor._currentClickOption = item;
      };
    _selection
      ..setOptions(ClickToAddOptions.values)
      ..setValue(ClickToAddOptions.None);
    append(_selection);
  }
}
