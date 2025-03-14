//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Legacy Shaders/Diffuse" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 
 LOD 200
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "SHADOWSUPPORT"="true" "RenderType"="Opaque" }
  GpuProgramID 59087
Program "vp" {
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = worldNormal_1;
  mediump vec4 normal_8;
  normal_8 = tmpvar_7;
  mediump vec3 x2_9;
  mediump vec3 x1_10;
  x1_10.x = dot (unity_SHAr, normal_8);
  x1_10.y = dot (unity_SHAg, normal_8);
  x1_10.z = dot (unity_SHAb, normal_8);
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal_8.xyzz * normal_8.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD3 = ((x2_9 + (unity_SHC.xyz * 
    ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y))
  )) + x1_10);
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c_10.xyz + (tmpvar_7.xyz * xlv_TEXCOORD3));
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = worldNormal_1;
  mediump vec4 normal_8;
  normal_8 = tmpvar_7;
  mediump vec3 x2_9;
  mediump vec3 x1_10;
  x1_10.x = dot (unity_SHAr, normal_8);
  x1_10.y = dot (unity_SHAg, normal_8);
  x1_10.z = dot (unity_SHAb, normal_8);
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal_8.xyzz * normal_8.yzzx);
  x2_9.x = dot (unity_SHBr, tmpvar_11);
  x2_9.y = dot (unity_SHBg, tmpvar_11);
  x2_9.z = dot (unity_SHBb, tmpvar_11);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD3 = ((x2_9 + (unity_SHC.xyz * 
    ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y))
  )) + x1_10);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c_10.xyz + (tmpvar_7.xyz * xlv_TEXCOORD3));
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  highp vec4 tmpvar_13;
  highp vec4 cse_14;
  cse_14 = (_Object2World * _glesVertex);
  tmpvar_13 = (unity_World2Shadow[0] * cse_14);
  tmpvar_3 = tmpvar_13;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_14.xyz;
  xlv_TEXCOORD3 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float tmpvar_9;
  mediump float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_10 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (float((dist_10 > 
    (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w)
  )), _LightShadowData.x);
  tmpvar_9 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_13;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = tmpvar_9;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_14;
  lowp vec4 c_15;
  lowp vec4 c_16;
  lowp float diff_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((tmpvar_8.xyz * tmpvar_14) * diff_17);
  c_16.xyz = tmpvar_19;
  c_16.w = tmpvar_8.w;
  c_15.w = c_16.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_16.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_15.xyz = tmpvar_20;
  c_4.xyz = c_15.xyz;
  c_4.w = 1.0;
  gl_FragData[0] = c_4;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
