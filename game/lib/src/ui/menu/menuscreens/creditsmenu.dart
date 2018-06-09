part of game.menu;

class CreditsMenu extends GameMenuScreen
{
  GameMenuController menu;
  CreditsMenu(this.menu) : super("Credits");

  Element setupFields()
  {
    Element el = super.setupFields();

    DivElement e = new DivElement();
    e.classes.add("credits_wrapper");

    Map jobtitles = {"Game design":["Lead design","Script writer","Object planner","GUI design"],
                     "Art and Animation": ["Creative manager","Art director","PreVis Artist","Lead artist","Animator","Concept artist","Environment artist"],
                     "Programming":["Lead programmer","Software engineer","AI programmer","Tools programmer","Graphics programmer","Gameplay programmer","Engine programmer"],
                      "Audio":["Not implementing audio"],
                      "Quality Assurance":["QA manager","Lead tester"],
                      "Production Management and Publishing":["Head of develpment","Creative director","Executive producer","Programming manager","Production scheduler"]};
    StringBuffer htmlb = new StringBuffer();

    for(String key in jobtitles.keys)
    {
      htmlb.write('<h2 class="menu_subtitle">$key</h2>');

      for(int i = 0; i < jobtitles[key].length; i++)
        htmlb.write('<div class="credit"><span class="title">${jobtitles[key][i]}:</span><span class="value">Danny Hendrix</span></div>');
    }

    e.innerHtml = htmlb.toString();

    el.append(e);

    e = new DivElement();
    e.innerHtml = 'This game was developed in <a href="http://www.dartlang.org">Dart</a> :D.';
    el.append(e);
    return el;
  }
}
