//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredReflections" {
Properties {
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  Blend Zero Zero, Zero Zero
  ZClip Off
  ZWrite Off
  GpuProgramID 2208
Program "vp" {
SubProgram "gles " {
"#version 100

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
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (glstate_matrix_mvp * tmpvar_4);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((glstate_matrix_modelview0 * tmpvar_8).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - max (max (gbuffer1_4.x, gbuffer1_4.y), gbuffer1_4.z));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_15;
  tmpvar_15 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_16;
  I_16 = -(tmpvar_1);
  mediump vec4 hdr_17;
  hdr_17 = tmpvar_2;
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = (I_16 - (2.0 * (
    dot (tmpvar_12, I_16)
   * tmpvar_12)));
  tmpvar_18.w = ((tmpvar_15 * (1.7 - 
    (0.7 * tmpvar_15)
  )) * 6.0);
  lowp vec4 tmpvar_19;
  tmpvar_19 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_18.xyz, tmpvar_18.w);
  mediump vec4 tmpvar_20;
  tmpvar_20 = tmpvar_19;
  mediump float tmpvar_21;
  if ((hdr_17.w == 1.0)) {
    tmpvar_21 = tmpvar_20.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_13);
  mediump vec2 tmpvar_23;
  tmpvar_23.x = (viewDir_22 - (2.0 * (
    dot (tmpvar_12, viewDir_22)
   * tmpvar_12))).y;
  tmpvar_23.y = (1.0 - clamp (dot (tmpvar_12, viewDir_22), 0.0, 1.0));
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = (((
    (hdr_17.x * tmpvar_21)
   * tmpvar_20.xyz) * gbuffer0_5.w) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - tmpvar_14))
  , 0.0, 1.0)), (
    (tmpvar_23 * tmpvar_23)
   * 
    (tmpvar_23 * tmpvar_23)
  ).yyy));
  mediump vec3 p_25;
  p_25 = tmpvar_8;
  mediump vec3 aabbMin_26;
  aabbMin_26 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_27;
  aabbMax_27 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_28;
  tmpvar_28 = max (max ((p_25 - aabbMax_27), (aabbMin_26 - p_25)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_29;
  tmpvar_29 = sqrt(dot (tmpvar_28, tmpvar_28));
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (tmpvar_29 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.xyz = tmpvar_24.xyz;
  tmpvar_32.w = tmpvar_30;
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    gl_Position = u_xlat0;
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
bool u_xlatb2;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_22 = (-u_xlat16_22) + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_5.x = max(u_xlat10_3.y, u_xlat10_3.x);
    u_xlat16_5.x = max(u_xlat10_3.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_3.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_3.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz + u_xlat10_3.xyz;
    u_xlat16_22 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_23 = (-u_xlat16_22) * 0.699999988 + 1.70000005;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_22 * 6.0;
    u_xlat16_23 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_23 = u_xlat16_23 + u_xlat16_23;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_23)) + u_xlat2.xyz;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_4.xyz, u_xlat16_22);
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(unity_SpecCube0_HDR.w==1.0);
#else
    u_xlatb2 = unity_SpecCube0_HDR.w==1.0;
#endif
    u_xlat16_4.x = (u_xlatb2) ? u_xlat10_1.w : 1.0;
    u_xlat16_4.x = u_xlat16_4.x * unity_SpecCube0_HDR.x;
    u_xlat16_4.xyz = u_xlat10_1.xyz * u_xlat16_4.xxx;
    u_xlat16_4.xyz = vec3(u_xlat10_18) * u_xlat16_4.xyz;
    SV_Target0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

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
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (glstate_matrix_mvp * tmpvar_4);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((glstate_matrix_modelview0 * tmpvar_8).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - max (max (gbuffer1_4.x, gbuffer1_4.y), gbuffer1_4.z));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_15;
  tmpvar_15 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_16;
  I_16 = -(tmpvar_1);
  mediump vec4 hdr_17;
  hdr_17 = tmpvar_2;
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = (I_16 - (2.0 * (
    dot (tmpvar_12, I_16)
   * tmpvar_12)));
  tmpvar_18.w = ((tmpvar_15 * (1.7 - 
    (0.7 * tmpvar_15)
  )) * 6.0);
  lowp vec4 tmpvar_19;
  tmpvar_19 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_18.xyz, tmpvar_18.w);
  mediump vec4 tmpvar_20;
  tmpvar_20 = tmpvar_19;
  mediump float tmpvar_21;
  if ((hdr_17.w == 1.0)) {
    tmpvar_21 = tmpvar_20.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_13);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_4.w);
  mediump float x_24;
  x_24 = (1.0 - clamp (dot (tmpvar_12, viewDir_22), 0.0, 1.0));
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((1.0 - 
    ((tmpvar_23 * tmpvar_23) * (tmpvar_23 * 0.28))
  ) * (
    ((hdr_17.x * tmpvar_21) * tmpvar_20.xyz)
   * gbuffer0_5.w)) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - tmpvar_14))
  , 0.0, 1.0)), vec3((
    (x_24 * x_24)
   * 
    (x_24 * x_24)
  ))));
  mediump vec3 p_26;
  p_26 = tmpvar_8;
  mediump vec3 aabbMin_27;
  aabbMin_27 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_28;
  aabbMax_28 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_29;
  tmpvar_29 = max (max ((p_26 - aabbMax_28), (aabbMin_27 - p_26)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_30;
  tmpvar_30 = sqrt(dot (tmpvar_29, tmpvar_29));
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((1.0 - (tmpvar_30 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.xyz = tmpvar_25.xyz;
  tmpvar_33.w = tmpvar_31;
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

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
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (glstate_matrix_mvp * tmpvar_4);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((glstate_matrix_modelview0 * tmpvar_8).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - max (max (gbuffer1_4.x, gbuffer1_4.y), gbuffer1_4.z));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_15;
  tmpvar_15 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_16;
  I_16 = -(tmpvar_1);
  mediump vec4 hdr_17;
  hdr_17 = tmpvar_2;
  mediump vec4 tmpvar_18;
  tmpvar_18.xyz = (I_16 - (2.0 * (
    dot (tmpvar_12, I_16)
   * tmpvar_12)));
  tmpvar_18.w = ((tmpvar_15 * (1.7 - 
    (0.7 * tmpvar_15)
  )) * 6.0);
  lowp vec4 tmpvar_19;
  tmpvar_19 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_18.xyz, tmpvar_18.w);
  mediump vec4 tmpvar_20;
  tmpvar_20 = tmpvar_19;
  mediump float tmpvar_21;
  if ((hdr_17.w == 1.0)) {
    tmpvar_21 = tmpvar_20.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_13);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_4.w);
  mediump float x_24;
  x_24 = (1.0 - clamp (dot (tmpvar_12, viewDir_22), 0.0, 1.0));
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((1.0 - 
    ((tmpvar_23 * tmpvar_23) * (tmpvar_23 * 0.28))
  ) * (
    ((hdr_17.x * tmpvar_21) * tmpvar_20.xyz)
   * gbuffer0_5.w)) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - tmpvar_14))
  , 0.0, 1.0)), vec3((
    (x_24 * x_24)
   * 
    (x_24 * x_24)
  ))));
  mediump vec3 p_26;
  p_26 = tmpvar_8;
  mediump vec3 aabbMin_27;
  aabbMin_27 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_28;
  aabbMax_28 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_29;
  tmpvar_29 = max (max ((p_26 - aabbMax_28), (aabbMin_27 - p_26)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_30;
  tmpvar_30 = sqrt(dot (tmpvar_29, tmpvar_29));
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((1.0 - (tmpvar_30 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.xyz = tmpvar_25.xyz;
  tmpvar_33.w = tmpvar_31;
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    gl_Position = u_xlat0;
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
bool u_xlatb3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + u_xlat2.xyz;
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_4.y = (-u_xlat10_2.w) + 1.0;
    u_xlat16_4.z = (-u_xlat16_4.y) * 0.699999988 + 1.70000005;
    u_xlat16_4.xz = u_xlat16_4.xz * u_xlat16_4.xy;
    u_xlat16_16 = u_xlat16_4.z * 6.0;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_5.xyz, u_xlat16_16);
#ifdef UNITY_ADRENO_ES3
    u_xlatb3 = !!(unity_SpecCube0_HDR.w==1.0);
#else
    u_xlatb3 = unity_SpecCube0_HDR.w==1.0;
#endif
    u_xlat16_16 = (u_xlatb3) ? u_xlat10_1.w : 1.0;
    u_xlat16_16 = u_xlat16_16 * unity_SpecCube0_HDR.x;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(u_xlat16_16);
    u_xlat16_5.xyz = vec3(u_xlat10_18) * u_xlat16_5.xyz;
    u_xlat16_16 = u_xlat16_4.y * u_xlat16_4.y;
    u_xlat16_10.x = u_xlat16_4.y * u_xlat16_16;
    u_xlat16_10.x = (-u_xlat16_10.x) * 0.280000001 + 1.0;
    u_xlat16_10.xyz = u_xlat16_5.xyz * u_xlat16_10.xxx;
    u_xlat16_5.x = max(u_xlat10_2.y, u_xlat10_2.x);
    u_xlat16_5.x = max(u_xlat10_2.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_2.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_2.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat16_5.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    gl_Position = u_xlat0;
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
bool u_xlatb3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + u_xlat2.xyz;
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_4.y = (-u_xlat10_2.w) + 1.0;
    u_xlat16_4.z = (-u_xlat16_4.y) * 0.699999988 + 1.70000005;
    u_xlat16_4.xz = u_xlat16_4.xz * u_xlat16_4.xy;
    u_xlat16_16 = u_xlat16_4.z * 6.0;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_5.xyz, u_xlat16_16);
#ifdef UNITY_ADRENO_ES3
    u_xlatb3 = !!(unity_SpecCube0_HDR.w==1.0);
#else
    u_xlatb3 = unity_SpecCube0_HDR.w==1.0;
#endif
    u_xlat16_16 = (u_xlatb3) ? u_xlat10_1.w : 1.0;
    u_xlat16_16 = u_xlat16_16 * unity_SpecCube0_HDR.x;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(u_xlat16_16);
    u_xlat16_5.xyz = vec3(u_xlat10_18) * u_xlat16_5.xyz;
    u_xlat16_16 = u_xlat16_4.y * u_xlat16_4.y;
    u_xlat16_10.x = u_xlat16_4.y * u_xlat16_16;
    u_xlat16_10.x = (-u_xlat16_10.x) * 0.280000001 + 1.0;
    u_xlat16_10.xyz = u_xlat16_5.xyz * u_xlat16_10.xxx;
    u_xlat16_5.x = max(u_xlat10_2.y, u_xlat10_2.x);
    u_xlat16_5.x = max(u_xlat10_2.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_2.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_2.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat16_5.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
    return;
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
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Blend Zero Zero, Zero Zero
  ZClip Off
  ZTest Always
  ZWrite Off
  GpuProgramID 128161
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (glstate_matrix_mvp * tmpvar_2);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
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
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
""
}
}
}
}
}