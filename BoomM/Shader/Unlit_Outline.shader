//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/Outline" {
Properties {
_Outline ("Outline", Range(0, 0.3)) = 0.02
_OutlineColor ("Outline Color", Color) = (0,0,0,1)
_Alpha ("Alpha", Range(0, 1)) = 1
}
SubShader {
 Pass {
  Name "VERTEXEXTENDED"
  Cull Off
  GpuProgramID 37942
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
}
}
 Pass {
  Name "VERTEXEXTENDED_TRANSPARENCY"
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  Cull Off
  GpuProgramID 77445
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump float _Alpha;
uniform mediump vec4 _TeamColor;
uniform mediump float _OutlineColorRatio;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = (_TeamColor * _OutlineColorRatio).xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "USE_OUTLINE_COLOR" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixInvV;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Outline;
uniform mediump vec4 _OutlineColor;
uniform mediump float _Alpha;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
void main ()
{
  highp mat4 m_1;
  m_1 = (unity_WorldToObject * unity_MatrixInvV);
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_2.x = m_1[0].x;
  tmpvar_2.y = m_1[1].x;
  tmpvar_2.z = m_1[2].x;
  tmpvar_2.w = m_1[3].x;
  tmpvar_3.x = m_1[0].y;
  tmpvar_3.y = m_1[1].y;
  tmpvar_3.z = m_1[2].y;
  tmpvar_3.w = m_1[3].y;
  tmpvar_4.x = m_1[0].z;
  tmpvar_4.y = m_1[1].z;
  tmpvar_4.z = m_1[2].z;
  tmpvar_4.w = m_1[3].z;
  mediump vec3 norm_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _glesVertex.xyz;
  tmpvar_8 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_9));
  tmpvar_6.w = tmpvar_8.w;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_2.xyz;
  tmpvar_10[1] = tmpvar_3.xyz;
  tmpvar_10[2] = tmpvar_4.xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  norm_5 = tmpvar_11;
  norm_5.xy = (norm_5.xy * 0.2);
  tmpvar_6.xy = (tmpvar_8.xy + (norm_5.xy * _Outline));
  tmpvar_6.z = (tmpvar_8.z + 0.001);
  tmpvar_7.xyz = _OutlineColor.xyz;
  tmpvar_7.w = (_Alpha / 1.6);
  xlv_TEXCOORD0 = vec2(0.0, 0.0);
  gl_Position = tmpvar_6;
  xlv_COLOR = tmpvar_7;
}


#endif
#ifdef FRAGMENT
varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "NO_USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "USE_OUTLINE_COLOR" }
""
}
}
}
}
}