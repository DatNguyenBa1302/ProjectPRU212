//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-Halo" {
SubShader { 
 Tags { "RenderType"="Overlay" }
 Pass {
  Tags { "RenderType"="Overlay" }
  ZWrite Off
  Cull Off
  Blend OneMinusDstColor One
  AlphaTest Greater 0
  ColorMask RGB
  GpuProgramID 31767
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _HaloFalloff_ST;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
}



#endif
#ifdef FRAGMENT

uniform sampler2D _HaloFalloff;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2.xyz = (xlv_COLOR.xyz * tmpvar_1.w);
  tmpvar_2.w = tmpvar_1.w;
  gl_FragData[0] = tmpvar_2;
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesColor;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _HaloFalloff_ST;
out lowp vec4 xlv_COLOR;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _HaloFalloff;
in lowp vec4 xlv_COLOR;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2.xyz = (xlv_COLOR.xyz * tmpvar_1.w);
  tmpvar_2.w = tmpvar_1.w;
  _glesFragData[0] = tmpvar_2;
}



#endif"
}
SubProgram "gles " {
Keywords { "FOG_LINEAR" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_1.z * unity_FogParams.z) + unity_FogParams.w);
}



#endif
#ifdef FRAGMENT

uniform sampler2D _HaloFalloff;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  gl_FragData[0] = col_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "FOG_LINEAR" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesColor;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
out lowp vec4 xlv_COLOR;
out highp vec2 xlv_TEXCOORD0;
out highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_1.z * unity_FogParams.z) + unity_FogParams.w);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _HaloFalloff;
in lowp vec4 xlv_COLOR;
in highp vec2 xlv_TEXCOORD0;
in highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  _glesFragData[0] = col_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "FOG_EXP" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = exp2(-((unity_FogParams.y * tmpvar_1.z)));
}



#endif
#ifdef FRAGMENT

uniform sampler2D _HaloFalloff;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  gl_FragData[0] = col_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "FOG_EXP" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesColor;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
out lowp vec4 xlv_COLOR;
out highp vec2 xlv_TEXCOORD0;
out highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = exp2(-((unity_FogParams.y * tmpvar_1.z)));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _HaloFalloff;
in lowp vec4 xlv_COLOR;
in highp vec2 xlv_TEXCOORD0;
in highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  _glesFragData[0] = col_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "FOG_EXP2" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp float tmpvar_2;
  tmpvar_2 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = exp2((-(tmpvar_2) * tmpvar_2));
}



#endif
#ifdef FRAGMENT

uniform sampler2D _HaloFalloff;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  gl_FragData[0] = col_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "FOG_EXP2" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesColor;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _HaloFalloff_ST;
out lowp vec4 xlv_COLOR;
out highp vec2 xlv_TEXCOORD0;
out highp float xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp float tmpvar_2;
  tmpvar_2 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _HaloFalloff_ST.xy) + _HaloFalloff_ST.zw);
  xlv_TEXCOORD1 = exp2((-(tmpvar_2) * tmpvar_2));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _HaloFalloff;
in lowp vec4 xlv_COLOR;
in highp vec2 xlv_TEXCOORD0;
in highp float xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture (_HaloFalloff, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = (xlv_COLOR.xyz * tmpvar_2.w);
  tmpvar_3.w = tmpvar_2.w;
  col_1.w = tmpvar_3.w;
  highp float tmpvar_4;
  tmpvar_4 = clamp (xlv_TEXCOORD1, 0.0, 1.0);
  col_1.xyz = mix (vec3(0.0, 0.0, 0.0), tmpvar_3.xyz, vec3(tmpvar_4));
  _glesFragData[0] = col_1;
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
SubProgram "gles " {
Keywords { "FOG_LINEAR" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "FOG_LINEAR" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "FOG_EXP" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "FOG_EXP" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "FOG_EXP2" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "FOG_EXP2" }
"!!GLES3"
}
}
 }
}
}