uniform mediump vec4 unity_4LightAtten0;
uniform mediump vec4 unity_LightColor[8];
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  highp vec4 v_5;
  v_5.x = _World2Object[0].x;
  v_5.y = _World2Object[1].x;
  v_5.z = _World2Object[2].x;
  v_5.w = _World2Object[3].x;
  highp vec4 v_6;
  v_6.x = _World2Object[0].y;
  v_6.y = _World2Object[1].y;
  v_6.z = _World2Object[2].y;
  v_6.w = _World2Object[3].y;
  highp vec4 v_7;
  v_7.x = _World2Object[0].z;
  v_7.y = _World2Object[1].z;
  v_7.z = _World2Object[2].z;
  v_7.w = _World2Object[3].z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize(((
    (v_5.xyz * _glesNormal.x)
   + 
    (v_6.xyz * _glesNormal.y)
  ) + (v_7.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_8;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = worldNormal_1;
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  x1_13.x = dot (unity_SHAr, normal_11);
  x1_13.y = dot (unity_SHAg, normal_11);
  x1_13.z = dot (unity_SHAb, normal_11);
  mediump vec4 tmpvar_14;
  tmpvar_14 = (normal_11.xyzz * normal_11.yzzx);
  x2_12.x = dot (unity_SHBr, tmpvar_14);
  x2_12.y = dot (unity_SHBg, tmpvar_14);
  x2_12.z = dot (unity_SHBb, tmpvar_14);
  tmpvar_10 = ((x2_12 + (unity_SHC.xyz * 
    ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y))
  )) + x1_13);
  highp vec3 lightColor0_15;
  lightColor0_15 = unity_LightColor[0].xyz;
  highp vec3 lightColor1_16;
  lightColor1_16 = unity_LightColor[1].xyz;
  highp vec3 lightColor2_17;
  lightColor2_17 = unity_LightColor[2].xyz;
  highp vec3 lightColor3_18;
  lightColor3_18 = unity_LightColor[3].xyz;
  highp vec4 lightAttenSq_19;
  lightAttenSq_19 = unity_4LightAtten0;
  highp vec3 normal_20;
  normal_20 = worldNormal_1;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_4LightPosX0 - tmpvar_4.x);
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosY0 - tmpvar_4.y);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosZ0 - tmpvar_4.z);
  highp vec4 tmpvar_24;
  tmpvar_24 = (((tmpvar_21 * tmpvar_21) + (tmpvar_22 * tmpvar_22)) + (tmpvar_23 * tmpvar_23));
  highp vec4 tmpvar_25;
  tmpvar_25 = (max (vec4(0.0, 0.0, 0.0, 0.0), (
    (((tmpvar_21 * normal_20.x) + (tmpvar_22 * normal_20.y)) + (tmpvar_23 * normal_20.z))
   * 
    inversesqrt(tmpvar_24)
  )) * (1.0/((1.0 + 
    (tmpvar_24 * lightAttenSq_19)
  ))));
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_10 + ((
    ((lightColor0_15 * tmpvar_25.x) + (lightColor1_16 * tmpvar_25.y))
   + 
    (lightColor2_17 * tmpvar_25.z)
  ) + (lightColor3_18 * tmpvar_25.w)));
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c_10.xyz + (tmpvar_7.xyz * xlv_TEXCOORD3));
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
uniform mediump vec4 unity_4LightAtten0;
uniform mediump vec4 unity_LightColor[8];
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  highp vec4 v_5;
  v_5.x = _World2Object[0].x;
  v_5.y = _World2Object[1].x;
  v_5.z = _World2Object[2].x;
  v_5.w = _World2Object[3].x;
  highp vec4 v_6;
  v_6.x = _World2Object[0].y;
  v_6.y = _World2Object[1].y;
  v_6.z = _World2Object[2].y;
  v_6.w = _World2Object[3].y;
  highp vec4 v_7;
  v_7.x = _World2Object[0].z;
  v_7.y = _World2Object[1].z;
  v_7.z = _World2Object[2].z;
  v_7.w = _World2Object[3].z;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize(((
    (v_5.xyz * _glesNormal.x)
   + 
    (v_6.xyz * _glesNormal.y)
  ) + (v_7.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_8;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = worldNormal_1;
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  x1_13.x = dot (unity_SHAr, normal_11);
  x1_13.y = dot (unity_SHAg, normal_11);
  x1_13.z = dot (unity_SHAb, normal_11);
  mediump vec4 tmpvar_14;
  tmpvar_14 = (normal_11.xyzz * normal_11.yzzx);
  x2_12.x = dot (unity_SHBr, tmpvar_14);
  x2_12.y = dot (unity_SHBg, tmpvar_14);
  x2_12.z = dot (unity_SHBb, tmpvar_14);
  tmpvar_10 = ((x2_12 + (unity_SHC.xyz * 
    ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y))
  )) + x1_13);
  highp vec3 lightColor0_15;
  lightColor0_15 = unity_LightColor[0].xyz;
  highp vec3 lightColor1_16;
  lightColor1_16 = unity_LightColor[1].xyz;
  highp vec3 lightColor2_17;
  lightColor2_17 = unity_LightColor[2].xyz;
  highp vec3 lightColor3_18;
  lightColor3_18 = unity_LightColor[3].xyz;
  highp vec4 lightAttenSq_19;
  lightAttenSq_19 = unity_4LightAtten0;
  highp vec3 normal_20;
  normal_20 = worldNormal_1;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_4LightPosX0 - tmpvar_4.x);
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosY0 - tmpvar_4.y);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosZ0 - tmpvar_4.z);
  highp vec4 tmpvar_24;
  tmpvar_24 = (((tmpvar_21 * tmpvar_21) + (tmpvar_22 * tmpvar_22)) + (tmpvar_23 * tmpvar_23));
  highp vec4 tmpvar_25;
  tmpvar_25 = (max (vec4(0.0, 0.0, 0.0, 0.0), (
    (((tmpvar_21 * normal_20.x) + (tmpvar_22 * normal_20.y)) + (tmpvar_23 * normal_20.z))
   * 
    inversesqrt(tmpvar_24)
  )) * (1.0/((1.0 + 
    (tmpvar_24 * lightAttenSq_19)
  ))));
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_10 + ((
    ((lightColor0_15 * tmpvar_25.x) + (lightColor1_16 * tmpvar_25.y))
   + 
    (lightColor2_17 * tmpvar_25.z)
  ) + (lightColor3_18 * tmpvar_25.w)));
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD3;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c_10.xyz + (tmpvar_7.xyz * xlv_TEXCOORD3));
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
uniform mediump vec4 unity_4LightAtten0;
uniform mediump vec4 unity_LightColor[8];
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 tmpvar_4;
  highp vec4 cse_5;
  cse_5 = (_Object2World * _glesVertex);
  highp vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  highp vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  highp vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * _glesNormal.x)
   + 
    (v_7.xyz * _glesNormal.y)
  ) + (v_8.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_9;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = worldNormal_1;
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  highp vec3 lightColor0_16;
  lightColor0_16 = unity_LightColor[0].xyz;
  highp vec3 lightColor1_17;
  lightColor1_17 = unity_LightColor[1].xyz;
  highp vec3 lightColor2_18;
  lightColor2_18 = unity_LightColor[2].xyz;
  highp vec3 lightColor3_19;
  lightColor3_19 = unity_LightColor[3].xyz;
  highp vec4 lightAttenSq_20;
  lightAttenSq_20 = unity_4LightAtten0;
  highp vec3 normal_21;
  normal_21 = worldNormal_1;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - cse_5.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - cse_5.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - cse_5.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), (
    (((tmpvar_22 * normal_21.x) + (tmpvar_23 * normal_21.y)) + (tmpvar_24 * normal_21.z))
   * 
    inversesqrt(tmpvar_25)
  )) * (1.0/((1.0 + 
    (tmpvar_25 * lightAttenSq_20)
  ))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_11 + ((
    ((lightColor0_16 * tmpvar_26.x) + (lightColor1_17 * tmpvar_26.y))
   + 
    (lightColor2_18 * tmpvar_26.z)
  ) + (lightColor3_19 * tmpvar_26.w)));
  tmpvar_3 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * cse_5);
  tmpvar_4 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_5.xyz;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float tmpvar_9;
  mediump float dist_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_10 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (float((dist_10 > 
    (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w)
  )), _LightShadowData.x);
  tmpvar_9 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_13;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = tmpvar_9;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_14;
  lowp vec4 c_15;
  lowp vec4 c_16;
  lowp float diff_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((tmpvar_8.xyz * tmpvar_14) * diff_17);
  c_16.xyz = tmpvar_19;
  c_16.w = tmpvar_8.w;
  c_15.w = c_16.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_16.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_15.xyz = tmpvar_20;
  c_4.xyz = c_15.xyz;
  c_4.w = 1.0;
  gl_FragData[0] = c_4;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  highp vec4 tmpvar_13;
  highp vec4 cse_14;
  cse_14 = (_Object2World * _glesVertex);
  tmpvar_13 = (unity_World2Shadow[0] * cse_14);
  tmpvar_3 = tmpvar_13;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_14.xyz;
  xlv_TEXCOORD3 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float shadow_9;
  lowp float tmpvar_10;
  tmpvar_10 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  mediump float tmpvar_11;
  tmpvar_11 = (_LightShadowData.x + (tmpvar_10 * (1.0 - _LightShadowData.x)));
  shadow_9 = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_12;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = shadow_9;
  mediump vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_13;
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_13) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (c_15.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_14.xyz = tmpvar_19;
  c_4.xyz = c_14.xyz;
  c_4.w = 1.0;
  gl_FragData[0] = c_4;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  highp vec4 tmpvar_13;
  highp vec4 cse_14;
  cse_14 = (_Object2World * _glesVertex);
  tmpvar_13 = (unity_World2Shadow[0] * cse_14);
  tmpvar_3 = tmpvar_13;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_14.xyz;
  xlv_TEXCOORD3 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD3;
in mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float shadow_9;
  mediump float tmpvar_10;
  tmpvar_10 = texture (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10;
  mediump float tmpvar_12;
  tmpvar_12 = (_LightShadowData.x + (tmpvar_11 * (1.0 - _LightShadowData.x)));
  shadow_9 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_13;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = shadow_9;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_14;
  lowp vec4 c_15;
  lowp vec4 c_16;
  lowp float diff_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((tmpvar_8.xyz * tmpvar_14) * diff_17);
  c_16.xyz = tmpvar_19;
  c_16.w = tmpvar_8.w;
  c_15.w = c_16.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_16.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_15.xyz = tmpvar_20;
  c_4.xyz = c_15.xyz;
  c_4.w = 1.0;
  _glesFragData[0] = c_4;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
uniform mediump vec4 unity_4LightAtten0;
uniform mediump vec4 unity_LightColor[8];
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 tmpvar_4;
  highp vec4 cse_5;
  cse_5 = (_Object2World * _glesVertex);
  highp vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  highp vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  highp vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * _glesNormal.x)
   + 
    (v_7.xyz * _glesNormal.y)
  ) + (v_8.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_9;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = worldNormal_1;
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  highp vec3 lightColor0_16;
  lightColor0_16 = unity_LightColor[0].xyz;
  highp vec3 lightColor1_17;
  lightColor1_17 = unity_LightColor[1].xyz;
  highp vec3 lightColor2_18;
  lightColor2_18 = unity_LightColor[2].xyz;
  highp vec3 lightColor3_19;
  lightColor3_19 = unity_LightColor[3].xyz;
  highp vec4 lightAttenSq_20;
  lightAttenSq_20 = unity_4LightAtten0;
  highp vec3 normal_21;
  normal_21 = worldNormal_1;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - cse_5.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - cse_5.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - cse_5.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), (
    (((tmpvar_22 * normal_21.x) + (tmpvar_23 * normal_21.y)) + (tmpvar_24 * normal_21.z))
   * 
    inversesqrt(tmpvar_25)
  )) * (1.0/((1.0 + 
    (tmpvar_25 * lightAttenSq_20)
  ))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_11 + ((
    ((lightColor0_16 * tmpvar_26.x) + (lightColor1_17 * tmpvar_26.y))
   + 
    (lightColor2_18 * tmpvar_26.z)
  ) + (lightColor3_19 * tmpvar_26.w)));
  tmpvar_3 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * cse_5);
  tmpvar_4 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_5.xyz;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float shadow_9;
  lowp float tmpvar_10;
  tmpvar_10 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  mediump float tmpvar_11;
  tmpvar_11 = (_LightShadowData.x + (tmpvar_10 * (1.0 - _LightShadowData.x)));
  shadow_9 = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_12;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = shadow_9;
  mediump vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_13;
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_13) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (c_15.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_14.xyz = tmpvar_19;
  c_4.xyz = c_14.xyz;
  c_4.w = 1.0;
  gl_FragData[0] = c_4;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
uniform mediump vec4 unity_4LightAtten0;
uniform mediump vec4 unity_LightColor[8];
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out mediump vec4 xlv_TEXCOORD4;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec4 tmpvar_4;
  highp vec4 cse_5;
  cse_5 = (_Object2World * _glesVertex);
  highp vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  highp vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  highp vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * _glesNormal.x)
   + 
    (v_7.xyz * _glesNormal.y)
  ) + (v_8.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_9;
  tmpvar_2 = worldNormal_1;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = worldNormal_1;
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  highp vec3 lightColor0_16;
  lightColor0_16 = unity_LightColor[0].xyz;
  highp vec3 lightColor1_17;
  lightColor1_17 = unity_LightColor[1].xyz;
  highp vec3 lightColor2_18;
  lightColor2_18 = unity_LightColor[2].xyz;
  highp vec3 lightColor3_19;
  lightColor3_19 = unity_LightColor[3].xyz;
  highp vec4 lightAttenSq_20;
  lightAttenSq_20 = unity_4LightAtten0;
  highp vec3 normal_21;
  normal_21 = worldNormal_1;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - cse_5.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - cse_5.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - cse_5.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), (
    (((tmpvar_22 * normal_21.x) + (tmpvar_23 * normal_21.y)) + (tmpvar_24 * normal_21.z))
   * 
    inversesqrt(tmpvar_25)
  )) * (1.0/((1.0 + 
    (tmpvar_25 * lightAttenSq_20)
  ))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_11 + ((
    ((lightColor0_16 * tmpvar_26.x) + (lightColor1_17 * tmpvar_26.y))
   + 
    (lightColor2_18 * tmpvar_26.z)
  ) + (lightColor3_19 * tmpvar_26.w)));
  tmpvar_3 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * cse_5);
  tmpvar_4 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = cse_5.xyz;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD3;
