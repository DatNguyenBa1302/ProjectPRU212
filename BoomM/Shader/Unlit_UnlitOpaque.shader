//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitOpaque" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Tint ("Tint", Color) = (1,1,1,0)
_EmphasizingColor ("EmphasizingColor", Color) = (1,1,1,1)
_EmphasizingPow ("EmphasizingPow", Range(0, 20)) = 1
}
SubShader {
 Tags { "QUEUE" = "geometry" }
 Pass {
  Name "MAIN"
  Tags { "QUEUE" = "geometry" }
  GpuProgramID 25056
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
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
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
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
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
uniform lowp vec4 _TeamColor;
uniform lowp vec4 _Tint;
uniform lowp vec4 _Overlay;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 r_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
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
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  r_1.w = 1.0;
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
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  r_1.w = 1.0;
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
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  r_1.w = 1.0;
  r_1.xyz = tmpvar_2.xyz;
  lowp vec3 r_3;
  r_3 = vec3(1.0, 1.0, 1.0);
  lowp float tmpvar_4;
  if ((tmpvar_2.x < 0.5)) {
    tmpvar_4 = ((2.0 * tmpvar_2.x) * _Overlay.x);
  } else {
    tmpvar_4 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.x)
    ) * (1.0 - _Overlay.x)));
  };
  r_3.x = tmpvar_4;
  lowp float tmpvar_5;
  if ((tmpvar_2.y < 0.5)) {
    tmpvar_5 = ((2.0 * tmpvar_2.y) * _Overlay.y);
  } else {
    tmpvar_5 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.y)
    ) * (1.0 - _Overlay.y)));
  };
  r_3.y = tmpvar_5;
  lowp float tmpvar_6;
  if ((tmpvar_2.z < 0.5)) {
    tmpvar_6 = ((2.0 * tmpvar_2.z) * _Overlay.z);
  } else {
    tmpvar_6 = (1.0 - ((2.0 * 
      (1.0 - tmpvar_2.z)
    ) * (1.0 - _Overlay.z)));
  };
  r_3.z = tmpvar_6;
  r_1.xyz = (((1.0 - tmpvar_2.w) * tmpvar_2.xyz) + (tmpvar_2.w * r_3));
  r_1.xyz = ((r_1.xyz * (1.0 - tmpvar_2.w)) + (tmpvar_2.w * (r_1.xyz * _TeamColor.xyz)));
  r_1.xyz = mix (r_1.xyz, _Tint.xyz, _Tint.www);
  lowp vec3 normal_7;
  normal_7 = xlv_NORMAL;
  lowp vec3 color_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_EmphasizingColor * pow ((1.0 - 
    clamp (dot (normal_7, vec3(0.0, 0.0, -1.0)), 0.0, 1.0)
  ), _EmphasizingPow)).xyz;
  color_8 = (r_1.xyz + tmpvar_9);
  r_1.xyz = color_8;
  r_1.w = 1.0;
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
}
}
}
}