//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FXM/UVScrollerForTile" {
Properties {
_MainTex ("_MainTex", 2D) = "white" { }
}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  GpuProgramID 62659
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesColor;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = tmpvar_1;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _Time;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  tmpvar_2.x = (xlv_TEXCOORD0.x + (_Time.y * 2.0));
  highp float tmpvar_3;
  if ((tmpvar_2.x < 0.0)) {
    tmpvar_3 = -(floor(-(tmpvar_2.x)));
  } else {
    tmpvar_3 = floor(tmpvar_2.x);
  };
  tmpvar_2.x = (tmpvar_2.x - tmpvar_3);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5.xyz = mix (xlv_COLOR.xyz, tmpvar_4.xyz, xlv_COLOR.www);
  tmpvar_5.w = tmpvar_4.w;
  tmpvar_1 = tmpvar_5;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesColor;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = tmpvar_1;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _Time;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  tmpvar_2.x = (xlv_TEXCOORD0.x + (_Time.y * 2.0));
  highp float tmpvar_3;
  if ((tmpvar_2.x < 0.0)) {
    tmpvar_3 = -(floor(-(tmpvar_2.x)));
  } else {
    tmpvar_3 = floor(tmpvar_2.x);
  };
  tmpvar_2.x = (tmpvar_2.x - tmpvar_3);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5.xyz = mix (xlv_COLOR.xyz, tmpvar_4.xyz, xlv_COLOR.www);
  tmpvar_5.w = tmpvar_4.w;
  tmpvar_1 = tmpvar_5;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesColor;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = tmpvar_1;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _Time;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  tmpvar_2.x = (xlv_TEXCOORD0.x + (_Time.y * 2.0));
  highp float tmpvar_3;
  if ((tmpvar_2.x < 0.0)) {
    tmpvar_3 = -(floor(-(tmpvar_2.x)));
  } else {
    tmpvar_3 = floor(tmpvar_2.x);
  };
  tmpvar_2.x = (tmpvar_2.x - tmpvar_3);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5.xyz = mix (xlv_COLOR.xyz, tmpvar_4.xyz, xlv_COLOR.www);
  tmpvar_5.w = tmpvar_4.w;
  tmpvar_1 = tmpvar_5;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
}
}
}
}