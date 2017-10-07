part of webgl;

class GlModelCollection{
  Map<String, GlModelBuffer> _models = {};
  GlRenderLayer layer;
  GlModelCollection(this.layer);
  void LoadModelsFromJson(Map json){
    for(Map m in json["models"]){
      _models[m["id"]] = new GlJsonModel(m).createBuffers(layer);
    }
  }
  GlModelBuffer getModelBuffer(String id) => _models[id];
  GlModelBuffer loadModel(String id, GlModel model){
    _models[id] = model.createBuffers(layer);
  }
}