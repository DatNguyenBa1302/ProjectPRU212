//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredShading" {
Properties {
 _LightTexture0 ("", any) = "" { }
 _LightTextureB0 ("", 2D) = "" { }
 _ShadowMapTexture ("", any) = "" { }
 _SrcBlend ("", Float) = 1
 _DstBlend ("", Float) = 1
}
SubShader { 
 Pass {
  Tags { "SHADOWSUPPORT"="true" }
  ZWrite Off
  Blend [_SrcBlend] [_DstBlend]
  GpuProgramID 36028
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * atten_6);
  tmpvar_5 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_7, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_3.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_20, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * atten_6);
  tmpvar_5 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_7, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_3.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_20, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = _LightColor.xyz;
  tmpvar_5 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(((_CameraToWorld * tmpvar_9).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_17;
  viewDir_17 = -(tmpvar_16);
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_6 + viewDir_17));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = (10.0 / log2((
    ((1.0 - tmpvar_20) * 0.968)
   + 0.03)));
  tmpvar_21 = (tmpvar_22 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_21 + 1.0) * pow (
      max (0.0, dot (tmpvar_15, tmpvar_18))
    , tmpvar_21)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_19 * tmpvar_19) * gbuffer1_3.w) + (tmpvar_20 * tmpvar_20)))
     * tmpvar_19) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_15, lightDir_6)));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = _LightColor.xyz;
  tmpvar_5 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(((_CameraToWorld * tmpvar_9).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_17;
  viewDir_17 = -(tmpvar_16);
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_6 + viewDir_17));
  mediump float tmpvar_19;
  tmpvar_19 = max (0.0, dot (lightDir_6, tmpvar_18));
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = (10.0 / log2((
    ((1.0 - tmpvar_20) * 0.968)
   + 0.03)));
  tmpvar_21 = (tmpvar_22 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_21 + 1.0) * pow (
      max (0.0, dot (tmpvar_15, tmpvar_18))
    , tmpvar_21)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_19 * tmpvar_19) * gbuffer1_3.w) + (tmpvar_20 * tmpvar_20)))
     * tmpvar_19) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_15, lightDir_6)));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_11;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_LightTexture0, tmpvar_15).w;
  atten_6 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  highp float tmpvar_19;
  tmpvar_19 = ((atten_6 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  atten_6 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_7 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_3.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_24, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_11);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_11;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = textureProj (_LightTexture0, tmpvar_15).w;
  atten_6 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_LightTextureB0, vec2(tmpvar_17));
  highp float tmpvar_19;
  tmpvar_19 = ((atten_6 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  atten_6 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_7 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_3.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_24, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  lowp vec4 tmpvar_17;
  highp vec3 P_18;
  P_18 = (_LightMatrix0 * tmpvar_16).xyz;
  tmpvar_17 = textureCube (_LightTexture0, P_18);
  highp float tmpvar_19;
  tmpvar_19 = (atten_6 * tmpvar_17.w);
  atten_6 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_7 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_3.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_24, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_11;
  lowp vec4 tmpvar_17;
  highp vec3 P_18;
  P_18 = (_LightMatrix0 * tmpvar_16).xyz;
  tmpvar_17 = texture (_LightTexture0, P_18);
  highp float tmpvar_19;
  tmpvar_19 = (atten_6 * tmpvar_17.w);
  atten_6 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_7 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_3.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_24, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  lowp vec4 tmpvar_13;
  highp vec2 P_14;
  P_14 = (_LightMatrix0 * tmpvar_12).xy;
  tmpvar_13 = texture2D (_LightTexture0, P_14);
  highp float tmpvar_15;
  tmpvar_15 = tmpvar_13.w;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  tmpvar_5 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_6 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_6, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_3.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_20, lightDir_6)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  lowp vec4 tmpvar_13;
  highp vec2 P_14;
  P_14 = (_LightMatrix0 * tmpvar_12).xy;
  tmpvar_13 = texture (_LightTexture0, P_14);
  highp float tmpvar_15;
  tmpvar_15 = tmpvar_13.w;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  tmpvar_5 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_6 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_6, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_3.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_20, lightDir_6)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_ShadowMapTexture, tmpvar_23);
  mediump float tmpvar_26;
  if ((tmpvar_25.x < (tmpvar_23.z / tmpvar_23.w))) {
    tmpvar_26 = _LightShadowData.x;
  } else {
    tmpvar_26 = 1.0;
  };
  tmpvar_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((tmpvar_24 + tmpvar_21), 0.0, 1.0);
  tmpvar_20 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_LightColor.xyz * tmpvar_28);
  tmpvar_5 = tmpvar_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_34;
  tmpvar_34 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_35;
  viewDir_35 = -(tmpvar_34);
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 + viewDir_35));
  mediump float tmpvar_37;
  tmpvar_37 = max (0.0, dot (lightDir_7, tmpvar_36));
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = (10.0 / log2((
    ((1.0 - tmpvar_38) * 0.968)
   + 0.03)));
  tmpvar_39 = (tmpvar_40 * tmpvar_40);
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_39 + 1.0) * pow (
      max (0.0, dot (tmpvar_33, tmpvar_36))
    , tmpvar_39)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_37 * tmpvar_37) * gbuffer1_3.w) + (tmpvar_38 * tmpvar_38)))
     * tmpvar_37) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_33, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = shadow2DProjEXT (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  tmpvar_25 = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = (_LightShadowData.x + (tmpvar_25 * (1.0 - _LightShadowData.x)));
  tmpvar_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp ((tmpvar_23 + clamp (
    ((mix (tmpvar_10.z, sqrt(
      dot (tmpvar_12, tmpvar_12)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_20 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (_LightColor.xyz * tmpvar_28);
  tmpvar_5 = tmpvar_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_34;
  tmpvar_34 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_35;
  viewDir_35 = -(tmpvar_34);
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize((lightDir_7 + viewDir_35));
  mediump float tmpvar_37;
  tmpvar_37 = max (0.0, dot (lightDir_7, tmpvar_36));
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = (10.0 / log2((
    ((1.0 - tmpvar_38) * 0.968)
   + 0.03)));
  tmpvar_39 = (tmpvar_40 * tmpvar_40);
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_39 + 1.0) * pow (
      max (0.0, dot (tmpvar_33, tmpvar_36))
    , tmpvar_39)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_37 * tmpvar_37) * gbuffer1_3.w) + (tmpvar_38 * tmpvar_38)))
     * tmpvar_37) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_33, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = textureProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  tmpvar_25 = (_LightShadowData.x + (tmpvar_24 * (1.0 - _LightShadowData.x)));
  tmpvar_23 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((tmpvar_23 + clamp (
    ((mix (tmpvar_10.z, sqrt(
      dot (tmpvar_12, tmpvar_12)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_20 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * tmpvar_27);
  tmpvar_5 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_7 + viewDir_34));
  mediump float tmpvar_36;
  tmpvar_36 = max (0.0, dot (lightDir_7, tmpvar_35));
  mediump float tmpvar_37;
  tmpvar_37 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = (10.0 / log2((
    ((1.0 - tmpvar_37) * 0.968)
   + 0.03)));
  tmpvar_38 = (tmpvar_39 * tmpvar_39);
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_38 + 1.0) * pow (
      max (0.0, dot (tmpvar_32, tmpvar_35))
    , tmpvar_38)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_36 * tmpvar_36) * gbuffer1_3.w) + (tmpvar_37 * tmpvar_37)))
     * tmpvar_36) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_32, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_13;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (_LightColor.xyz * tmpvar_16);
  tmpvar_5 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 + viewDir_23));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_6, tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (10.0 / log2((
    ((1.0 - tmpvar_26) * 0.968)
   + 0.03)));
  tmpvar_27 = (tmpvar_28 * tmpvar_28);
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_27 + 1.0) * pow (
      max (0.0, dot (tmpvar_21, tmpvar_24))
    , tmpvar_27)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_25 * tmpvar_25) * gbuffer1_3.w) + (tmpvar_26 * tmpvar_26)))
     * tmpvar_25) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_21, lightDir_6)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = (_LightMatrix0 * tmpvar_16).xy;
  tmpvar_17 = texture2D (_LightTexture0, P_18);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * (tmpvar_13 * tmpvar_17.w));
  tmpvar_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_3.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_23, lightDir_6)));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_17, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < tmpvar_16)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  highp float tmpvar_20;
  tmpvar_20 = (atten_6 * tmpvar_19);
  atten_6 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_LightColor.xyz * tmpvar_20);
  tmpvar_5 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_27;
  viewDir_27 = -(tmpvar_26);
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 + viewDir_27));
  mediump float tmpvar_29;
  tmpvar_29 = max (0.0, dot (lightDir_7, tmpvar_28));
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = (10.0 / log2((
    ((1.0 - tmpvar_30) * 0.968)
   + 0.03)));
  tmpvar_31 = (tmpvar_32 * tmpvar_32);
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_31 + 1.0) * pow (
      max (0.0, dot (tmpvar_25, tmpvar_28))
    , tmpvar_31)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_29 * tmpvar_29) * gbuffer1_3.w) + (tmpvar_30 * tmpvar_30)))
     * tmpvar_29) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_25, lightDir_7)));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = texture (_ShadowMapTexture, tmpvar_12);
  mediump float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16)) {
    tmpvar_18 = _LightShadowData.x;
  } else {
    tmpvar_18 = 1.0;
  };
  highp float tmpvar_19;
  tmpvar_19 = (atten_6 * tmpvar_18);
  atten_6 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_5 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_7 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_7, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_3.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_24, lightDir_7)));
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_17, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < tmpvar_16)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_11;
  lowp vec4 tmpvar_21;
  highp vec3 P_22;
  P_22 = (_LightMatrix0 * tmpvar_20).xyz;
  tmpvar_21 = textureCube (_LightTexture0, P_22);
  highp float tmpvar_23;
  tmpvar_23 = ((atten_6 * tmpvar_19) * tmpvar_21.w);
  atten_6 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (_LightColor.xyz * tmpvar_23);
  tmpvar_5 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize((lightDir_7 + viewDir_30));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, dot (lightDir_7, tmpvar_31));
  mediump float tmpvar_33;
  tmpvar_33 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = (10.0 / log2((
    ((1.0 - tmpvar_33) * 0.968)
   + 0.03)));
  tmpvar_34 = (tmpvar_35 * tmpvar_35);
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_34 + 1.0) * pow (
      max (0.0, dot (tmpvar_28, tmpvar_31))
    , tmpvar_34)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_32 * tmpvar_32) * gbuffer1_3.w) + (tmpvar_33 * tmpvar_33)))
     * tmpvar_32) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_28, lightDir_7)));
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = texture (_ShadowMapTexture, tmpvar_12);
  mediump float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16)) {
    tmpvar_18 = _LightShadowData.x;
  } else {
    tmpvar_18 = 1.0;
  };
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_11;
  lowp vec4 tmpvar_20;
  highp vec3 P_21;
  P_21 = (_LightMatrix0 * tmpvar_19).xyz;
  tmpvar_20 = texture (_LightTexture0, P_21);
  highp float tmpvar_22;
  tmpvar_22 = ((atten_6 * tmpvar_18) * tmpvar_20.w);
  atten_6 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (_LightColor.xyz * tmpvar_22);
  tmpvar_5 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 + viewDir_29));
  mediump float tmpvar_31;
  tmpvar_31 = max (0.0, dot (lightDir_7, tmpvar_30));
  mediump float tmpvar_32;
  tmpvar_32 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = (10.0 / log2((
    ((1.0 - tmpvar_32) * 0.968)
   + 0.03)));
  tmpvar_33 = (tmpvar_34 * tmpvar_34);
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_33 + 1.0) * pow (
      max (0.0, dot (tmpvar_27, tmpvar_30))
    , tmpvar_33)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_31 * tmpvar_31) * gbuffer1_3.w) + (tmpvar_32 * tmpvar_32)))
     * tmpvar_31) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_27, lightDir_7)));
  mediump vec4 tmpvar_36;
  tmpvar_36 = exp2(-(tmpvar_35));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_10.z, sqrt(dot (tmpvar_12, tmpvar_12)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_11;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_World2Shadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 shadowVals_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  highp vec2 P_27;
  P_27 = (tmpvar_26.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_28;
  tmpvar_28 = texture2D (_ShadowMapTexture, P_27).x;
  shadowVals_25.x = tmpvar_28;
  highp vec2 P_29;
  P_29 = (tmpvar_26.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, P_29).x;
  shadowVals_25.y = tmpvar_30;
  highp vec2 P_31;
  P_31 = (tmpvar_26.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, P_31).x;
  shadowVals_25.z = tmpvar_32;
  highp vec2 P_33;
  P_33 = (tmpvar_26.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, P_33).x;
  shadowVals_25.w = tmpvar_34;
  bvec4 tmpvar_35;
  tmpvar_35 = lessThan (shadowVals_25, tmpvar_26.zzzz);
  mediump vec4 tmpvar_36;
  tmpvar_36 = _LightShadowData.xxxx;
  mediump float tmpvar_37;
  if (tmpvar_35.x) {
    tmpvar_37 = tmpvar_36.x;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump float tmpvar_38;
  if (tmpvar_35.y) {
    tmpvar_38 = tmpvar_36.y;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if (tmpvar_35.z) {
    tmpvar_39 = tmpvar_36.z;
  } else {
    tmpvar_39 = 1.0;
  };
  mediump float tmpvar_40;
  if (tmpvar_35.w) {
    tmpvar_40 = tmpvar_36.w;
  } else {
    tmpvar_40 = 1.0;
  };
  mediump vec4 tmpvar_41;
  tmpvar_41.x = tmpvar_37;
  tmpvar_41.y = tmpvar_38;
  tmpvar_41.z = tmpvar_39;
  tmpvar_41.w = tmpvar_40;
  mediump float tmpvar_42;
  tmpvar_42 = dot (tmpvar_41, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp ((tmpvar_24 + tmpvar_21), 0.0, 1.0);
  tmpvar_20 = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_44;
  lowp vec4 tmpvar_45;
  tmpvar_45 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_45;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_46;
  lowp vec4 tmpvar_47;
  tmpvar_47 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_47;
  highp vec3 tmpvar_48;
  tmpvar_48 = (_LightColor.xyz * tmpvar_44);
  tmpvar_5 = tmpvar_48;
  mediump vec3 tmpvar_49;
  tmpvar_49 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_50;
  tmpvar_50 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_51;
  viewDir_51 = -(tmpvar_50);
  mediump vec3 tmpvar_52;
  tmpvar_52 = normalize((lightDir_7 + viewDir_51));
  mediump float tmpvar_53;
  tmpvar_53 = max (0.0, dot (lightDir_7, tmpvar_52));
  mediump float tmpvar_54;
  tmpvar_54 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_55;
  mediump float tmpvar_56;
  tmpvar_56 = (10.0 / log2((
    ((1.0 - tmpvar_54) * 0.968)
   + 0.03)));
  tmpvar_55 = (tmpvar_56 * tmpvar_56);
  mediump vec4 tmpvar_57;
  tmpvar_57.w = 1.0;
  tmpvar_57.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_55 + 1.0) * pow (
      max (0.0, dot (tmpvar_49, tmpvar_52))
    , tmpvar_55)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_53 * tmpvar_53) * gbuffer1_3.w) + (tmpvar_54 * tmpvar_54)))
     * tmpvar_53) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_49, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  mediump vec4 shadows_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  highp vec3 coord_26;
  coord_26 = (tmpvar_25 + _ShadowOffsets[0].xyz);
  lowp float tmpvar_27;
  tmpvar_27 = shadow2DEXT (_ShadowMapTexture, coord_26);
  shadows_24.x = tmpvar_27;
  highp vec3 coord_28;
  coord_28 = (tmpvar_25 + _ShadowOffsets[1].xyz);
  lowp float tmpvar_29;
  tmpvar_29 = shadow2DEXT (_ShadowMapTexture, coord_28);
  shadows_24.y = tmpvar_29;
  highp vec3 coord_30;
  coord_30 = (tmpvar_25 + _ShadowOffsets[2].xyz);
  lowp float tmpvar_31;
  tmpvar_31 = shadow2DEXT (_ShadowMapTexture, coord_30);
  shadows_24.z = tmpvar_31;
  highp vec3 coord_32;
  coord_32 = (tmpvar_25 + _ShadowOffsets[3].xyz);
  lowp float tmpvar_33;
  tmpvar_33 = shadow2DEXT (_ShadowMapTexture, coord_32);
  shadows_24.w = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (_LightShadowData.xxxx + (shadows_24 * (1.0 - _LightShadowData.xxxx)));
  shadows_24 = tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((tmpvar_23 + clamp (
    ((mix (tmpvar_10.z, sqrt(
      dot (tmpvar_12, tmpvar_12)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_20 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (_LightColor.xyz * tmpvar_37);
  tmpvar_5 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_44;
  viewDir_44 = -(tmpvar_43);
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 + viewDir_44));
  mediump float tmpvar_46;
  tmpvar_46 = max (0.0, dot (lightDir_7, tmpvar_45));
  mediump float tmpvar_47;
  tmpvar_47 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = (10.0 / log2((
    ((1.0 - tmpvar_47) * 0.968)
   + 0.03)));
  tmpvar_48 = (tmpvar_49 * tmpvar_49);
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_48 + 1.0) * pow (
      max (0.0, dot (tmpvar_42, tmpvar_45))
    , tmpvar_48)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_46 * tmpvar_46) * gbuffer1_3.w) + (tmpvar_47 * tmpvar_47)))
     * tmpvar_46) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_42, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  atten_6 = ((atten_6 * float(
    (tmpvar_16.w < 0.0)
  )) * tmpvar_19.w);
  mediump float tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_11;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  mediump vec4 shadows_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  highp vec3 coord_26;
  coord_26 = (tmpvar_25 + _ShadowOffsets[0].xyz);
  mediump float tmpvar_27;
  tmpvar_27 = texture (_ShadowMapTexture, coord_26);
  shadows_24.x = tmpvar_27;
  highp vec3 coord_28;
  coord_28 = (tmpvar_25 + _ShadowOffsets[1].xyz);
  mediump float tmpvar_29;
  tmpvar_29 = texture (_ShadowMapTexture, coord_28);
  shadows_24.y = tmpvar_29;
  highp vec3 coord_30;
  coord_30 = (tmpvar_25 + _ShadowOffsets[2].xyz);
  mediump float tmpvar_31;
  tmpvar_31 = texture (_ShadowMapTexture, coord_30);
  shadows_24.z = tmpvar_31;
  highp vec3 coord_32;
  coord_32 = (tmpvar_25 + _ShadowOffsets[3].xyz);
  mediump float tmpvar_33;
  tmpvar_33 = texture (_ShadowMapTexture, coord_32);
  shadows_24.w = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (_LightShadowData.xxxx + (shadows_24 * (1.0 - _LightShadowData.xxxx)));
  shadows_24 = tmpvar_34;
  mediump float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((tmpvar_23 + clamp (
    ((mix (tmpvar_10.z, sqrt(
      dot (tmpvar_12, tmpvar_12)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_20 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (atten_6 * tmpvar_20);
  atten_6 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (_LightColor.xyz * tmpvar_37);
  tmpvar_5 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_44;
  viewDir_44 = -(tmpvar_43);
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 + viewDir_44));
  mediump float tmpvar_46;
  tmpvar_46 = max (0.0, dot (lightDir_7, tmpvar_45));
  mediump float tmpvar_47;
  tmpvar_47 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = (10.0 / log2((
    ((1.0 - tmpvar_47) * 0.968)
   + 0.03)));
  tmpvar_48 = (tmpvar_49 * tmpvar_49);
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_48 + 1.0) * pow (
      max (0.0, dot (tmpvar_42, tmpvar_45))
    , tmpvar_48)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_46 * tmpvar_46) * gbuffer1_3.w) + (tmpvar_47 * tmpvar_47)))
     * tmpvar_46) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_42, lightDir_7)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_16.x = dot (tmpvar_18, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_16.y = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_16.z = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_16.w = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_22;
  tmpvar_22 = lessThan (shadowVals_16, vec4(tmpvar_17));
  mediump vec4 tmpvar_23;
  tmpvar_23 = _LightShadowData.xxxx;
  mediump float tmpvar_24;
  if (tmpvar_22.x) {
    tmpvar_24 = tmpvar_23.x;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_22.y) {
    tmpvar_25 = tmpvar_23.y;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_22.z) {
    tmpvar_26 = tmpvar_23.z;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_22.w) {
    tmpvar_27 = tmpvar_23.w;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump vec4 tmpvar_28;
  tmpvar_28.x = tmpvar_24;
  tmpvar_28.y = tmpvar_25;
  tmpvar_28.z = tmpvar_26;
  tmpvar_28.w = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = dot (tmpvar_28, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_30;
  tmpvar_30 = (atten_6 * tmpvar_29);
  atten_6 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_LightColor.xyz * tmpvar_30);
  tmpvar_5 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_37;
  viewDir_37 = -(tmpvar_36);
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 + viewDir_37));
  mediump float tmpvar_39;
  tmpvar_39 = max (0.0, dot (lightDir_7, tmpvar_38));
  mediump float tmpvar_40;
  tmpvar_40 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = (10.0 / log2((
    ((1.0 - tmpvar_40) * 0.968)
   + 0.03)));
  tmpvar_41 = (tmpvar_42 * tmpvar_42);
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_41 + 1.0) * pow (
      max (0.0, dot (tmpvar_35, tmpvar_38))
    , tmpvar_41)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_39 * tmpvar_39) * gbuffer1_3.w) + (tmpvar_40 * tmpvar_40)))
     * tmpvar_39) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_35, lightDir_7)));
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_18;
  tmpvar_18 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_16.x = tmpvar_18.x;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_16.y = tmpvar_19.x;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_16.z = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_16.w = tmpvar_21.x;
  bvec4 tmpvar_22;
  tmpvar_22 = lessThan (shadowVals_16, vec4(tmpvar_17));
  mediump vec4 tmpvar_23;
  tmpvar_23 = _LightShadowData.xxxx;
  mediump float tmpvar_24;
  if (tmpvar_22.x) {
    tmpvar_24 = tmpvar_23.x;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_22.y) {
    tmpvar_25 = tmpvar_23.y;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_22.z) {
    tmpvar_26 = tmpvar_23.z;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_22.w) {
    tmpvar_27 = tmpvar_23.w;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump vec4 tmpvar_28;
  tmpvar_28.x = tmpvar_24;
  tmpvar_28.y = tmpvar_25;
  tmpvar_28.z = tmpvar_26;
  tmpvar_28.w = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = dot (tmpvar_28, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_30;
  tmpvar_30 = (atten_6 * tmpvar_29);
  atten_6 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_LightColor.xyz * tmpvar_30);
  tmpvar_5 = tmpvar_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_36;
  tmpvar_36 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_37;
  viewDir_37 = -(tmpvar_36);
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 + viewDir_37));
  mediump float tmpvar_39;
  tmpvar_39 = max (0.0, dot (lightDir_7, tmpvar_38));
  mediump float tmpvar_40;
  tmpvar_40 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = (10.0 / log2((
    ((1.0 - tmpvar_40) * 0.968)
   + 0.03)));
  tmpvar_41 = (tmpvar_42 * tmpvar_42);
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_41 + 1.0) * pow (
      max (0.0, dot (tmpvar_35, tmpvar_38))
    , tmpvar_41)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_39 * tmpvar_39) * gbuffer1_3.w) + (tmpvar_40 * tmpvar_40)))
     * tmpvar_39) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_35, lightDir_7)));
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_16.x = dot (tmpvar_18, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_16.y = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_16.z = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_16.w = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_22;
  tmpvar_22 = lessThan (shadowVals_16, vec4(tmpvar_17));
  mediump vec4 tmpvar_23;
  tmpvar_23 = _LightShadowData.xxxx;
  mediump float tmpvar_24;
  if (tmpvar_22.x) {
    tmpvar_24 = tmpvar_23.x;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_22.y) {
    tmpvar_25 = tmpvar_23.y;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_22.z) {
    tmpvar_26 = tmpvar_23.z;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_22.w) {
    tmpvar_27 = tmpvar_23.w;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump vec4 tmpvar_28;
  tmpvar_28.x = tmpvar_24;
  tmpvar_28.y = tmpvar_25;
  tmpvar_28.z = tmpvar_26;
  tmpvar_28.w = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = dot (tmpvar_28, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = tmpvar_11;
  lowp vec4 tmpvar_31;
  highp vec3 P_32;
  P_32 = (_LightMatrix0 * tmpvar_30).xyz;
  tmpvar_31 = textureCube (_LightTexture0, P_32);
  highp float tmpvar_33;
  tmpvar_33 = ((atten_6 * tmpvar_29) * tmpvar_31.w);
  atten_6 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (_LightColor.xyz * tmpvar_33);
  tmpvar_5 = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_40;
  viewDir_40 = -(tmpvar_39);
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 + viewDir_40));
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, dot (lightDir_7, tmpvar_41));
  mediump float tmpvar_43;
  tmpvar_43 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = (10.0 / log2((
    ((1.0 - tmpvar_43) * 0.968)
   + 0.03)));
  tmpvar_44 = (tmpvar_45 * tmpvar_45);
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_44 + 1.0) * pow (
      max (0.0, dot (tmpvar_38, tmpvar_41))
    , tmpvar_44)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_42 * tmpvar_42) * gbuffer1_3.w) + (tmpvar_43 * tmpvar_43)))
     * tmpvar_42) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_38, lightDir_7)));
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(tmpvar_46));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_12 = (tmpvar_11 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float tmpvar_17;
  tmpvar_17 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_18;
  tmpvar_18 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_16.x = tmpvar_18.x;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_16.y = tmpvar_19.x;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_16.z = tmpvar_20.x;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture (_ShadowMapTexture, (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_16.w = tmpvar_21.x;
  bvec4 tmpvar_22;
  tmpvar_22 = lessThan (shadowVals_16, vec4(tmpvar_17));
  mediump vec4 tmpvar_23;
  tmpvar_23 = _LightShadowData.xxxx;
  mediump float tmpvar_24;
  if (tmpvar_22.x) {
    tmpvar_24 = tmpvar_23.x;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_22.y) {
    tmpvar_25 = tmpvar_23.y;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_22.z) {
    tmpvar_26 = tmpvar_23.z;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_22.w) {
    tmpvar_27 = tmpvar_23.w;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump vec4 tmpvar_28;
  tmpvar_28.x = tmpvar_24;
  tmpvar_28.y = tmpvar_25;
  tmpvar_28.z = tmpvar_26;
  tmpvar_28.w = tmpvar_27;
  mediump float tmpvar_29;
  tmpvar_29 = dot (tmpvar_28, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = tmpvar_11;
  lowp vec4 tmpvar_31;
  highp vec3 P_32;
  P_32 = (_LightMatrix0 * tmpvar_30).xyz;
  tmpvar_31 = texture (_LightTexture0, P_32);
  highp float tmpvar_33;
  tmpvar_33 = ((atten_6 * tmpvar_29) * tmpvar_31.w);
  atten_6 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (_LightColor.xyz * tmpvar_33);
  tmpvar_5 = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_39;
  tmpvar_39 = normalize((tmpvar_11 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_40;
  viewDir_40 = -(tmpvar_39);
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 + viewDir_40));
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, dot (lightDir_7, tmpvar_41));
  mediump float tmpvar_43;
  tmpvar_43 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = (10.0 / log2((
    ((1.0 - tmpvar_43) * 0.968)
   + 0.03)));
  tmpvar_44 = (tmpvar_45 * tmpvar_45);
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_44 + 1.0) * pow (
      max (0.0, dot (tmpvar_38, tmpvar_41))
    , tmpvar_44)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_42 * tmpvar_42) * gbuffer1_3.w) + (tmpvar_43 * tmpvar_43)))
     * tmpvar_42) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_38, lightDir_7)));
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(tmpvar_46));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_13;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (_LightColor.xyz * tmpvar_16);
  tmpvar_5 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 + viewDir_23));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_6, tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (10.0 / log2((
    ((1.0 - tmpvar_26) * 0.968)
   + 0.03)));
  tmpvar_27 = (tmpvar_28 * tmpvar_28);
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_27 + 1.0) * pow (
      max (0.0, dot (tmpvar_21, tmpvar_24))
    , tmpvar_27)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_25 * tmpvar_25) * gbuffer1_3.w) + (tmpvar_26 * tmpvar_26)))
     * tmpvar_25) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_21, lightDir_6)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_13;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (_LightColor.xyz * tmpvar_16);
  tmpvar_5 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_6 + viewDir_23));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (lightDir_6, tmpvar_24));
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (10.0 / log2((
    ((1.0 - tmpvar_26) * 0.968)
   + 0.03)));
  tmpvar_27 = (tmpvar_28 * tmpvar_28);
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_27 + 1.0) * pow (
      max (0.0, dot (tmpvar_21, tmpvar_24))
    , tmpvar_27)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_25 * tmpvar_25) * gbuffer1_3.w) + (tmpvar_26 * tmpvar_26)))
     * tmpvar_25) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_21, lightDir_6)));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = (_LightMatrix0 * tmpvar_16).xy;
  tmpvar_17 = texture2D (_LightTexture0, P_18);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * (tmpvar_13 * tmpvar_17.w));
  tmpvar_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_3.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_23, lightDir_6)));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = (_LightMatrix0 * tmpvar_16).xy;
  tmpvar_17 = texture (_LightTexture0, P_18);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * (tmpvar_13 * tmpvar_17.w));
  tmpvar_5 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_3.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_3.xyz)
  ) * tmpvar_5) * max (0.0, dot (tmpvar_23, lightDir_6)));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightColor.xyz * atten_5);
  tmpvar_4 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_6 + viewDir_21));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (10.0 / log2((
    ((1.0 - tmpvar_24) * 0.968)
   + 0.03)));
  tmpvar_25 = (tmpvar_26 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_25 + 1.0) * pow (
      max (0.0, dot (tmpvar_19, tmpvar_22))
    , tmpvar_25)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_23 * tmpvar_23) * gbuffer1_2.w) + (tmpvar_24 * tmpvar_24)))
     * tmpvar_23) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_19, lightDir_6)));
  gl_FragData[0] = tmpvar_27;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightColor.xyz * atten_5);
  tmpvar_4 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_6 + viewDir_21));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_6, tmpvar_22));
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (10.0 / log2((
    ((1.0 - tmpvar_24) * 0.968)
   + 0.03)));
  tmpvar_25 = (tmpvar_26 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_25 + 1.0) * pow (
      max (0.0, dot (tmpvar_19, tmpvar_22))
    , tmpvar_25)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_23 * tmpvar_23) * gbuffer1_2.w) + (tmpvar_24 * tmpvar_24)))
     * tmpvar_23) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_19, lightDir_6)));
  _glesFragData[0] = tmpvar_27;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _LightColor.xyz;
  tmpvar_4 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(((_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_16;
  viewDir_16 = -(tmpvar_15);
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_5 + viewDir_16));
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (lightDir_5, tmpvar_17));
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (10.0 / log2((
    ((1.0 - tmpvar_19) * 0.968)
   + 0.03)));
  tmpvar_20 = (tmpvar_21 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_20 + 1.0) * pow (
      max (0.0, dot (tmpvar_14, tmpvar_17))
    , tmpvar_20)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_18 * tmpvar_18) * gbuffer1_2.w) + (tmpvar_19 * tmpvar_19)))
     * tmpvar_18) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_14, lightDir_5)));
  gl_FragData[0] = tmpvar_22;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _LightColor.xyz;
  tmpvar_4 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(((_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_16;
  viewDir_16 = -(tmpvar_15);
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_5 + viewDir_16));
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, dot (lightDir_5, tmpvar_17));
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (10.0 / log2((
    ((1.0 - tmpvar_19) * 0.968)
   + 0.03)));
  tmpvar_20 = (tmpvar_21 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_20 + 1.0) * pow (
      max (0.0, dot (tmpvar_14, tmpvar_17))
    , tmpvar_20)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_18 * tmpvar_18) * gbuffer1_2.w) + (tmpvar_19 * tmpvar_19)))
     * tmpvar_18) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_14, lightDir_5)));
  _glesFragData[0] = tmpvar_22;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (_LightMatrix0 * tmpvar_13);
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_LightTexture0, tmpvar_14).w;
  atten_5 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTextureB0, vec2(tmpvar_16));
  highp float tmpvar_18;
  tmpvar_18 = ((atten_5 * float(
    (tmpvar_14.w < 0.0)
  )) * tmpvar_17.w);
  atten_5 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * tmpvar_18);
  tmpvar_4 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_2.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_23, lightDir_6)));
  gl_FragData[0] = tmpvar_31;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (_LightMatrix0 * tmpvar_13);
  lowp float tmpvar_15;
  tmpvar_15 = textureProj (_LightTexture0, tmpvar_14).w;
  atten_5 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_LightTextureB0, vec2(tmpvar_16));
  highp float tmpvar_18;
  tmpvar_18 = ((atten_5 * float(
    (tmpvar_14.w < 0.0)
  )) * tmpvar_17.w);
  atten_5 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * tmpvar_18);
  tmpvar_4 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_2.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_23, lightDir_6)));
  _glesFragData[0] = tmpvar_31;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  lowp vec4 tmpvar_16;
  highp vec3 P_17;
  P_17 = (_LightMatrix0 * tmpvar_15).xyz;
  tmpvar_16 = textureCube (_LightTexture0, P_17);
  highp float tmpvar_18;
  tmpvar_18 = (atten_5 * tmpvar_16.w);
  atten_5 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * tmpvar_18);
  tmpvar_4 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_2.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_23, lightDir_6)));
  gl_FragData[0] = tmpvar_31;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  lowp vec4 tmpvar_16;
  highp vec3 P_17;
  P_17 = (_LightMatrix0 * tmpvar_15).xyz;
  tmpvar_16 = texture (_LightTexture0, P_17);
  highp float tmpvar_18;
  tmpvar_18 = (atten_5 * tmpvar_16.w);
  atten_5 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * tmpvar_18);
  tmpvar_4 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_2.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_23, lightDir_6)));
  _glesFragData[0] = tmpvar_31;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = (_LightMatrix0 * tmpvar_11).xy;
  tmpvar_12 = texture2D (_LightTexture0, P_13);
  highp float tmpvar_14;
  tmpvar_14 = tmpvar_12.w;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightColor.xyz * tmpvar_14);
  tmpvar_4 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_5 + viewDir_21));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_5, tmpvar_22));
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (10.0 / log2((
    ((1.0 - tmpvar_24) * 0.968)
   + 0.03)));
  tmpvar_25 = (tmpvar_26 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_25 + 1.0) * pow (
      max (0.0, dot (tmpvar_19, tmpvar_22))
    , tmpvar_25)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_23 * tmpvar_23) * gbuffer1_2.w) + (tmpvar_24 * tmpvar_24)))
     * tmpvar_23) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_19, lightDir_5)));
  gl_FragData[0] = tmpvar_27;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = (_LightMatrix0 * tmpvar_11).xy;
  tmpvar_12 = texture (_LightTexture0, P_13);
  highp float tmpvar_14;
  tmpvar_14 = tmpvar_12.w;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightColor.xyz * tmpvar_14);
  tmpvar_4 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_5 + viewDir_21));
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, dot (lightDir_5, tmpvar_22));
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (10.0 / log2((
    ((1.0 - tmpvar_24) * 0.968)
   + 0.03)));
  tmpvar_25 = (tmpvar_26 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_25 + 1.0) * pow (
      max (0.0, dot (tmpvar_19, tmpvar_22))
    , tmpvar_25)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_23 * tmpvar_23) * gbuffer1_2.w) + (tmpvar_24 * tmpvar_24)))
     * tmpvar_23) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_19, lightDir_5)));
  _glesFragData[0] = tmpvar_27;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" "SHADOWS_NONATIVE" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((tmpvar_23 + tmpvar_20), 0.0, 1.0);
  tmpvar_19 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * tmpvar_27);
  tmpvar_4 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_6 + viewDir_34));
  mediump float tmpvar_36;
  tmpvar_36 = max (0.0, dot (lightDir_6, tmpvar_35));
  mediump float tmpvar_37;
  tmpvar_37 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = (10.0 / log2((
    ((1.0 - tmpvar_37) * 0.968)
   + 0.03)));
  tmpvar_38 = (tmpvar_39 * tmpvar_39);
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_38 + 1.0) * pow (
      max (0.0, dot (tmpvar_32, tmpvar_35))
    , tmpvar_38)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_36 * tmpvar_36) * gbuffer1_2.w) + (tmpvar_37 * tmpvar_37)))
     * tmpvar_36) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_32, lightDir_6)));
  gl_FragData[0] = tmpvar_40;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_World2Shadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = shadow2DProjEXT (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  tmpvar_24 = tmpvar_23;
  mediump float tmpvar_25;
  tmpvar_25 = (_LightShadowData.x + (tmpvar_24 * (1.0 - _LightShadowData.x)));
  tmpvar_22 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((tmpvar_22 + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_19 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (_LightColor.xyz * tmpvar_27);
  tmpvar_4 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_6 + viewDir_34));
  mediump float tmpvar_36;
  tmpvar_36 = max (0.0, dot (lightDir_6, tmpvar_35));
  mediump float tmpvar_37;
  tmpvar_37 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = (10.0 / log2((
    ((1.0 - tmpvar_37) * 0.968)
   + 0.03)));
  tmpvar_38 = (tmpvar_39 * tmpvar_39);
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_38 + 1.0) * pow (
      max (0.0, dot (tmpvar_32, tmpvar_35))
    , tmpvar_38)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_36 * tmpvar_36) * gbuffer1_2.w) + (tmpvar_37 * tmpvar_37)))
     * tmpvar_36) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_32, lightDir_6)));
  gl_FragData[0] = tmpvar_40;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = textureProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_World2Shadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = textureProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  tmpvar_24 = (_LightShadowData.x + (tmpvar_23 * (1.0 - _LightShadowData.x)));
  tmpvar_22 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp ((tmpvar_22 + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_19 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_LightColor.xyz * tmpvar_26);
  tmpvar_4 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize((lightDir_6 + viewDir_33));
  mediump float tmpvar_35;
  tmpvar_35 = max (0.0, dot (lightDir_6, tmpvar_34));
  mediump float tmpvar_36;
  tmpvar_36 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_37;
  mediump float tmpvar_38;
  tmpvar_38 = (10.0 / log2((
    ((1.0 - tmpvar_36) * 0.968)
   + 0.03)));
  tmpvar_37 = (tmpvar_38 * tmpvar_38);
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_37 + 1.0) * pow (
      max (0.0, dot (tmpvar_31, tmpvar_34))
    , tmpvar_37)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_35 * tmpvar_35) * gbuffer1_2.w) + (tmpvar_36 * tmpvar_36)))
     * tmpvar_35) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_31, lightDir_6)));
  _glesFragData[0] = tmpvar_39;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = tmpvar_12;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  tmpvar_4 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_5, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_2.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_20, lightDir_5)));
  gl_FragData[0] = tmpvar_28;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (_LightMatrix0 * tmpvar_15).xy;
  tmpvar_16 = texture2D (_LightTexture0, P_17);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * (tmpvar_12 * tmpvar_16.w));
  tmpvar_4 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_5 + viewDir_24));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (lightDir_5, tmpvar_25));
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = (10.0 / log2((
    ((1.0 - tmpvar_27) * 0.968)
   + 0.03)));
  tmpvar_28 = (tmpvar_29 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_28 + 1.0) * pow (
      max (0.0, dot (tmpvar_22, tmpvar_25))
    , tmpvar_28)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_26 * tmpvar_26) * gbuffer1_2.w) + (tmpvar_27 * tmpvar_27)))
     * tmpvar_26) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_22, lightDir_5)));
  gl_FragData[0] = tmpvar_30;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_16, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_18;
  if ((tmpvar_17 < tmpvar_15)) {
    tmpvar_18 = _LightShadowData.x;
  } else {
    tmpvar_18 = 1.0;
  };
  highp float tmpvar_19;
  tmpvar_19 = (atten_5 * tmpvar_18);
  atten_5 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_LightColor.xyz * tmpvar_19);
  tmpvar_4 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize((lightDir_6 + viewDir_26));
  mediump float tmpvar_28;
  tmpvar_28 = max (0.0, dot (lightDir_6, tmpvar_27));
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (10.0 / log2((
    ((1.0 - tmpvar_29) * 0.968)
   + 0.03)));
  tmpvar_30 = (tmpvar_31 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_30 + 1.0) * pow (
      max (0.0, dot (tmpvar_24, tmpvar_27))
    , tmpvar_30)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_28 * tmpvar_28) * gbuffer1_2.w) + (tmpvar_29 * tmpvar_29)))
     * tmpvar_28) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_24, lightDir_6)));
  gl_FragData[0] = tmpvar_32;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_16;
  tmpvar_16 = texture (_ShadowMapTexture, tmpvar_11);
  mediump float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  highp float tmpvar_18;
  tmpvar_18 = (atten_5 * tmpvar_17);
  atten_5 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_LightColor.xyz * tmpvar_18);
  tmpvar_4 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 + viewDir_25));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.0, dot (lightDir_6, tmpvar_26));
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = (10.0 / log2((
    ((1.0 - tmpvar_28) * 0.968)
   + 0.03)));
  tmpvar_29 = (tmpvar_30 * tmpvar_30);
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_29 + 1.0) * pow (
      max (0.0, dot (tmpvar_23, tmpvar_26))
    , tmpvar_29)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_27 * tmpvar_27) * gbuffer1_2.w) + (tmpvar_28 * tmpvar_28)))
     * tmpvar_27) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_23, lightDir_6)));
  _glesFragData[0] = tmpvar_31;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_16, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_18;
  if ((tmpvar_17 < tmpvar_15)) {
    tmpvar_18 = _LightShadowData.x;
  } else {
    tmpvar_18 = 1.0;
  };
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  lowp vec4 tmpvar_20;
  highp vec3 P_21;
  P_21 = (_LightMatrix0 * tmpvar_19).xyz;
  tmpvar_20 = textureCube (_LightTexture0, P_21);
  highp float tmpvar_22;
  tmpvar_22 = ((atten_5 * tmpvar_18) * tmpvar_20.w);
  atten_5 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (_LightColor.xyz * tmpvar_22);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_6 + viewDir_29));
  mediump float tmpvar_31;
  tmpvar_31 = max (0.0, dot (lightDir_6, tmpvar_30));
  mediump float tmpvar_32;
  tmpvar_32 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = (10.0 / log2((
    ((1.0 - tmpvar_32) * 0.968)
   + 0.03)));
  tmpvar_33 = (tmpvar_34 * tmpvar_34);
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_33 + 1.0) * pow (
      max (0.0, dot (tmpvar_27, tmpvar_30))
    , tmpvar_33)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_31 * tmpvar_31) * gbuffer1_2.w) + (tmpvar_32 * tmpvar_32)))
     * tmpvar_31) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_27, lightDir_6)));
  gl_FragData[0] = tmpvar_35;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_16;
  tmpvar_16 = texture (_ShadowMapTexture, tmpvar_11);
  mediump float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  lowp vec4 tmpvar_19;
  highp vec3 P_20;
  P_20 = (_LightMatrix0 * tmpvar_18).xyz;
  tmpvar_19 = texture (_LightTexture0, P_20);
  highp float tmpvar_21;
  tmpvar_21 = ((atten_5 * tmpvar_17) * tmpvar_19.w);
  atten_5 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * tmpvar_21);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_28;
  viewDir_28 = -(tmpvar_27);
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize((lightDir_6 + viewDir_28));
  mediump float tmpvar_30;
  tmpvar_30 = max (0.0, dot (lightDir_6, tmpvar_29));
  mediump float tmpvar_31;
  tmpvar_31 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = (10.0 / log2((
    ((1.0 - tmpvar_31) * 0.968)
   + 0.03)));
  tmpvar_32 = (tmpvar_33 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_32 + 1.0) * pow (
      max (0.0, dot (tmpvar_26, tmpvar_29))
    , tmpvar_32)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_30 * tmpvar_30) * gbuffer1_2.w) + (tmpvar_31 * tmpvar_31)))
     * tmpvar_30) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_26, lightDir_6)));
  _glesFragData[0] = tmpvar_34;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" "SHADOWS_NONATIVE" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_World2Shadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  highp vec2 P_26;
  P_26 = (tmpvar_25.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, P_26).x;
  shadowVals_24.x = tmpvar_27;
  highp vec2 P_28;
  P_28 = (tmpvar_25.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, P_28).x;
  shadowVals_24.y = tmpvar_29;
  highp vec2 P_30;
  P_30 = (tmpvar_25.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, P_30).x;
  shadowVals_24.z = tmpvar_31;
  highp vec2 P_32;
  P_32 = (tmpvar_25.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_24.w = tmpvar_33;
  bvec4 tmpvar_34;
  tmpvar_34 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_35;
  tmpvar_35 = _LightShadowData.xxxx;
  mediump float tmpvar_36;
  if (tmpvar_34.x) {
    tmpvar_36 = tmpvar_35.x;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_34.y) {
    tmpvar_37 = tmpvar_35.y;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump float tmpvar_38;
  if (tmpvar_34.z) {
    tmpvar_38 = tmpvar_35.z;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if (tmpvar_34.w) {
    tmpvar_39 = tmpvar_35.w;
  } else {
    tmpvar_39 = 1.0;
  };
  mediump vec4 tmpvar_40;
  tmpvar_40.x = tmpvar_36;
  tmpvar_40.y = tmpvar_37;
  tmpvar_40.z = tmpvar_38;
  tmpvar_40.w = tmpvar_39;
  mediump float tmpvar_41;
  tmpvar_41 = dot (tmpvar_40, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp ((tmpvar_23 + tmpvar_20), 0.0, 1.0);
  tmpvar_19 = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_43;
  lowp vec4 tmpvar_44;
  tmpvar_44 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_44;
  lowp vec4 tmpvar_45;
  tmpvar_45 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_45;
  lowp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_46;
  highp vec3 tmpvar_47;
  tmpvar_47 = (_LightColor.xyz * tmpvar_43);
  tmpvar_4 = tmpvar_47;
  mediump vec3 tmpvar_48;
  tmpvar_48 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_49;
  tmpvar_49 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_50;
  viewDir_50 = -(tmpvar_49);
  mediump vec3 tmpvar_51;
  tmpvar_51 = normalize((lightDir_6 + viewDir_50));
  mediump float tmpvar_52;
  tmpvar_52 = max (0.0, dot (lightDir_6, tmpvar_51));
  mediump float tmpvar_53;
  tmpvar_53 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_54;
  mediump float tmpvar_55;
  tmpvar_55 = (10.0 / log2((
    ((1.0 - tmpvar_53) * 0.968)
   + 0.03)));
  tmpvar_54 = (tmpvar_55 * tmpvar_55);
  mediump vec4 tmpvar_56;
  tmpvar_56.w = 1.0;
  tmpvar_56.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_54 + 1.0) * pow (
      max (0.0, dot (tmpvar_48, tmpvar_51))
    , tmpvar_54)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_52 * tmpvar_52) * gbuffer1_2.w) + (tmpvar_53 * tmpvar_53)))
     * tmpvar_52) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_48, lightDir_6)));
  gl_FragData[0] = tmpvar_56;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_World2Shadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  mediump vec4 shadows_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  highp vec3 coord_25;
  coord_25 = (tmpvar_24 + _ShadowOffsets[0].xyz);
  lowp float tmpvar_26;
  tmpvar_26 = shadow2DEXT (_ShadowMapTexture, coord_25);
  shadows_23.x = tmpvar_26;
  highp vec3 coord_27;
  coord_27 = (tmpvar_24 + _ShadowOffsets[1].xyz);
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, coord_27);
  shadows_23.y = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_24 + _ShadowOffsets[2].xyz);
  lowp float tmpvar_30;
  tmpvar_30 = shadow2DEXT (_ShadowMapTexture, coord_29);
  shadows_23.z = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_24 + _ShadowOffsets[3].xyz);
  lowp float tmpvar_32;
  tmpvar_32 = shadow2DEXT (_ShadowMapTexture, coord_31);
  shadows_23.w = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = (_LightShadowData.xxxx + (shadows_23 * (1.0 - _LightShadowData.xxxx)));
  shadows_23 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((tmpvar_22 + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_19 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_36;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = (_LightColor.xyz * tmpvar_36);
  tmpvar_4 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_43;
  viewDir_43 = -(tmpvar_42);
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize((lightDir_6 + viewDir_43));
  mediump float tmpvar_45;
  tmpvar_45 = max (0.0, dot (lightDir_6, tmpvar_44));
  mediump float tmpvar_46;
  tmpvar_46 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = (10.0 / log2((
    ((1.0 - tmpvar_46) * 0.968)
   + 0.03)));
  tmpvar_47 = (tmpvar_48 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_47 + 1.0) * pow (
      max (0.0, dot (tmpvar_41, tmpvar_44))
    , tmpvar_47)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_45 * tmpvar_45) * gbuffer1_2.w) + (tmpvar_46 * tmpvar_46)))
     * tmpvar_45) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_41, lightDir_6)));
  gl_FragData[0] = tmpvar_49;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_LightMatrix0 * tmpvar_14);
  lowp float tmpvar_16;
  tmpvar_16 = textureProj (_LightTexture0, tmpvar_15).w;
  atten_5 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = ((atten_5 * float(
    (tmpvar_15.w < 0.0)
  )) * tmpvar_18.w);
  mediump float tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_World2Shadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  mediump vec4 shadows_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  highp vec3 coord_25;
  coord_25 = (tmpvar_24 + _ShadowOffsets[0].xyz);
  mediump float tmpvar_26;
  tmpvar_26 = texture (_ShadowMapTexture, coord_25);
  shadows_23.x = tmpvar_26;
  highp vec3 coord_27;
  coord_27 = (tmpvar_24 + _ShadowOffsets[1].xyz);
  mediump float tmpvar_28;
  tmpvar_28 = texture (_ShadowMapTexture, coord_27);
  shadows_23.y = tmpvar_28;
  highp vec3 coord_29;
  coord_29 = (tmpvar_24 + _ShadowOffsets[2].xyz);
  mediump float tmpvar_30;
  tmpvar_30 = texture (_ShadowMapTexture, coord_29);
  shadows_23.z = tmpvar_30;
  highp vec3 coord_31;
  coord_31 = (tmpvar_24 + _ShadowOffsets[3].xyz);
  mediump float tmpvar_32;
  tmpvar_32 = texture (_ShadowMapTexture, coord_31);
  shadows_23.w = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = (_LightShadowData.xxxx + (shadows_23 * (1.0 - _LightShadowData.xxxx)));
  shadows_23 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((tmpvar_22 + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_19 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = (atten_5 * tmpvar_19);
  atten_5 = tmpvar_36;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_39;
  highp vec3 tmpvar_40;
  tmpvar_40 = (_LightColor.xyz * tmpvar_36);
  tmpvar_4 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_43;
  viewDir_43 = -(tmpvar_42);
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize((lightDir_6 + viewDir_43));
  mediump float tmpvar_45;
  tmpvar_45 = max (0.0, dot (lightDir_6, tmpvar_44));
  mediump float tmpvar_46;
  tmpvar_46 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = (10.0 / log2((
    ((1.0 - tmpvar_46) * 0.968)
   + 0.03)));
  tmpvar_47 = (tmpvar_48 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_47 + 1.0) * pow (
      max (0.0, dot (tmpvar_41, tmpvar_44))
    , tmpvar_47)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_45 * tmpvar_45) * gbuffer1_2.w) + (tmpvar_46 * tmpvar_46)))
     * tmpvar_45) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_41, lightDir_6)));
  _glesFragData[0] = tmpvar_49;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_15.x = dot (tmpvar_17, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_15.y = dot (tmpvar_18, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_15.z = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_15.w = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_21;
  tmpvar_21 = lessThan (shadowVals_15, vec4(tmpvar_16));
  mediump vec4 tmpvar_22;
  tmpvar_22 = _LightShadowData.xxxx;
  mediump float tmpvar_23;
  if (tmpvar_21.x) {
    tmpvar_23 = tmpvar_22.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_21.y) {
    tmpvar_24 = tmpvar_22.y;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_21.z) {
    tmpvar_25 = tmpvar_22.z;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_21.w) {
    tmpvar_26 = tmpvar_22.w;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump vec4 tmpvar_27;
  tmpvar_27.x = tmpvar_23;
  tmpvar_27.y = tmpvar_24;
  tmpvar_27.z = tmpvar_25;
  tmpvar_27.w = tmpvar_26;
  mediump float tmpvar_28;
  tmpvar_28 = dot (tmpvar_27, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_29;
  tmpvar_29 = (atten_5 * tmpvar_28);
  atten_5 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (_LightColor.xyz * tmpvar_29);
  tmpvar_4 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_36;
  viewDir_36 = -(tmpvar_35);
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize((lightDir_6 + viewDir_36));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_6, tmpvar_37));
  mediump float tmpvar_39;
  tmpvar_39 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (10.0 / log2((
    ((1.0 - tmpvar_39) * 0.968)
   + 0.03)));
  tmpvar_40 = (tmpvar_41 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_40 + 1.0) * pow (
      max (0.0, dot (tmpvar_34, tmpvar_37))
    , tmpvar_40)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_38 * tmpvar_38) * gbuffer1_2.w) + (tmpvar_39 * tmpvar_39)))
     * tmpvar_38) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_34, lightDir_6)));
  gl_FragData[0] = tmpvar_42;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_15.x = tmpvar_17.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_15.y = tmpvar_18.x;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_15.z = tmpvar_19.x;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_15.w = tmpvar_20.x;
  bvec4 tmpvar_21;
  tmpvar_21 = lessThan (shadowVals_15, vec4(tmpvar_16));
  mediump vec4 tmpvar_22;
  tmpvar_22 = _LightShadowData.xxxx;
  mediump float tmpvar_23;
  if (tmpvar_21.x) {
    tmpvar_23 = tmpvar_22.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_21.y) {
    tmpvar_24 = tmpvar_22.y;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_21.z) {
    tmpvar_25 = tmpvar_22.z;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_21.w) {
    tmpvar_26 = tmpvar_22.w;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump vec4 tmpvar_27;
  tmpvar_27.x = tmpvar_23;
  tmpvar_27.y = tmpvar_24;
  tmpvar_27.z = tmpvar_25;
  tmpvar_27.w = tmpvar_26;
  mediump float tmpvar_28;
  tmpvar_28 = dot (tmpvar_27, vec4(0.25, 0.25, 0.25, 0.25));
  highp float tmpvar_29;
  tmpvar_29 = (atten_5 * tmpvar_28);
  atten_5 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (_LightColor.xyz * tmpvar_29);
  tmpvar_4 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_36;
  viewDir_36 = -(tmpvar_35);
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize((lightDir_6 + viewDir_36));
  mediump float tmpvar_38;
  tmpvar_38 = max (0.0, dot (lightDir_6, tmpvar_37));
  mediump float tmpvar_39;
  tmpvar_39 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (10.0 / log2((
    ((1.0 - tmpvar_39) * 0.968)
   + 0.03)));
  tmpvar_40 = (tmpvar_41 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_40 + 1.0) * pow (
      max (0.0, dot (tmpvar_34, tmpvar_37))
    , tmpvar_40)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_38 * tmpvar_38) * gbuffer1_2.w) + (tmpvar_39 * tmpvar_39)))
     * tmpvar_38) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_34, lightDir_6)));
  _glesFragData[0] = tmpvar_42;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_15.x = dot (tmpvar_17, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_15.y = dot (tmpvar_18, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_15.z = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_15.w = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_21;
  tmpvar_21 = lessThan (shadowVals_15, vec4(tmpvar_16));
  mediump vec4 tmpvar_22;
  tmpvar_22 = _LightShadowData.xxxx;
  mediump float tmpvar_23;
  if (tmpvar_21.x) {
    tmpvar_23 = tmpvar_22.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_21.y) {
    tmpvar_24 = tmpvar_22.y;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_21.z) {
    tmpvar_25 = tmpvar_22.z;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_21.w) {
    tmpvar_26 = tmpvar_22.w;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump vec4 tmpvar_27;
  tmpvar_27.x = tmpvar_23;
  tmpvar_27.y = tmpvar_24;
  tmpvar_27.z = tmpvar_25;
  tmpvar_27.w = tmpvar_26;
  mediump float tmpvar_28;
  tmpvar_28 = dot (tmpvar_27, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = tmpvar_10;
  lowp vec4 tmpvar_30;
  highp vec3 P_31;
  P_31 = (_LightMatrix0 * tmpvar_29).xyz;
  tmpvar_30 = textureCube (_LightTexture0, P_31);
  highp float tmpvar_32;
  tmpvar_32 = ((atten_5 * tmpvar_28) * tmpvar_30.w);
  atten_5 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * tmpvar_32);
  tmpvar_4 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_39;
  viewDir_39 = -(tmpvar_38);
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize((lightDir_6 + viewDir_39));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_6, tmpvar_40));
  mediump float tmpvar_42;
  tmpvar_42 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = (10.0 / log2((
    ((1.0 - tmpvar_42) * 0.968)
   + 0.03)));
  tmpvar_43 = (tmpvar_44 * tmpvar_44);
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_43 + 1.0) * pow (
      max (0.0, dot (tmpvar_37, tmpvar_40))
    , tmpvar_43)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_41 * tmpvar_41) * gbuffer1_2.w) + (tmpvar_42 * tmpvar_42)))
     * tmpvar_41) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_37, lightDir_6)));
  gl_FragData[0] = tmpvar_45;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_5 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp vec4 tmpvar_17;
  tmpvar_17 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125)));
  shadowVals_15.x = tmpvar_17.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125)));
  shadowVals_15.y = tmpvar_18.x;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125)));
  shadowVals_15.z = tmpvar_19.x;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125)));
  shadowVals_15.w = tmpvar_20.x;
  bvec4 tmpvar_21;
  tmpvar_21 = lessThan (shadowVals_15, vec4(tmpvar_16));
  mediump vec4 tmpvar_22;
  tmpvar_22 = _LightShadowData.xxxx;
  mediump float tmpvar_23;
  if (tmpvar_21.x) {
    tmpvar_23 = tmpvar_22.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_21.y) {
    tmpvar_24 = tmpvar_22.y;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump float tmpvar_25;
  if (tmpvar_21.z) {
    tmpvar_25 = tmpvar_22.z;
  } else {
    tmpvar_25 = 1.0;
  };
  mediump float tmpvar_26;
  if (tmpvar_21.w) {
    tmpvar_26 = tmpvar_22.w;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump vec4 tmpvar_27;
  tmpvar_27.x = tmpvar_23;
  tmpvar_27.y = tmpvar_24;
  tmpvar_27.z = tmpvar_25;
  tmpvar_27.w = tmpvar_26;
  mediump float tmpvar_28;
  tmpvar_28 = dot (tmpvar_27, vec4(0.25, 0.25, 0.25, 0.25));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = tmpvar_10;
  lowp vec4 tmpvar_30;
  highp vec3 P_31;
  P_31 = (_LightMatrix0 * tmpvar_29).xyz;
  tmpvar_30 = texture (_LightTexture0, P_31);
  highp float tmpvar_32;
  tmpvar_32 = ((atten_5 * tmpvar_28) * tmpvar_30.w);
  atten_5 = tmpvar_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * tmpvar_32);
  tmpvar_4 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_39;
  viewDir_39 = -(tmpvar_38);
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize((lightDir_6 + viewDir_39));
  mediump float tmpvar_41;
  tmpvar_41 = max (0.0, dot (lightDir_6, tmpvar_40));
  mediump float tmpvar_42;
  tmpvar_42 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = (10.0 / log2((
    ((1.0 - tmpvar_42) * 0.968)
   + 0.03)));
  tmpvar_43 = (tmpvar_44 * tmpvar_44);
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_43 + 1.0) * pow (
      max (0.0, dot (tmpvar_37, tmpvar_40))
    , tmpvar_43)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_41 * tmpvar_41) * gbuffer1_2.w) + (tmpvar_42 * tmpvar_42)))
     * tmpvar_41) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_37, lightDir_6)));
  _glesFragData[0] = tmpvar_45;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = tmpvar_12;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  tmpvar_4 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_5, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_2.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_20, lightDir_5)));
  gl_FragData[0] = tmpvar_28;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = tmpvar_12;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (_LightColor.xyz * tmpvar_15);
  tmpvar_4 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 + viewDir_22));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, dot (lightDir_5, tmpvar_23));
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = (10.0 / log2((
    ((1.0 - tmpvar_25) * 0.968)
   + 0.03)));
  tmpvar_26 = (tmpvar_27 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_26 + 1.0) * pow (
      max (0.0, dot (tmpvar_20, tmpvar_23))
    , tmpvar_26)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_24 * tmpvar_24) * gbuffer1_2.w) + (tmpvar_25 * tmpvar_25)))
     * tmpvar_24) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_20, lightDir_5)));
  _glesFragData[0] = tmpvar_28;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (_LightMatrix0 * tmpvar_15).xy;
  tmpvar_16 = texture2D (_LightTexture0, P_17);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * (tmpvar_12 * tmpvar_16.w));
  tmpvar_4 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_5 + viewDir_24));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (lightDir_5, tmpvar_25));
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = (10.0 / log2((
    ((1.0 - tmpvar_27) * 0.968)
   + 0.03)));
  tmpvar_28 = (tmpvar_29 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_28 + 1.0) * pow (
      max (0.0, dot (tmpvar_22, tmpvar_25))
    , tmpvar_28)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_26 * tmpvar_26) * gbuffer1_2.w) + (tmpvar_27 * tmpvar_27)))
     * tmpvar_26) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_22, lightDir_5)));
  gl_FragData[0] = tmpvar_30;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform highp mat4 _LightMatrix0;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform mediump vec4 unity_LightGammaCorrectionConsts;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