in mediump vec4 xlv_TEXCOORD4;
void main ()
{
  mediump float tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec4 c_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp float shadow_9;
  mediump float tmpvar_10;
  tmpvar_10 = texture (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10;
  mediump float tmpvar_12;
  tmpvar_12 = (_LightShadowData.x + (tmpvar_11 * (1.0 - _LightShadowData.x)));
  shadow_9 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_2 = tmpvar_13;
  tmpvar_3 = lightDir_6;
  tmpvar_1 = shadow_9;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_2 * tmpvar_1);
  tmpvar_2 = tmpvar_14;
  lowp vec4 c_15;
  lowp vec4 c_16;
  lowp float diff_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (tmpvar_5, tmpvar_3));
  diff_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((tmpvar_8.xyz * tmpvar_14) * diff_17);
  c_16.xyz = tmpvar_19;
  c_16.w = tmpvar_8.w;
  c_15.w = c_16.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_16.xyz + (tmpvar_8.xyz * xlv_TEXCOORD3));
  c_15.xyz = tmpvar_20;
  c_4.xyz = c_15.xyz;
  c_4.w = 1.0;
  _glesFragData[0] = c_4;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLES3"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="Opaque" }
  ZWrite Off
  Blend One One
  GpuProgramID 123306
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec3 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xyz;
  lightCoord_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = dot (lightCoord_4, lightCoord_4);
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_LightTexture0, vec2(tmpvar_11)).w;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_13;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_12);
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_1) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = c_15.xyz;
  c_14.xyz = tmpvar_19;
  c_3.xyz = c_14.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec3 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xyz;
  lightCoord_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = dot (lightCoord_4, lightCoord_4);
  lowp float tmpvar_12;
  tmpvar_12 = texture (_LightTexture0, vec2(tmpvar_11)).w;
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_13;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_12);
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_1) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = c_15.xyz;
  c_14.xyz = tmpvar_19;
  c_3.xyz = c_14.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = c_10.xyz;
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp vec3 tmpvar_4;
  lowp vec3 lightDir_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  lightDir_5 = tmpvar_6;
  tmpvar_4 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_7;
  tmpvar_7 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec3 tmpvar_8;
  tmpvar_8 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_8;
  tmpvar_2 = lightDir_5;
  lowp vec4 c_9;
  lowp vec4 c_10;
  lowp float diff_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_4, tmpvar_2));
  diff_11 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = ((tmpvar_7.xyz * tmpvar_1) * diff_11);
  c_10.xyz = tmpvar_13;
  c_10.w = tmpvar_7.w;
  c_9.w = c_10.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = c_10.xyz;
  c_9.xyz = tmpvar_14;
  c_3.xyz = c_9.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp float atten_4;
  mediump vec4 lightCoord_5;
  lowp vec3 tmpvar_6;
  lowp vec3 lightDir_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_7 = tmpvar_8;
  tmpvar_6 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = xlv_TEXCOORD2;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_LightMatrix0 * tmpvar_10);
  lightCoord_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = ((lightCoord_5.xy / lightCoord_5.w) + 0.5);
  tmpvar_12 = texture2D (_LightTexture0, P_13);
  mediump float tmpvar_14;
  tmpvar_14 = dot (lightCoord_5.xyz, lightCoord_5.xyz);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14));
  mediump float tmpvar_16;
  tmpvar_16 = ((float(
    (lightCoord_5.z > 0.0)
  ) * tmpvar_12.w) * tmpvar_15.w);
  atten_4 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_17;
  tmpvar_2 = lightDir_7;
  tmpvar_1 = (tmpvar_1 * atten_4);
  lowp vec4 c_18;
  lowp vec4 c_19;
  lowp float diff_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_6, tmpvar_2));
  diff_20 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((tmpvar_9.xyz * tmpvar_1) * diff_20);
  c_19.xyz = tmpvar_22;
  c_19.w = tmpvar_9.w;
  c_18.w = c_19.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = c_19.xyz;
  c_18.xyz = tmpvar_23;
  c_3.xyz = c_18.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  lowp float atten_4;
  mediump vec4 lightCoord_5;
  lowp vec3 tmpvar_6;
  lowp vec3 lightDir_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_7 = tmpvar_8;
  tmpvar_6 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = xlv_TEXCOORD2;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_LightMatrix0 * tmpvar_10);
  lightCoord_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = ((lightCoord_5.xy / lightCoord_5.w) + 0.5);
  tmpvar_12 = texture (_LightTexture0, P_13);
  mediump float tmpvar_14;
  tmpvar_14 = dot (lightCoord_5.xyz, lightCoord_5.xyz);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14));
  mediump float tmpvar_16;
  tmpvar_16 = ((float(
    (lightCoord_5.z > 0.0)
  ) * tmpvar_12.w) * tmpvar_15.w);
  atten_4 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_17;
  tmpvar_2 = lightDir_7;
  tmpvar_1 = (tmpvar_1 * atten_4);
  lowp vec4 c_18;
  lowp vec4 c_19;
  lowp float diff_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_6, tmpvar_2));
  diff_20 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((tmpvar_9.xyz * tmpvar_1) * diff_20);
  c_19.xyz = tmpvar_22;
  c_19.w = tmpvar_9.w;
  c_18.w = c_19.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = c_19.xyz;
  c_18.xyz = tmpvar_23;
  c_3.xyz = c_18.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform lowp samplerCube _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec3 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xyz;
  lightCoord_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = dot (lightCoord_4, lightCoord_4);
  lowp float tmpvar_12;
  tmpvar_12 = (texture2D (_LightTextureB0, vec2(tmpvar_11)).w * textureCube (_LightTexture0, lightCoord_4).w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_13;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_12);
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_1) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = c_15.xyz;
  c_14.xyz = tmpvar_19;
  c_3.xyz = c_14.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform lowp samplerCube _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec3 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xyz;
  lightCoord_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = dot (lightCoord_4, lightCoord_4);
  lowp float tmpvar_12;
  tmpvar_12 = (texture (_LightTextureB0, vec2(tmpvar_11)).w * texture (_LightTexture0, lightCoord_4).w);
  lowp vec3 tmpvar_13;
  tmpvar_13 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_13;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_12);
  lowp vec4 c_14;
  lowp vec4 c_15;
  lowp float diff_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = ((tmpvar_8.xyz * tmpvar_1) * diff_16);
  c_15.xyz = tmpvar_18;
  c_15.w = tmpvar_8.w;
  c_14.w = c_15.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = c_15.xyz;
  c_14.xyz = tmpvar_19;
  c_3.xyz = c_14.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec2 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec2 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xy;
  lightCoord_4 = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, lightCoord_4).w;
  lowp vec3 tmpvar_12;
  tmpvar_12 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_12;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_11);
  lowp vec4 c_13;
  lowp vec4 c_14;
  lowp float diff_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_15 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_8.xyz * tmpvar_1) * diff_15);
  c_14.xyz = tmpvar_17;
  c_14.w = tmpvar_8.w;
  c_13.w = c_14.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = c_14.xyz;
  c_13.xyz = tmpvar_18;
  c_3.xyz = c_13.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform mediump vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform mediump mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main ()
{
  mediump vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  lowp vec4 c_3;
  mediump vec2 lightCoord_4;
  lowp vec3 tmpvar_5;
  lowp vec3 lightDir_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  lightDir_6 = tmpvar_7;
  tmpvar_5 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = xlv_TEXCOORD2;
  highp vec2 tmpvar_10;
  tmpvar_10 = (_LightMatrix0 * tmpvar_9).xy;
  lightCoord_4 = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture (_LightTexture0, lightCoord_4).w;
  lowp vec3 tmpvar_12;
  tmpvar_12 = _LightColor0.xyz;
  tmpvar_1 = tmpvar_12;
  tmpvar_2 = lightDir_6;
  tmpvar_1 = (tmpvar_1 * tmpvar_11);
  lowp vec4 c_13;
  lowp vec4 c_14;
  lowp float diff_15;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_5, tmpvar_2));
  diff_15 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_8.xyz * tmpvar_1) * diff_15);
  c_14.xyz = tmpvar_17;
  c_14.w = tmpvar_8.w;
  c_13.w = c_14.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = c_14.xyz;
  c_13.xyz = tmpvar_18;
  c_3.xyz = c_13.xyz;
  c_3.w = 1.0;
  _glesFragData[0] = c_3;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "RenderType"="Opaque" }
  GpuProgramID 164273
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0;
  res_1.xyz = ((tmpvar_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
out mediump vec3 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  highp vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  highp vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * _glesNormal.x)
   + 
    (v_4.xyz * _glesNormal.y)
  ) + (v_5.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_6;
  tmpvar_2 = worldNormal_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
in mediump vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0;
  res_1.xyz = ((tmpvar_2 * 0.5) + 0.5);
  res_1.w = 0.0;
  _glesFragData[0] = res_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
"!!GLES"
}
SubProgram "gles3 " {
"!!GLES3"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "RenderType"="Opaque" }
  ZWrite Off
  GpuProgramID 201509
