//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitTransparencyRepeatedAlphaTex" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_SubTex ("Sub Texture", 2D) = "black" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Alpha ("Alpha", Float) = 1
_Tint ("Tint", Color) = (1,1,1,0)
}
SubShader {
 Tags { "QUEUE" = "Transparent+1" }
 Pass {
  Name "MAIN"
  Tags { "QUEUE" = "Transparent+1" }
  Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
  GpuProgramID 62474
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _WorldMatrices[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp int tmpvar_1;
  tmpvar_1 = int((_glesColor.x * 10.0));
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = ((unity_MatrixVP * _WorldMatrices[tmpvar_1]) * _glesVertex);
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
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
  lowp vec4 col_3;
  col_3.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_3.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((col_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * col_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * col_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((col_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * col_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - col_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - col_3.w) * col_3.xyz) + (col_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - col_3.w)) + (col_3.w * (r_1.xyz * _TeamColor.xyz)));
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
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _WorldMatrices[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp int tmpvar_1;
  tmpvar_1 = int((_glesColor.x * 10.0));
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = ((unity_MatrixVP * _WorldMatrices[tmpvar_1]) * _glesVertex);
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
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
  lowp vec4 col_3;
  col_3.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_3.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((col_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * col_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * col_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((col_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * col_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - col_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - col_3.w) * col_3.xyz) + (col_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - col_3.w)) + (col_3.w * (r_1.xyz * _TeamColor.xyz)));
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
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _WorldMatrices[10];
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR;
void main ()
{
  highp int tmpvar_1;
  tmpvar_1 = int((_glesColor.x * 10.0));
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = ((unity_MatrixVP * _WorldMatrices[tmpvar_1]) * _glesVertex);
  xlv_COLOR = _glesColor;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
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
  lowp vec4 col_3;
  col_3.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_3.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_3.xyz;
  lowp vec3 r_4;
  r_4 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_5;
  if ((col_3.x < 0.5)) {
    tmpvar_5 = ((2.0 * col_3.x) * _Overlay.x);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_3.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_4.x = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_3.y < 0.5)) {
    tmpvar_6 = ((2.0 * col_3.y) * _Overlay.y);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_3.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_4.y = tmpvar_6;
  lowp float tmpvar_7;
  if ((col_3.z < 0.5)) {
    tmpvar_7 = ((2.0 * col_3.z) * _Overlay.z);
  } else {
    tmpvar_7 = (1.0 - ((2.0 * 
      (1.0 - col_3.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_4.z = tmpvar_7;
  r_1.xyz = (((1.0 - col_3.w) * col_3.xyz) + (col_3.w * r_4));
  r_1.xyz = ((r_1.xyz * (1.0 - col_3.w)) + (col_3.w * (r_1.xyz * _TeamColor.xyz)));
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