in highp vec4 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7 = texture (_CameraDepthTexture, tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_7.x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture (_ShadowMapTexture, tmpvar_6);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (_LightMatrix0 * tmpvar_15).xy;
  tmpvar_16 = texture (_LightTexture0, P_17);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * (tmpvar_12 * tmpvar_16.w));
  tmpvar_4 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize((lightDir_5 + viewDir_24));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (lightDir_5, tmpvar_25));
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = (10.0 / log2((
    ((1.0 - tmpvar_27) * 0.968)
   + 0.03)));
  tmpvar_28 = (tmpvar_29 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    ((((tmpvar_28 + 1.0) * pow (
      max (0.0, dot (tmpvar_22, tmpvar_25))
    , tmpvar_28)) / ((
      (unity_LightGammaCorrectionConsts.z * (((tmpvar_26 * tmpvar_26) * gbuffer1_2.w) + (tmpvar_27 * tmpvar_27)))
     * tmpvar_26) + 0.0001)) * gbuffer1_2.xyz)
  ) * tmpvar_4) * max (0.0, dot (tmpvar_22, lightDir_5)));
  _glesFragData[0] = tmpvar_30;
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
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "UNITY_HDR_ON" }
"!!GLES3"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Stencil {
   Ref [_StencilNonBackground]
   ReadMask [_StencilNonBackground]
   CompFront Equal
   CompBack Equal
  }
  GpuProgramID 123303
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out highp vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform sampler2D _LightBuffer;
in highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture (_LightBuffer, xlv_TEXCOORD0)));
  _glesFragData[0] = tmpvar_1;
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
}
Fallback Off
}