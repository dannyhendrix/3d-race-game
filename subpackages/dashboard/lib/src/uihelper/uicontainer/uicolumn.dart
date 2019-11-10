part of uihelper;

class UiColumn extends UiContainer{
  UiColumn(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<SpanElement>();
  }
  @override
  void build(){
    super.build();
    element.className = "column";
  }
}