//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "UI/Hidden/UI-Effect-Shiny" {
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
  GpuProgramID 72
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  tmpvar_1 = color_7;
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  tmpvar_1 = color_7;
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  tmpvar_1 = color_7;
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  mediump float x_18;
  x_18 = (color_7.w - 0.001);
  if ((x_18 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_7;
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  mediump float x_18;
  x_18 = (color_7.w - 0.001);
  if ((x_18 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_7;
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
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_4;
  highp float tmpvar_5;
  tmpvar_5 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_4.x = (tmpvar_5 / 4095.0);
  highp float tmpvar_6;
  tmpvar_6 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_4.y = (tmpvar_6 / 4095.0);
  tmpvar_2 = (_glesColor * _Color);
  mediump vec2 unpacked_7;
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (_glesMultiTexCoord0.y, 4096.0)));
  unpacked_7.x = (tmpvar_8 / 4095.0);
  highp float tmpvar_9;
  tmpvar_9 = (float(mod (floor((_glesMultiTexCoord0.y / 4096.0)), 4096.0)));
  unpacked_7.y = (tmpvar_9 / 4095.0);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = tmpvar_2;
  xlv_TEXCOORD0 = unpacked_4;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = unpacked_7;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ParamTex;
uniform lowp vec4 _TextureSampleAdd;
uniform highp vec4 _ClipRect;
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR;
varying mediump vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((texture2D (_MainTex, xlv_TEXCOORD0) + _TextureSampleAdd) * xlv_COLOR);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump vec4 color_7;
  color_7.w = color_2.w;
  mediump float location_8;
  lowp float nomalizedPos_9;
  mediump float tmpvar_10;
  tmpvar_10 = xlv_TEXCOORD2.x;
  nomalizedPos_9 = tmpvar_10;
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.25;
  tmpvar_11.y = xlv_TEXCOORD2.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ParamTex, tmpvar_11);
  mediump vec2 tmpvar_13;
  tmpvar_13.x = 0.75;
  tmpvar_13.y = xlv_TEXCOORD2.y;
  lowp float tmpvar_14;
  tmpvar_14 = ((tmpvar_12.x * 2.0) - 0.5);
  location_8 = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_ParamTex, tmpvar_13).x;
  lowp float edge1_16;
  edge1_16 = (tmpvar_12.z * 2.0);
  mediump float tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    clamp (abs(((nomalizedPos_9 - location_8) / tmpvar_12.y)), 0.0, 1.0)
  ) / edge1_16), 0.0, 1.0);
  color_7.xyz = (color_2.xyz + ((
    (color_2.w * ((tmpvar_17 * (tmpvar_17 * 
      (3.0 - (2.0 * tmpvar_17))
    )) / 2.0))
   * tmpvar_12.w) * mix (vec3(1.0, 1.0, 1.0), 
    (color_2.xyz * 10.0)
  , vec3(tmpvar_15))));
  color_2 = color_7;
  mediump float x_18;
  x_18 = (color_7.w - 0.001);
  if ((x_18 < 0.0)) {
    discard;
  };
  tmpvar_1 = color_7;
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
}
}
}
}