part of webgl_game;

typedef OnValueChanged(Input input);
typedef MapInput(Input input);
abstract class Input{
  //TODO: type is not supported/filled correctly
  Type type;
  bool isNull = false;
  dynamic createValue();
  dynamic createEmpty();
  Element createElement(String name, dynamic currentValue);
  void map(MapInput f) => f(this);
  OnValueChanged onValueChanged;

  static final _listBaseType = reflectType(List);
  static final _mapBaseType = reflectType(Map);
  static Input createInput(Type type, OnValueChanged onValueChanged)
  {
    Input input = _createInput(type);
    input.onValueChanged = onValueChanged;
    return input;
  }
  static Input _createInput(Type type){
    if(type == int) return new InputInt();
    if(type == double) return new InputDouble();
    if(type == String) return new InputString();
    if(type == bool) return new InputBool();
    TypeMirror typemirror = reflectType(type);
    if (typemirror.originalDeclaration.isSubtypeOf(_listBaseType)){
      Type subtype = typemirror.typeArguments.first.reflectedType;
      return new InputList(subtype);
    }
    var cs = reflectClass(type);
    if(cs.isEnum) return new InputEnum(cs);
    return new InputObj(cs);
  }
}
class InputList extends Input{
  List<Input> _inputs;
  Map<Input,Element> _inputElements;
  Element _el_items;
  Type type;
  InputList(this.type);
  dynamic createValue() => isNull ? null : _inputs.map((Input input) => input.createValue()).toList();
  dynamic createEmpty() => [];

  void map(MapInput f){
    f(this);
    for(int i = 0; i< _inputs.length; i++) _inputs[i].map(f);
  }
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    _el_items = new SpanElement();
    el_wrap.className = "in listIn";
    el_legend.text = name;
    el_wrap.append(el_legend);
    el_wrap.append(_el_items);
    _inputs = [];
    _inputElements = {};
    for(int i = 0; i < currentValue.length; i++){
      _createNewListItem(currentValue[i]);
    }
    el_wrap.append(createButton("add", (Event e){
      _createNewListItem(null);
    }));
    return el_wrap;
  }
  void _createNewListItem(dynamic itemValue){
    Input input = Input.createInput(type, onValueChanged);
    if(itemValue == null) itemValue = input.createEmpty();
    _inputs.add(input);
    Element el_wrap = new DivElement();
    el_wrap.append(input.createElement("", itemValue));

    el_wrap.append(createButton("content_copy", (Event e){
      dynamic clone = CloneObject.clone(input.createValue());
      _createNewListItem(clone);
    }));
    el_wrap.append(createButton("remove", (Event e){
      _inputs.remove(input);
      _inputElements[input].remove();
      _inputElements.remove(input);
    }));

    _inputElements[input] = el_wrap;
    _el_items.append(el_wrap);
  }
}
class InputObj extends Input{
  Map<Symbol, Input> _inputs;
  ClassMirror _cm;
  Type objType;

  InputObj(this._cm){
    objType = _cm.reflectedType;
  }
  dynamic createValue(){
    if(isNull) return null;
    ClassMirror cm = _cm;
    InstanceMirror newinstance = cm.newInstance(new Symbol(""), []);
    while(cm != null){
      cm.declarations.values.where((x) => x is VariableMirror).forEach((VariableMirror dm){
        Symbol s = dm.simpleName;
        newinstance.setField(s, _inputs[s].createValue());
      });
      cm = cm.superclass;
    }
    return newinstance.reflectee;
  }
  void map(MapInput f){
    f(this);
    for(Input i in _inputs.values) i.map(f);
  }

  dynamic createEmpty()=> _cm.newInstance(new Symbol(""), []).reflectee;

  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap;
    if(name == null || name.isEmpty){
      el_wrap = new SpanElement();
    }else{
      el_wrap = new FieldSetElement();
      Element el_legend = new LegendElement();
      el_legend.text = name;
      el_wrap.append(el_legend);
    }
    el_wrap.className = "in objIn";