Program "vp" {
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  highp vec4 v_7;
  v_7.x = _World2Object[0].x;
  v_7.y = _World2Object[1].x;
  v_7.z = _World2Object[2].x;
  v_7.w = _World2Object[3].x;
  highp vec4 v_8;
  v_8.x = _World2Object[0].y;
  v_8.y = _World2Object[1].y;
  v_8.z = _World2Object[2].y;
  v_8.w = _World2Object[3].y;
  highp vec4 v_9;
  v_9.x = _World2Object[0].z;
  v_9.y = _World2Object[1].z;
  v_9.z = _World2Object[2].z;
  v_9.w = _World2Object[3].z;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = normalize(((
    (v_7.xyz * _glesNormal.x)
   + 
    (v_8.xyz * _glesNormal.y)
  ) + (v_9.xyz * _glesNormal.z)));
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  tmpvar_2 = tmpvar_11;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = tmpvar_1;
  xlv_TEXCOORD4 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_6.w;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_7;
  lowp vec4 c_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz * light_3.xyz);
  c_8.xyz = tmpvar_9;
  c_8.w = tmpvar_4.w;
  c_2.xyz = c_8.xyz;
  c_2.w = 1.0;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  highp vec4 v_7;
  v_7.x = _World2Object[0].x;
  v_7.y = _World2Object[1].x;
  v_7.z = _World2Object[2].x;
  v_7.w = _World2Object[3].x;
  highp vec4 v_8;
  v_8.x = _World2Object[0].y;
  v_8.y = _World2Object[1].y;
  v_8.z = _World2Object[2].y;
  v_8.w = _World2Object[3].y;
  highp vec4 v_9;
  v_9.x = _World2Object[0].z;
  v_9.y = _World2Object[1].z;
  v_9.z = _World2Object[2].z;
  v_9.w = _World2Object[3].z;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = normalize(((
    (v_7.xyz * _glesNormal.x)
   + 
    (v_8.xyz * _glesNormal.y)
  ) + (v_9.xyz * _glesNormal.z)));
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  tmpvar_2 = tmpvar_11;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = tmpvar_1;
  xlv_TEXCOORD4 = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightBuffer;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_6.w;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_7;
  lowp vec4 c_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz * light_3.xyz);
  c_8.xyz = tmpvar_9;
  c_8.w = tmpvar_4.w;
  c_2.xyz = c_8.xyz;
  c_2.w = 1.0;
  tmpvar_1 = c_2;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  highp vec4 v_7;
  v_7.x = _World2Object[0].x;
  v_7.y = _World2Object[1].x;
  v_7.z = _World2Object[2].x;
  v_7.w = _World2Object[3].x;
  highp vec4 v_8;
  v_8.x = _World2Object[0].y;
  v_8.y = _World2Object[1].y;
  v_8.z = _World2Object[2].y;
  v_8.w = _World2Object[3].y;
  highp vec4 v_9;
  v_9.x = _World2Object[0].z;
  v_9.y = _World2Object[1].z;
  v_9.z = _World2Object[2].z;
  v_9.w = _World2Object[3].z;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = normalize(((
    (v_7.xyz * _glesNormal.x)
   + 
    (v_8.xyz * _glesNormal.y)
  ) + (v_9.xyz * _glesNormal.z)));
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  tmpvar_2 = tmpvar_11;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = tmpvar_1;
  xlv_TEXCOORD4 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_6.w;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_7;
  lowp vec4 c_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz * light_3.xyz);
  c_8.xyz = tmpvar_9;
  c_8.w = tmpvar_4.w;
  c_2.xyz = c_8.xyz;
  c_2.w = 1.0;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  highp vec4 v_7;
  v_7.x = _World2Object[0].x;
  v_7.y = _World2Object[1].x;
  v_7.z = _World2Object[2].x;
  v_7.w = _World2Object[3].x;
  highp vec4 v_8;
  v_8.x = _World2Object[0].y;
  v_8.y = _World2Object[1].y;
  v_8.z = _World2Object[2].y;
  v_8.w = _World2Object[3].y;
  highp vec4 v_9;
  v_9.x = _World2Object[0].z;
  v_9.y = _World2Object[1].z;
  v_9.z = _World2Object[2].z;
  v_9.w = _World2Object[3].z;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = normalize(((
    (v_7.xyz * _glesNormal.x)
   + 
    (v_8.xyz * _glesNormal.y)
  ) + (v_9.xyz * _glesNormal.z)));
  mediump vec3 tmpvar_11;
  mediump vec4 normal_12;
  normal_12 = tmpvar_10;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  x1_14.x = dot (unity_SHAr, normal_12);
  x1_14.y = dot (unity_SHAg, normal_12);
  x1_14.z = dot (unity_SHAb, normal_12);
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal_12.xyzz * normal_12.yzzx);
  x2_13.x = dot (unity_SHBr, tmpvar_15);
  x2_13.y = dot (unity_SHBg, tmpvar_15);
  x2_13.z = dot (unity_SHBb, tmpvar_15);
  tmpvar_11 = ((x2_13 + (unity_SHC.xyz * 
    ((normal_12.x * normal_12.x) - (normal_12.y * normal_12.y))
  )) + x1_14);
  tmpvar_2 = tmpvar_11;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = tmpvar_1;
  xlv_TEXCOORD4 = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
