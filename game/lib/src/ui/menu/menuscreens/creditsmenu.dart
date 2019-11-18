part of game.menu;

class CreditsMenu extends GameMenuMainScreen
{
  UiTextHtml _textHtml;
  CreditsMenu(ILifetime lifetime) : super(lifetime, GameMainMenuPage.Credits){
    _textHtml = lifetime.resolve();
  }

  @override
  void build()
  {
    super.build();

    _textHtml.addStyle("credits_wrapper");

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

    htmlb.write('This game was developed in <a href="http://www.dartlang.org">Dart</a> :D.');
    _textHtml.changeText(htmlb.toString());

    append(_textHtml);
  }
}
