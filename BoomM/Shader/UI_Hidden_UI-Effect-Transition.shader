//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "UI/Hidden/UI-Effect-Transition" {
Properties {
_MainTex ("Main Texture", 2D) = "white" { }
_Color ("Tint", Color) = (1,1,1,1)
_StencilComp ("Stencil Comparison", Float) = 8
_Stencil ("Stencil ID", Float) = 0
_StencilOp ("Stencil Operation", Float) = 0
_StencilWriteMask ("Stencil Write Mask", Float) = 255
_StencilReadMask ("Stencil Read Mask", Float) = 255
_ColorMask ("Color Mask", Float) = 15
[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
[Header(Transition)] _NoiseTex ("Transition Texture (A)", 2D) = "white" { }
_ParamTex ("Parameter Texture", 2D) = "white" { }
}
SubShader {
 Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Name "DEFAULT"
  Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  ColorMask 0 0
  ZTest Off
  ZWrite Off
  Cull Off
  Stencil {
   ReadMask 0
   WriteMask 0
   Comp Disabled
   Pass Keep
   Fail Keep
   ZFail Keep
  }
  GpuProgramID 40101
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
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
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
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
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_8;
  x_8 = (color_2.w - 0.001);
  if ((x_8 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_8;
  x_8 = (color_2.w - 0.001);
  if ((x_8 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  tmpvar_7 = color_2;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_8;
  x_8 = (color_2.w - 0.001);
  if ((x_8 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = clamp ((alpha_9 + (1.0 - 
    (tmpvar_12 * 2.0)
  )), 0.0, 1.0);
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  color_8.xyz = color_2.xyz;
  highp float alpha_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2.z;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_9 = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = (1.0 - texture2D (_ParamTex, tmpvar_10).x);
  highp float tmpvar_13;
  tmpvar_13 = float(((
    (color_2.w * alpha_9)
   - tmpvar_12) >= 0.001));
  color_8.w = (color_2.w * tmpvar_13);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_14;
  x_14 = (color_2.w - 0.001);
  if ((x_14 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_24;
  x_24 = (color_2.w - 0.001);
  if ((x_24 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_24;
  x_24 = (color_2.w - 0.001);
  if ((x_24 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_5;
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_5.x = (tmpvar_6 / 4095.0);
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_5.y = (tmpvar_7 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  lowp vec3 unpacked_8;
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (_glesMultiTexCoord0.y, 256.0)));
  unpacked_8.x = (tmpvar_9 / 255.0);
  highp float tmpvar_10;
  tmpvar_10 = floor((_glesMultiTexCoord0.y / 256.0));
  highp float tmpvar_11;
  tmpvar_11 = (float(mod (tmpvar_10, 256.0)));
  unpacked_8.y = (tmpvar_11 / 255.0);
  highp float tmpvar_12;
  tmpvar_12 = (float(mod (floor((tmpvar_10 / 256.0)), 256.0)));
  unpacked_8.z = (tmpvar_12 / 255.0);
  tmpvar_3 = unpacked_8;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_5;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_3;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _NoiseTex;
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  lowp vec4 tmpvar_7;
  mediump vec4 color_8;
  lowp float edgeLerp_9;
  highp float alpha_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.z;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_NoiseTex, xlv_TEXCOORD2.xy).w;
  alpha_10 = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = (1.0 - tmpvar_12.x);
  lowp float tmpvar_15;
  tmpvar_15 = (tmpvar_12.y / 4.0);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = 0.75;
  tmpvar_16.y = xlv_TEXCOORD2.z;
  highp float tmpvar_17;
  tmpvar_17 = ((alpha_10 - (tmpvar_14 * 
    (1.0 + tmpvar_15)
  )) + tmpvar_15);
  highp float tmpvar_18;
  tmpvar_18 = (float((color_2.w >= tmpvar_17)) * clamp ((
    ((tmpvar_15 - tmpvar_17) * 16.0)
   / tmpvar_12.z), 0.0, 1.0));
  edgeLerp_9 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = texture2D (_ParamTex, tmpvar_16).xyz;
  tmpvar_19.w = edgeLerp_9;
  lowp vec4 tmpvar_20;
  mediump vec4 color_21;
  color_21.w = color_2.w;
  mediump vec4 factor_22;
  factor_22 = tmpvar_19;
  color_21.xyz = (color_2.xyz + (factor_22.xyz * factor_22.w));
  tmpvar_20 = color_21;
  color_8 = tmpvar_20;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_17 * 32.0) / tmpvar_12.z), 0.0, 1.0);
  color_8.w = (color_8.w * tmpvar_23);
  tmpvar_7 = color_8;
  color_2 = (tmpvar_7 * xlv_COLOR);
  mediump float x_24;
  x_24 = (color_2.w - 0.001);
  if ((x_24 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_2;
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
SubProgram "gles hw_tier00 " {
Keywords { "FADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "FADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "FADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "CUTOFF" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "CUTOFF" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "CUTOFF" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DISSOLVE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DISSOLVE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DISSOLVE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "FADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "CUTOFF" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_UI_ALPHACLIP" "DISSOLVE" }
""
}
}
}
}
}