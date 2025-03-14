//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-PrePassCollectShadows" {
Properties {
 _ShadowMapTexture ("", any) = "" { }
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 58189
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  mediump float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_11.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  mediump float tmpvar_14;
  tmpvar_14 = mix (_LightShadowData.x, 1.0, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_14 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = vec4(shadow_2);
  res_1 = tmpvar_16;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  lowp float tmpvar_12;
  tmpvar_12 = shadow2DEXT (_ShadowMapTexture, tmpvar_11.xyz);
  mediump float tmpvar_13;
  tmpvar_13 = tmpvar_12;
  mediump float tmpvar_14;
  tmpvar_14 = mix (_LightShadowData.x, 1.0, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_14 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = vec4(shadow_2);
  res_1 = tmpvar_16;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump float tmpvar_12;
  tmpvar_12 = texture (_ShadowMapTexture, tmpvar_11.xyz);
  mediump float tmpvar_13;
  tmpvar_13 = mix (_LightShadowData.x, 1.0, tmpvar_12);
  highp float tmpvar_14;
  tmpvar_14 = (tmpvar_13 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = vec4(shadow_2);
  res_1 = tmpvar_15;
  _glesFragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  mediump float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_15.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  mediump float tmpvar_18;
  tmpvar_18 = mix (_LightShadowData.x, 1.0, tmpvar_17);
  highp float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    sqrt(dot (tmpvar_20, tmpvar_20))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_21 = tmpvar_22;
  tmpvar_19 = tmpvar_21;
  highp float tmpvar_23;
  tmpvar_23 = (tmpvar_18 + tmpvar_19);
  shadow_2 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = vec4(shadow_2);
  res_1 = tmpvar_24;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  lowp float tmpvar_16;
  tmpvar_16 = shadow2DEXT (_ShadowMapTexture, tmpvar_15.xyz);
  mediump float tmpvar_17;
  tmpvar_17 = tmpvar_16;
  mediump float tmpvar_18;
  tmpvar_18 = mix (_LightShadowData.x, 1.0, tmpvar_17);
  highp float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    sqrt(dot (tmpvar_20, tmpvar_20))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_21 = tmpvar_22;
  tmpvar_19 = tmpvar_21;
  highp float tmpvar_23;
  tmpvar_23 = (tmpvar_18 + tmpvar_19);
  shadow_2 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = vec4(shadow_2);
  res_1 = tmpvar_24;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  mediump float tmpvar_16;
  tmpvar_16 = texture (_ShadowMapTexture, tmpvar_15.xyz);
  mediump float tmpvar_17;
  tmpvar_17 = mix (_LightShadowData.x, 1.0, tmpvar_16);
  highp float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    sqrt(dot (tmpvar_19, tmpvar_19))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  tmpvar_18 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_17 + tmpvar_18);
  shadow_2 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = vec4(shadow_2);
  res_1 = tmpvar_23;
  _glesFragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_10 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(shadow_2);
  res_1 = tmpvar_12;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  lowp float tmpvar_8;
  tmpvar_8 = shadow2DEXT (_ShadowMapTexture, tmpvar_7.xyz);
  mediump float tmpvar_9;
  tmpvar_9 = tmpvar_8;
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_10 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(shadow_2);
  res_1 = tmpvar_12;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  mediump float tmpvar_8;
  tmpvar_8 = texture (_ShadowMapTexture, tmpvar_7.xyz);
  mediump float tmpvar_9;
  tmpvar_9 = mix (_LightShadowData.x, 1.0, tmpvar_8);
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_9 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_2);
  res_1 = tmpvar_11;
  _glesFragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  highp float tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    sqrt(dot (tmpvar_12, tmpvar_12))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  tmpvar_11 = tmpvar_13;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_10 + tmpvar_11);
  shadow_2 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = vec4(shadow_2);
  res_1 = tmpvar_16;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  lowp float tmpvar_8;
  tmpvar_8 = shadow2DEXT (_ShadowMapTexture, tmpvar_7.xyz);
  mediump float tmpvar_9;
  tmpvar_9 = tmpvar_8;
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  highp float tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    sqrt(dot (tmpvar_12, tmpvar_12))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  tmpvar_11 = tmpvar_13;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_10 + tmpvar_11);
  shadow_2 = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = vec4(shadow_2);
  res_1 = tmpvar_16;
  gl_FragData[0] = res_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 res_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  mediump float tmpvar_8;
  tmpvar_8 = texture (_ShadowMapTexture, tmpvar_7.xyz);
  mediump float tmpvar_9;
  tmpvar_9 = mix (_LightShadowData.x, 1.0, tmpvar_8);
  highp float tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    sqrt(dot (tmpvar_11, tmpvar_11))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  tmpvar_10 = tmpvar_12;
  highp float tmpvar_14;
  tmpvar_14 = (tmpvar_9 + tmpvar_10);
  shadow_2 = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = vec4(shadow_2);
  res_1 = tmpvar_15;
  _glesFragData[0] = res_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3"
}
}
 }
}
SubShader { 
 Tags { "ShadowmapFilter"="PCF_5x5" }
 Pass {
  Tags { "ShadowmapFilter"="PCF_5x5" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 97017
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  highp vec2 tmpvar_12;
  tmpvar_12 = _ShadowMapTexture_TexelSize.xy;
  highp vec3 tmpvar_13;
  tmpvar_13.xy = (tmpvar_11.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_13.z = tmpvar_11.z;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  mediump float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_11.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  highp vec2 tmpvar_16;
  tmpvar_16.x = 0.0;
  tmpvar_16.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_17;
  tmpvar_17.xy = (tmpvar_11.xy + tmpvar_16);
  tmpvar_17.z = tmpvar_11.z;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_ShadowMapTexture, tmpvar_17.xy);
  highp float tmpvar_19;
  if ((tmpvar_18.x < tmpvar_11.z)) {
    tmpvar_19 = 0.0;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_15 + tmpvar_19);
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_12.x;
  tmpvar_21.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_11.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_11.z;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_11.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_20 + tmpvar_24);
  highp vec2 tmpvar_26;
  tmpvar_26.y = 0.0;
  tmpvar_26.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_11.xy + tmpvar_26);
  tmpvar_27.z = tmpvar_11.z;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_ShadowMapTexture, tmpvar_27.xy);
  highp float tmpvar_29;
  if ((tmpvar_28.x < tmpvar_11.z)) {
    tmpvar_29 = 0.0;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_25 + tmpvar_29);
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_11.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  tmpvar_33 = (tmpvar_30 + tmpvar_32);
  highp vec2 tmpvar_34;
  tmpvar_34.y = 0.0;
  tmpvar_34.x = tmpvar_12.x;
  highp vec3 tmpvar_35;
  tmpvar_35.xy = (tmpvar_11.xy + tmpvar_34);
  tmpvar_35.z = tmpvar_11.z;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_ShadowMapTexture, tmpvar_35.xy);
  highp float tmpvar_37;
  if ((tmpvar_36.x < tmpvar_11.z)) {
    tmpvar_37 = 0.0;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump float tmpvar_38;
  tmpvar_38 = (tmpvar_33 + tmpvar_37);
  highp vec2 tmpvar_39;
  tmpvar_39.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_39.y = tmpvar_12.y;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_11.xy + tmpvar_39);
  tmpvar_40.z = tmpvar_11.z;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_ShadowMapTexture, tmpvar_40.xy);
  highp float tmpvar_42;
  if ((tmpvar_41.x < tmpvar_11.z)) {
    tmpvar_42 = 0.0;
  } else {
    tmpvar_42 = 1.0;
  };
  mediump float tmpvar_43;
  tmpvar_43 = (tmpvar_38 + tmpvar_42);
  highp vec2 tmpvar_44;
  tmpvar_44.x = 0.0;
  tmpvar_44.y = tmpvar_12.y;
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_11.xy + tmpvar_44);
  tmpvar_45.z = tmpvar_11.z;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_11.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  mediump float tmpvar_48;
  tmpvar_48 = (tmpvar_43 + tmpvar_47);
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_11.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_49.z = tmpvar_11.z;
  lowp vec4 tmpvar_50;
  tmpvar_50 = texture2D (_ShadowMapTexture, tmpvar_49.xy);
  highp float tmpvar_51;
  if ((tmpvar_50.x < tmpvar_11.z)) {
    tmpvar_51 = 0.0;
  } else {
    tmpvar_51 = 1.0;
  };
  mediump float tmpvar_52;
  tmpvar_52 = mix (_LightShadowData.x, 1.0, ((tmpvar_48 + tmpvar_51) / 9.0));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_52 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_53;
  mediump vec4 tmpvar_54;
  tmpvar_54 = vec4(shadow_2);
  tmpvar_1 = tmpvar_54;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump vec3 accum_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = ((tmpvar_11.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_14;
  tmpvar_14 = ((floor(tmpvar_13) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_15;
  tmpvar_15 = fract(tmpvar_13);
  highp vec3 tmpvar_16;
  tmpvar_16.y = 7.0;
  tmpvar_16.x = (4.0 - (3.0 * tmpvar_15.x));
  tmpvar_16.z = (1.0 + (3.0 * tmpvar_15.x));
  highp vec3 tmpvar_17;
  tmpvar_17.x = (((3.0 - 
    (2.0 * tmpvar_15.x)
  ) / tmpvar_16.x) - 2.0);
  tmpvar_17.y = ((3.0 + tmpvar_15.x) / 7.0);
  tmpvar_17.z = ((tmpvar_15.x / tmpvar_16.z) + 2.0);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.y = 7.0;
  tmpvar_19.x = (4.0 - (3.0 * tmpvar_15.y));
  tmpvar_19.z = (1.0 + (3.0 * tmpvar_15.y));
  highp vec3 tmpvar_20;
  tmpvar_20.x = (((3.0 - 
    (2.0 * tmpvar_15.y)
  ) / tmpvar_19.x) - 2.0);
  tmpvar_20.y = ((3.0 + tmpvar_15.y) / 7.0);
  tmpvar_20.z = ((tmpvar_15.y / tmpvar_19.z) + 2.0);
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_16 * tmpvar_19.x);
  accum_12 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_18.x;
  tmpvar_23.y = tmpvar_21.x;
  highp float depth_24;
  depth_24 = tmpvar_11.z;
  highp vec3 uv_25;
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_14 + tmpvar_23);
  tmpvar_26.z = depth_24;
  uv_25.xy = tmpvar_26.xy;
  uv_25.z = depth_24;
  lowp float tmpvar_27;
  tmpvar_27 = shadow2DEXT (_ShadowMapTexture, uv_25);
  highp vec2 tmpvar_28;
  tmpvar_28.x = tmpvar_18.y;
  tmpvar_28.y = tmpvar_21.x;
  highp float depth_29;
  depth_29 = tmpvar_11.z;
  highp vec3 uv_30;
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_14 + tmpvar_28);
  tmpvar_31.z = depth_29;
  uv_30.xy = tmpvar_31.xy;
  uv_30.z = depth_29;
  lowp float tmpvar_32;
  tmpvar_32 = shadow2DEXT (_ShadowMapTexture, uv_30);
  highp vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_18.z;
  tmpvar_33.y = tmpvar_21.x;
  highp float depth_34;
  depth_34 = tmpvar_11.z;
  highp vec3 uv_35;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_14 + tmpvar_33);
  tmpvar_36.z = depth_34;
  uv_35.xy = tmpvar_36.xy;
  uv_35.z = depth_34;
  lowp float tmpvar_37;
  tmpvar_37 = shadow2DEXT (_ShadowMapTexture, uv_35);
  mediump float tmpvar_38;
  tmpvar_38 = (((accum_12.x * tmpvar_27) + (accum_12.y * tmpvar_32)) + (accum_12.z * tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = (tmpvar_16 * 7.0);
  accum_12 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_18.x;
  tmpvar_40.y = tmpvar_21.y;
  highp float depth_41;
  depth_41 = tmpvar_11.z;
  highp vec3 uv_42;
  highp vec3 tmpvar_43;
  tmpvar_43.xy = (tmpvar_14 + tmpvar_40);
  tmpvar_43.z = depth_41;
  uv_42.xy = tmpvar_43.xy;
  uv_42.z = depth_41;
  lowp float tmpvar_44;
  tmpvar_44 = shadow2DEXT (_ShadowMapTexture, uv_42);
  highp vec2 tmpvar_45;
  tmpvar_45.x = tmpvar_18.y;
  tmpvar_45.y = tmpvar_21.y;
  highp float depth_46;
  depth_46 = tmpvar_11.z;
  highp vec3 uv_47;
  highp vec3 tmpvar_48;
  tmpvar_48.xy = (tmpvar_14 + tmpvar_45);
  tmpvar_48.z = depth_46;
  uv_47.xy = tmpvar_48.xy;
  uv_47.z = depth_46;
  lowp float tmpvar_49;
  tmpvar_49 = shadow2DEXT (_ShadowMapTexture, uv_47);
  highp vec2 tmpvar_50;
  tmpvar_50.x = tmpvar_18.z;
  tmpvar_50.y = tmpvar_21.y;
  highp float depth_51;
  depth_51 = tmpvar_11.z;
  highp vec3 uv_52;
  highp vec3 tmpvar_53;
  tmpvar_53.xy = (tmpvar_14 + tmpvar_50);
  tmpvar_53.z = depth_51;
  uv_52.xy = tmpvar_53.xy;
  uv_52.z = depth_51;
  lowp float tmpvar_54;
  tmpvar_54 = shadow2DEXT (_ShadowMapTexture, uv_52);
  mediump float tmpvar_55;
  tmpvar_55 = (((tmpvar_38 + 
    (accum_12.x * tmpvar_44)
  ) + (accum_12.y * tmpvar_49)) + (accum_12.z * tmpvar_54));
  highp vec3 tmpvar_56;
  tmpvar_56 = (tmpvar_16 * tmpvar_19.z);
  accum_12 = tmpvar_56;
  highp vec2 tmpvar_57;
  tmpvar_57.x = tmpvar_18.x;
  tmpvar_57.y = tmpvar_21.z;
  highp float depth_58;
  depth_58 = tmpvar_11.z;
  highp vec3 uv_59;
  highp vec3 tmpvar_60;
  tmpvar_60.xy = (tmpvar_14 + tmpvar_57);
  tmpvar_60.z = depth_58;
  uv_59.xy = tmpvar_60.xy;
  uv_59.z = depth_58;
  lowp float tmpvar_61;
  tmpvar_61 = shadow2DEXT (_ShadowMapTexture, uv_59);
  highp vec2 tmpvar_62;
  tmpvar_62.x = tmpvar_18.y;
  tmpvar_62.y = tmpvar_21.z;
  highp float depth_63;
  depth_63 = tmpvar_11.z;
  highp vec3 uv_64;
  highp vec3 tmpvar_65;
  tmpvar_65.xy = (tmpvar_14 + tmpvar_62);
  tmpvar_65.z = depth_63;
  uv_64.xy = tmpvar_65.xy;
  uv_64.z = depth_63;
  lowp float tmpvar_66;
  tmpvar_66 = shadow2DEXT (_ShadowMapTexture, uv_64);
  highp vec2 tmpvar_67;
  tmpvar_67.x = tmpvar_18.z;
  tmpvar_67.y = tmpvar_21.z;
  highp float depth_68;
  depth_68 = tmpvar_11.z;
  highp vec3 uv_69;
  highp vec3 tmpvar_70;
  tmpvar_70.xy = (tmpvar_14 + tmpvar_67);
  tmpvar_70.z = depth_68;
  uv_69.xy = tmpvar_70.xy;
  uv_69.z = depth_68;
  lowp float tmpvar_71;
  tmpvar_71 = shadow2DEXT (_ShadowMapTexture, uv_69);
  mediump float tmpvar_72;
  tmpvar_72 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_55 + (accum_12.x * tmpvar_61)) + (accum_12.y * tmpvar_66))
   + 
    (accum_12.z * tmpvar_71)
  ) / 144.0));
  highp float tmpvar_73;
  tmpvar_73 = (tmpvar_72 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_73;
  mediump vec4 tmpvar_74;
  tmpvar_74 = vec4(shadow_2);
  tmpvar_1 = tmpvar_74;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (tmpvar_5.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (tmpvar_5.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump vec3 accum_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = ((tmpvar_11.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_14;
  tmpvar_14 = ((floor(tmpvar_13) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_15;
  tmpvar_15 = fract(tmpvar_13);
  highp vec3 tmpvar_16;
  tmpvar_16.y = 7.0;
  tmpvar_16.x = (4.0 - (3.0 * tmpvar_15.x));
  tmpvar_16.z = (1.0 + (3.0 * tmpvar_15.x));
  highp vec3 tmpvar_17;
  tmpvar_17.x = (((3.0 - 
    (2.0 * tmpvar_15.x)
  ) / tmpvar_16.x) - 2.0);
  tmpvar_17.y = ((3.0 + tmpvar_15.x) / 7.0);
  tmpvar_17.z = ((tmpvar_15.x / tmpvar_16.z) + 2.0);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.y = 7.0;
  tmpvar_19.x = (4.0 - (3.0 * tmpvar_15.y));
  tmpvar_19.z = (1.0 + (3.0 * tmpvar_15.y));
  highp vec3 tmpvar_20;
  tmpvar_20.x = (((3.0 - 
    (2.0 * tmpvar_15.y)
  ) / tmpvar_19.x) - 2.0);
  tmpvar_20.y = ((3.0 + tmpvar_15.y) / 7.0);
  tmpvar_20.z = ((tmpvar_15.y / tmpvar_19.z) + 2.0);
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_16 * tmpvar_19.x);
  accum_12 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_18.x;
  tmpvar_23.y = tmpvar_21.x;
  highp float depth_24;
  depth_24 = tmpvar_11.z;
  highp vec3 uv_25;
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_14 + tmpvar_23);
  tmpvar_26.z = depth_24;
  uv_25.xy = tmpvar_26.xy;
  uv_25.z = depth_24;
  mediump float tmpvar_27;
  tmpvar_27 = texture (_ShadowMapTexture, uv_25);
  highp vec2 tmpvar_28;
  tmpvar_28.x = tmpvar_18.y;
  tmpvar_28.y = tmpvar_21.x;
  highp float depth_29;
  depth_29 = tmpvar_11.z;
  highp vec3 uv_30;
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_14 + tmpvar_28);
  tmpvar_31.z = depth_29;
  uv_30.xy = tmpvar_31.xy;
  uv_30.z = depth_29;
  mediump float tmpvar_32;
  tmpvar_32 = texture (_ShadowMapTexture, uv_30);
  highp vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_18.z;
  tmpvar_33.y = tmpvar_21.x;
  highp float depth_34;
  depth_34 = tmpvar_11.z;
  highp vec3 uv_35;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_14 + tmpvar_33);
  tmpvar_36.z = depth_34;
  uv_35.xy = tmpvar_36.xy;
  uv_35.z = depth_34;
  mediump float tmpvar_37;
  tmpvar_37 = texture (_ShadowMapTexture, uv_35);
  mediump float tmpvar_38;
  tmpvar_38 = (((accum_12.x * tmpvar_27) + (accum_12.y * tmpvar_32)) + (accum_12.z * tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = (tmpvar_16 * 7.0);
  accum_12 = tmpvar_39;
  highp vec2 tmpvar_40;
  tmpvar_40.x = tmpvar_18.x;
  tmpvar_40.y = tmpvar_21.y;
  highp float depth_41;
  depth_41 = tmpvar_11.z;
  highp vec3 uv_42;
  highp vec3 tmpvar_43;
  tmpvar_43.xy = (tmpvar_14 + tmpvar_40);
  tmpvar_43.z = depth_41;
  uv_42.xy = tmpvar_43.xy;
  uv_42.z = depth_41;
  mediump float tmpvar_44;
  tmpvar_44 = texture (_ShadowMapTexture, uv_42);
  highp vec2 tmpvar_45;
  tmpvar_45.x = tmpvar_18.y;
  tmpvar_45.y = tmpvar_21.y;
  highp float depth_46;
  depth_46 = tmpvar_11.z;
  highp vec3 uv_47;
  highp vec3 tmpvar_48;
  tmpvar_48.xy = (tmpvar_14 + tmpvar_45);
  tmpvar_48.z = depth_46;
  uv_47.xy = tmpvar_48.xy;
  uv_47.z = depth_46;
  mediump float tmpvar_49;
  tmpvar_49 = texture (_ShadowMapTexture, uv_47);
  highp vec2 tmpvar_50;
  tmpvar_50.x = tmpvar_18.z;
  tmpvar_50.y = tmpvar_21.y;
  highp float depth_51;
  depth_51 = tmpvar_11.z;
  highp vec3 uv_52;
  highp vec3 tmpvar_53;
  tmpvar_53.xy = (tmpvar_14 + tmpvar_50);
  tmpvar_53.z = depth_51;
  uv_52.xy = tmpvar_53.xy;
  uv_52.z = depth_51;
  mediump float tmpvar_54;
  tmpvar_54 = texture (_ShadowMapTexture, uv_52);
  mediump float tmpvar_55;
  tmpvar_55 = (((tmpvar_38 + 
    (accum_12.x * tmpvar_44)
  ) + (accum_12.y * tmpvar_49)) + (accum_12.z * tmpvar_54));
  highp vec3 tmpvar_56;
  tmpvar_56 = (tmpvar_16 * tmpvar_19.z);
  accum_12 = tmpvar_56;
  highp vec2 tmpvar_57;
  tmpvar_57.x = tmpvar_18.x;
  tmpvar_57.y = tmpvar_21.z;
  highp float depth_58;
  depth_58 = tmpvar_11.z;
  highp vec3 uv_59;
  highp vec3 tmpvar_60;
  tmpvar_60.xy = (tmpvar_14 + tmpvar_57);
  tmpvar_60.z = depth_58;
  uv_59.xy = tmpvar_60.xy;
  uv_59.z = depth_58;
  mediump float tmpvar_61;
  tmpvar_61 = texture (_ShadowMapTexture, uv_59);
  highp vec2 tmpvar_62;
  tmpvar_62.x = tmpvar_18.y;
  tmpvar_62.y = tmpvar_21.z;
  highp float depth_63;
  depth_63 = tmpvar_11.z;
  highp vec3 uv_64;
  highp vec3 tmpvar_65;
  tmpvar_65.xy = (tmpvar_14 + tmpvar_62);
  tmpvar_65.z = depth_63;
  uv_64.xy = tmpvar_65.xy;
  uv_64.z = depth_63;
  mediump float tmpvar_66;
  tmpvar_66 = texture (_ShadowMapTexture, uv_64);
  highp vec2 tmpvar_67;
  tmpvar_67.x = tmpvar_18.z;
  tmpvar_67.y = tmpvar_21.z;
  highp float depth_68;
  depth_68 = tmpvar_11.z;
  highp vec3 uv_69;
  highp vec3 tmpvar_70;
  tmpvar_70.xy = (tmpvar_14 + tmpvar_67);
  tmpvar_70.z = depth_68;
  uv_69.xy = tmpvar_70.xy;
  uv_69.z = depth_68;
  mediump float tmpvar_71;
  tmpvar_71 = texture (_ShadowMapTexture, uv_69);
  mediump float tmpvar_72;
  tmpvar_72 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_55 + (accum_12.x * tmpvar_61)) + (accum_12.y * tmpvar_66))
   + 
    (accum_12.z * tmpvar_71)
  ) / 144.0));
  highp float tmpvar_73;
  tmpvar_73 = (tmpvar_72 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_73;
  mediump vec4 tmpvar_74;
  tmpvar_74 = vec4(shadow_2);
  tmpvar_1 = tmpvar_74;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  highp vec2 tmpvar_16;
  tmpvar_16 = _ShadowMapTexture_TexelSize.xy;
  highp vec3 tmpvar_17;
  tmpvar_17.xy = (tmpvar_15.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_17.z = tmpvar_15.z;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_ShadowMapTexture, tmpvar_17.xy);
  mediump float tmpvar_19;
  if ((tmpvar_18.x < tmpvar_15.z)) {
    tmpvar_19 = 0.0;
  } else {
    tmpvar_19 = 1.0;
  };
  highp vec2 tmpvar_20;
  tmpvar_20.x = 0.0;
  tmpvar_20.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_21;
  tmpvar_21.xy = (tmpvar_15.xy + tmpvar_20);
  tmpvar_21.z = tmpvar_15.z;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_21.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_15.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_19 + tmpvar_23);
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_16.x;
  tmpvar_25.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_15.xy + tmpvar_25);
  tmpvar_26.z = tmpvar_15.z;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_26.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_15.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_24 + tmpvar_28);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_15.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_15.z;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_15.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  tmpvar_34 = (tmpvar_29 + tmpvar_33);
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_15.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  tmpvar_37 = (tmpvar_34 + tmpvar_36);
  highp vec2 tmpvar_38;
  tmpvar_38.y = 0.0;
  tmpvar_38.x = tmpvar_16.x;
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_15.xy + tmpvar_38);
  tmpvar_39.z = tmpvar_15.z;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_15.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  mediump float tmpvar_42;
  tmpvar_42 = (tmpvar_37 + tmpvar_41);
  highp vec2 tmpvar_43;
  tmpvar_43.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_43.y = tmpvar_16.y;
  highp vec3 tmpvar_44;
  tmpvar_44.xy = (tmpvar_15.xy + tmpvar_43);
  tmpvar_44.z = tmpvar_15.z;
  lowp vec4 tmpvar_45;
  tmpvar_45 = texture2D (_ShadowMapTexture, tmpvar_44.xy);
  highp float tmpvar_46;
  if ((tmpvar_45.x < tmpvar_15.z)) {
    tmpvar_46 = 0.0;
  } else {
    tmpvar_46 = 1.0;
  };
  mediump float tmpvar_47;
  tmpvar_47 = (tmpvar_42 + tmpvar_46);
  highp vec2 tmpvar_48;
  tmpvar_48.x = 0.0;
  tmpvar_48.y = tmpvar_16.y;
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_15.xy + tmpvar_48);
  tmpvar_49.z = tmpvar_15.z;
  lowp vec4 tmpvar_50;
  tmpvar_50 = texture2D (_ShadowMapTexture, tmpvar_49.xy);
  highp float tmpvar_51;
  if ((tmpvar_50.x < tmpvar_15.z)) {
    tmpvar_51 = 0.0;
  } else {
    tmpvar_51 = 1.0;
  };
  mediump float tmpvar_52;
  tmpvar_52 = (tmpvar_47 + tmpvar_51);
  highp vec3 tmpvar_53;
  tmpvar_53.xy = (tmpvar_15.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_53.z = tmpvar_15.z;
  lowp vec4 tmpvar_54;
  tmpvar_54 = texture2D (_ShadowMapTexture, tmpvar_53.xy);
  highp float tmpvar_55;
  if ((tmpvar_54.x < tmpvar_15.z)) {
    tmpvar_55 = 0.0;
  } else {
    tmpvar_55 = 1.0;
  };
  mediump float tmpvar_56;
  tmpvar_56 = mix (_LightShadowData.x, 1.0, ((tmpvar_52 + tmpvar_55) / 9.0));
  highp float tmpvar_57;
  highp vec3 tmpvar_58;
  tmpvar_58 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_59;
  highp float tmpvar_60;
  tmpvar_60 = clamp (((
    sqrt(dot (tmpvar_58, tmpvar_58))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_59 = tmpvar_60;
  tmpvar_57 = tmpvar_59;
  highp float tmpvar_61;
  tmpvar_61 = (tmpvar_56 + tmpvar_57);
  shadow_2 = tmpvar_61;
  mediump vec4 tmpvar_62;
  tmpvar_62 = vec4(shadow_2);
  tmpvar_1 = tmpvar_62;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  mediump vec3 accum_16;
  highp vec2 tmpvar_17;
  tmpvar_17 = ((tmpvar_15.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_18;
  tmpvar_18 = ((floor(tmpvar_17) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_19;
  tmpvar_19 = fract(tmpvar_17);
  highp vec3 tmpvar_20;
  tmpvar_20.y = 7.0;
  tmpvar_20.x = (4.0 - (3.0 * tmpvar_19.x));
  tmpvar_20.z = (1.0 + (3.0 * tmpvar_19.x));
  highp vec3 tmpvar_21;
  tmpvar_21.x = (((3.0 - 
    (2.0 * tmpvar_19.x)
  ) / tmpvar_20.x) - 2.0);
  tmpvar_21.y = ((3.0 + tmpvar_19.x) / 7.0);
  tmpvar_21.z = ((tmpvar_19.x / tmpvar_20.z) + 2.0);
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_23;
  tmpvar_23.y = 7.0;
  tmpvar_23.x = (4.0 - (3.0 * tmpvar_19.y));
  tmpvar_23.z = (1.0 + (3.0 * tmpvar_19.y));
  highp vec3 tmpvar_24;
  tmpvar_24.x = (((3.0 - 
    (2.0 * tmpvar_19.y)
  ) / tmpvar_23.x) - 2.0);
  tmpvar_24.y = ((3.0 + tmpvar_19.y) / 7.0);
  tmpvar_24.z = ((tmpvar_19.y / tmpvar_23.z) + 2.0);
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_20 * tmpvar_23.x);
  accum_16 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_22.x;
  tmpvar_27.y = tmpvar_25.x;
  highp float depth_28;
  depth_28 = tmpvar_15.z;
  highp vec3 uv_29;
  highp vec3 tmpvar_30;
  tmpvar_30.xy = (tmpvar_18 + tmpvar_27);
  tmpvar_30.z = depth_28;
  uv_29.xy = tmpvar_30.xy;
  uv_29.z = depth_28;
  lowp float tmpvar_31;
  tmpvar_31 = shadow2DEXT (_ShadowMapTexture, uv_29);
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_22.y;
  tmpvar_32.y = tmpvar_25.x;
  highp float depth_33;
  depth_33 = tmpvar_15.z;
  highp vec3 uv_34;
  highp vec3 tmpvar_35;
  tmpvar_35.xy = (tmpvar_18 + tmpvar_32);
  tmpvar_35.z = depth_33;
  uv_34.xy = tmpvar_35.xy;
  uv_34.z = depth_33;
  lowp float tmpvar_36;
  tmpvar_36 = shadow2DEXT (_ShadowMapTexture, uv_34);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_22.z;
  tmpvar_37.y = tmpvar_25.x;
  highp float depth_38;
  depth_38 = tmpvar_15.z;
  highp vec3 uv_39;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_18 + tmpvar_37);
  tmpvar_40.z = depth_38;
  uv_39.xy = tmpvar_40.xy;
  uv_39.z = depth_38;
  lowp float tmpvar_41;
  tmpvar_41 = shadow2DEXT (_ShadowMapTexture, uv_39);
  mediump float tmpvar_42;
  tmpvar_42 = (((accum_16.x * tmpvar_31) + (accum_16.y * tmpvar_36)) + (accum_16.z * tmpvar_41));
  highp vec3 tmpvar_43;
  tmpvar_43 = (tmpvar_20 * 7.0);
  accum_16 = tmpvar_43;
  highp vec2 tmpvar_44;
  tmpvar_44.x = tmpvar_22.x;
  tmpvar_44.y = tmpvar_25.y;
  highp float depth_45;
  depth_45 = tmpvar_15.z;
  highp vec3 uv_46;
  highp vec3 tmpvar_47;
  tmpvar_47.xy = (tmpvar_18 + tmpvar_44);
  tmpvar_47.z = depth_45;
  uv_46.xy = tmpvar_47.xy;
  uv_46.z = depth_45;
  lowp float tmpvar_48;
  tmpvar_48 = shadow2DEXT (_ShadowMapTexture, uv_46);
  highp vec2 tmpvar_49;
  tmpvar_49.x = tmpvar_22.y;
  tmpvar_49.y = tmpvar_25.y;
  highp float depth_50;
  depth_50 = tmpvar_15.z;
  highp vec3 uv_51;
  highp vec3 tmpvar_52;
  tmpvar_52.xy = (tmpvar_18 + tmpvar_49);
  tmpvar_52.z = depth_50;
  uv_51.xy = tmpvar_52.xy;
  uv_51.z = depth_50;
  lowp float tmpvar_53;
  tmpvar_53 = shadow2DEXT (_ShadowMapTexture, uv_51);
  highp vec2 tmpvar_54;
  tmpvar_54.x = tmpvar_22.z;
  tmpvar_54.y = tmpvar_25.y;
  highp float depth_55;
  depth_55 = tmpvar_15.z;
  highp vec3 uv_56;
  highp vec3 tmpvar_57;
  tmpvar_57.xy = (tmpvar_18 + tmpvar_54);
  tmpvar_57.z = depth_55;
  uv_56.xy = tmpvar_57.xy;
  uv_56.z = depth_55;
  lowp float tmpvar_58;
  tmpvar_58 = shadow2DEXT (_ShadowMapTexture, uv_56);
  mediump float tmpvar_59;
  tmpvar_59 = (((tmpvar_42 + 
    (accum_16.x * tmpvar_48)
  ) + (accum_16.y * tmpvar_53)) + (accum_16.z * tmpvar_58));
  highp vec3 tmpvar_60;
  tmpvar_60 = (tmpvar_20 * tmpvar_23.z);
  accum_16 = tmpvar_60;
  highp vec2 tmpvar_61;
  tmpvar_61.x = tmpvar_22.x;
  tmpvar_61.y = tmpvar_25.z;
  highp float depth_62;
  depth_62 = tmpvar_15.z;
  highp vec3 uv_63;
  highp vec3 tmpvar_64;
  tmpvar_64.xy = (tmpvar_18 + tmpvar_61);
  tmpvar_64.z = depth_62;
  uv_63.xy = tmpvar_64.xy;
  uv_63.z = depth_62;
  lowp float tmpvar_65;
  tmpvar_65 = shadow2DEXT (_ShadowMapTexture, uv_63);
  highp vec2 tmpvar_66;
  tmpvar_66.x = tmpvar_22.y;
  tmpvar_66.y = tmpvar_25.z;
  highp float depth_67;
  depth_67 = tmpvar_15.z;
  highp vec3 uv_68;
  highp vec3 tmpvar_69;
  tmpvar_69.xy = (tmpvar_18 + tmpvar_66);
  tmpvar_69.z = depth_67;
  uv_68.xy = tmpvar_69.xy;
  uv_68.z = depth_67;
  lowp float tmpvar_70;
  tmpvar_70 = shadow2DEXT (_ShadowMapTexture, uv_68);
  highp vec2 tmpvar_71;
  tmpvar_71.x = tmpvar_22.z;
  tmpvar_71.y = tmpvar_25.z;
  highp float depth_72;
  depth_72 = tmpvar_15.z;
  highp vec3 uv_73;
  highp vec3 tmpvar_74;
  tmpvar_74.xy = (tmpvar_18 + tmpvar_71);
  tmpvar_74.z = depth_72;
  uv_73.xy = tmpvar_74.xy;
  uv_73.z = depth_72;
  lowp float tmpvar_75;
  tmpvar_75 = shadow2DEXT (_ShadowMapTexture, uv_73);
  mediump float tmpvar_76;
  tmpvar_76 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_59 + (accum_16.x * tmpvar_65)) + (accum_16.y * tmpvar_70))
   + 
    (accum_16.z * tmpvar_75)
  ) / 144.0));
  highp float tmpvar_77;
  highp vec3 tmpvar_78;
  tmpvar_78 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_79;
  highp float tmpvar_80;
  tmpvar_80 = clamp (((
    sqrt(dot (tmpvar_78, tmpvar_78))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_79 = tmpvar_80;
  tmpvar_77 = tmpvar_79;
  highp float tmpvar_81;
  tmpvar_81 = (tmpvar_76 + tmpvar_77);
  shadow_2 = tmpvar_81;
  mediump vec4 tmpvar_82;
  tmpvar_82 = vec4(shadow_2);
  tmpvar_1 = tmpvar_82;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  lowp vec4 weights_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_6.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_8, tmpvar_8);
  tmpvar_12.y = dot (tmpvar_9, tmpvar_9);
  tmpvar_12.z = dot (tmpvar_10, tmpvar_10);
  tmpvar_12.w = dot (tmpvar_11, tmpvar_11);
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_12, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  weights_7.x = tmpvar_14.x;
  weights_7.yzw = clamp ((tmpvar_14.yzw - tmpvar_14.xyz), 0.0, 1.0);
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = (((
    ((unity_World2Shadow[0] * tmpvar_6).xyz * tmpvar_14.x)
   + 
    ((unity_World2Shadow[1] * tmpvar_6).xyz * weights_7.y)
  ) + (
    (unity_World2Shadow[2] * tmpvar_6)
  .xyz * weights_7.z)) + ((unity_World2Shadow[3] * tmpvar_6).xyz * weights_7.w));
  mediump vec3 accum_16;
  highp vec2 tmpvar_17;
  tmpvar_17 = ((tmpvar_15.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_18;
  tmpvar_18 = ((floor(tmpvar_17) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_19;
  tmpvar_19 = fract(tmpvar_17);
  highp vec3 tmpvar_20;
  tmpvar_20.y = 7.0;
  tmpvar_20.x = (4.0 - (3.0 * tmpvar_19.x));
  tmpvar_20.z = (1.0 + (3.0 * tmpvar_19.x));
  highp vec3 tmpvar_21;
  tmpvar_21.x = (((3.0 - 
    (2.0 * tmpvar_19.x)
  ) / tmpvar_20.x) - 2.0);
  tmpvar_21.y = ((3.0 + tmpvar_19.x) / 7.0);
  tmpvar_21.z = ((tmpvar_19.x / tmpvar_20.z) + 2.0);
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_23;
  tmpvar_23.y = 7.0;
  tmpvar_23.x = (4.0 - (3.0 * tmpvar_19.y));
  tmpvar_23.z = (1.0 + (3.0 * tmpvar_19.y));
  highp vec3 tmpvar_24;
  tmpvar_24.x = (((3.0 - 
    (2.0 * tmpvar_19.y)
  ) / tmpvar_23.x) - 2.0);
  tmpvar_24.y = ((3.0 + tmpvar_19.y) / 7.0);
  tmpvar_24.z = ((tmpvar_19.y / tmpvar_23.z) + 2.0);
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_20 * tmpvar_23.x);
  accum_16 = tmpvar_26;
  highp vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_22.x;
  tmpvar_27.y = tmpvar_25.x;
  highp float depth_28;
  depth_28 = tmpvar_15.z;
  highp vec3 uv_29;
  highp vec3 tmpvar_30;
  tmpvar_30.xy = (tmpvar_18 + tmpvar_27);
  tmpvar_30.z = depth_28;
  uv_29.xy = tmpvar_30.xy;
  uv_29.z = depth_28;
  mediump float tmpvar_31;
  tmpvar_31 = texture (_ShadowMapTexture, uv_29);
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_22.y;
  tmpvar_32.y = tmpvar_25.x;
  highp float depth_33;
  depth_33 = tmpvar_15.z;
  highp vec3 uv_34;
  highp vec3 tmpvar_35;
  tmpvar_35.xy = (tmpvar_18 + tmpvar_32);
  tmpvar_35.z = depth_33;
  uv_34.xy = tmpvar_35.xy;
  uv_34.z = depth_33;
  mediump float tmpvar_36;
  tmpvar_36 = texture (_ShadowMapTexture, uv_34);
  highp vec2 tmpvar_37;
  tmpvar_37.x = tmpvar_22.z;
  tmpvar_37.y = tmpvar_25.x;
  highp float depth_38;
  depth_38 = tmpvar_15.z;
  highp vec3 uv_39;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_18 + tmpvar_37);
  tmpvar_40.z = depth_38;
  uv_39.xy = tmpvar_40.xy;
  uv_39.z = depth_38;
  mediump float tmpvar_41;
  tmpvar_41 = texture (_ShadowMapTexture, uv_39);
  mediump float tmpvar_42;
  tmpvar_42 = (((accum_16.x * tmpvar_31) + (accum_16.y * tmpvar_36)) + (accum_16.z * tmpvar_41));
  highp vec3 tmpvar_43;
  tmpvar_43 = (tmpvar_20 * 7.0);
  accum_16 = tmpvar_43;
  highp vec2 tmpvar_44;
  tmpvar_44.x = tmpvar_22.x;
  tmpvar_44.y = tmpvar_25.y;
  highp float depth_45;
  depth_45 = tmpvar_15.z;
  highp vec3 uv_46;
  highp vec3 tmpvar_47;
  tmpvar_47.xy = (tmpvar_18 + tmpvar_44);
  tmpvar_47.z = depth_45;
  uv_46.xy = tmpvar_47.xy;
  uv_46.z = depth_45;
  mediump float tmpvar_48;
  tmpvar_48 = texture (_ShadowMapTexture, uv_46);
  highp vec2 tmpvar_49;
  tmpvar_49.x = tmpvar_22.y;
  tmpvar_49.y = tmpvar_25.y;
  highp float depth_50;
  depth_50 = tmpvar_15.z;
  highp vec3 uv_51;
  highp vec3 tmpvar_52;
  tmpvar_52.xy = (tmpvar_18 + tmpvar_49);
  tmpvar_52.z = depth_50;
  uv_51.xy = tmpvar_52.xy;
  uv_51.z = depth_50;
  mediump float tmpvar_53;
  tmpvar_53 = texture (_ShadowMapTexture, uv_51);
  highp vec2 tmpvar_54;
  tmpvar_54.x = tmpvar_22.z;
  tmpvar_54.y = tmpvar_25.y;
  highp float depth_55;
  depth_55 = tmpvar_15.z;
  highp vec3 uv_56;
  highp vec3 tmpvar_57;
  tmpvar_57.xy = (tmpvar_18 + tmpvar_54);
  tmpvar_57.z = depth_55;
  uv_56.xy = tmpvar_57.xy;
  uv_56.z = depth_55;
  mediump float tmpvar_58;
  tmpvar_58 = texture (_ShadowMapTexture, uv_56);
  mediump float tmpvar_59;
  tmpvar_59 = (((tmpvar_42 + 
    (accum_16.x * tmpvar_48)
  ) + (accum_16.y * tmpvar_53)) + (accum_16.z * tmpvar_58));
  highp vec3 tmpvar_60;
  tmpvar_60 = (tmpvar_20 * tmpvar_23.z);
  accum_16 = tmpvar_60;
  highp vec2 tmpvar_61;
  tmpvar_61.x = tmpvar_22.x;
  tmpvar_61.y = tmpvar_25.z;
  highp float depth_62;
  depth_62 = tmpvar_15.z;
  highp vec3 uv_63;
  highp vec3 tmpvar_64;
  tmpvar_64.xy = (tmpvar_18 + tmpvar_61);
  tmpvar_64.z = depth_62;
  uv_63.xy = tmpvar_64.xy;
  uv_63.z = depth_62;
  mediump float tmpvar_65;
  tmpvar_65 = texture (_ShadowMapTexture, uv_63);
  highp vec2 tmpvar_66;
  tmpvar_66.x = tmpvar_22.y;
  tmpvar_66.y = tmpvar_25.z;
  highp float depth_67;
  depth_67 = tmpvar_15.z;
  highp vec3 uv_68;
  highp vec3 tmpvar_69;
  tmpvar_69.xy = (tmpvar_18 + tmpvar_66);
  tmpvar_69.z = depth_67;
  uv_68.xy = tmpvar_69.xy;
  uv_68.z = depth_67;
  mediump float tmpvar_70;
  tmpvar_70 = texture (_ShadowMapTexture, uv_68);
  highp vec2 tmpvar_71;
  tmpvar_71.x = tmpvar_22.z;
  tmpvar_71.y = tmpvar_25.z;
  highp float depth_72;
  depth_72 = tmpvar_15.z;
  highp vec3 uv_73;
  highp vec3 tmpvar_74;
  tmpvar_74.xy = (tmpvar_18 + tmpvar_71);
  tmpvar_74.z = depth_72;
  uv_73.xy = tmpvar_74.xy;
  uv_73.z = depth_72;
  mediump float tmpvar_75;
  tmpvar_75 = texture (_ShadowMapTexture, uv_73);
  mediump float tmpvar_76;
  tmpvar_76 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_59 + (accum_16.x * tmpvar_65)) + (accum_16.y * tmpvar_70))
   + 
    (accum_16.z * tmpvar_75)
  ) / 144.0));
  highp float tmpvar_77;
  highp vec3 tmpvar_78;
  tmpvar_78 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_79;
  highp float tmpvar_80;
  tmpvar_80 = clamp (((
    sqrt(dot (tmpvar_78, tmpvar_78))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_79 = tmpvar_80;
  tmpvar_77 = tmpvar_79;
  highp float tmpvar_81;
  tmpvar_81 = (tmpvar_76 + tmpvar_77);
  shadow_2 = tmpvar_81;
  mediump vec4 tmpvar_82;
  tmpvar_82 = vec4(shadow_2);
  tmpvar_1 = tmpvar_82;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  highp vec2 tmpvar_8;
  tmpvar_8 = _ShadowMapTexture_TexelSize.xy;
  highp vec3 tmpvar_9;
  tmpvar_9.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_9.z = tmpvar_7.z;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  mediump float tmpvar_11;
  if ((tmpvar_10.x < tmpvar_7.z)) {
    tmpvar_11 = 0.0;
  } else {
    tmpvar_11 = 1.0;
  };
  highp vec2 tmpvar_12;
  tmpvar_12.x = 0.0;
  tmpvar_12.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_13;
  tmpvar_13.xy = (tmpvar_7.xy + tmpvar_12);
  tmpvar_13.z = tmpvar_7.z;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  highp float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_7.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  mediump float tmpvar_16;
  tmpvar_16 = (tmpvar_11 + tmpvar_15);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_8.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_16 + tmpvar_20);
  highp vec2 tmpvar_22;
  tmpvar_22.y = 0.0;
  tmpvar_22.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_23;
  tmpvar_23.xy = (tmpvar_7.xy + tmpvar_22);
  tmpvar_23.z = tmpvar_7.z;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_ShadowMapTexture, tmpvar_23.xy);
  highp float tmpvar_25;
  if ((tmpvar_24.x < tmpvar_7.z)) {
    tmpvar_25 = 0.0;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_21 + tmpvar_25);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_7.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_26 + tmpvar_28);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = tmpvar_8.x;
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_7.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_7.z;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_7.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  tmpvar_34 = (tmpvar_29 + tmpvar_33);
  highp vec2 tmpvar_35;
  tmpvar_35.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_35.y = tmpvar_8.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_34 + tmpvar_38);
  highp vec2 tmpvar_40;
  tmpvar_40.x = 0.0;
  tmpvar_40.y = tmpvar_8.y;
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_7.xy + tmpvar_40);
  tmpvar_41.z = tmpvar_7.z;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_7.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  mediump float tmpvar_44;
  tmpvar_44 = (tmpvar_39 + tmpvar_43);
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_45.z = tmpvar_7.z;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_7.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  mediump float tmpvar_48;
  tmpvar_48 = mix (_LightShadowData.x, 1.0, ((tmpvar_44 + tmpvar_47) / 9.0));
  highp float tmpvar_49;
  tmpvar_49 = (tmpvar_48 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_49;
  mediump vec4 tmpvar_50;
  tmpvar_50 = vec4(shadow_2);
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  mediump vec3 accum_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((tmpvar_7.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_10;
  tmpvar_10 = ((floor(tmpvar_9) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_11;
  tmpvar_11 = fract(tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12.y = 7.0;
  tmpvar_12.x = (4.0 - (3.0 * tmpvar_11.x));
  tmpvar_12.z = (1.0 + (3.0 * tmpvar_11.x));
  highp vec3 tmpvar_13;
  tmpvar_13.x = (((3.0 - 
    (2.0 * tmpvar_11.x)
  ) / tmpvar_12.x) - 2.0);
  tmpvar_13.y = ((3.0 + tmpvar_11.x) / 7.0);
  tmpvar_13.z = ((tmpvar_11.x / tmpvar_12.z) + 2.0);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_15;
  tmpvar_15.y = 7.0;
  tmpvar_15.x = (4.0 - (3.0 * tmpvar_11.y));
  tmpvar_15.z = (1.0 + (3.0 * tmpvar_11.y));
  highp vec3 tmpvar_16;
  tmpvar_16.x = (((3.0 - 
    (2.0 * tmpvar_11.y)
  ) / tmpvar_15.x) - 2.0);
  tmpvar_16.y = ((3.0 + tmpvar_11.y) / 7.0);
  tmpvar_16.z = ((tmpvar_11.y / tmpvar_15.z) + 2.0);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_12 * tmpvar_15.x);
  accum_8 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_14.x;
  tmpvar_19.y = tmpvar_17.x;
  highp float depth_20;
  depth_20 = tmpvar_7.z;
  highp vec3 uv_21;
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_10 + tmpvar_19);
  tmpvar_22.z = depth_20;
  uv_21.xy = tmpvar_22.xy;
  uv_21.z = depth_20;
  lowp float tmpvar_23;
  tmpvar_23 = shadow2DEXT (_ShadowMapTexture, uv_21);
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_14.y;
  tmpvar_24.y = tmpvar_17.x;
  highp float depth_25;
  depth_25 = tmpvar_7.z;
  highp vec3 uv_26;
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_10 + tmpvar_24);
  tmpvar_27.z = depth_25;
  uv_26.xy = tmpvar_27.xy;
  uv_26.z = depth_25;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, uv_26);
  highp vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_14.z;
  tmpvar_29.y = tmpvar_17.x;
  highp float depth_30;
  depth_30 = tmpvar_7.z;
  highp vec3 uv_31;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_10 + tmpvar_29);
  tmpvar_32.z = depth_30;
  uv_31.xy = tmpvar_32.xy;
  uv_31.z = depth_30;
  lowp float tmpvar_33;
  tmpvar_33 = shadow2DEXT (_ShadowMapTexture, uv_31);
  mediump float tmpvar_34;
  tmpvar_34 = (((accum_8.x * tmpvar_23) + (accum_8.y * tmpvar_28)) + (accum_8.z * tmpvar_33));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * 7.0);
  accum_8 = tmpvar_35;
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_14.x;
  tmpvar_36.y = tmpvar_17.y;
  highp float depth_37;
  depth_37 = tmpvar_7.z;
  highp vec3 uv_38;
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_10 + tmpvar_36);
  tmpvar_39.z = depth_37;
  uv_38.xy = tmpvar_39.xy;
  uv_38.z = depth_37;
  lowp float tmpvar_40;
  tmpvar_40 = shadow2DEXT (_ShadowMapTexture, uv_38);
  highp vec2 tmpvar_41;
  tmpvar_41.x = tmpvar_14.y;
  tmpvar_41.y = tmpvar_17.y;
  highp float depth_42;
  depth_42 = tmpvar_7.z;
  highp vec3 uv_43;
  highp vec3 tmpvar_44;
  tmpvar_44.xy = (tmpvar_10 + tmpvar_41);
  tmpvar_44.z = depth_42;
  uv_43.xy = tmpvar_44.xy;
  uv_43.z = depth_42;
  lowp float tmpvar_45;
  tmpvar_45 = shadow2DEXT (_ShadowMapTexture, uv_43);
  highp vec2 tmpvar_46;
  tmpvar_46.x = tmpvar_14.z;
  tmpvar_46.y = tmpvar_17.y;
  highp float depth_47;
  depth_47 = tmpvar_7.z;
  highp vec3 uv_48;
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_10 + tmpvar_46);
  tmpvar_49.z = depth_47;
  uv_48.xy = tmpvar_49.xy;
  uv_48.z = depth_47;
  lowp float tmpvar_50;
  tmpvar_50 = shadow2DEXT (_ShadowMapTexture, uv_48);
  mediump float tmpvar_51;
  tmpvar_51 = (((tmpvar_34 + 
    (accum_8.x * tmpvar_40)
  ) + (accum_8.y * tmpvar_45)) + (accum_8.z * tmpvar_50));
  highp vec3 tmpvar_52;
  tmpvar_52 = (tmpvar_12 * tmpvar_15.z);
  accum_8 = tmpvar_52;
  highp vec2 tmpvar_53;
  tmpvar_53.x = tmpvar_14.x;
  tmpvar_53.y = tmpvar_17.z;
  highp float depth_54;
  depth_54 = tmpvar_7.z;
  highp vec3 uv_55;
  highp vec3 tmpvar_56;
  tmpvar_56.xy = (tmpvar_10 + tmpvar_53);
  tmpvar_56.z = depth_54;
  uv_55.xy = tmpvar_56.xy;
  uv_55.z = depth_54;
  lowp float tmpvar_57;
  tmpvar_57 = shadow2DEXT (_ShadowMapTexture, uv_55);
  highp vec2 tmpvar_58;
  tmpvar_58.x = tmpvar_14.y;
  tmpvar_58.y = tmpvar_17.z;
  highp float depth_59;
  depth_59 = tmpvar_7.z;
  highp vec3 uv_60;
  highp vec3 tmpvar_61;
  tmpvar_61.xy = (tmpvar_10 + tmpvar_58);
  tmpvar_61.z = depth_59;
  uv_60.xy = tmpvar_61.xy;
  uv_60.z = depth_59;
  lowp float tmpvar_62;
  tmpvar_62 = shadow2DEXT (_ShadowMapTexture, uv_60);
  highp vec2 tmpvar_63;
  tmpvar_63.x = tmpvar_14.z;
  tmpvar_63.y = tmpvar_17.z;
  highp float depth_64;
  depth_64 = tmpvar_7.z;
  highp vec3 uv_65;
  highp vec3 tmpvar_66;
  tmpvar_66.xy = (tmpvar_10 + tmpvar_63);
  tmpvar_66.z = depth_64;
  uv_65.xy = tmpvar_66.xy;
  uv_65.z = depth_64;
  lowp float tmpvar_67;
  tmpvar_67 = shadow2DEXT (_ShadowMapTexture, uv_65);
  mediump float tmpvar_68;
  tmpvar_68 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_51 + (accum_8.x * tmpvar_57)) + (accum_8.y * tmpvar_62))
   + 
    (accum_8.z * tmpvar_67)
  ) / 144.0));
  highp float tmpvar_69;
  tmpvar_69 = (tmpvar_68 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_69;
  mediump vec4 tmpvar_70;
  tmpvar_70 = vec4(shadow_2);
  tmpvar_1 = tmpvar_70;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec3 tmpvar_5;
  tmpvar_5 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * (_CameraToWorld * tmpvar_6)).xyz;
  mediump vec3 accum_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((tmpvar_7.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_10;
  tmpvar_10 = ((floor(tmpvar_9) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_11;
  tmpvar_11 = fract(tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12.y = 7.0;
  tmpvar_12.x = (4.0 - (3.0 * tmpvar_11.x));
  tmpvar_12.z = (1.0 + (3.0 * tmpvar_11.x));
  highp vec3 tmpvar_13;
  tmpvar_13.x = (((3.0 - 
    (2.0 * tmpvar_11.x)
  ) / tmpvar_12.x) - 2.0);
  tmpvar_13.y = ((3.0 + tmpvar_11.x) / 7.0);
  tmpvar_13.z = ((tmpvar_11.x / tmpvar_12.z) + 2.0);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_15;
  tmpvar_15.y = 7.0;
  tmpvar_15.x = (4.0 - (3.0 * tmpvar_11.y));
  tmpvar_15.z = (1.0 + (3.0 * tmpvar_11.y));
  highp vec3 tmpvar_16;
  tmpvar_16.x = (((3.0 - 
    (2.0 * tmpvar_11.y)
  ) / tmpvar_15.x) - 2.0);
  tmpvar_16.y = ((3.0 + tmpvar_11.y) / 7.0);
  tmpvar_16.z = ((tmpvar_11.y / tmpvar_15.z) + 2.0);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_12 * tmpvar_15.x);
  accum_8 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_14.x;
  tmpvar_19.y = tmpvar_17.x;
  highp float depth_20;
  depth_20 = tmpvar_7.z;
  highp vec3 uv_21;
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_10 + tmpvar_19);
  tmpvar_22.z = depth_20;
  uv_21.xy = tmpvar_22.xy;
  uv_21.z = depth_20;
  mediump float tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, uv_21);
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_14.y;
  tmpvar_24.y = tmpvar_17.x;
  highp float depth_25;
  depth_25 = tmpvar_7.z;
  highp vec3 uv_26;
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_10 + tmpvar_24);
  tmpvar_27.z = depth_25;
  uv_26.xy = tmpvar_27.xy;
  uv_26.z = depth_25;
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, uv_26);
  highp vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_14.z;
  tmpvar_29.y = tmpvar_17.x;
  highp float depth_30;
  depth_30 = tmpvar_7.z;
  highp vec3 uv_31;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_10 + tmpvar_29);
  tmpvar_32.z = depth_30;
  uv_31.xy = tmpvar_32.xy;
  uv_31.z = depth_30;
  mediump float tmpvar_33;
  tmpvar_33 = texture (_ShadowMapTexture, uv_31);
  mediump float tmpvar_34;
  tmpvar_34 = (((accum_8.x * tmpvar_23) + (accum_8.y * tmpvar_28)) + (accum_8.z * tmpvar_33));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * 7.0);
  accum_8 = tmpvar_35;
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_14.x;
  tmpvar_36.y = tmpvar_17.y;
  highp float depth_37;
  depth_37 = tmpvar_7.z;
  highp vec3 uv_38;
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_10 + tmpvar_36);
  tmpvar_39.z = depth_37;
  uv_38.xy = tmpvar_39.xy;
  uv_38.z = depth_37;
  mediump float tmpvar_40;
  tmpvar_40 = texture (_ShadowMapTexture, uv_38);
  highp vec2 tmpvar_41;
  tmpvar_41.x = tmpvar_14.y;
  tmpvar_41.y = tmpvar_17.y;
  highp float depth_42;
  depth_42 = tmpvar_7.z;
  highp vec3 uv_43;
  highp vec3 tmpvar_44;
  tmpvar_44.xy = (tmpvar_10 + tmpvar_41);
  tmpvar_44.z = depth_42;
  uv_43.xy = tmpvar_44.xy;
  uv_43.z = depth_42;
  mediump float tmpvar_45;
  tmpvar_45 = texture (_ShadowMapTexture, uv_43);
  highp vec2 tmpvar_46;
  tmpvar_46.x = tmpvar_14.z;
  tmpvar_46.y = tmpvar_17.y;
  highp float depth_47;
  depth_47 = tmpvar_7.z;
  highp vec3 uv_48;
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_10 + tmpvar_46);
  tmpvar_49.z = depth_47;
  uv_48.xy = tmpvar_49.xy;
  uv_48.z = depth_47;
  mediump float tmpvar_50;
  tmpvar_50 = texture (_ShadowMapTexture, uv_48);
  mediump float tmpvar_51;
  tmpvar_51 = (((tmpvar_34 + 
    (accum_8.x * tmpvar_40)
  ) + (accum_8.y * tmpvar_45)) + (accum_8.z * tmpvar_50));
  highp vec3 tmpvar_52;
  tmpvar_52 = (tmpvar_12 * tmpvar_15.z);
  accum_8 = tmpvar_52;
  highp vec2 tmpvar_53;
  tmpvar_53.x = tmpvar_14.x;
  tmpvar_53.y = tmpvar_17.z;
  highp float depth_54;
  depth_54 = tmpvar_7.z;
  highp vec3 uv_55;
  highp vec3 tmpvar_56;
  tmpvar_56.xy = (tmpvar_10 + tmpvar_53);
  tmpvar_56.z = depth_54;
  uv_55.xy = tmpvar_56.xy;
  uv_55.z = depth_54;
  mediump float tmpvar_57;
  tmpvar_57 = texture (_ShadowMapTexture, uv_55);
  highp vec2 tmpvar_58;
  tmpvar_58.x = tmpvar_14.y;
  tmpvar_58.y = tmpvar_17.z;
  highp float depth_59;
  depth_59 = tmpvar_7.z;
  highp vec3 uv_60;
  highp vec3 tmpvar_61;
  tmpvar_61.xy = (tmpvar_10 + tmpvar_58);
  tmpvar_61.z = depth_59;
  uv_60.xy = tmpvar_61.xy;
  uv_60.z = depth_59;
  mediump float tmpvar_62;
  tmpvar_62 = texture (_ShadowMapTexture, uv_60);
  highp vec2 tmpvar_63;
  tmpvar_63.x = tmpvar_14.z;
  tmpvar_63.y = tmpvar_17.z;
  highp float depth_64;
  depth_64 = tmpvar_7.z;
  highp vec3 uv_65;
  highp vec3 tmpvar_66;
  tmpvar_66.xy = (tmpvar_10 + tmpvar_63);
  tmpvar_66.z = depth_64;
  uv_65.xy = tmpvar_66.xy;
  uv_65.z = depth_64;
  mediump float tmpvar_67;
  tmpvar_67 = texture (_ShadowMapTexture, uv_65);
  mediump float tmpvar_68;
  tmpvar_68 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_51 + (accum_8.x * tmpvar_57)) + (accum_8.y * tmpvar_62))
   + 
    (accum_8.z * tmpvar_67)
  ) / 144.0));
  highp float tmpvar_69;
  tmpvar_69 = (tmpvar_68 + clamp ((
    (tmpvar_5.z * _LightShadowData.z)
   + _LightShadowData.w), 0.0, 1.0));
  shadow_2 = tmpvar_69;
  mediump vec4 tmpvar_70;
  tmpvar_70 = vec4(shadow_2);
  tmpvar_1 = tmpvar_70;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  highp vec2 tmpvar_8;
  tmpvar_8 = _ShadowMapTexture_TexelSize.xy;
  highp vec3 tmpvar_9;
  tmpvar_9.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_9.z = tmpvar_7.z;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  mediump float tmpvar_11;
  if ((tmpvar_10.x < tmpvar_7.z)) {
    tmpvar_11 = 0.0;
  } else {
    tmpvar_11 = 1.0;
  };
  highp vec2 tmpvar_12;
  tmpvar_12.x = 0.0;
  tmpvar_12.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_13;
  tmpvar_13.xy = (tmpvar_7.xy + tmpvar_12);
  tmpvar_13.z = tmpvar_7.z;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  highp float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_7.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  mediump float tmpvar_16;
  tmpvar_16 = (tmpvar_11 + tmpvar_15);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_8.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_16 + tmpvar_20);
  highp vec2 tmpvar_22;
  tmpvar_22.y = 0.0;
  tmpvar_22.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_23;
  tmpvar_23.xy = (tmpvar_7.xy + tmpvar_22);
  tmpvar_23.z = tmpvar_7.z;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_ShadowMapTexture, tmpvar_23.xy);
  highp float tmpvar_25;
  if ((tmpvar_24.x < tmpvar_7.z)) {
    tmpvar_25 = 0.0;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_21 + tmpvar_25);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_7.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_26 + tmpvar_28);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = tmpvar_8.x;
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_7.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_7.z;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_7.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  tmpvar_34 = (tmpvar_29 + tmpvar_33);
  highp vec2 tmpvar_35;
  tmpvar_35.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_35.y = tmpvar_8.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_34 + tmpvar_38);
  highp vec2 tmpvar_40;
  tmpvar_40.x = 0.0;
  tmpvar_40.y = tmpvar_8.y;
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_7.xy + tmpvar_40);
  tmpvar_41.z = tmpvar_7.z;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_7.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  mediump float tmpvar_44;
  tmpvar_44 = (tmpvar_39 + tmpvar_43);
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_45.z = tmpvar_7.z;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_7.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  mediump float tmpvar_48;
  tmpvar_48 = mix (_LightShadowData.x, 1.0, ((tmpvar_44 + tmpvar_47) / 9.0));
  highp float tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (((
    sqrt(dot (tmpvar_50, tmpvar_50))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  tmpvar_49 = tmpvar_51;
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_48 + tmpvar_49);
  shadow_2 = tmpvar_53;
  mediump vec4 tmpvar_54;
  tmpvar_54 = vec4(shadow_2);
  tmpvar_1 = tmpvar_54;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  mediump vec3 accum_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((tmpvar_7.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_10;
  tmpvar_10 = ((floor(tmpvar_9) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_11;
  tmpvar_11 = fract(tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12.y = 7.0;
  tmpvar_12.x = (4.0 - (3.0 * tmpvar_11.x));
  tmpvar_12.z = (1.0 + (3.0 * tmpvar_11.x));
  highp vec3 tmpvar_13;
  tmpvar_13.x = (((3.0 - 
    (2.0 * tmpvar_11.x)
  ) / tmpvar_12.x) - 2.0);
  tmpvar_13.y = ((3.0 + tmpvar_11.x) / 7.0);
  tmpvar_13.z = ((tmpvar_11.x / tmpvar_12.z) + 2.0);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_15;
  tmpvar_15.y = 7.0;
  tmpvar_15.x = (4.0 - (3.0 * tmpvar_11.y));
  tmpvar_15.z = (1.0 + (3.0 * tmpvar_11.y));
  highp vec3 tmpvar_16;
  tmpvar_16.x = (((3.0 - 
    (2.0 * tmpvar_11.y)
  ) / tmpvar_15.x) - 2.0);
  tmpvar_16.y = ((3.0 + tmpvar_11.y) / 7.0);
  tmpvar_16.z = ((tmpvar_11.y / tmpvar_15.z) + 2.0);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_12 * tmpvar_15.x);
  accum_8 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_14.x;
  tmpvar_19.y = tmpvar_17.x;
  highp float depth_20;
  depth_20 = tmpvar_7.z;
  highp vec3 uv_21;
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_10 + tmpvar_19);
  tmpvar_22.z = depth_20;
  uv_21.xy = tmpvar_22.xy;
  uv_21.z = depth_20;
  lowp float tmpvar_23;
  tmpvar_23 = shadow2DEXT (_ShadowMapTexture, uv_21);
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_14.y;
  tmpvar_24.y = tmpvar_17.x;
  highp float depth_25;
  depth_25 = tmpvar_7.z;
  highp vec3 uv_26;
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_10 + tmpvar_24);
  tmpvar_27.z = depth_25;
  uv_26.xy = tmpvar_27.xy;
  uv_26.z = depth_25;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, uv_26);
  highp vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_14.z;
  tmpvar_29.y = tmpvar_17.x;
  highp float depth_30;
  depth_30 = tmpvar_7.z;
  highp vec3 uv_31;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_10 + tmpvar_29);
  tmpvar_32.z = depth_30;
  uv_31.xy = tmpvar_32.xy;
  uv_31.z = depth_30;
  lowp float tmpvar_33;
  tmpvar_33 = shadow2DEXT (_ShadowMapTexture, uv_31);
  mediump float tmpvar_34;
  tmpvar_34 = (((accum_8.x * tmpvar_23) + (accum_8.y * tmpvar_28)) + (accum_8.z * tmpvar_33));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * 7.0);
  accum_8 = tmpvar_35;
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_14.x;
  tmpvar_36.y = tmpvar_17.y;
  highp float depth_37;
  depth_37 = tmpvar_7.z;
  highp vec3 uv_38;
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_10 + tmpvar_36);
  tmpvar_39.z = depth_37;
  uv_38.xy = tmpvar_39.xy;
  uv_38.z = depth_37;
  lowp float tmpvar_40;
  tmpvar_40 = shadow2DEXT (_ShadowMapTexture, uv_38);
  highp vec2 tmpvar_41;
  tmpvar_41.x = tmpvar_14.y;
  tmpvar_41.y = tmpvar_17.y;
  highp float depth_42;
  depth_42 = tmpvar_7.z;
  highp vec3 uv_43;
  highp vec3 tmpvar_44;
  tmpvar_44.xy = (tmpvar_10 + tmpvar_41);
  tmpvar_44.z = depth_42;
  uv_43.xy = tmpvar_44.xy;
  uv_43.z = depth_42;
  lowp float tmpvar_45;
  tmpvar_45 = shadow2DEXT (_ShadowMapTexture, uv_43);
  highp vec2 tmpvar_46;
  tmpvar_46.x = tmpvar_14.z;
  tmpvar_46.y = tmpvar_17.y;
  highp float depth_47;
  depth_47 = tmpvar_7.z;
  highp vec3 uv_48;
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_10 + tmpvar_46);
  tmpvar_49.z = depth_47;
  uv_48.xy = tmpvar_49.xy;
  uv_48.z = depth_47;
  lowp float tmpvar_50;
  tmpvar_50 = shadow2DEXT (_ShadowMapTexture, uv_48);
  mediump float tmpvar_51;
  tmpvar_51 = (((tmpvar_34 + 
    (accum_8.x * tmpvar_40)
  ) + (accum_8.y * tmpvar_45)) + (accum_8.z * tmpvar_50));
  highp vec3 tmpvar_52;
  tmpvar_52 = (tmpvar_12 * tmpvar_15.z);
  accum_8 = tmpvar_52;
  highp vec2 tmpvar_53;
  tmpvar_53.x = tmpvar_14.x;
  tmpvar_53.y = tmpvar_17.z;
  highp float depth_54;
  depth_54 = tmpvar_7.z;
  highp vec3 uv_55;
  highp vec3 tmpvar_56;
  tmpvar_56.xy = (tmpvar_10 + tmpvar_53);
  tmpvar_56.z = depth_54;
  uv_55.xy = tmpvar_56.xy;
  uv_55.z = depth_54;
  lowp float tmpvar_57;
  tmpvar_57 = shadow2DEXT (_ShadowMapTexture, uv_55);
  highp vec2 tmpvar_58;
  tmpvar_58.x = tmpvar_14.y;
  tmpvar_58.y = tmpvar_17.z;
  highp float depth_59;
  depth_59 = tmpvar_7.z;
  highp vec3 uv_60;
  highp vec3 tmpvar_61;
  tmpvar_61.xy = (tmpvar_10 + tmpvar_58);
  tmpvar_61.z = depth_59;
  uv_60.xy = tmpvar_61.xy;
  uv_60.z = depth_59;
  lowp float tmpvar_62;
  tmpvar_62 = shadow2DEXT (_ShadowMapTexture, uv_60);
  highp vec2 tmpvar_63;
  tmpvar_63.x = tmpvar_14.z;
  tmpvar_63.y = tmpvar_17.z;
  highp float depth_64;
  depth_64 = tmpvar_7.z;
  highp vec3 uv_65;
  highp vec3 tmpvar_66;
  tmpvar_66.xy = (tmpvar_10 + tmpvar_63);
  tmpvar_66.z = depth_64;
  uv_65.xy = tmpvar_66.xy;
  uv_65.z = depth_64;
  lowp float tmpvar_67;
  tmpvar_67 = shadow2DEXT (_ShadowMapTexture, uv_65);
  mediump float tmpvar_68;
  tmpvar_68 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_51 + (accum_8.x * tmpvar_57)) + (accum_8.y * tmpvar_62))
   + 
    (accum_8.z * tmpvar_67)
  ) / 144.0));
  highp float tmpvar_69;
  highp vec3 tmpvar_70;
  tmpvar_70 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_71;
  highp float tmpvar_72;
  tmpvar_72 = clamp (((
    sqrt(dot (tmpvar_70, tmpvar_70))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_71 = tmpvar_72;
  tmpvar_69 = tmpvar_71;
  highp float tmpvar_73;
  tmpvar_73 = (tmpvar_68 + tmpvar_69);
  shadow_2 = tmpvar_73;
  mediump vec4 tmpvar_74;
  tmpvar_74 = vec4(shadow_2);
  tmpvar_1 = tmpvar_74;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
in vec4 _glesMultiTexCoord0;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 clipPos_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  clipPos_1.xzw = tmpvar_2.xzw;
  clipPos_1.y = (tmpvar_2.y * _ProjectionParams.x);
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(-1.0, 1.0);
  tmpvar_3.xy = clipPos_1.xy;
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraInvProjection * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(1.0, 1.0);
  tmpvar_5.xy = clipPos_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.xy = tmpvar_4.xy;
  tmpvar_6.z = -(tmpvar_4.z);
  tmpvar_6.w = -((unity_CameraInvProjection * tmpvar_5).z);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
  xlv_TEXCOORD2 = tmpvar_6;
  gl_Position = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp mat4 _CameraToWorld;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float shadow_2;
  highp vec3 vposOrtho_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = texture (_CameraDepthTexture, xlv_TEXCOORD0);
  vposOrtho_3.xy = xlv_TEXCOORD2.xy;
  vposOrtho_3.z = mix (xlv_TEXCOORD2.z, xlv_TEXCOORD2.w, tmpvar_4.x);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_4.x) + _ZBufferParams.y)))
  , tmpvar_4.x, unity_OrthoParams.w)), vposOrtho_3, unity_OrthoParams.www);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_CameraToWorld * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_World2Shadow[0] * tmpvar_6).xyz;
  mediump vec3 accum_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((tmpvar_7.xy * _ShadowMapTexture_TexelSize.zw) + vec2(0.5, 0.5));
  highp vec2 tmpvar_10;
  tmpvar_10 = ((floor(tmpvar_9) - vec2(0.5, 0.5)) * _ShadowMapTexture_TexelSize.xy);
  highp vec2 tmpvar_11;
  tmpvar_11 = fract(tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12.y = 7.0;
  tmpvar_12.x = (4.0 - (3.0 * tmpvar_11.x));
  tmpvar_12.z = (1.0 + (3.0 * tmpvar_11.x));
  highp vec3 tmpvar_13;
  tmpvar_13.x = (((3.0 - 
    (2.0 * tmpvar_11.x)
  ) / tmpvar_12.x) - 2.0);
  tmpvar_13.y = ((3.0 + tmpvar_11.x) / 7.0);
  tmpvar_13.z = ((tmpvar_11.x / tmpvar_12.z) + 2.0);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_15;
  tmpvar_15.y = 7.0;
  tmpvar_15.x = (4.0 - (3.0 * tmpvar_11.y));
  tmpvar_15.z = (1.0 + (3.0 * tmpvar_11.y));
  highp vec3 tmpvar_16;
  tmpvar_16.x = (((3.0 - 
    (2.0 * tmpvar_11.y)
  ) / tmpvar_15.x) - 2.0);
  tmpvar_16.y = ((3.0 + tmpvar_11.y) / 7.0);
  tmpvar_16.z = ((tmpvar_11.y / tmpvar_15.z) + 2.0);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_12 * tmpvar_15.x);
  accum_8 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_14.x;
  tmpvar_19.y = tmpvar_17.x;
  highp float depth_20;
  depth_20 = tmpvar_7.z;
  highp vec3 uv_21;
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_10 + tmpvar_19);
  tmpvar_22.z = depth_20;
  uv_21.xy = tmpvar_22.xy;
  uv_21.z = depth_20;
  mediump float tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, uv_21);
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_14.y;
  tmpvar_24.y = tmpvar_17.x;
  highp float depth_25;
  depth_25 = tmpvar_7.z;
  highp vec3 uv_26;
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_10 + tmpvar_24);
  tmpvar_27.z = depth_25;
  uv_26.xy = tmpvar_27.xy;
  uv_26.z = depth_25;
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, uv_26);
  highp vec2 tmpvar_29;
  tmpvar_29.x = tmpvar_14.z;
  tmpvar_29.y = tmpvar_17.x;
  highp float depth_30;
  depth_30 = tmpvar_7.z;
  highp vec3 uv_31;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_10 + tmpvar_29);
  tmpvar_32.z = depth_30;
  uv_31.xy = tmpvar_32.xy;
  uv_31.z = depth_30;
  mediump float tmpvar_33;
  tmpvar_33 = texture (_ShadowMapTexture, uv_31);
  mediump float tmpvar_34;
  tmpvar_34 = (((accum_8.x * tmpvar_23) + (accum_8.y * tmpvar_28)) + (accum_8.z * tmpvar_33));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_12 * 7.0);
  accum_8 = tmpvar_35;
  highp vec2 tmpvar_36;
  tmpvar_36.x = tmpvar_14.x;
  tmpvar_36.y = tmpvar_17.y;
  highp float depth_37;
  depth_37 = tmpvar_7.z;
  highp vec3 uv_38;
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_10 + tmpvar_36);
  tmpvar_39.z = depth_37;
  uv_38.xy = tmpvar_39.xy;
  uv_38.z = depth_37;
  mediump float tmpvar_40;
  tmpvar_40 = texture (_ShadowMapTexture, uv_38);
  highp vec2 tmpvar_41;
  tmpvar_41.x = tmpvar_14.y;
  tmpvar_41.y = tmpvar_17.y;
  highp float depth_42;
  depth_42 = tmpvar_7.z;
  highp vec3 uv_43;
  highp vec3 tmpvar_44;
  tmpvar_44.xy = (tmpvar_10 + tmpvar_41);
  tmpvar_44.z = depth_42;
  uv_43.xy = tmpvar_44.xy;
  uv_43.z = depth_42;
  mediump float tmpvar_45;
  tmpvar_45 = texture (_ShadowMapTexture, uv_43);
  highp vec2 tmpvar_46;
  tmpvar_46.x = tmpvar_14.z;
  tmpvar_46.y = tmpvar_17.y;
  highp float depth_47;
  depth_47 = tmpvar_7.z;
  highp vec3 uv_48;
  highp vec3 tmpvar_49;
  tmpvar_49.xy = (tmpvar_10 + tmpvar_46);
  tmpvar_49.z = depth_47;
  uv_48.xy = tmpvar_49.xy;
  uv_48.z = depth_47;
  mediump float tmpvar_50;
  tmpvar_50 = texture (_ShadowMapTexture, uv_48);
  mediump float tmpvar_51;
  tmpvar_51 = (((tmpvar_34 + 
    (accum_8.x * tmpvar_40)
  ) + (accum_8.y * tmpvar_45)) + (accum_8.z * tmpvar_50));
  highp vec3 tmpvar_52;
  tmpvar_52 = (tmpvar_12 * tmpvar_15.z);
  accum_8 = tmpvar_52;
  highp vec2 tmpvar_53;
  tmpvar_53.x = tmpvar_14.x;
  tmpvar_53.y = tmpvar_17.z;
  highp float depth_54;
  depth_54 = tmpvar_7.z;
  highp vec3 uv_55;
  highp vec3 tmpvar_56;
  tmpvar_56.xy = (tmpvar_10 + tmpvar_53);
  tmpvar_56.z = depth_54;
  uv_55.xy = tmpvar_56.xy;
  uv_55.z = depth_54;
  mediump float tmpvar_57;
  tmpvar_57 = texture (_ShadowMapTexture, uv_55);
  highp vec2 tmpvar_58;
  tmpvar_58.x = tmpvar_14.y;
  tmpvar_58.y = tmpvar_17.z;
  highp float depth_59;
  depth_59 = tmpvar_7.z;
  highp vec3 uv_60;
  highp vec3 tmpvar_61;
  tmpvar_61.xy = (tmpvar_10 + tmpvar_58);
  tmpvar_61.z = depth_59;
  uv_60.xy = tmpvar_61.xy;
  uv_60.z = depth_59;
  mediump float tmpvar_62;
  tmpvar_62 = texture (_ShadowMapTexture, uv_60);
  highp vec2 tmpvar_63;
  tmpvar_63.x = tmpvar_14.z;
  tmpvar_63.y = tmpvar_17.z;
  highp float depth_64;
  depth_64 = tmpvar_7.z;
  highp vec3 uv_65;
  highp vec3 tmpvar_66;
  tmpvar_66.xy = (tmpvar_10 + tmpvar_63);
  tmpvar_66.z = depth_64;
  uv_65.xy = tmpvar_66.xy;
  uv_65.z = depth_64;
  mediump float tmpvar_67;
  tmpvar_67 = texture (_ShadowMapTexture, uv_65);
  mediump float tmpvar_68;
  tmpvar_68 = mix (_LightShadowData.x, 1.0, ((
    ((tmpvar_51 + (accum_8.x * tmpvar_57)) + (accum_8.y * tmpvar_62))
   + 
    (accum_8.z * tmpvar_67)
  ) / 144.0));
  highp float tmpvar_69;
  highp vec3 tmpvar_70;
  tmpvar_70 = (tmpvar_6.xyz - unity_ShadowFadeCenterAndType.xyz);
  mediump float tmpvar_71;
  highp float tmpvar_72;
  tmpvar_72 = clamp (((
    sqrt(dot (tmpvar_70, tmpvar_70))
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_71 = tmpvar_72;
  tmpvar_69 = tmpvar_71;
  highp float tmpvar_73;
  tmpvar_73 = (tmpvar_68 + tmpvar_69);
  shadow_2 = tmpvar_73;
  mediump vec4 tmpvar_74;
  tmpvar_74 = vec4(shadow_2);
  tmpvar_1 = tmpvar_74;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NATIVE" "SHADOWS_SINGLE_CASCADE" }
"!!GLES3"
}
}
 }
}
Fallback Off
}