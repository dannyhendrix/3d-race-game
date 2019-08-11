part of game.leveleditor;

class UITable{
  int columns;
  int rows;
  List<List<Element>> _cells;
  UITable(this.columns, this.rows);
  void append(int column, int row, Node element){
    _cells[row][column].append(element);
  }
  Element createElement(){
    var table = new TableElement();
    _cells = [];
    for(int row = 0; row < rows; row++){
      _cells.add([]);
      var tr = new TableRowElement();
      table.append(tr);
      for(int column = 0; column < columns; column++){
        var td = new TableCellElement();
        tr.append(td);
        _cells[row].add(td);
      }
    }
    return table;
  }
}