//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-PrePassLighting" {
Properties {
 _LightTexture0 ("", any) = "" { }
 _LightTextureB0 ("", 2D) = "" { }
 _ShadowMapTexture ("", any) = "" { }
}
SubShader { 
 Pass {
  Tags { "SHADOWSUPPORT"="true" }
  ZWrite Off
  Blend DstColor Zero
  GpuProgramID 57115
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = exp2(-(tmpvar_24));
  tmpvar_1 = tmpvar_25;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = exp2(-(tmpvar_24));
  tmpvar_1 = tmpvar_25;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = textureProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = textureCube (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture2D (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, tmpvar_24);
  mediump float tmpvar_27;
  if ((tmpvar_26.x < (tmpvar_24.z / tmpvar_24.w))) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.0;
  };
  tmpvar_25 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = shadow2DProjEXT (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25;
  mediump float tmpvar_27;
  tmpvar_27 = (_LightShadowData.x + (tmpvar_26 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = textureProj (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = (_LightShadowData.x + (tmpvar_25 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_31;
  tmpvar_31 = max (0.0, dot (lightDir_7, tmpvar_30));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = pow (max (0.0, dot (h_4, tmpvar_30)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = (spec_3 * clamp (tmpvar_28, 0.0, 1.0));
  spec_3 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_LightColor.xyz * (tmpvar_31 * tmpvar_28));
  res_2.xyz = tmpvar_35;
  mediump vec3 c_36;
  c_36 = _LightColor.xyz;
  mediump float tmpvar_37;
  tmpvar_37 = dot (c_36, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_38;
  tmpvar_38 = (tmpvar_34 * tmpvar_37);
  res_2.w = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_40;
  tmpvar_40 = (res_2 * tmpvar_39);
  res_2 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = exp2(-(tmpvar_40));
  tmpvar_1 = tmpvar_41;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp float tmpvar_22;
  tmpvar_22 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_7, tmpvar_24));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_24)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_22, 0.0, 1.0));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_22));
  res_2.xyz = tmpvar_29;
  mediump vec3 c_30;
  c_30 = _LightColor.xyz;
  mediump float tmpvar_31;
  tmpvar_31 = dot (c_30, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp float tmpvar_21;
  tmpvar_21 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_7, tmpvar_23));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (spec_3 * clamp (tmpvar_21, 0.0, 1.0));
  spec_3 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (_LightColor.xyz * (tmpvar_24 * tmpvar_21));
  res_2.xyz = tmpvar_28;
  mediump vec3 c_29;
  c_29 = _LightColor.xyz;
  mediump float tmpvar_30;
  tmpvar_30 = dot (c_29, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_31;
  tmpvar_31 = (tmpvar_27 * tmpvar_30);
  res_2.w = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_33;
  tmpvar_33 = (res_2 * tmpvar_32);
  res_2 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  lowp vec4 tmpvar_23;
  highp vec3 P_24;
  P_24 = (_LightMatrix0 * tmpvar_22).xyz;
  tmpvar_23 = textureCube (_LightTexture0, P_24);
  highp float tmpvar_25;
  tmpvar_25 = ((atten_6 * tmpvar_21) * tmpvar_23.w);
  atten_6 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (spec_3 * clamp (tmpvar_25, 0.0, 1.0));
  spec_3 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_LightColor.xyz * (tmpvar_28 * tmpvar_25));
  res_2.xyz = tmpvar_32;
  mediump vec3 c_33;
  c_33 = _LightColor.xyz;
  mediump float tmpvar_34;
  tmpvar_34 = dot (c_33, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (tmpvar_31 * tmpvar_34);
  res_2.w = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_2 * tmpvar_36);
  res_2 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = texture (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = ((atten_6 * tmpvar_20) * tmpvar_22.w);
  atten_6 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_7, tmpvar_26));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_26)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (spec_3 * clamp (tmpvar_24, 0.0, 1.0));
  spec_3 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * (tmpvar_27 * tmpvar_24));
  res_2.xyz = tmpvar_31;
  mediump vec3 c_32;
  c_32 = _LightColor.xyz;
  mediump float tmpvar_33;
  tmpvar_33 = dot (c_32, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_34;
  tmpvar_34 = (tmpvar_30 * tmpvar_33);
  res_2.w = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_36;
  tmpvar_36 = (res_2 * tmpvar_35);
  res_2 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
  tmpvar_1 = tmpvar_37;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  highp vec2 P_28;
  P_28 = (tmpvar_27.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, P_28).x;
  shadowVals_26.x = tmpvar_29;
  highp vec2 P_30;
  P_30 = (tmpvar_27.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, P_30).x;
  shadowVals_26.y = tmpvar_31;
  highp vec2 P_32;
  P_32 = (tmpvar_27.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_26.z = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_27.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_26.w = tmpvar_35;
  bvec4 tmpvar_36;
  tmpvar_36 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_37;
  tmpvar_37 = _LightShadowData.xxxx;
  mediump float tmpvar_38;
  if (tmpvar_36.x) {
    tmpvar_38 = tmpvar_37.x;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if (tmpvar_36.y) {
    tmpvar_39 = tmpvar_37.y;
  } else {
    tmpvar_39 = 1.0;
  };
  mediump float tmpvar_40;
  if (tmpvar_36.z) {
    tmpvar_40 = tmpvar_37.z;
  } else {
    tmpvar_40 = 1.0;
  };
  mediump float tmpvar_41;
  if (tmpvar_36.w) {
    tmpvar_41 = tmpvar_37.w;
  } else {
    tmpvar_41 = 1.0;
  };
  mediump vec4 tmpvar_42;
  tmpvar_42.x = tmpvar_38;
  tmpvar_42.y = tmpvar_39;
  tmpvar_42.z = tmpvar_40;
  tmpvar_42.w = tmpvar_41;
  mediump float tmpvar_43;
  tmpvar_43 = dot (tmpvar_42, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_44;
  highp float tmpvar_45;
  tmpvar_45 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_45;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_48;
  tmpvar_48 = max (0.0, dot (lightDir_7, tmpvar_47));
  highp vec3 tmpvar_49;
  tmpvar_49 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = pow (max (0.0, dot (h_4, tmpvar_47)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_50;
  highp float tmpvar_51;
  tmpvar_51 = (spec_3 * clamp (tmpvar_45, 0.0, 1.0));
  spec_3 = tmpvar_51;
  highp vec3 tmpvar_52;
  tmpvar_52 = (_LightColor.xyz * (tmpvar_48 * tmpvar_45));
  res_2.xyz = tmpvar_52;
  mediump vec3 c_53;
  c_53 = _LightColor.xyz;
  mediump float tmpvar_54;
  tmpvar_54 = dot (c_53, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_55;
  tmpvar_55 = (tmpvar_51 * tmpvar_54);
  res_2.w = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_57;
  tmpvar_57 = (res_2 * tmpvar_56);
  res_2 = tmpvar_57;
  mediump vec4 tmpvar_58;
  tmpvar_58 = exp2(-(tmpvar_57));
  tmpvar_1 = tmpvar_58;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  lowp float tmpvar_30;
  tmpvar_30 = shadow2DEXT (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  lowp float tmpvar_32;
  tmpvar_32 = shadow2DEXT (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  mediump vec4 tmpvar_51;
  tmpvar_51 = exp2(-(tmpvar_50));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  mediump float tmpvar_30;
  tmpvar_30 = texture (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  mediump float tmpvar_32;
  tmpvar_32 = texture (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  mediump float tmpvar_34;
  tmpvar_34 = texture (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  mediump vec4 tmpvar_51;
  tmpvar_51 = exp2(-(tmpvar_50));
  tmpvar_1 = tmpvar_51;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(tmpvar_44));
  tmpvar_1 = tmpvar_45;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(tmpvar_44));
  tmpvar_1 = tmpvar_45;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = textureCube (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = texture (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
}
 }
 Pass {
  Tags { "SHADOWSUPPORT"="true" }
  ZWrite Off
  Blend One One
  GpuProgramID 113408
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  tmpvar_1 = tmpvar_24;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = textureProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = textureCube (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture2D (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, tmpvar_24);
  mediump float tmpvar_27;
  if ((tmpvar_26.x < (tmpvar_24.z / tmpvar_24.w))) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.0;
  };
  tmpvar_25 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = shadow2DProjEXT (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25;
  mediump float tmpvar_27;
  tmpvar_27 = (_LightShadowData.x + (tmpvar_26 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = textureProj (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = (_LightShadowData.x + (tmpvar_25 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_31;
  tmpvar_31 = max (0.0, dot (lightDir_7, tmpvar_30));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = pow (max (0.0, dot (h_4, tmpvar_30)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = (spec_3 * clamp (tmpvar_28, 0.0, 1.0));
  spec_3 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_LightColor.xyz * (tmpvar_31 * tmpvar_28));
  res_2.xyz = tmpvar_35;
  mediump vec3 c_36;
  c_36 = _LightColor.xyz;
  mediump float tmpvar_37;
  tmpvar_37 = dot (c_36, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_38;
  tmpvar_38 = (tmpvar_34 * tmpvar_37);
  res_2.w = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_40;
  tmpvar_40 = (res_2 * tmpvar_39);
  res_2 = tmpvar_40;
  tmpvar_1 = tmpvar_40;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp float tmpvar_22;
  tmpvar_22 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_7, tmpvar_24));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_24)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_22, 0.0, 1.0));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_22));
  res_2.xyz = tmpvar_29;
  mediump vec3 c_30;
  c_30 = _LightColor.xyz;
  mediump float tmpvar_31;
  tmpvar_31 = dot (c_30, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp float tmpvar_21;
  tmpvar_21 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_7, tmpvar_23));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (spec_3 * clamp (tmpvar_21, 0.0, 1.0));
  spec_3 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (_LightColor.xyz * (tmpvar_24 * tmpvar_21));
  res_2.xyz = tmpvar_28;
  mediump vec3 c_29;
  c_29 = _LightColor.xyz;
  mediump float tmpvar_30;
  tmpvar_30 = dot (c_29, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_31;
  tmpvar_31 = (tmpvar_27 * tmpvar_30);
  res_2.w = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_33;
  tmpvar_33 = (res_2 * tmpvar_32);
  res_2 = tmpvar_33;
  tmpvar_1 = tmpvar_33;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  lowp vec4 tmpvar_23;
  highp vec3 P_24;
  P_24 = (_LightMatrix0 * tmpvar_22).xyz;
  tmpvar_23 = textureCube (_LightTexture0, P_24);
  highp float tmpvar_25;
  tmpvar_25 = ((atten_6 * tmpvar_21) * tmpvar_23.w);
  atten_6 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (spec_3 * clamp (tmpvar_25, 0.0, 1.0));
  spec_3 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_LightColor.xyz * (tmpvar_28 * tmpvar_25));
  res_2.xyz = tmpvar_32;
  mediump vec3 c_33;
  c_33 = _LightColor.xyz;
  mediump float tmpvar_34;
  tmpvar_34 = dot (c_33, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (tmpvar_31 * tmpvar_34);
  res_2.w = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_2 * tmpvar_36);
  res_2 = tmpvar_37;
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = texture (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = ((atten_6 * tmpvar_20) * tmpvar_22.w);
  atten_6 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_7, tmpvar_26));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_26)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (spec_3 * clamp (tmpvar_24, 0.0, 1.0));
  spec_3 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * (tmpvar_27 * tmpvar_24));
  res_2.xyz = tmpvar_31;
  mediump vec3 c_32;
  c_32 = _LightColor.xyz;
  mediump float tmpvar_33;
  tmpvar_33 = dot (c_32, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_34;
  tmpvar_34 = (tmpvar_30 * tmpvar_33);
  res_2.w = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_36;
  tmpvar_36 = (res_2 * tmpvar_35);
  res_2 = tmpvar_36;
  tmpvar_1 = tmpvar_36;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  highp vec2 P_28;
  P_28 = (tmpvar_27.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, P_28).x;
  shadowVals_26.x = tmpvar_29;
  highp vec2 P_30;
  P_30 = (tmpvar_27.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, P_30).x;
  shadowVals_26.y = tmpvar_31;
  highp vec2 P_32;
  P_32 = (tmpvar_27.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_26.z = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_27.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_26.w = tmpvar_35;
  bvec4 tmpvar_36;
  tmpvar_36 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_37;
  tmpvar_37 = _LightShadowData.xxxx;
  mediump float tmpvar_38;
  if (tmpvar_36.x) {
    tmpvar_38 = tmpvar_37.x;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if (tmpvar_36.y) {
    tmpvar_39 = tmpvar_37.y;
  } else {
    tmpvar_39 = 1.0;
  };
  mediump float tmpvar_40;
  if (tmpvar_36.z) {
    tmpvar_40 = tmpvar_37.z;
  } else {
    tmpvar_40 = 1.0;
  };
  mediump float tmpvar_41;
  if (tmpvar_36.w) {
    tmpvar_41 = tmpvar_37.w;
  } else {
    tmpvar_41 = 1.0;
  };
  mediump vec4 tmpvar_42;
  tmpvar_42.x = tmpvar_38;
  tmpvar_42.y = tmpvar_39;
  tmpvar_42.z = tmpvar_40;
  tmpvar_42.w = tmpvar_41;
  mediump float tmpvar_43;
  tmpvar_43 = dot (tmpvar_42, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_44;
  highp float tmpvar_45;
  tmpvar_45 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_45;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_48;
  tmpvar_48 = max (0.0, dot (lightDir_7, tmpvar_47));
  highp vec3 tmpvar_49;
  tmpvar_49 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = pow (max (0.0, dot (h_4, tmpvar_47)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_50;
  highp float tmpvar_51;
  tmpvar_51 = (spec_3 * clamp (tmpvar_45, 0.0, 1.0));
  spec_3 = tmpvar_51;
  highp vec3 tmpvar_52;
  tmpvar_52 = (_LightColor.xyz * (tmpvar_48 * tmpvar_45));
  res_2.xyz = tmpvar_52;
  mediump vec3 c_53;
  c_53 = _LightColor.xyz;
  mediump float tmpvar_54;
  tmpvar_54 = dot (c_53, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_55;
  tmpvar_55 = (tmpvar_51 * tmpvar_54);
  res_2.w = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_57;
  tmpvar_57 = (res_2 * tmpvar_56);
  res_2 = tmpvar_57;
  tmpvar_1 = tmpvar_57;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  lowp float tmpvar_30;
  tmpvar_30 = shadow2DEXT (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  lowp float tmpvar_32;
  tmpvar_32 = shadow2DEXT (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  mediump float tmpvar_30;
  tmpvar_30 = texture (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  mediump float tmpvar_32;
  tmpvar_32 = texture (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  mediump float tmpvar_34;
  tmpvar_34 = texture (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  tmpvar_1 = tmpvar_50;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  tmpvar_1 = tmpvar_44;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  tmpvar_1 = tmpvar_44;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = textureCube (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = texture (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  tmpvar_1 = tmpvar_47;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
}
 }
 Pass {
  Tags { "SHADOWSUPPORT"="true" }
  ZWrite Off
  Blend One One
  GpuProgramID 155461
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_7, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * atten_6));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  tmpvar_1 = tmpvar_24.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (lightDir_6, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (spec_3 * clamp (1.0, 0.0, 1.0));
  spec_3 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  res_2.xyz = tmpvar_19;
  mediump vec3 c_20;
  c_20 = _LightColor.xyz;
  mediump float tmpvar_21;
  tmpvar_21 = dot (c_20, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_22;
  tmpvar_22 = (tmpvar_18 * tmpvar_21);
  res_2.w = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (res_2 * tmpvar_23);
  res_2 = tmpvar_24;
  tmpvar_1 = tmpvar_24.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = texture2DProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_11;
  highp vec4 tmpvar_16;
  tmpvar_16 = (_LightMatrix0 * tmpvar_15);
  lowp float tmpvar_17;
  tmpvar_17 = textureProj (_LightTexture0, tmpvar_16).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_LightTextureB0, vec2(tmpvar_18));
  highp float tmpvar_20;
  tmpvar_20 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = textureCube (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_11;
  lowp vec4 tmpvar_18;
  highp vec3 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xyz;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_18.w);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_7, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture2D (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = (_LightMatrix0 * tmpvar_13).xy;
  tmpvar_14 = texture (_LightTexture0, P_15);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_14.w;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (spec_3 * clamp (tmpvar_16, 0.0, 1.0));
  spec_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * (tmpvar_19 * tmpvar_16));
  res_2.xyz = tmpvar_23;
  mediump vec3 c_24;
  c_24 = _LightColor.xyz;
  mediump float tmpvar_25;
  tmpvar_25 = dot (c_24, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_22 * tmpvar_25);
  res_2.w = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (res_2 * tmpvar_27);
  res_2 = tmpvar_28;
  tmpvar_1 = tmpvar_28.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, tmpvar_24);
  mediump float tmpvar_27;
  if ((tmpvar_26.x < (tmpvar_24.z / tmpvar_24.w))) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.0;
  };
  tmpvar_25 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = shadow2DProjEXT (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = tmpvar_25;
  mediump float tmpvar_27;
  tmpvar_27 = (_LightShadowData.x + (tmpvar_26 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_31)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_29, 0.0, 1.0));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_29));
  res_2.xyz = tmpvar_36;
  mediump vec3 c_37;
  c_37 = _LightColor.xyz;
  mediump float tmpvar_38;
  tmpvar_38 = dot (c_37, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = textureProj (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  tmpvar_26 = (_LightShadowData.x + (tmpvar_25 * (1.0 - _LightShadowData.x)));
  tmpvar_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_31;
  tmpvar_31 = max (0.0, dot (lightDir_7, tmpvar_30));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = pow (max (0.0, dot (h_4, tmpvar_30)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = (spec_3 * clamp (tmpvar_28, 0.0, 1.0));
  spec_3 = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_LightColor.xyz * (tmpvar_31 * tmpvar_28));
  res_2.xyz = tmpvar_35;
  mediump vec3 c_36;
  c_36 = _LightColor.xyz;
  mediump float tmpvar_37;
  tmpvar_37 = dot (c_36, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_38;
  tmpvar_38 = (tmpvar_34 * tmpvar_37);
  res_2.w = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_40;
  tmpvar_40 = (res_2 * tmpvar_39);
  res_2 = tmpvar_40;
  tmpvar_1 = tmpvar_40.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp float tmpvar_22;
  tmpvar_22 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_7, tmpvar_24));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_24)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_22, 0.0, 1.0));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_22));
  res_2.xyz = tmpvar_29;
  mediump vec3 c_30;
  c_30 = _LightColor.xyz;
  mediump float tmpvar_31;
  tmpvar_31 = dot (c_30, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp float tmpvar_21;
  tmpvar_21 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_7, tmpvar_23));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (spec_3 * clamp (tmpvar_21, 0.0, 1.0));
  spec_3 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (_LightColor.xyz * (tmpvar_24 * tmpvar_21));
  res_2.xyz = tmpvar_28;
  mediump vec3 c_29;
  c_29 = _LightColor.xyz;
  mediump float tmpvar_30;
  tmpvar_30 = dot (c_29, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_31;
  tmpvar_31 = (tmpvar_27 * tmpvar_30);
  res_2.w = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_33;
  tmpvar_33 = (res_2 * tmpvar_32);
  res_2 = tmpvar_33;
  tmpvar_1 = tmpvar_33.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_14);
  highp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_21;
  if ((tmpvar_20 < tmpvar_18)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  lowp vec4 tmpvar_23;
  highp vec3 P_24;
  P_24 = (_LightMatrix0 * tmpvar_22).xyz;
  tmpvar_23 = textureCube (_LightTexture0, P_24);
  highp float tmpvar_25;
  tmpvar_25 = ((atten_6 * tmpvar_21) * tmpvar_23.w);
  atten_6 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (spec_3 * clamp (tmpvar_25, 0.0, 1.0));
  spec_3 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_LightColor.xyz * (tmpvar_28 * tmpvar_25));
  res_2.xyz = tmpvar_32;
  mediump vec3 c_33;
  c_33 = _LightColor.xyz;
  mediump float tmpvar_34;
  tmpvar_34 = dot (c_33, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_35;
  tmpvar_35 = (tmpvar_31 * tmpvar_34);
  res_2.w = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_2 * tmpvar_36);
  res_2 = tmpvar_37;
  tmpvar_1 = tmpvar_37.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, tmpvar_14);
  mediump float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_18)) {
    tmpvar_20 = _LightShadowData.x;
  } else {
    tmpvar_20 = 1.0;
  };
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = texture (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = ((atten_6 * tmpvar_20) * tmpvar_22.w);
  atten_6 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_7, tmpvar_26));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_26)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = (spec_3 * clamp (tmpvar_24, 0.0, 1.0));
  spec_3 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * (tmpvar_27 * tmpvar_24));
  res_2.xyz = tmpvar_31;
  mediump vec3 c_32;
  c_32 = _LightColor.xyz;
  mediump float tmpvar_33;
  tmpvar_33 = dot (c_32, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_34;
  tmpvar_34 = (tmpvar_30 * tmpvar_33);
  res_2.w = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_36;
  tmpvar_36 = (res_2 * tmpvar_35);
  res_2 = tmpvar_36;
  tmpvar_1 = tmpvar_36.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_11;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_World2Shadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  highp vec2 P_28;
  P_28 = (tmpvar_27.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, P_28).x;
  shadowVals_26.x = tmpvar_29;
  highp vec2 P_30;
  P_30 = (tmpvar_27.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, P_30).x;
  shadowVals_26.y = tmpvar_31;
  highp vec2 P_32;
  P_32 = (tmpvar_27.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_26.z = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_27.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_26.w = tmpvar_35;
  bvec4 tmpvar_36;
  tmpvar_36 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_37;
  tmpvar_37 = _LightShadowData.xxxx;
  mediump float tmpvar_38;
  if (tmpvar_36.x) {
    tmpvar_38 = tmpvar_37.x;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if (tmpvar_36.y) {
    tmpvar_39 = tmpvar_37.y;
  } else {
    tmpvar_39 = 1.0;
  };
  mediump float tmpvar_40;
  if (tmpvar_36.z) {
    tmpvar_40 = tmpvar_37.z;
  } else {
    tmpvar_40 = 1.0;
  };
  mediump float tmpvar_41;
  if (tmpvar_36.w) {
    tmpvar_41 = tmpvar_37.w;
  } else {
    tmpvar_41 = 1.0;
  };
  mediump vec4 tmpvar_42;
  tmpvar_42.x = tmpvar_38;
  tmpvar_42.y = tmpvar_39;
  tmpvar_42.z = tmpvar_40;
  tmpvar_42.w = tmpvar_41;
  mediump float tmpvar_43;
  tmpvar_43 = dot (tmpvar_42, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_44;
  highp float tmpvar_45;
  tmpvar_45 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_45;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_46;
  mediump vec3 tmpvar_47;
  tmpvar_47 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_48;
  tmpvar_48 = max (0.0, dot (lightDir_7, tmpvar_47));
  highp vec3 tmpvar_49;
  tmpvar_49 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = pow (max (0.0, dot (h_4, tmpvar_47)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_50;
  highp float tmpvar_51;
  tmpvar_51 = (spec_3 * clamp (tmpvar_45, 0.0, 1.0));
  spec_3 = tmpvar_51;
  highp vec3 tmpvar_52;
  tmpvar_52 = (_LightColor.xyz * (tmpvar_48 * tmpvar_45));
  res_2.xyz = tmpvar_52;
  mediump vec3 c_53;
  c_53 = _LightColor.xyz;
  mediump float tmpvar_54;
  tmpvar_54 = dot (c_53, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_55;
  tmpvar_55 = (tmpvar_51 * tmpvar_54);
  res_2.w = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_57;
  tmpvar_57 = (res_2 * tmpvar_56);
  res_2 = tmpvar_57;
  tmpvar_1 = tmpvar_57.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = texture2DProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  lowp float tmpvar_30;
  tmpvar_30 = shadow2DEXT (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  lowp float tmpvar_32;
  tmpvar_32 = shadow2DEXT (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  lowp float tmpvar_34;
  tmpvar_34 = shadow2DEXT (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  tmpvar_1 = tmpvar_50.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_World2Shadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_14);
  lightDir_7 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  highp vec4 tmpvar_17;
  tmpvar_17 = (_LightMatrix0 * tmpvar_16);
  lowp float tmpvar_18;
  tmpvar_18 = textureProj (_LightTexture0, tmpvar_17).w;
  atten_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = ((atten_6 * float(
    (tmpvar_17.w < 0.0)
  )) * tmpvar_20.w);
  mediump float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  mediump vec4 shadows_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec3 coord_27;
  coord_27 = (tmpvar_26 + _ShadowOffsets[0].xyz);
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, coord_27);
  shadows_25.x = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_26 + _ShadowOffsets[1].xyz);
  mediump float tmpvar_30;
  tmpvar_30 = texture (_ShadowMapTexture, coord_29);
  shadows_25.y = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_26 + _ShadowOffsets[2].xyz);
  mediump float tmpvar_32;
  tmpvar_32 = texture (_ShadowMapTexture, coord_31);
  shadows_25.z = tmpvar_32;
  highp vec3 coord_33;
  coord_33 = (tmpvar_26 + _ShadowOffsets[3].xyz);
  mediump float tmpvar_34;
  tmpvar_34 = texture (_ShadowMapTexture, coord_33);
  shadows_25.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (_LightShadowData.xxxx + (shadows_25 * (1.0 - _LightShadowData.xxxx)));
  shadows_25 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_24 + clamp (
    ((tmpvar_13 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_21 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (atten_6 * tmpvar_21);
  atten_6 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_7, tmpvar_40));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (spec_3 * clamp (tmpvar_38, 0.0, 1.0));
  spec_3 = tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_LightColor.xyz * (tmpvar_41 * tmpvar_38));
  res_2.xyz = tmpvar_45;
  mediump vec3 c_46;
  c_46 = _LightColor.xyz;
  mediump float tmpvar_47;
  tmpvar_47 = dot (c_46, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_48;
  tmpvar_48 = (tmpvar_44 * tmpvar_47);
  res_2.w = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_50;
  tmpvar_50 = (res_2 * tmpvar_49);
  res_2 = tmpvar_50;
  tmpvar_1 = tmpvar_50.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  tmpvar_1 = tmpvar_44.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_32;
  tmpvar_32 = (atten_6 * tmpvar_31);
  atten_6 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_7, tmpvar_34));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_36;
  mediump float tmpvar_37;
  tmpvar_37 = pow (max (0.0, dot (h_4, tmpvar_34)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = (spec_3 * clamp (tmpvar_32, 0.0, 1.0));
  spec_3 = tmpvar_38;
  highp vec3 tmpvar_39;
  tmpvar_39 = (_LightColor.xyz * (tmpvar_35 * tmpvar_32));
  res_2.xyz = tmpvar_39;
  mediump vec3 c_40;
  c_40 = _LightColor.xyz;
  mediump float tmpvar_41;
  tmpvar_41 = dot (c_40, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_38 * tmpvar_41);
  res_2.w = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = (res_2 * tmpvar_43);
  res_2 = tmpvar_44;
  tmpvar_1 = tmpvar_44.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = textureCube (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  tmpvar_1 = tmpvar_47.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9 = texture (_CameraDepthTexture, tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_9.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_11;
  tmpvar_11 = (_CameraToWorld * tmpvar_10).xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = -(normalize(tmpvar_14));
  lightDir_7 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_14, tmpvar_14) * _LightPos.w);
  lowp float tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16)).w;
  atten_6 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float tmpvar_19;
  tmpvar_19 = ((sqrt(
    dot (tmpvar_14, tmpvar_14)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_18.x = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_18.y = tmpvar_21.x;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_18.z = tmpvar_22.x;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture (_ShadowMapTexture, (tmpvar_14 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_18.w = tmpvar_23.x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_18, vec4(tmpvar_19));
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = tmpvar_11;
  lowp vec4 tmpvar_33;
  highp vec3 P_34;
  P_34 = (_LightMatrix0 * tmpvar_32).xyz;
  tmpvar_33 = texture (_LightTexture0, P_34);
  highp float tmpvar_35;
  tmpvar_35 = ((atten_6 * tmpvar_31) * tmpvar_33.w);
  atten_6 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture (_CameraNormalsTexture, tmpvar_8);
  nspec_5 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_7, tmpvar_37));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((lightDir_7 - normalize(
    (tmpvar_11 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = (spec_3 * clamp (tmpvar_35, 0.0, 1.0));
  spec_3 = tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_LightColor.xyz * (tmpvar_38 * tmpvar_35));
  res_2.xyz = tmpvar_42;
  mediump vec3 c_43;
  c_43 = _LightColor.xyz;
  mediump float tmpvar_44;
  tmpvar_44 = dot (c_43, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_41 * tmpvar_44);
  res_2.w = tmpvar_45;
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_13 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_47;
  tmpvar_47 = (res_2 * tmpvar_46);
  res_2 = tmpvar_47;
  tmpvar_1 = tmpvar_47.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_14;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, dot (lightDir_6, tmpvar_19));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (spec_3 * clamp (tmpvar_17, 0.0, 1.0));
  spec_3 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * (tmpvar_20 * tmpvar_17));
  res_2.xyz = tmpvar_24;
  mediump vec3 c_25;
  c_25 = _LightColor.xyz;
  mediump float tmpvar_26;
  tmpvar_26 = dot (c_25, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_27;
  tmpvar_27 = (tmpvar_23 * tmpvar_26);
  res_2.w = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (res_2 * tmpvar_28);
  res_2 = tmpvar_29;
  tmpvar_1 = tmpvar_29.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp float _LightAsQuad;
out highp vec4 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((glstate_matrix_modelview0 * _glesVertex).xyz * vec3(-1.0, -1.0, 1.0)), _glesNormal, vec3(_LightAsQuad));
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform mediump vec4 unity_ColorSpaceLuminance;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8 = texture (_CameraDepthTexture, tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_8.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = (tmpvar_14 * tmpvar_18.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraNormalsTexture, tmpvar_7);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (spec_3 * clamp (tmpvar_20, 0.0, 1.0));
  spec_3 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * (tmpvar_23 * tmpvar_20));
  res_2.xyz = tmpvar_27;
  mediump vec3 c_28;
  c_28 = _LightColor.xyz;
  mediump float tmpvar_29;
  tmpvar_29 = dot (c_28, unity_ColorSpaceLuminance.xyz);
  highp float tmpvar_30;
  tmpvar_30 = (tmpvar_26 * tmpvar_29);
  res_2.w = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  mediump vec4 tmpvar_32;
  tmpvar_32 = (res_2 * tmpvar_31);
  res_2 = tmpvar_32;
  tmpvar_1 = tmpvar_32.wxyz;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3"
}
}
 }
}
Fallback Off
}