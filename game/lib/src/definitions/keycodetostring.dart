part of game.definitions;

abstract class KeycodeToString
{
  static int undefined = -90;
  static Map<int,String> _keyCodeToString = {
    -1: "Mouse left",
    -2:  "Mouse middle",
    -3: "Mouse right",
    8 : "Backspace", //  backspace
    9 : "Tab", //  tab
    13 : "Enter", //  enter
    16 : "Shift", //  shift
    17 : "Ctrl", //  ctrl
    18 : "Alt", //  alt
    19 : "Pause/Break", //  pause/break
    20 : "Caps lock", //  caps lock
    27 : "Escape", //  escape
    32 : "Spacebar", // spacebar
    33 : "Page up", // page up, to avoid displaying alternate character and confusing people
    34 : "Page down", // page down
    35 : "End", // end
    36 : "Home", // home
    37 : "Left arrow", // left arrow
    38 : "Up arrow", // up arrow
    39 : "Right arrow", // right arrow
    40 : "Down arrow", // down arrow
    45 : "Insert", // insert
    46 : "Delete", // delete
    48 : "0",
    49 : "1",
    50 : "2",
    51 : "3",
    52 : "4",
    53 : "5",
    54 : "6",
    55 : "7",
    56 : "8",
    57 : "9",
    65 : "A",
    66 : "B",
    67 : "C",
    68 : "D",
    69 : "E",
    70 : "F",
    71 : "G",
    72 : "H",
    73 : "I",
    74 : "J",
    75 : "K",
    76 : "L",
    77 : "M",
    78 : "N",
    79 : "O",
    80 : "P",
    81 : "Q",
    82 : "R",
    83 : "S",
    84 : "T",
    85 : "U",
    86 : "V",
    87 : "W",
    88 : "X",
    89 : "Y",
    90 : "Z",
    91 : "Left window", // left window
    92 : "Right window", // right window
    93 : "Select key", // select key
    96 : "Numpad 0", // numpad 0
    97 : "Numpad 1", // numpad 1
    98 : "Numpad 2", // numpad 2
    99 : "Numpad 3", // numpad 3
    100 : "Numpad 4", // numpad 4
    101 : "Numpad 5", // numpad 5
    102 : "Numpad 6", // numpad 6
    103 : "Numpad 7", // numpad 7
    104 : "Numpad 8", // numpad 8
    105 : "Numpad 9", // numpad 9
    106 : "Multiply", // multiply
    107 : "Add", // add
    109 : "Subtract", // subtract
    110 : "Decimal point", // decimal point
    111 : "Divide", // divide
    112 : "F1", // F1
    113 : "F2", // F2
    114 : "F3", // F3
    115 : "F4", // F4
    116 : "F5", // F5
    117 : "F6", // F6
    118 : "F7", // F7
    119 : "F8", // F8
    120 : "F9", // F9
    121 : "F10", // F10
    122 : "F11", // F11
    123 : "F12", // F12
    144 : "Num lock", // num lock
    145 : "Scroll lock", // scroll lock
    186 : ",", // semi-colon
    187 : "=", // equal-sign
    188 : ",", // comma
    189 : "-", // dash
    190 : ".", // period
    191 : "/", // forward slash
    192 : "`", // grave accent
    219 : "[", // open bracket
    220 : "\\", // back slash
    221 : "]", // close bracket
    222 : "'", // single quote
  };

  static String translate(int key)
  {
    if(key == undefined)
      return "Undefined key";
    return _keyCodeToString.containsKey(key) ? _keyCodeToString[key] : "Invalid key";
  }

  static bool isValidKey(int key)
  {
    return _keyCodeToString.containsKey(key);
  }
}