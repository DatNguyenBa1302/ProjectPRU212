//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "UI/Hidden/UI-Effect-HSV" {
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
  GpuProgramID 51202
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
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
  lowp float masked_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = 0.25;
  tmpvar_9.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ParamTex, tmpvar_9);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.75;
  tmpvar_11.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (texture2D (_ParamTex, tmpvar_11).xyz - 0.5);
  mediump vec3 c_13;
  c_13 = color_2.xyz;
  mediump vec4 tmpvar_14;
  tmpvar_14.xy = c_13.zy;
  tmpvar_14.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_13.yz;
  tmpvar_15.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_16;
  tmpvar_16 = mix (tmpvar_14, tmpvar_15, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = tmpvar_16.xyw;
  tmpvar_17.w = c_13.x;
  mediump vec4 tmpvar_18;
  tmpvar_18.x = c_13.x;
  tmpvar_18.yzw = tmpvar_16.yzx;
  mediump vec4 tmpvar_19;
  tmpvar_19 = mix (tmpvar_17, tmpvar_18, vec4(float((color_2.x >= tmpvar_16.x))));
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x - min (tmpvar_19.w, tmpvar_19.y));
  mediump vec3 tmpvar_21;
  tmpvar_21.x = abs((tmpvar_19.z + (
    (tmpvar_19.w - tmpvar_19.y)
   / 
    ((6.0 * tmpvar_20) + 1e-10)
  )));
  tmpvar_21.y = (tmpvar_20 / (tmpvar_19.x + 1e-10));
  tmpvar_21.z = tmpvar_19.x;
  mediump vec3 tmpvar_22;
  tmpvar_22 = abs((tmpvar_21 - tmpvar_10.xyz));
  mediump float tmpvar_23;
  tmpvar_23 = max (max (min (
    (1.0 - tmpvar_22.x)
  , tmpvar_22.x), (
    min ((1.0 - tmpvar_22.y), tmpvar_22.y)
   / 10.0)), (min (
    (1.0 - tmpvar_22.z)
  , tmpvar_22.z) / 10.0));
  mediump vec3 tmpvar_24;
  tmpvar_24.x = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.y = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.z = float((tmpvar_10.w >= tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = tmpvar_24.x;
  masked_8 = tmpvar_25;
  mediump vec3 c_26;
  c_26 = (tmpvar_21 + (tmpvar_12 * masked_8));
  mediump vec2 tmpvar_27;
  tmpvar_27 = clamp (c_26.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_28;
  tmpvar_28.x = c_26.x;
  tmpvar_28.yz = tmpvar_27;
  c_26 = tmpvar_28;
  color_7.xyz = (tmpvar_27.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_28.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_27.xxx));
  color_2 = color_7;
  tmpvar_1 = ((color_7 + _TextureSampleAdd) * xlv_COLOR);
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
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
  lowp float masked_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = 0.25;
  tmpvar_9.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ParamTex, tmpvar_9);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.75;
  tmpvar_11.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (texture2D (_ParamTex, tmpvar_11).xyz - 0.5);
  mediump vec3 c_13;
  c_13 = color_2.xyz;
  mediump vec4 tmpvar_14;
  tmpvar_14.xy = c_13.zy;
  tmpvar_14.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_13.yz;
  tmpvar_15.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_16;
  tmpvar_16 = mix (tmpvar_14, tmpvar_15, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = tmpvar_16.xyw;
  tmpvar_17.w = c_13.x;
  mediump vec4 tmpvar_18;
  tmpvar_18.x = c_13.x;
  tmpvar_18.yzw = tmpvar_16.yzx;
  mediump vec4 tmpvar_19;
  tmpvar_19 = mix (tmpvar_17, tmpvar_18, vec4(float((color_2.x >= tmpvar_16.x))));
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x - min (tmpvar_19.w, tmpvar_19.y));
  mediump vec3 tmpvar_21;
  tmpvar_21.x = abs((tmpvar_19.z + (
    (tmpvar_19.w - tmpvar_19.y)
   / 
    ((6.0 * tmpvar_20) + 1e-10)
  )));
  tmpvar_21.y = (tmpvar_20 / (tmpvar_19.x + 1e-10));
  tmpvar_21.z = tmpvar_19.x;
  mediump vec3 tmpvar_22;
  tmpvar_22 = abs((tmpvar_21 - tmpvar_10.xyz));
  mediump float tmpvar_23;
  tmpvar_23 = max (max (min (
    (1.0 - tmpvar_22.x)
  , tmpvar_22.x), (
    min ((1.0 - tmpvar_22.y), tmpvar_22.y)
   / 10.0)), (min (
    (1.0 - tmpvar_22.z)
  , tmpvar_22.z) / 10.0));
  mediump vec3 tmpvar_24;
  tmpvar_24.x = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.y = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.z = float((tmpvar_10.w >= tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = tmpvar_24.x;
  masked_8 = tmpvar_25;
  mediump vec3 c_26;
  c_26 = (tmpvar_21 + (tmpvar_12 * masked_8));
  mediump vec2 tmpvar_27;
  tmpvar_27 = clamp (c_26.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_28;
  tmpvar_28.x = c_26.x;
  tmpvar_28.yz = tmpvar_27;
  c_26 = tmpvar_28;
  color_7.xyz = (tmpvar_27.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_28.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_27.xxx));
  color_2 = color_7;
  tmpvar_1 = ((color_7 + _TextureSampleAdd) * xlv_COLOR);
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
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
  lowp float masked_8;
  mediump vec2 tmpvar_9;
  tmpvar_9.x = 0.25;
  tmpvar_9.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ParamTex, tmpvar_9);
  mediump vec2 tmpvar_11;
  tmpvar_11.x = 0.75;
  tmpvar_11.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (texture2D (_ParamTex, tmpvar_11).xyz - 0.5);
  mediump vec3 c_13;
  c_13 = color_2.xyz;
  mediump vec4 tmpvar_14;
  tmpvar_14.xy = c_13.zy;
  tmpvar_14.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_13.yz;
  tmpvar_15.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_16;
  tmpvar_16 = mix (tmpvar_14, tmpvar_15, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = tmpvar_16.xyw;
  tmpvar_17.w = c_13.x;
  mediump vec4 tmpvar_18;
  tmpvar_18.x = c_13.x;
  tmpvar_18.yzw = tmpvar_16.yzx;
  mediump vec4 tmpvar_19;
  tmpvar_19 = mix (tmpvar_17, tmpvar_18, vec4(float((color_2.x >= tmpvar_16.x))));
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x - min (tmpvar_19.w, tmpvar_19.y));
  mediump vec3 tmpvar_21;
  tmpvar_21.x = abs((tmpvar_19.z + (
    (tmpvar_19.w - tmpvar_19.y)
   / 
    ((6.0 * tmpvar_20) + 1e-10)
  )));
  tmpvar_21.y = (tmpvar_20 / (tmpvar_19.x + 1e-10));
  tmpvar_21.z = tmpvar_19.x;
  mediump vec3 tmpvar_22;
  tmpvar_22 = abs((tmpvar_21 - tmpvar_10.xyz));
  mediump float tmpvar_23;
  tmpvar_23 = max (max (min (
    (1.0 - tmpvar_22.x)
  , tmpvar_22.x), (
    min ((1.0 - tmpvar_22.y), tmpvar_22.y)
   / 10.0)), (min (
    (1.0 - tmpvar_22.z)
  , tmpvar_22.z) / 10.0));
  mediump vec3 tmpvar_24;
  tmpvar_24.x = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.y = float((tmpvar_10.w >= tmpvar_23));
  tmpvar_24.z = float((tmpvar_10.w >= tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = tmpvar_24.x;
  masked_8 = tmpvar_25;
  mediump vec3 c_26;
  c_26 = (tmpvar_21 + (tmpvar_12 * masked_8));
  mediump vec2 tmpvar_27;
  tmpvar_27 = clamp (c_26.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_28;
  tmpvar_28.x = c_26.x;
  tmpvar_28.yz = tmpvar_27;
  c_26 = tmpvar_28;
  color_7.xyz = (tmpvar_27.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_28.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_27.xxx));
  color_2 = color_7;
  tmpvar_1 = ((color_7 + _TextureSampleAdd) * xlv_COLOR);
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump float x_7;
  x_7 = (color_2.w - 0.001);
  if ((x_7 < 0.0)) {
    discard;
  };
  mediump vec4 color_8;
  color_8.w = color_2.w;
  lowp float masked_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ParamTex, tmpvar_10);
  mediump vec2 tmpvar_12;
  tmpvar_12.x = 0.75;
  tmpvar_12.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (texture2D (_ParamTex, tmpvar_12).xyz - 0.5);
  mediump vec3 c_14;
  c_14 = color_2.xyz;
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_14.zy;
  tmpvar_15.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_16;
  tmpvar_16.xy = c_14.yz;
  tmpvar_16.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (tmpvar_15, tmpvar_16, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = tmpvar_17.xyw;
  tmpvar_18.w = c_14.x;
  mediump vec4 tmpvar_19;
  tmpvar_19.x = c_14.x;
  tmpvar_19.yzw = tmpvar_17.yzx;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (tmpvar_18, tmpvar_19, vec4(float((color_2.x >= tmpvar_17.x))));
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20.x - min (tmpvar_20.w, tmpvar_20.y));
  mediump vec3 tmpvar_22;
  tmpvar_22.x = abs((tmpvar_20.z + (
    (tmpvar_20.w - tmpvar_20.y)
   / 
    ((6.0 * tmpvar_21) + 1e-10)
  )));
  tmpvar_22.y = (tmpvar_21 / (tmpvar_20.x + 1e-10));
  tmpvar_22.z = tmpvar_20.x;
  mediump vec3 tmpvar_23;
  tmpvar_23 = abs((tmpvar_22 - tmpvar_11.xyz));
  mediump float tmpvar_24;
  tmpvar_24 = max (max (min (
    (1.0 - tmpvar_23.x)
  , tmpvar_23.x), (
    min ((1.0 - tmpvar_23.y), tmpvar_23.y)
   / 10.0)), (min (
    (1.0 - tmpvar_23.z)
  , tmpvar_23.z) / 10.0));
  mediump vec3 tmpvar_25;
  tmpvar_25.x = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.y = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.z = float((tmpvar_11.w >= tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25.x;
  masked_9 = tmpvar_26;
  mediump vec3 c_27;
  c_27 = (tmpvar_22 + (tmpvar_13 * masked_9));
  mediump vec2 tmpvar_28;
  tmpvar_28 = clamp (c_27.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_29;
  tmpvar_29.x = c_27.x;
  tmpvar_29.yz = tmpvar_28;
  c_27 = tmpvar_29;
  color_8.xyz = (tmpvar_28.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_29.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_28.xxx));
  color_2 = color_8;
  tmpvar_1 = ((color_8 + _TextureSampleAdd) * xlv_COLOR);
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump float x_7;
  x_7 = (color_2.w - 0.001);
  if ((x_7 < 0.0)) {
    discard;
  };
  mediump vec4 color_8;
  color_8.w = color_2.w;
  lowp float masked_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ParamTex, tmpvar_10);
  mediump vec2 tmpvar_12;
  tmpvar_12.x = 0.75;
  tmpvar_12.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (texture2D (_ParamTex, tmpvar_12).xyz - 0.5);
  mediump vec3 c_14;
  c_14 = color_2.xyz;
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_14.zy;
  tmpvar_15.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_16;
  tmpvar_16.xy = c_14.yz;
  tmpvar_16.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (tmpvar_15, tmpvar_16, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = tmpvar_17.xyw;
  tmpvar_18.w = c_14.x;
  mediump vec4 tmpvar_19;
  tmpvar_19.x = c_14.x;
  tmpvar_19.yzw = tmpvar_17.yzx;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (tmpvar_18, tmpvar_19, vec4(float((color_2.x >= tmpvar_17.x))));
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20.x - min (tmpvar_20.w, tmpvar_20.y));
  mediump vec3 tmpvar_22;
  tmpvar_22.x = abs((tmpvar_20.z + (
    (tmpvar_20.w - tmpvar_20.y)
   / 
    ((6.0 * tmpvar_21) + 1e-10)
  )));
  tmpvar_22.y = (tmpvar_21 / (tmpvar_20.x + 1e-10));
  tmpvar_22.z = tmpvar_20.x;
  mediump vec3 tmpvar_23;
  tmpvar_23 = abs((tmpvar_22 - tmpvar_11.xyz));
  mediump float tmpvar_24;
  tmpvar_24 = max (max (min (
    (1.0 - tmpvar_23.x)
  , tmpvar_23.x), (
    min ((1.0 - tmpvar_23.y), tmpvar_23.y)
   / 10.0)), (min (
    (1.0 - tmpvar_23.z)
  , tmpvar_23.z) / 10.0));
  mediump vec3 tmpvar_25;
  tmpvar_25.x = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.y = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.z = float((tmpvar_11.w >= tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25.x;
  masked_9 = tmpvar_26;
  mediump vec3 c_27;
  c_27 = (tmpvar_22 + (tmpvar_13 * masked_9));
  mediump vec2 tmpvar_28;
  tmpvar_28 = clamp (c_27.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_29;
  tmpvar_29.x = c_27.x;
  tmpvar_29.yz = tmpvar_28;
  c_27 = tmpvar_29;
  color_8.xyz = (tmpvar_28.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_29.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_28.xxx));
  color_2 = color_8;
  tmpvar_1 = ((color_8 + _TextureSampleAdd) * xlv_COLOR);
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec2 tmpvar_2;
  tmpvar_2 = _glesMultiTexCoord0.xy;
  lowp vec4 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_1.xyz;
  mediump vec2 unpacked_6;
  highp float tmpvar_7;
  tmpvar_7 = (float(mod (_glesMultiTexCoord0.x, 4096.0)));
  unpacked_6.x = (tmpvar_7 / 4095.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((_glesMultiTexCoord0.x / 4096.0)), 4096.0)));
  unpacked_6.y = (tmpvar_8 / 4095.0);
  tmpvar_3 = (_glesColor * _Color);
  tmpvar_4 = tmpvar_2.y;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_5));
  xlv_COLOR = tmpvar_3;
  xlv_TEXCOORD0 = unpacked_6;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_4;
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
varying mediump float xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  color_2 = tmpvar_3;
  highp float tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = float((_ClipRect.z >= xlv_TEXCOORD1.x));
  tmpvar_5.y = float((_ClipRect.w >= xlv_TEXCOORD1.y));
  highp vec2 tmpvar_6;
  tmpvar_6 = (vec2(greaterThanEqual (xlv_TEXCOORD1.xy, _ClipRect.xy)) * tmpvar_5);
  tmpvar_4 = (tmpvar_6.x * tmpvar_6.y);
  color_2.w = (color_2.w * tmpvar_4);
  mediump float x_7;
  x_7 = (color_2.w - 0.001);
  if ((x_7 < 0.0)) {
    discard;
  };
  mediump vec4 color_8;
  color_8.w = color_2.w;
  lowp float masked_9;
  mediump vec2 tmpvar_10;
  tmpvar_10.x = 0.25;
  tmpvar_10.y = xlv_TEXCOORD2;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ParamTex, tmpvar_10);
  mediump vec2 tmpvar_12;
  tmpvar_12.x = 0.75;
  tmpvar_12.y = xlv_TEXCOORD2;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (texture2D (_ParamTex, tmpvar_12).xyz - 0.5);
  mediump vec3 c_14;
  c_14 = color_2.xyz;
  mediump vec4 tmpvar_15;
  tmpvar_15.xy = c_14.zy;
  tmpvar_15.zw = vec2(-1.0, 0.6666667);
  mediump vec4 tmpvar_16;
  tmpvar_16.xy = c_14.yz;
  tmpvar_16.zw = vec2(0.0, -0.3333333);
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (tmpvar_15, tmpvar_16, vec4(float((color_2.y >= color_2.z))));
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = tmpvar_17.xyw;
  tmpvar_18.w = c_14.x;
  mediump vec4 tmpvar_19;
  tmpvar_19.x = c_14.x;
  tmpvar_19.yzw = tmpvar_17.yzx;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (tmpvar_18, tmpvar_19, vec4(float((color_2.x >= tmpvar_17.x))));
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20.x - min (tmpvar_20.w, tmpvar_20.y));
  mediump vec3 tmpvar_22;
  tmpvar_22.x = abs((tmpvar_20.z + (
    (tmpvar_20.w - tmpvar_20.y)
   / 
    ((6.0 * tmpvar_21) + 1e-10)
  )));
  tmpvar_22.y = (tmpvar_21 / (tmpvar_20.x + 1e-10));
  tmpvar_22.z = tmpvar_20.x;
  mediump vec3 tmpvar_23;
  tmpvar_23 = abs((tmpvar_22 - tmpvar_11.xyz));
  mediump float tmpvar_24;
  tmpvar_24 = max (max (min (
    (1.0 - tmpvar_23.x)
  , tmpvar_23.x), (
    min ((1.0 - tmpvar_23.y), tmpvar_23.y)
   / 10.0)), (min (
    (1.0 - tmpvar_23.z)
  , tmpvar_23.z) / 10.0));
  mediump vec3 tmpvar_25;
  tmpvar_25.x = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.y = float((tmpvar_11.w >= tmpvar_24));
  tmpvar_25.z = float((tmpvar_11.w >= tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25.x;
  masked_9 = tmpvar_26;
  mediump vec3 c_27;
  c_27 = (tmpvar_22 + (tmpvar_13 * masked_9));
  mediump vec2 tmpvar_28;
  tmpvar_28 = clamp (c_27.yz, vec2(0.0, 0.0), vec2(1.0, 1.0));
  mediump vec3 tmpvar_29;
  tmpvar_29.x = c_27.x;
  tmpvar_29.yz = tmpvar_28;
  c_27 = tmpvar_29;
  color_8.xyz = (tmpvar_28.y * mix (vec3(1.0, 1.0, 1.0), clamp (
    (abs(((
      fract((tmpvar_29.xxx + vec3(1.0, 0.6666667, 0.3333333)))
     * 6.0) - vec3(3.0, 3.0, 3.0))) - vec3(1.0, 1.0, 1.0))
  , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), tmpvar_28.xxx));
  color_2 = color_8;
  tmpvar_1 = ((color_8 + _TextureSampleAdd) * xlv_COLOR);
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