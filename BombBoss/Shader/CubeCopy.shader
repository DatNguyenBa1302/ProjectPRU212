//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/CubeCopy" {
Properties {
 _MainTex ("Main", CUBE) = "" { }
 _Level ("Level", Float) = 0
}
SubShader { 
 LOD 200
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 18733
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
vec4 impl_textureCubeLodEXT(samplerCube sampler, vec3 coord, float lod)
{
#if defined(GL_EXT_shader_texture_lod)
 return textureCubeLodEXT(sampler, coord, lod);
#else
 return textureCube(sampler, coord, lod);
#endif
}

uniform highp float _Level;
uniform lowp samplerCube _MainTex;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = impl_textureCubeLodEXT (_MainTex, xlv_TEXCOORD0.xyz, _Level);
  tmpvar_1 = tmpvar_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out highp vec4 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp float _Level;
uniform lowp samplerCube _MainTex;
in highp vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = textureLod (_MainTex, xlv_TEXCOORD0.xyz, _Level);
  tmpvar_1 = tmpvar_2;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
"!!GLES"
}
SubProgram "gles3 " {
"!!GLES3"
}
}
 }
}
}