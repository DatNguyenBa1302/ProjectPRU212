//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Sprites/Default-Decal" {
Properties {
_MainTex ("Sprite Texture", 2D) = "white" { }
_Color ("Tint", Color) = (1,1,1,1)
[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
_DecalTex ("Decal Texture", 2D) = "black" { }
_DecalPosX ("Decal PosX", Range(-1, 1)) = 0
_DecalPosY ("Decal PosY", Range(-1, 1)) = 0
_DecalScale ("Decal Scale", Float) = 1
}
SubShader {
 Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
  ZWrite Off
  Cull Off
  GpuProgramID 46828
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
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (_glesColor * _Color);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
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
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (_glesColor * _Color);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
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
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (_glesColor * _Color);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  tmpvar_1 = (_glesColor * _Color);
  highp vec4 pos_4;
  pos_4.zw = tmpvar_2.zw;
  highp vec2 tmpvar_5;
  tmpvar_5 = (_ScreenParams.xy * 0.5);
  pos_4.xy = ((floor(
    (((tmpvar_2.xy / tmpvar_2.w) * tmpvar_5) + vec2(0.5, 0.5))
  ) / tmpvar_5) * tmpvar_2.w);
  gl_Position = pos_4;
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  tmpvar_1 = (_glesColor * _Color);
  highp vec4 pos_4;
  pos_4.zw = tmpvar_2.zw;
  highp vec2 tmpvar_5;
  tmpvar_5 = (_ScreenParams.xy * 0.5);
  pos_4.xy = ((floor(
    (((tmpvar_2.xy / tmpvar_2.w) * tmpvar_5) + vec2(0.5, 0.5))
  ) / tmpvar_5) * tmpvar_2.w);
  gl_Position = pos_4;
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 _Color;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  tmpvar_2 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  tmpvar_1 = (_glesColor * _Color);
  highp vec4 pos_4;
  pos_4.zw = tmpvar_2.zw;
  highp vec2 tmpvar_5;
  tmpvar_5 = (_ScreenParams.xy * 0.5);
  pos_4.xy = ((floor(
    (((tmpvar_2.xy / tmpvar_2.w) * tmpvar_5) + vec2(0.5, 0.5))
  ) / tmpvar_5) * tmpvar_2.w);
  gl_Position = pos_4;
  xlv_COLOR = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  c_1 = tmpvar_2;
  lowp vec2 tmpvar_3;
  tmpvar_3.x = _DecalPosX;
  tmpvar_3.y = _DecalPosY;
  lowp vec4 tmpvar_4;
  highp vec2 P_5;
  P_5 = ((xlv_TEXCOORD0 + tmpvar_3) / _DecalScale);
  tmpvar_4 = texture2D (_DecalTex, P_5);
  if ((tmpvar_4.w > 0.0)) {
    c_1.xyz = (tmpvar_4.xyz * tmpvar_2.w);
  } else {
    c_1.xyz = (c_1.xyz * tmpvar_2.w);
  };
  gl_FragData[0] = c_1;
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
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
""
}
}
}
}
}