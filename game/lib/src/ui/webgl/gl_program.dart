// Copyright (c) 2013, John Thomas McDole.
/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
part of webgl;

/**
 * Create a WebGL [Program], compiling [Shader]s from passed in sources and
 * cache [UniformLocation]s and AttribLocations.
 */
class GlProgram {
  Map<String, int> attributes = new Map<String, int>();
  Map<String, UniformLocation> uniforms = new Map<String, UniformLocation>();
  Program program;

  Shader fragShader, vertShader;

  GlProgram(String fragSrc, String vertSrc, List<String> attributeNames, List<String> uniformNames, RenderLayer3d layer) {
    RenderingContext ctx = layer.ctx;
    fragShader = ctx.createShader(FRAGMENT_SHADER);
    ctx.shaderSource(fragShader, fragSrc);
    ctx.compileShader(fragShader);

    vertShader = ctx.createShader(VERTEX_SHADER);
    ctx.shaderSource(vertShader, vertSrc);
    ctx.compileShader(vertShader);

    program = ctx.createProgram();
    ctx.attachShader(program, vertShader);
    ctx.attachShader(program, fragShader);
    ctx.linkProgram(program);

    if (!ctx.getProgramParameter(program, LINK_STATUS)) {
      print("Could not initialise shaders");
    }

    for (String attrib in attributeNames) {
      int attributeLocation = ctx.getAttribLocation(program, attrib);
      print(attributeLocation);
      ctx.enableVertexAttribArray(attributeLocation);
      attributes[attrib] = attributeLocation;
    }
    for (String uniform in uniformNames) {
      var uniformLocation = ctx.getUniformLocation(program, uniform);
      uniforms[uniform] = uniformLocation;
    }
  }
}
