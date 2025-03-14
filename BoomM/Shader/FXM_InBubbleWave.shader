//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FXM/InBubbleWave" {
Properties {
_MainTexture ("_MainTexture", 2D) = "white" { }
_OverlayColor ("_OverlayColor", Color) = (1,1,1,1)
_Progress ("_Progress", Range(0, 1)) = 0
_WavePosition ("_WavePosition", Range(0, 1)) = 0
_Speed ("_Speed", Float) = 0
}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  GpuProgramID 26824
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _Time;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Progress;
uniform mediump float _WavePosition;
uniform mediump float _Speed;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _glesVertex.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  tmpvar_2.xy = tmpvar_1;
  tmpvar_2.z = ((_glesMultiTexCoord0.y - _Progress) + _WavePosition);
  highp float tmpvar_5;
  tmpvar_5 = (_Time.y * _Speed);
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  tmpvar_2.w = (tmpvar_5 - tmpvar_6);
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTexture;
uniform mediump vec4 _OverlayColor;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 layer_wave_1;
  highp float horz_offset_2;
  mediump vec4 layer_static_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTexture, xlv_TEXCOORD0.xy);
  layer_static_3 = tmpvar_4;
  highp float tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD0.x + xlv_TEXCOORD0.w);
  horz_offset_2 = tmpvar_5;
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  horz_offset_2 = (tmpvar_5 - tmpvar_6);
  highp vec2 tmpvar_7;
  tmpvar_7.x = horz_offset_2;
  tmpvar_7.y = xlv_TEXCOORD0.z;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTexture, tmpvar_7);
  layer_wave_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.xyz = ((layer_static_3.x + layer_wave_1.y) + _OverlayColor.xyz);
  tmpvar_9.w = ((layer_static_3.w * layer_wave_1.z) * _OverlayColor.w);
  gl_FragData[0] = tmpvar_9;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _Time;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Progress;
uniform mediump float _WavePosition;
uniform mediump float _Speed;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _glesVertex.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  tmpvar_2.xy = tmpvar_1;
  tmpvar_2.z = ((_glesMultiTexCoord0.y - _Progress) + _WavePosition);
  highp float tmpvar_5;
  tmpvar_5 = (_Time.y * _Speed);
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  tmpvar_2.w = (tmpvar_5 - tmpvar_6);
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTexture;
uniform mediump vec4 _OverlayColor;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 layer_wave_1;
  highp float horz_offset_2;
  mediump vec4 layer_static_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTexture, xlv_TEXCOORD0.xy);
  layer_static_3 = tmpvar_4;
  highp float tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD0.x + xlv_TEXCOORD0.w);
  horz_offset_2 = tmpvar_5;
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  horz_offset_2 = (tmpvar_5 - tmpvar_6);
  highp vec2 tmpvar_7;
  tmpvar_7.x = horz_offset_2;
  tmpvar_7.y = xlv_TEXCOORD0.z;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTexture, tmpvar_7);
  layer_wave_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.xyz = ((layer_static_3.x + layer_wave_1.y) + _OverlayColor.xyz);
  tmpvar_9.w = ((layer_static_3.w * layer_wave_1.z) * _OverlayColor.w);
  gl_FragData[0] = tmpvar_9;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _Time;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform mediump float _Progress;
uniform mediump float _WavePosition;
uniform mediump float _Speed;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _glesVertex.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  tmpvar_2.xy = tmpvar_1;
  tmpvar_2.z = ((_glesMultiTexCoord0.y - _Progress) + _WavePosition);
  highp float tmpvar_5;
  tmpvar_5 = (_Time.y * _Speed);
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  tmpvar_2.w = (tmpvar_5 - tmpvar_6);
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTexture;
uniform mediump vec4 _OverlayColor;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 layer_wave_1;
  highp float horz_offset_2;
  mediump vec4 layer_static_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTexture, xlv_TEXCOORD0.xy);
  layer_static_3 = tmpvar_4;
  highp float tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD0.x + xlv_TEXCOORD0.w);
  horz_offset_2 = tmpvar_5;
  highp float tmpvar_6;
  if ((tmpvar_5 < 0.0)) {
    tmpvar_6 = -(floor(-(tmpvar_5)));
  } else {
    tmpvar_6 = floor(tmpvar_5);
  };
  horz_offset_2 = (tmpvar_5 - tmpvar_6);
  highp vec2 tmpvar_7;
  tmpvar_7.x = horz_offset_2;
  tmpvar_7.y = xlv_TEXCOORD0.z;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTexture, tmpvar_7);
  layer_wave_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.xyz = ((layer_static_3.x + layer_wave_1.y) + _OverlayColor.xyz);
  tmpvar_9.w = ((layer_static_3.w * layer_wave_1.z) * _OverlayColor.w);
  gl_FragData[0] = tmpvar_9;
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