uniform sampler2D _LightBuffer;
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD4;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_6.w;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz + xlv_TEXCOORD4);
  light_3.xyz = tmpvar_7;
  lowp vec4 c_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz * light_3.xyz);
  c_8.xyz = tmpvar_9;
  c_8.w = tmpvar_4.w;
  c_2.xyz = c_8.xyz;
  c_2.w = 1.0;
  tmpvar_1 = c_2;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
}
 }
 Pass {
  Name "DEFERRED"
  Tags { "LIGHTMODE"="Deferred" "RenderType"="Opaque" }
  GpuProgramID 323583
Program "vp" {
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vec2(0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_draw_buffers : require
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD5;
void main ()
{
  mediump vec4 outDiffuse_1;
  mediump vec4 outEmission_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec4 outDiffuseOcclusion_5;
  mediump vec4 outNormal_6;
  mediump vec4 emission_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_4.xyz;
  outDiffuseOcclusion_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((tmpvar_3 * 0.5) + 0.5);
  outNormal_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = vec3(0.0, 0.0, 0.0);
  emission_7 = tmpvar_10;
  emission_7.xyz = (emission_7.xyz + (tmpvar_4.xyz * xlv_TEXCOORD5));
  outDiffuse_1.xyz = outDiffuseOcclusion_5.xyz;
  outEmission_2.w = emission_7.w;
  outDiffuse_1.w = 1.0;
  outEmission_2.xyz = exp2(-(emission_7.xyz));
  gl_FragData[0] = outDiffuse_1;
  gl_FragData[1] = vec4(0.0, 0.0, 0.0, 0.0);
  gl_FragData[2] = outNormal_6;
  gl_FragData[3] = outEmission_2;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD4;
out mediump vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vec2(0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD5;
void main ()
{
  mediump vec4 outDiffuse_1;
  mediump vec4 outEmission_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec4 outDiffuseOcclusion_5;
  mediump vec4 outNormal_6;
  mediump vec4 emission_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_4.xyz;
  outDiffuseOcclusion_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((tmpvar_3 * 0.5) + 0.5);
  outNormal_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = vec3(0.0, 0.0, 0.0);
  emission_7 = tmpvar_10;
  emission_7.xyz = (emission_7.xyz + (tmpvar_4.xyz * xlv_TEXCOORD5));
  outDiffuse_1.xyz = outDiffuseOcclusion_5.xyz;
  outEmission_2.w = emission_7.w;
  outDiffuse_1.w = 1.0;
  outEmission_2.xyz = exp2(-(emission_7.xyz));
  _glesFragData[0] = outDiffuse_1;
  _glesFragData[1] = vec4(0.0, 0.0, 0.0, 0.0);
  _glesFragData[2] = outNormal_6;
  _glesFragData[3] = outEmission_2;
}



#endif"
}
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vec2(0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_draw_buffers : require
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD5;
void main ()
{
  mediump vec4 outDiffuse_1;
  lowp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec4 outDiffuseOcclusion_4;
  mediump vec4 outNormal_5;
  mediump vec4 emission_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_3.xyz;
  outDiffuseOcclusion_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((tmpvar_2 * 0.5) + 0.5);
  outNormal_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = vec3(0.0, 0.0, 0.0);
  emission_6 = tmpvar_9;
  emission_6.xyz = (emission_6.xyz + (tmpvar_3.xyz * xlv_TEXCOORD5));
  outDiffuse_1.xyz = outDiffuseOcclusion_4.xyz;
  outDiffuse_1.w = 1.0;
  gl_FragData[0] = outDiffuse_1;
  gl_FragData[1] = vec4(0.0, 0.0, 0.0, 0.0);
  gl_FragData[2] = outNormal_5;
  gl_FragData[3] = emission_6;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_SHAr;
uniform mediump vec4 unity_SHAg;
uniform mediump vec4 unity_SHAb;
uniform mediump vec4 unity_SHBr;
uniform mediump vec4 unity_SHBg;
uniform mediump vec4 unity_SHBb;
uniform mediump vec4 unity_SHC;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
out highp vec2 xlv_TEXCOORD0;
out mediump vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD4;
out mediump vec3 xlv_TEXCOORD5;
void main ()
{
  lowp vec3 worldNormal_1;
  mediump vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 v_4;
  v_4.x = _World2Object[0].x;
  v_4.y = _World2Object[1].x;
  v_4.z = _World2Object[2].x;
  v_4.w = _World2Object[3].x;
  highp vec4 v_5;
  v_5.x = _World2Object[0].y;
  v_5.y = _World2Object[1].y;
  v_5.z = _World2Object[2].y;
  v_5.w = _World2Object[3].y;
  highp vec4 v_6;
  v_6.x = _World2Object[0].z;
  v_6.y = _World2Object[1].z;
  v_6.z = _World2Object[2].z;
  v_6.w = _World2Object[3].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((
    (v_4.xyz * _glesNormal.x)
   + 
    (v_5.xyz * _glesNormal.y)
  ) + (v_6.xyz * _glesNormal.z)));
  worldNormal_1 = tmpvar_7;
  tmpvar_2 = worldNormal_1;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vec2(0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = worldNormal_1;
  mediump vec4 normal_9;
  normal_9 = tmpvar_8;
  mediump vec3 x2_10;
  mediump vec3 x1_11;
  x1_11.x = dot (unity_SHAr, normal_9);
  x1_11.y = dot (unity_SHAg, normal_9);
  x1_11.z = dot (unity_SHAb, normal_9);
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal_9.xyzz * normal_9.yzzx);
  x2_10.x = dot (unity_SHBr, tmpvar_12);
  x2_10.y = dot (unity_SHBg, tmpvar_12);
  x2_10.z = dot (unity_SHBb, tmpvar_12);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = ((x2_10 + (unity_SHC.xyz * 
    ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y))
  )) + x1_11);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
in highp vec2 xlv_TEXCOORD0;
in mediump vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD5;
void main ()
{
  mediump vec4 outDiffuse_1;
  lowp vec3 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec4 outDiffuseOcclusion_4;
  mediump vec4 outNormal_5;
  mediump vec4 emission_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_3.xyz;
  outDiffuseOcclusion_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((tmpvar_2 * 0.5) + 0.5);
  outNormal_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = vec3(0.0, 0.0, 0.0);
  emission_6 = tmpvar_9;
  emission_6.xyz = (emission_6.xyz + (tmpvar_3.xyz * xlv_TEXCOORD5));
  outDiffuse_1.xyz = outDiffuseOcclusion_4.xyz;
  outDiffuse_1.w = 1.0;
  _glesFragData[0] = outDiffuse_1;
  _glesFragData[1] = vec4(0.0, 0.0, 0.0, 0.0);
  _glesFragData[2] = outNormal_5;
  _glesFragData[3] = emission_6;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
}
 }
}
Fallback "Legacy Shaders/VertexLit"
}