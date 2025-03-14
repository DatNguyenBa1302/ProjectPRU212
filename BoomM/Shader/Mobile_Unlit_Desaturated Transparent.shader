//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Mobile/Unlit/Desaturated Transparent" {
Properties {
_Opacity ("Opacity", Range(0, 1)) = 1
_Red ("Red", Range(0, 1)) = 0
_Green ("Green", Range(0, 1)) = 0
_Blue ("Blue", Range(0, 1)) = 0
_Weight ("Weight", Range(0, 1)) = 0.5
_MainTex ("Texture", 2D) = "" { }
_StencilComp ("Stencil Comparison", Float) = 8
_Stencil ("Stencil ID", Float) = 0
_StencilOp ("Stencil Operation", Float) = 0
_StencilWriteMask ("Stencil Write Mask", Float) = 255
_StencilReadMask ("Stencil Read Mask", Float) = 255
_ColorMask ("Color Mask", Float) = 15
}
SubShader {
 Tags { "QUEUE" = "Transparent" }
 Pass {
  Tags { "QUEUE" = "Transparent" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  ColorMask 0 0
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
  GpuProgramID 41863
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}


#endif
#ifdef FRAGMENT
uniform highp float _Opacity;
uniform highp float _Red;
uniform highp float _Green;
uniform highp float _Blue;
uniform highp float _Weight;
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  lowp vec4 fragColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD);
  fragColor_1.xyz = vec3(dot (tmpvar_2.xyz, vec3(0.222, 0.707, 0.071)));
  fragColor_1.x = ((tmpvar_2.x * _Red) + (fragColor_1.x * (1.0 - _Red)));
  fragColor_1.y = ((tmpvar_2.y * _Green) + (fragColor_1.y * (1.0 - _Green)));
  fragColor_1.z = ((tmpvar_2.z * _Blue) + (fragColor_1.z * (1.0 - _Blue)));
  if ((_Weight > 0.5)) {
    highp float tmpvar_3;
    tmpvar_3 = (0.5 - _Weight);
    fragColor_1.xyz = (fragColor_1.xyz - (fragColor_1.xyz * vec3(tmpvar_3)));
  } else {
    highp float tmpvar_4;
    tmpvar_4 = (_Weight - 0.5);
    fragColor_1.xyz = (fragColor_1.xyz + (fragColor_1.xyz * vec3(tmpvar_4)));
  };
  fragColor_1.w = (tmpvar_2.w * _Opacity);
  gl_FragData[0] = fragColor_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}


#endif
#ifdef FRAGMENT
uniform highp float _Opacity;
uniform highp float _Red;
uniform highp float _Green;
uniform highp float _Blue;
uniform highp float _Weight;
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  lowp vec4 fragColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD);
  fragColor_1.xyz = vec3(dot (tmpvar_2.xyz, vec3(0.222, 0.707, 0.071)));
  fragColor_1.x = ((tmpvar_2.x * _Red) + (fragColor_1.x * (1.0 - _Red)));
  fragColor_1.y = ((tmpvar_2.y * _Green) + (fragColor_1.y * (1.0 - _Green)));
  fragColor_1.z = ((tmpvar_2.z * _Blue) + (fragColor_1.z * (1.0 - _Blue)));
  if ((_Weight > 0.5)) {
    highp float tmpvar_3;
    tmpvar_3 = (0.5 - _Weight);
    fragColor_1.xyz = (fragColor_1.xyz - (fragColor_1.xyz * vec3(tmpvar_3)));
  } else {
    highp float tmpvar_4;
    tmpvar_4 = (_Weight - 0.5);
    fragColor_1.xyz = (fragColor_1.xyz + (fragColor_1.xyz * vec3(tmpvar_4)));
  };
  fragColor_1.w = (tmpvar_2.w * _Opacity);
  gl_FragData[0] = fragColor_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}


#endif
#ifdef FRAGMENT
uniform highp float _Opacity;
uniform highp float _Red;
uniform highp float _Green;
uniform highp float _Blue;
uniform highp float _Weight;
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD;
void main ()
{
  lowp vec4 fragColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD);
  fragColor_1.xyz = vec3(dot (tmpvar_2.xyz, vec3(0.222, 0.707, 0.071)));
  fragColor_1.x = ((tmpvar_2.x * _Red) + (fragColor_1.x * (1.0 - _Red)));
  fragColor_1.y = ((tmpvar_2.y * _Green) + (fragColor_1.y * (1.0 - _Green)));
  fragColor_1.z = ((tmpvar_2.z * _Blue) + (fragColor_1.z * (1.0 - _Blue)));
  if ((_Weight > 0.5)) {
    highp float tmpvar_3;
    tmpvar_3 = (0.5 - _Weight);
    fragColor_1.xyz = (fragColor_1.xyz - (fragColor_1.xyz * vec3(tmpvar_3)));
  } else {
    highp float tmpvar_4;
    tmpvar_4 = (_Weight - 0.5);
    fragColor_1.xyz = (fragColor_1.xyz + (fragColor_1.xyz * vec3(tmpvar_4)));
  };
  fragColor_1.w = (tmpvar_2.w * _Opacity);
  gl_FragData[0] = fragColor_1;
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