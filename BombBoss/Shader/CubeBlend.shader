//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/CubeBlend" {
Properties {
[NoScaleOffset]  _TexA ("Cubemap", CUBE) = "grey" { }
[NoScaleOffset]  _TexB ("Cubemap", CUBE) = "grey" { }
 _value ("Value", Range(0,1)) = 0.5
}
SubShader { 
 Tags { "QUEUE"="Background" "RenderType"="Background" }
 Pass {
  Tags { "QUEUE"="Background" "RenderType"="Background" }
  ZTest Always
  ZWrite Off
  Fog { Mode Off }
  GpuProgramID 50939
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = impl_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  mediump vec3 tmpvar_3;
  mediump vec4 data_4;
  data_4 = tmpvar_2;
  tmpvar_3 = ((_TexA_HDR.x * data_4.w) * data_4.xyz);
  lowp vec4 tmpvar_5;
  tmpvar_5 = impl_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  mediump vec3 tmpvar_6;
  mediump vec4 data_7;
  data_7 = tmpvar_5;
  tmpvar_6 = ((_TexB_HDR.x * data_7.w) * data_7.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_3, tmpvar_6, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out highp vec3 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
in highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = textureLod (_TexA, xlv_TEXCOORD0, _Level);
  mediump vec3 tmpvar_3;
  mediump vec4 data_4;
  data_4 = tmpvar_2;
  tmpvar_3 = ((_TexA_HDR.x * data_4.w) * data_4.xyz);
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureLod (_TexB, xlv_TEXCOORD0, _Level);
  mediump vec3 tmpvar_6;
  mediump vec4 data_7;
  data_7 = tmpvar_5;
  tmpvar_6 = ((_TexB_HDR.x * data_7.w) * data_7.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_3, tmpvar_6, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  _glesFragData[0] = tmpvar_9;
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
Fallback Off
}