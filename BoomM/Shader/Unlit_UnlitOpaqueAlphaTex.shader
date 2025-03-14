//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitOpaqueAlphaTex" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_SubTex ("Sub Texture", 2D) = "black" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Tint ("Tint", Color) = (1,1,1,0)
_DecalTex ("Decal Texture", 2D) = "black" { }
_DecalPosX ("Decal PosX", Range(-1, 1)) = 0
_DecalPosY ("Decal PosY", Range(-1, 1)) = 0
_DecalScale ("Decal Scale", Float) = 1
_EmphasizingColor ("EmphasizingColor", Color) = (1,1,1,1)
_EmphasizingPow ("EmphasizingPow", Range(0, 20)) = 1
}
SubShader {
 Tags { "QUEUE" = "geometry" }
 Pass {
  Name "MAIN"
  Tags { "QUEUE" = "geometry" }
  GpuProgramID 22044
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_EMPHASIZING" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_EMPHASIZING" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_EMPHASIZING" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  lowp vec3 normal_10;
  normal_10 = xlv_NORMAL;
  lowp vec3 color_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_10, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_11 = (r_1.xyz + tmpvar_12);
  r_1.xyz = color_11;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  lowp vec3 normal_10;
  normal_10 = xlv_NORMAL;
  lowp vec3 color_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_10, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_11 = (r_1.xyz + tmpvar_12);
  r_1.xyz = color_11;
  gl_FragData[0] = r_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  highp mat3 tmpvar_2;
  tmpvar_2[0] = unity_WorldToObject[0].xyz;
  tmpvar_2[1] = unity_WorldToObject[1].xyz;
  tmpvar_2[2] = unity_WorldToObject[2].xyz;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_NORMAL = normalize((_glesNormal * tmpvar_2));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
uniform sampler2D _DecalTex;
uniform lowp float _DecalPosX;
uniform lowp float _DecalPosY;
uniform lowp float _DecalScale;
uniform lowp vec4 _EmphasizingColor;
uniform lowp float _EmphasizingPow;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_NORMAL;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 col_2;
  col_2.xyz = texture2D (_MainTex, xlv_TEXCOORD0).xyz;
  col_2.w = texture2D (_SubTex, xlv_TEXCOORD0).x;
  r_1.w = 1.0;
  r_1.xyz = col_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((col_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * col_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - col_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((col_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * col_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - col_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((col_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * col_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - col_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - col_2.w) * col_2.xyz) + (col_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - col_2.w)) + (col_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  r_1.w = 1.0;
  lowp vec2 tmpvar_7;
  tmpvar_7.x = _DecalPosX;
  tmpvar_7.y = _DecalPosY;
  lowp vec4 tmpvar_8;
  highp vec2 P_9;
  P_9 = ((xlv_TEXCOORD0 + tmpvar_7) / _DecalScale);
  tmpvar_8 = texture2D (_DecalTex, P_9);
  if ((tmpvar_8.w > 0.0)) {
    r_1.xyz = tmpvar_8.xyz;
  };
  lowp vec3 normal_10;
  normal_10 = xlv_NORMAL;
  lowp vec3 color_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_10, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_11 = (r_1.xyz + tmpvar_12);
  r_1.xyz = color_11;
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
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_EMPHASIZING" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_EMPHASIZING" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_EMPHASIZING" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_DECAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_DECAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_DECAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "ENABLE_EMPHASIZING" "ENABLE_DECAL" }
""
}
}
}
}
}