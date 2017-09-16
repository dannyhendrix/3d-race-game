import "dart:html";
import "dart:convert";

List<Info> infos = [];
double x =0.0,y =0.0,z =0.0;
double rx =0.0,ry =0.0,rz =0.0;

void main(){
  document.body.append(createTriangleInput());
  document.body.append(createOrientationInput());
}

Element createOrientationInput(){
  DivElement el_wrap = new DivElement();
  var title = new HeadingElement.h2();
  title.text = "Orientation";
  el_wrap.append(title);
  el_wrap.append(createInputElementDouble("x",x,(double v){x=v;}));
  el_wrap.append(createInputElementDouble("y",y,(double v){y=v;}));
  el_wrap.append(createInputElementDouble("z",z,(double v){z=v;}));
  el_wrap.append(createInputElementDouble("rx",rx,(double v){rx=v;}));
  el_wrap.append(createInputElementDouble("ry",ry,(double v){ry=v;}));
  el_wrap.append(createInputElementDouble("rz",rz,(double v){rz=v;}));
  return el_wrap;
}

Element createTriangleInput(){
  DivElement el_wrapper = new DivElement();
  DivElement el_trianglesList = new DivElement();
  el_trianglesList.className = "trianglesList";

  Element output = new DivElement();
  output.className = "output";

  el_wrapper.append(el_trianglesList);
  el_wrapper.append(createButton("Add Triangle", (Event e){
    TraiangleInfo t = new TraiangleInfo();
    el_trianglesList.append(t.element);
    infos.add(t);
  }));
  el_wrapper.append(createButton("Add label", (Event e){
    LabelInfo l = new LabelInfo();
    el_trianglesList.append(l.element);
    infos.add(l);
  }));

  el_wrapper.append(createButton("CreateJson", (Event e){
    var infoJsonList = infos.map((Info info)=>info.toJson()).toList(growable:false);
    output.innerHtml = JSON.encode(infoJsonList);
  }));

  el_wrapper.append(output);
  return el_wrapper;
}

abstract class Info{
  Map toJson();
}

typedef void OnPointValueChange(double newvalue);
class PointInfo extends Info {
  double x =0.0,y =0.0,z =0.0;
  double lx =0.0,ly =0.0,lz =0.0;

  List<InputElement> inputElements;
  InputElement in_x, in_y, in_z, in_lx, in_ly, in_lz;

  Element element;

  PointInfo(){
    element = _createElement();
  }

  Map toJson(){
    Map res = {};
    res["xyz"] = [x,y,z];
    res["light"] = [lx,ly,lz];
    return res;
  }

  Element _createElement(){
    DivElement el_wrap = new DivElement();
    el_wrap.append(createInputElementDouble("x",x,(double v){x=v;}));
    el_wrap.append(createInputElementDouble("y",y,(double v){y=v;}));
    el_wrap.append(createInputElementDouble("z",z,(double v){z=v;}));
    el_wrap.append(createInputElementDouble("lx",lx,(double v){lx=v;}));
    el_wrap.append(createInputElementDouble("ly",ly,(double v){ly=v;}));
    el_wrap.append(createInputElementDouble("lz",lz,(double v){lz=v;}));
    return el_wrap;
  }
}

class TraiangleInfo extends Info{
  List<PointInfo> points;
  Element element;

  TraiangleInfo(){
    points = [];
    for(int i = 0; i < 3; i++)
        points.add(new PointInfo());
    element = _createElement();
  }

  Map toJson(){
    Map res = {};
    res["type"] = "triangle";
    res["points"] = points.map((PointInfo point)=>point.toJson()).toList();
    return res;
  }

  Element _createElement(){
    DivElement el_wrap = new DivElement();
    points.forEach((PointInfo p) => el_wrap.append(p.element));

    el_wrap.append(createMoveUpButton("up", el_wrap, (Event e){}));
    el_wrap.append(createMoveDownButton("down", el_wrap, (Event e){}));

    el_wrap.append(new HRElement());
    el_wrap.className = "triangleIn";

    return el_wrap;
  }
}

class LabelInfo extends Info{
  String label = "";
  Element element;

  LabelInfo(){
    element = _createElement();
  }

  Map toJson(){
    Map res = {};
    res["type"] = "label";
    res["value"] = label;
    return res;
  }

  Element _createElement(){
    DivElement el_wrap = new DivElement();

    InputElement el_label = new InputElement();
    el_label.onChange.listen((Event e){label = el_label.value;});
    el_wrap.append(el_label);
    el_wrap.append(createMoveUpButton("up", el_wrap, (Event e){}));
    el_wrap.append(createMoveDownButton("down", el_wrap, (Event e){}));

    el_wrap.append(new HRElement());
    el_wrap.className = "label";

    return el_wrap;
  }
}

Element createInputElementDouble(String label, double value, OnPointValueChange onChange){
  Element el_wrap = new SpanElement();
  InputElement el = new InputElement();
  el.value = value.toString();
  el.onChange.listen((Event e){
    onChange(double.parse(el.value));
  });
  el_wrap.appendText(label);
  el_wrap.append(el);
  el_wrap.className = "pointIn";
  return el_wrap;
}

Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen(onClick);
  return btn;
}
Element createMoveUpButton(String labelText, Element el_wrap, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen((Event e){
    var index = el_wrap.parent.nodes.indexOf(el_wrap);
    index = (index < 1) ? 0 : index-1;
    Element elBefore = el_wrap.parent.nodes[index];
    el_wrap.parent.insertBefore(el_wrap,elBefore);
    onClick(e);
  });
  return btn;
}
Element createMoveDownButton(String labelText, Element el_wrap, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen((Event e){
    var index = el_wrap.parent.nodes.indexOf(el_wrap);
    index = (index < 0) ? 0 : index+2;
    if(index >= el_wrap.parent.nodes.length){
      el_wrap.parent.append(el_wrap);
    }else{
      Element elBefore = el_wrap.parent.nodes[index];
      el_wrap.parent.insertBefore(el_wrap,elBefore);
    }
    onClick(e);
  });
  return btn;
}