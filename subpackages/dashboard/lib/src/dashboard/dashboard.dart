part of dashboard;

class Dashboard
{
  //main element
  Element element;

  Dashboard()
  {

  }

  void init([bool appendToBody = true])
  {
    element = setupFields();
    if(appendToBody)
      document.body.append(element);
  }

  //can be overwritten to create fields onstart
  //should return the main dashboard DOM element
  Element setupFields()
  {
    DivElement el = new DivElement();
    el.id = "dashboard_wrapper";
    return el;
  }

  void appendElement(Element e)
  {
    element.append(e);
  }

  Element createTopBar({String height : "30px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_header";
    el.className = "dashboard_panel";
    el.style.left = "0px";
    el.style.right = "0px";
    el.style.height = height;
    el.style.top = "0px";
    return el;
  }

  Element createGameFrame({String topOffset : "30px", String bottomOffset : "30px",String leftOffset : "100px", String rightOffset : "100px", String width : "100px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_game";
    el.className = "dashboard_panel";
    el.style.top = topOffset;
    el.style.bottom = bottomOffset;
    el.style.left = leftOffset;
    el.style.right = rightOffset;
    return el;
  }

  Element createBottomBar({String height : "30px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_footer";
    el.className = "dashboard_panel";
    el.style.left = "0px";
    el.style.right = "0px";
    el.style.height = height;
    el.style.bottom = "0px";
    return el;
  }

  Element createLeftSideBar({String topOffset : "30px", String bottomOffset : "30px", String width : "100px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_left";
    el.className = "dashboard_panel";
    el.style.top = topOffset;
    el.style.bottom = bottomOffset;
    el.style.left = "0px";
    el.style.width = width;
    return el;
  }

  Element createRightSideBar({String topOffset : "30px", String bottomOffset : "30px", String width : "100px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_right";
    el.className = "dashboard_panel";
    el.style.top = topOffset;
    el.style.bottom = bottomOffset;
    el.style.right = "0px";
    el.style.width = width;
    return el;
  }

  Element createMainFrame({String topHeight : "30px", String bottomHeight : "30px", String leftWidth : "100px", String rightWidth : "100px"})
  {
    DivElement el = new DivElement();
    el.id = "dashboard_wrapper";
	
	/**
	Layer order (top to bottom)
	1 header
	2 bottom
	3 right
	4 left
	5 game
	**/
	
	el.append(createGameFrame(topOffset : topHeight, bottomOffset : bottomHeight,leftOffset : leftWidth, rightOffset : rightWidth));
    
    if(rightWidth != "0px" && rightWidth != "0%")
      el.append(createRightSideBar(topOffset : topHeight, bottomOffset : bottomHeight, width:rightWidth));
	  
	if(leftWidth != "0px" && leftWidth != "0%")
      el.append(createLeftSideBar(topOffset : topHeight, bottomOffset : bottomHeight, width:leftWidth));

	if(bottomHeight != "0px" && bottomHeight != "0%")
      el.append(createBottomBar(height:bottomHeight));
	  
    if(topHeight != "0px" && topHeight != "0%")
      el.append(createTopBar(height:topHeight));

    return el;
  }

  Element createButton(String label, Function callback)
  {
    ButtonElement btn = new ButtonElement();
    btn.text  = label;
    btn.onClick.listen((MouseEvent e){ e.preventDefault(); callback(e); });
    btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); callback(e); });
    btn.className = "dashboard_btn";
    return btn;
  }
}