part of webgl;

abstract class GlModelCollection{
  void LoadModelsFromJson(Map json){}
  GlModelBuffer getModelBuffer(String id);
  void loadModel(String id, GlModel model){}
}

class GlModelCollectionBuffer extends GlModelCollection{
  Map<String, GlModelBuffer> _models = {};
  GlRenderLayer _layer;
  GlModelCollectionBuffer(this._layer);
  void LoadModelsFromJson(Map json){
    for(Map m in json["models"]){
      _models[m["id"]] = new GlJsonModel(m).createBuffers(_layer);
    }
  }
  GlModelBuffer getModelBuffer(String id) => _models[id];
  void loadModel(String id, GlModel model){
    _models[id] = model.createBuffers(_layer);
  }
}

class GlModelCollectionModels extends GlModelCollection{
  Map<String, GlModel> _models = {};
  GlModelBuffer getModelBuffer(String id) {
    return null;
  }

  void loadModel(String id, GlModel model) {
    _models[id] = model;
  }

  GlModel getModel(String id){
    return _models[id];
  }
  List<GlModel> getAllModels() => _models.values.toList();
}