    _inputs = {};
    InstanceMirror instance = reflect(currentValue);
    ClassMirror cm = instance.type;
    while(cm != null){
      cm.declarations.values.where((x) => x is VariableMirror && !x.isPrivate).forEach((VariableMirror dm){
        Symbol s = dm.simpleName;
        Input input = Input.createInput(dm.type.reflectedType, onValueChanged);
        _inputs[s] = input;
        el_wrap.append(input.createElement(MirrorSystem.getName(s), instance.getField(s).reflectee));
      });
      cm = cm.superclass;
    }
    return el_wrap;
  }
}
class InputInt extends Input{
  InputElement _inputElement;
  dynamic createValue() => isNull ? null : int.parse(_inputElement.value);
  dynamic createEmpty() => 0;
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new SpanElement();
    el_wrap.className = "in intIn";
    el_wrap.appendText(name);
    _inputElement = new InputElement();
    _inputElement.value = currentValue.toString();
    _inputElement.onChange.listen((Event e){
      if(onValueChanged != null) onValueChanged(this);
    });
    el_wrap.append(_inputElement);
    return el_wrap;
  }
}
class InputEnum extends Input{
  ClassMirror _cm;
  Type objType;
  List<String> _options;

  InputEnum(this._cm){
    objType = _cm.reflectedType;
    _options = [];
    // This is more future rebust but prints the values as "EnumName.ValueName"
    /*
    for(var name in _cm.getField(new Symbol("values")).reflectee){
      _options.add(name.toString());
    }*/
    for(var x in _cm.staticMembers.values){
      String name = MirrorSystem.getName(x.simpleName);
      if(name == "values") continue;
      _options.add(name);
    }
  }
  SelectElement _inputElement;
  dynamic createValue() => _cm.getField(new Symbol("values")).reflectee[_inputElement.selectedIndex];
  dynamic createEmpty() => _cm.getField(new Symbol("values")).reflectee.first;
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new SpanElement();
    el_wrap.className = "in enumIn";
    el_wrap.appendText(name);
    _inputElement = new SelectElement();
    for(String value in _options){
      _inputElement.append(new OptionElement(data:value));
    }
    _inputElement.selectedIndex = currentValue.index;
    _inputElement.onChange.listen((Event e){
      if(onValueChanged != null) onValueChanged(this);
    });
    el_wrap.append(_inputElement);
    return el_wrap;
  }
}
class InputDouble extends Input{
  InputElement _inputElement;
  dynamic createValue() => isNull ? null : double.parse(_inputElement.value);
  dynamic createEmpty() => 0.0;
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new SpanElement();
    el_wrap.className = "in doubleIn";
    el_wrap.appendText(name);
    _inputElement = new InputElement();
    _inputElement.value = currentValue.toString();
    _inputElement.onChange.listen((Event e){
      if(onValueChanged != null) onValueChanged(this);
    });
    el_wrap.append(_inputElement);
    return el_wrap;
  }
}
class InputString extends Input{
  InputElement _inputElement;
  dynamic createValue() => isNull ? null : _inputElement.value;
  dynamic createEmpty() => "";
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new SpanElement();
    el_wrap.className = "in stringIn";
    el_wrap.appendText(name);
    _inputElement = new InputElement();
    _inputElement.value = currentValue.toString();
    _inputElement.onChange.listen((Event e){
      if(onValueChanged != null) onValueChanged(this);
    });
    el_wrap.append(_inputElement);
    return el_wrap;
  }
}
class InputBool extends Input{
  CheckboxInputElement _inputElement;
  dynamic createValue() => isNull ? null : _inputElement.checked;
  dynamic createEmpty() => false;
  Element createElement(String name, dynamic currentValue){
    if(currentValue == null){
      isNull = true;
      return new SpanElement();
    }
    Element el_wrap = new SpanElement();
    el_wrap.className = "in boolIn";
    el_wrap.appendText(name);
    _inputElement = new CheckboxInputElement();
    _inputElement.checked = currentValue;
    _inputElement.onChange.listen((Event e){
      if(onValueChanged != null) onValueChanged(this);
    });
    el_wrap.append(_inputElement);
    return el_wrap;
  }
}

Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.innerHtml = '<i class="material-icons md-dark">$labelText</i>';
  //btn.text = labelText;
  btn.onClick.listen(onClick);
  btn.className = "btn";
  return btn;
}