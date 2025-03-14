//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitTransparencySkinningRepeated" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Tint ("Tint", Color) = (1,1,1,0)
}
SubShader {
 Tags { "QUEUE" = "Transparent+1" }
 Pass {
  Name "MAIN"
  Tags { "QUEUE" = "Transparent+1" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  GpuProgramID 33758
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _Tint;
uniform highp float _Alphas[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  lowp vec4 r_1;
  highp int group_2;
  group_2 = int((xlv_COLOR.x * 10.0));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((tmpvar_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((tmpvar_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * tmpvar_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - tmpvar_3.w) * tmpvar_3.xyz) + (tmpvar_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_3.w)) + (tmpvar_3.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = _Alphas[group_2];
  gl_FragData[0] = r_1;
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
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _Tint;
uniform highp float _Alphas[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  lowp vec4 r_1;
  highp int group_2;
  group_2 = int((xlv_COLOR.x * 10.0));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((tmpvar_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((tmpvar_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * tmpvar_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - tmpvar_3.w) * tmpvar_3.xyz) + (tmpvar_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_3.w)) + (tmpvar_3.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = _Alphas[group_2];
  gl_FragData[0] = r_1;
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
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _Tint;
uniform highp float _Alphas[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  lowp vec4 r_1;
  highp int group_2;
  group_2 = int((xlv_COLOR.x * 10.0));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((tmpvar_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((tmpvar_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * tmpvar_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - tmpvar_3.w) * tmpvar_3.xyz) + (tmpvar_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_3.w)) + (tmpvar_3.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = _Alphas[group_2];
  gl_FragData[0] = r_1;
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