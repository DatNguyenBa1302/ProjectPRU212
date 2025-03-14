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
  Tags { "SHADOWSUPPORT" = "true" }
  Blend Zero Zero, Zero Zero
  ZClip Off
  ZWrite Off
  GpuProgramID 26031
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_7);
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0));
  mediump vec2 tmpvar_22;
  tmpvar_22.x = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21)).x;
  tmpvar_22.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_NHxRoughness, tmpvar_22);
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_23.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_18, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_25;
  tmpvar_25 = exp2(-(tmpvar_24));
  tmpvar_1 = tmpvar_25;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat13;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat10_18) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.xyz = u_xlat2.xyz * u_xlat16_4.xxx;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat10_15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0.x = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0.x = u_xlat16_4.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_21;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat10_15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0.x = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0.x = u_xlat16_4.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_21;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = dot ((viewDir_15 - (2.0 * 
    (dot (tmpvar_13, viewDir_15) * tmpvar_13)
  )), lightDir_6);
  tmpvar_16.y = (1.0 - clamp (dot (tmpvar_13, viewDir_15), 0.0, 1.0));
  mediump vec2 tmpvar_17;
  tmpvar_17.x = ((tmpvar_16 * tmpvar_16) * (tmpvar_16 * tmpvar_16)).x;
  tmpvar_17.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (unity_NHxRoughness, tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_18.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_13, lightDir_6)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_20;
  tmpvar_20 = exp2(-(tmpvar_19));
  tmpvar_1 = tmpvar_20;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat16_18 = dot((-u_xlat0.xyz), u_xlat16_3.xyz);
    u_xlat16_18 = u_xlat16_18 + u_xlat16_18;
    u_xlat16_4.xyz = u_xlat16_3.xyz * (-vec3(u_xlat16_18)) + (-u_xlat0.xyz);
    u_xlat16_3.x = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xxx * _LightColor.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_18 = u_xlat16_18 * u_xlat16_18;
    u_xlat16_4.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_15 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_15 = u_xlat10_15 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_15) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump float specularTerm_16;
  mediump vec3 tmpvar_17;
  mediump vec3 inVec_18;
  inVec_18 = (lightDir_6 + viewDir_15);
  tmpvar_17 = (inVec_18 * inversesqrt(max (0.001, 
    dot (inVec_18, inVec_18)
  )));
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_13, tmpvar_17), 0.0, 1.0);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * tmpvar_20);
  specularTerm_16 = ((tmpvar_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_17), 0.0, 1.0)) * (1.5 + tmpvar_21))
   * 
    (((tmpvar_19 * tmpvar_19) * ((tmpvar_21 * tmpvar_21) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_22 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_13, lightDir_6), 0.0, 1.0));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump float specularTerm_16;
  mediump vec3 tmpvar_17;
  mediump vec3 inVec_18;
  inVec_18 = (lightDir_6 + viewDir_15);
  tmpvar_17 = (inVec_18 * inversesqrt(max (0.001, 
    dot (inVec_18, inVec_18)
  )));
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_13, tmpvar_17), 0.0, 1.0);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * tmpvar_20);
  specularTerm_16 = ((tmpvar_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_17), 0.0, 1.0)) * (1.5 + tmpvar_21))
   * 
    (((tmpvar_19 * tmpvar_19) * ((tmpvar_21 * tmpvar_21) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_22 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_13, lightDir_6), 0.0, 1.0));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0.x = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0.x);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_0.x = u_xlat16_18 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0.x = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0.x);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_0.x = u_xlat16_18 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_6 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_6 = (atten_6 * tmpvar_19.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec2 tmpvar_26;
  tmpvar_26.x = dot ((viewDir_25 - (2.0 * 
    (dot (tmpvar_23, viewDir_25) * tmpvar_23)
  )), lightDir_7);
  tmpvar_26.y = (1.0 - clamp (dot (tmpvar_23, viewDir_25), 0.0, 1.0));
  mediump vec2 tmpvar_27;
  tmpvar_27.x = ((tmpvar_26 * tmpvar_26) * (tmpvar_26 * tmpvar_26)).x;
  tmpvar_27.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (unity_NHxRoughness, tmpvar_27);
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_28.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_23, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_19;
lowp float u_xlat10_19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_19 = u_xlat10_19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_18 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_6 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_6 = (atten_6 * tmpvar_19.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_7 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_32 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_23, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_6 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_6 = (atten_6 * tmpvar_19.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_7 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_32 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_23, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16.w = -8.0;
  tmpvar_16.xyz = (unity_WorldToLight * tmpvar_15).xyz;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_LightTexture0, tmpvar_16.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_17.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = dot ((viewDir_23 - (2.0 * 
    (dot (tmpvar_21, viewDir_23) * tmpvar_21)
  )), lightDir_7);
  tmpvar_24.y = (1.0 - clamp (dot (tmpvar_21, viewDir_23), 0.0, 1.0));
  mediump vec2 tmpvar_25;
  tmpvar_25.x = ((tmpvar_24 * tmpvar_24) * (tmpvar_24 * tmpvar_24)).x;
  tmpvar_25.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (unity_NHxRoughness, tmpvar_25);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_26.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_21, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(tmpvar_27));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat13;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_19;
lowp float u_xlat10_19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_19 = u_xlat10_19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0.x = u_xlat10_0 * u_xlat10_18;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16.w = -8.0;
  tmpvar_16.xyz = (unity_WorldToLight * tmpvar_15).xyz;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_LightTexture0, tmpvar_16.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_17.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16.w = -8.0;
  tmpvar_16.xyz = (unity_WorldToLight * tmpvar_15).xyz;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_LightTexture0, tmpvar_16.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_17.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0.x = u_xlat10_0 * u_xlat10_13;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0.x = u_xlat10_0 * u_xlat10_13;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0);
  atten_6 = tmpvar_14.w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_7);
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0));
  mediump vec2 tmpvar_22;
  tmpvar_22.x = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21)).x;
  tmpvar_22.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_NHxRoughness, tmpvar_22);
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_23.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_18, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_25;
  tmpvar_25 = exp2(-(tmpvar_24));
  tmpvar_1 = tmpvar_25;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_10;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_18) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat6.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0);
  atten_6 = tmpvar_14.w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0);
  atten_6 = tmpvar_14.w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 tmpvar_26;
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
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump vec2 tmpvar_35;
  tmpvar_35.x = dot ((viewDir_34 - (2.0 * 
    (dot (tmpvar_32, viewDir_34) * tmpvar_32)
  )), lightDir_7);
  tmpvar_35.y = (1.0 - clamp (dot (tmpvar_32, viewDir_34), 0.0, 1.0));
  mediump vec2 tmpvar_36;
  tmpvar_36.x = ((tmpvar_35 * tmpvar_35) * (tmpvar_35 * tmpvar_35)).x;
  tmpvar_36.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (unity_NHxRoughness, tmpvar_36);
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_37.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_32, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp vec4 u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
lowp float u_xlat10_22;
bool u_xlatb22;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1.x * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_21 = inversesqrt(u_xlat16_21);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = vec3(u_xlat16_21) * u_xlat1.xyz;
    u_xlat1.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat1.x = inversesqrt(u_xlat1.x);
    u_xlat1.xyz = u_xlat1.xxx * u_xlat3.xyz;
    u_xlat16_21 = dot((-u_xlat1.xyz), u_xlat16_0.xyz);
    u_xlat16_21 = u_xlat16_21 + u_xlat16_21;
    u_xlat16_0.xyz = u_xlat16_0.xyz * (-vec3(u_xlat16_21)) + (-u_xlat1.xyz);
    u_xlat16_0.x = dot(u_xlat16_0.xyz, u_xlat4.xyz);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat10_1 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_0.y = (-u_xlat10_1.w) + 1.0;
    u_xlat10_22 = texture(unity_NHxRoughness, u_xlat16_0.xy).w;
    u_xlat16_22 = u_xlat10_22 * 16.0;
    u_xlat16_0.xyz = vec3(u_xlat16_22) * u_xlat10_1.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_0.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 tmpvar_26;
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
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump float specularTerm_35;
  mediump vec3 tmpvar_36;
  mediump vec3 inVec_37;
  inVec_37 = (lightDir_7 + viewDir_34);
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_32, tmpvar_36), 0.0, 1.0);
  mediump float tmpvar_39;
  tmpvar_39 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_40;
  tmpvar_40 = (tmpvar_39 * tmpvar_39);
  specularTerm_35 = ((tmpvar_40 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_36), 0.0, 1.0)) * (1.5 + tmpvar_40))
   * 
    (((tmpvar_38 * tmpvar_38) * ((tmpvar_40 * tmpvar_40) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_41;
  tmpvar_41 = clamp (specularTerm_35, 0.0, 100.0);
  specularTerm_35 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_41 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_32, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_43;
  tmpvar_43 = exp2(-(tmpvar_42));
  tmpvar_1 = tmpvar_43;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 tmpvar_26;
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
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_34;
  viewDir_34 = -(tmpvar_33);
  mediump float specularTerm_35;
  mediump vec3 tmpvar_36;
  mediump vec3 inVec_37;
  inVec_37 = (lightDir_7 + viewDir_34);
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  mediump float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_32, tmpvar_36), 0.0, 1.0);
  mediump float tmpvar_39;
  tmpvar_39 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_40;
  tmpvar_40 = (tmpvar_39 * tmpvar_39);
  specularTerm_35 = ((tmpvar_40 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_36), 0.0, 1.0)) * (1.5 + tmpvar_40))
   * 
    (((tmpvar_38 * tmpvar_38) * ((tmpvar_40 * tmpvar_40) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_41;
  tmpvar_41 = clamp (specularTerm_35, 0.0, 100.0);
  specularTerm_35 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42.w = 1.0;
  tmpvar_42.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_41 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_32, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_43;
  tmpvar_43 = exp2(-(tmpvar_42));
  tmpvar_1 = tmpvar_43;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_16;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
bool u_xlatb22;
mediump float u_xlat16_23;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat22 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat22) + u_xlat4.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_22 = max(u_xlat16_21, 0.00100000005);
    u_xlat16_21 = inversesqrt(u_xlat16_22);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_22 = max(u_xlat16_21, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_21 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_16 = u_xlat16_21 * u_xlat16_21 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_21;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_16;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_0.x = dot(u_xlat16_6.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_7 = min(max(u_xlat16_7, 0.0), 1.0);
#else
    u_xlat16_7 = clamp(u_xlat16_7, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_23 = u_xlat16_21 * u_xlat16_21 + -1.0;
    u_xlat16_23 = u_xlat16_0.x * u_xlat16_23 + 1.00001001;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_21 / u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_22, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat16_0.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_16;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
bool u_xlatb22;
mediump float u_xlat16_23;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat22 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat22) + u_xlat4.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_22 = max(u_xlat16_21, 0.00100000005);
    u_xlat16_21 = inversesqrt(u_xlat16_22);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_22 = max(u_xlat16_21, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_21 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_16 = u_xlat16_21 * u_xlat16_21 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_21;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_16;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_0.x = dot(u_xlat16_6.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_7 = min(max(u_xlat16_7, 0.0), 1.0);
#else
    u_xlat16_7 = clamp(u_xlat16_7, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_23 = u_xlat16_21 * u_xlat16_21 + -1.0;
    u_xlat16_23 = u_xlat16_0.x * u_xlat16_23 + 1.00001001;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_21 / u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_22, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat16_0.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec2 tmpvar_22;
  tmpvar_22.x = dot ((viewDir_21 - (2.0 * 
    (dot (tmpvar_19, viewDir_21) * tmpvar_19)
  )), lightDir_7);
  tmpvar_22.y = (1.0 - clamp (dot (tmpvar_19, viewDir_21), 0.0, 1.0));
  mediump vec2 tmpvar_23;
  tmpvar_23.x = ((tmpvar_22 * tmpvar_22) * (tmpvar_22 * tmpvar_22)).x;
  tmpvar_23.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (unity_NHxRoughness, tmpvar_23);
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_24.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_19, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(tmpvar_25));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat6.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat6.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10 = u_xlat16_10 * u_xlat16_10;
    u_xlat16_5.x = u_xlat16_10 * u_xlat16_10;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_6 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_6 = u_xlat10_6 * 16.0;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xyz = u_xlat16_4.xxx * u_xlat0.xzw;
    u_xlat16_5.xyz = vec3(u_xlat16_6) * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump float specularTerm_22;
  mediump vec3 tmpvar_23;
  mediump vec3 inVec_24;
  inVec_24 = (lightDir_7 + viewDir_21);
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_19, tmpvar_23), 0.0, 1.0);
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  tmpvar_27 = (tmpvar_26 * tmpvar_26);
  specularTerm_22 = ((tmpvar_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_23), 0.0, 1.0)) * (1.5 + tmpvar_27))
   * 
    (((tmpvar_25 * tmpvar_25) * ((tmpvar_27 * tmpvar_27) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_28 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump float specularTerm_22;
  mediump vec3 tmpvar_23;
  mediump vec3 inVec_24;
  inVec_24 = (lightDir_7 + viewDir_21);
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_19, tmpvar_23), 0.0, 1.0);
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  tmpvar_27 = (tmpvar_26 * tmpvar_26);
  specularTerm_22 = ((tmpvar_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_23), 0.0, 1.0)) * (1.5 + tmpvar_27))
   * 
    (((tmpvar_25 * tmpvar_25) * ((tmpvar_27 * tmpvar_27) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_28 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (unity_WorldToLight * tmpvar_16).xy;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec2 tmpvar_25;
  tmpvar_25.x = dot ((viewDir_24 - (2.0 * 
    (dot (tmpvar_22, viewDir_24) * tmpvar_22)
  )), lightDir_7);
  tmpvar_25.y = (1.0 - clamp (dot (tmpvar_22, viewDir_24), 0.0, 1.0));
  mediump vec2 tmpvar_26;
  tmpvar_26.x = ((tmpvar_25 * tmpvar_25) * (tmpvar_25 * tmpvar_25)).x;
  tmpvar_26.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (unity_NHxRoughness, tmpvar_26);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_27.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_22, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_22 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (unity_WorldToLight * tmpvar_16).xy;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_7 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_31 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_15;
  tmpvar_15 = clamp ((tmpvar_14.x + clamp (
    ((mix (tmpvar_9.z, sqrt(
      dot (tmpvar_11, tmpvar_11)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_13 = tmpvar_15;
  atten_6 = tmpvar_13;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (unity_WorldToLight * tmpvar_16).xy;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_7 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_31 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_33;
  tmpvar_33 = exp2(-(tmpvar_32));
  tmpvar_1 = tmpvar_33;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = dot ((viewDir_23 - (2.0 * 
    (dot (tmpvar_21, viewDir_23) * tmpvar_21)
  )), lightDir_7);
  tmpvar_24.y = (1.0 - clamp (dot (tmpvar_21, viewDir_23), 0.0, 1.0));
  mediump vec2 tmpvar_25;
  tmpvar_25.x = ((tmpvar_24 * tmpvar_24) * (tmpvar_24 * tmpvar_24)).x;
  tmpvar_25.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (unity_NHxRoughness, tmpvar_25);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_26.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_21, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(tmpvar_27));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat13;
float u_xlat18;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat2.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_6 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_6 = u_xlat10_6 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_6) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6 = sqrt(u_xlat18);
    u_xlat12 = u_xlat18 * _LightPos.w;
    u_xlat10_12 = texture(_LightTextureB0, vec2(u_xlat12)).w;
    u_xlat6 = u_xlat6 * _LightPositionRange.w;
    u_xlat6 = u_xlat6 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat6);
#else
    u_xlatb0 = u_xlat0.x<u_xlat6;
#endif
    u_xlat16_5.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0.x = u_xlat10_12 * u_xlat16_5.x;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_7 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_7);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_7 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_14 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_14 = u_xlat16_5.x * u_xlat16_14 + 1.00001001;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_7 = u_xlat16_26 / u_xlat16_7;
    u_xlat16_7 = u_xlat16_7 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_7, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat7);
#else
    u_xlatb0 = u_xlat0.x<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0.x = u_xlat10_14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_7 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_7);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_7 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_14 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_14 = u_xlat16_5.x * u_xlat16_14 + 1.00001001;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_7 = u_xlat16_26 / u_xlat16_7;
    u_xlat16_7 = u_xlat16_7 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_7, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat7);
#else
    u_xlatb0 = u_xlat0.x<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0.x = u_xlat10_14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.w = -8.0;
  tmpvar_19.xyz = (unity_WorldToLight * tmpvar_18).xyz;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_LightTexture0, tmpvar_19.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_20.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump vec2 tmpvar_27;
  tmpvar_27.x = dot ((viewDir_26 - (2.0 * 
    (dot (tmpvar_24, viewDir_26) * tmpvar_24)
  )), lightDir_7);
  tmpvar_27.y = (1.0 - clamp (dot (tmpvar_24, viewDir_26), 0.0, 1.0));
  mediump vec2 tmpvar_28;
  tmpvar_28.x = ((tmpvar_27 * tmpvar_27) * (tmpvar_27 * tmpvar_27)).x;
  tmpvar_28.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (unity_NHxRoughness, tmpvar_28);
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_29.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_24, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_31;
  tmpvar_31 = exp2(-(tmpvar_30));
  tmpvar_1 = tmpvar_31;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
bool u_xlatb15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
float u_xlat22;
float u_xlat23;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_21 = texture(_LightTexture0, u_xlat2.xyz, -8.0).w;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat2.xyz);
    u_xlat15 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat22 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat23 = sqrt(u_xlat22);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat23);
#else
    u_xlatb15 = u_xlat15<u_xlat23;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat15 = u_xlat22 * _LightPos.w;
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat2.xyz = vec3(u_xlat22) * u_xlat2.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_15 = u_xlat16_4.x * u_xlat10_15;
    u_xlat16_21 = u_xlat10_21 * u_xlat16_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.w = -8.0;
  tmpvar_19.xyz = (unity_WorldToLight * tmpvar_18).xyz;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_LightTexture0, tmpvar_19.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_20.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump float specularTerm_27;
  mediump vec3 tmpvar_28;
  mediump vec3 inVec_29;
  inVec_29 = (lightDir_7 + viewDir_26);
  tmpvar_28 = (inVec_29 * inversesqrt(max (0.001, 
    dot (inVec_29, inVec_29)
  )));
  mediump float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_24, tmpvar_28), 0.0, 1.0);
  mediump float tmpvar_31;
  tmpvar_31 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_32;
  tmpvar_32 = (tmpvar_31 * tmpvar_31);
  specularTerm_27 = ((tmpvar_32 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_28), 0.0, 1.0)) * (1.5 + tmpvar_32))
   * 
    (((tmpvar_30 * tmpvar_30) * ((tmpvar_32 * tmpvar_32) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (specularTerm_27, 0.0, 100.0);
  specularTerm_27 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_33 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_16;
  tmpvar_16 = dot (textureCube (_ShadowMapTexture, tmpvar_11), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_17;
  if ((tmpvar_16 < mydist_15)) {
    tmpvar_17 = _LightShadowData.x;
  } else {
    tmpvar_17 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_17);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.w = -8.0;
  tmpvar_19.xyz = (unity_WorldToLight * tmpvar_18).xyz;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_LightTexture0, tmpvar_19.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_20.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_26;
  viewDir_26 = -(tmpvar_25);
  mediump float specularTerm_27;
  mediump vec3 tmpvar_28;
  mediump vec3 inVec_29;
  inVec_29 = (lightDir_7 + viewDir_26);
  tmpvar_28 = (inVec_29 * inversesqrt(max (0.001, 
    dot (inVec_29, inVec_29)
  )));
  mediump float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_24, tmpvar_28), 0.0, 1.0);
  mediump float tmpvar_31;
  tmpvar_31 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_32;
  tmpvar_32 = (tmpvar_31 * tmpvar_31);
  specularTerm_27 = ((tmpvar_32 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_28), 0.0, 1.0)) * (1.5 + tmpvar_32))
   * 
    (((tmpvar_30 * tmpvar_30) * ((tmpvar_32 * tmpvar_32) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_33;
  tmpvar_33 = clamp (specularTerm_27, 0.0, 100.0);
  specularTerm_27 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_33 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat22) * u_xlat3.xyz;
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat22 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat4.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_21 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_21);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat4.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_1 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_1 = u_xlat16_5.x * u_xlat16_1 + 1.00001001;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_21 = u_xlat16_26 / u_xlat16_21;
    u_xlat16_21 = u_xlat16_21 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_21, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat22<u_xlat7);
#else
    u_xlatb7 = u_xlat22<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat16_0.x = u_xlat10_0 * u_xlat16_7;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat22) * u_xlat3.xyz;
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat22 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat4.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_21 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_21);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat4.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_1 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_1 = u_xlat16_5.x * u_xlat16_1 + 1.00001001;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_21 = u_xlat16_26 / u_xlat16_21;
    u_xlat16_21 = u_xlat16_21 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_21, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat22<u_xlat7);
#else
    u_xlatb7 = u_xlat22<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat16_0.x = u_xlat10_0 * u_xlat16_7;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  shadowVals_26.x = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_26.y = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_26.z = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_26.w = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_28;
  tmpvar_28 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_29;
  tmpvar_29 = _LightShadowData.xxxx;
  mediump float tmpvar_30;
  if (tmpvar_28.x) {
    tmpvar_30 = tmpvar_29.x;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_28.y) {
    tmpvar_31 = tmpvar_29.y;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_28.z) {
    tmpvar_32 = tmpvar_29.z;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_28.w) {
    tmpvar_33 = tmpvar_29.w;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump vec4 tmpvar_34;
  tmpvar_34.x = tmpvar_30;
  tmpvar_34.y = tmpvar_31;
  tmpvar_34.z = tmpvar_32;
  tmpvar_34.w = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_36;
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_42;
  viewDir_42 = -(tmpvar_41);
  mediump vec2 tmpvar_43;
  tmpvar_43.x = dot ((viewDir_42 - (2.0 * 
    (dot (tmpvar_40, viewDir_42) * tmpvar_40)
  )), lightDir_7);
  tmpvar_43.y = (1.0 - clamp (dot (tmpvar_40, viewDir_42), 0.0, 1.0));
  mediump vec2 tmpvar_44;
  tmpvar_44.x = ((tmpvar_43 * tmpvar_43) * (tmpvar_43 * tmpvar_43)).x;
  tmpvar_44.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_45;
  tmpvar_45 = texture2D (unity_NHxRoughness, tmpvar_44);
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_45.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_40, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(tmpvar_46));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
lowp vec4 u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
lowp float u_xlat10_25;
bool u_xlatb25;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = vec3(u_xlat16_24) * u_xlat1.xyz;
    u_xlat1.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat1.x = inversesqrt(u_xlat1.x);
    u_xlat1.xyz = u_xlat1.xxx * u_xlat3.xyz;
    u_xlat16_24 = dot((-u_xlat1.xyz), u_xlat16_0.xyz);
    u_xlat16_24 = u_xlat16_24 + u_xlat16_24;
    u_xlat16_0.xyz = u_xlat16_0.xyz * (-vec3(u_xlat16_24)) + (-u_xlat1.xyz);
    u_xlat16_0.x = dot(u_xlat16_0.xyz, u_xlat4.xyz);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat10_1 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_0.y = (-u_xlat10_1.w) + 1.0;
    u_xlat10_25 = texture(unity_NHxRoughness, u_xlat16_0.xy).w;
    u_xlat16_25 = u_xlat10_25 * 16.0;
    u_xlat16_0.xyz = vec3(u_xlat16_25) * u_xlat10_1.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xyz = u_xlat16_7.xyz * u_xlat16_0.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  shadowVals_26.x = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_26.y = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_26.z = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_26.w = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_28;
  tmpvar_28 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_29;
  tmpvar_29 = _LightShadowData.xxxx;
  mediump float tmpvar_30;
  if (tmpvar_28.x) {
    tmpvar_30 = tmpvar_29.x;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_28.y) {
    tmpvar_31 = tmpvar_29.y;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_28.z) {
    tmpvar_32 = tmpvar_29.z;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_28.w) {
    tmpvar_33 = tmpvar_29.w;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump vec4 tmpvar_34;
  tmpvar_34.x = tmpvar_30;
  tmpvar_34.y = tmpvar_31;
  tmpvar_34.z = tmpvar_32;
  tmpvar_34.w = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_36;
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_42;
  viewDir_42 = -(tmpvar_41);
  mediump float specularTerm_43;
  mediump vec3 tmpvar_44;
  mediump vec3 inVec_45;
  inVec_45 = (lightDir_7 + viewDir_42);
  tmpvar_44 = (inVec_45 * inversesqrt(max (0.001, 
    dot (inVec_45, inVec_45)
  )));
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_40, tmpvar_44), 0.0, 1.0);
  mediump float tmpvar_47;
  tmpvar_47 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_48;
  tmpvar_48 = (tmpvar_47 * tmpvar_47);
  specularTerm_43 = ((tmpvar_48 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_44), 0.0, 1.0)) * (1.5 + tmpvar_48))
   * 
    (((tmpvar_46 * tmpvar_46) * ((tmpvar_48 * tmpvar_48) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_49;
  tmpvar_49 = clamp (specularTerm_43, 0.0, 100.0);
  specularTerm_43 = tmpvar_49;
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_49 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_40, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_51;
  tmpvar_51 = exp2(-(tmpvar_50));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_17.w;
  atten_6 = (tmpvar_18 * float((tmpvar_15.w < 0.0)));
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19));
  atten_6 = (atten_6 * tmpvar_20.w);
  mediump float tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_10;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_WorldToShadow[0] * tmpvar_23);
  lowp float tmpvar_25;
  highp vec4 shadowVals_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_24.xyz / tmpvar_24.w);
  shadowVals_26.x = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_26.y = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_26.z = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_26.w = texture2D (_ShadowMapTexture, (tmpvar_27.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_28;
  tmpvar_28 = lessThan (shadowVals_26, tmpvar_27.zzzz);
  mediump vec4 tmpvar_29;
  tmpvar_29 = _LightShadowData.xxxx;
  mediump float tmpvar_30;
  if (tmpvar_28.x) {
    tmpvar_30 = tmpvar_29.x;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_28.y) {
    tmpvar_31 = tmpvar_29.y;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_28.z) {
    tmpvar_32 = tmpvar_29.z;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_28.w) {
    tmpvar_33 = tmpvar_29.w;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump vec4 tmpvar_34;
  tmpvar_34.x = tmpvar_30;
  tmpvar_34.y = tmpvar_31;
  tmpvar_34.z = tmpvar_32;
  tmpvar_34.w = tmpvar_33;
  mediump float tmpvar_35;
  tmpvar_35 = dot (tmpvar_34, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_25 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp ((tmpvar_25 + tmpvar_22), 0.0, 1.0);
  tmpvar_21 = tmpvar_36;
  atten_6 = (atten_6 * tmpvar_21);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_42;
  viewDir_42 = -(tmpvar_41);
  mediump float specularTerm_43;
  mediump vec3 tmpvar_44;
  mediump vec3 inVec_45;
  inVec_45 = (lightDir_7 + viewDir_42);
  tmpvar_44 = (inVec_45 * inversesqrt(max (0.001, 
    dot (inVec_45, inVec_45)
  )));
  mediump float tmpvar_46;
  tmpvar_46 = clamp (dot (tmpvar_40, tmpvar_44), 0.0, 1.0);
  mediump float tmpvar_47;
  tmpvar_47 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_48;
  tmpvar_48 = (tmpvar_47 * tmpvar_47);
  specularTerm_43 = ((tmpvar_48 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_44), 0.0, 1.0)) * (1.5 + tmpvar_48))
   * 
    (((tmpvar_46 * tmpvar_46) * ((tmpvar_48 * tmpvar_48) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_49;
  tmpvar_49 = clamp (specularTerm_43, 0.0, 100.0);
  specularTerm_43 = tmpvar_49;
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_49 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_40, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_51;
  tmpvar_51 = exp2(-(tmpvar_50));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
mediump float u_xlat16_8;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_18;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
bool u_xlatb25;
mediump float u_xlat16_26;
mediump float u_xlat16_31;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_25 = max(u_xlat16_24, 0.00100000005);
    u_xlat16_24 = inversesqrt(u_xlat16_25);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_25 = max(u_xlat16_24, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_24 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_18 = u_xlat16_24 * u_xlat16_24 + 1.5;
    u_xlat16_24 = u_xlat16_24 * u_xlat16_24;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_18;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_0.x = dot(u_xlat16_7.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_8 = dot(u_xlat16_7.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_8 = min(max(u_xlat16_8, 0.0), 1.0);
#else
    u_xlat16_8 = clamp(u_xlat16_8, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_26 = u_xlat16_24 * u_xlat16_24 + -1.0;
    u_xlat16_26 = u_xlat16_0.x * u_xlat16_26 + 1.00001001;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_26;
    u_xlat16_25 = u_xlat16_24 / u_xlat16_25;
    u_xlat16_25 = u_xlat16_25 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_25, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_8) * u_xlat16_0.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
mediump float u_xlat16_8;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_18;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
bool u_xlatb25;
mediump float u_xlat16_26;
mediump float u_xlat16_31;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_25 = max(u_xlat16_24, 0.00100000005);
    u_xlat16_24 = inversesqrt(u_xlat16_25);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_25 = max(u_xlat16_24, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_24 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_18 = u_xlat16_24 * u_xlat16_24 + 1.5;
    u_xlat16_24 = u_xlat16_24 * u_xlat16_24;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_18;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_0.x = dot(u_xlat16_7.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_8 = dot(u_xlat16_7.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_8 = min(max(u_xlat16_8, 0.0), 1.0);
#else
    u_xlat16_8 = clamp(u_xlat16_8, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_26 = u_xlat16_24 * u_xlat16_24 + -1.0;
    u_xlat16_26 = u_xlat16_0.x * u_xlat16_26 + 1.00001001;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_26;
    u_xlat16_25 = u_xlat16_24 / u_xlat16_25;
    u_xlat16_25 = u_xlat16_25 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_25, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_8) * u_xlat16_0.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump vec2 tmpvar_31;
  tmpvar_31.x = dot ((viewDir_30 - (2.0 * 
    (dot (tmpvar_28, viewDir_30) * tmpvar_28)
  )), lightDir_7);
  tmpvar_31.y = (1.0 - clamp (dot (tmpvar_28, viewDir_30), 0.0, 1.0));
  mediump vec2 tmpvar_32;
  tmpvar_32.x = ((tmpvar_31 * tmpvar_31) * (tmpvar_31 * tmpvar_31)).x;
  tmpvar_32.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (unity_NHxRoughness, tmpvar_32);
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_33.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_28, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_26 = dot((-u_xlat0.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat0.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_7 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_37 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_7 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_37 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat13 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat19);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat2 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.x = dot(u_xlat2, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.y = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat0.xyz = u_xlat0.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat0 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat2.w = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.z = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0.x = sqrt(u_xlat13);
    u_xlat6 = u_xlat13 * _LightPos.w;
    u_xlat10_6 = texture(_LightTextureB0, vec2(u_xlat6)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * 0.970000029;
    u_xlatb1 = lessThan(u_xlat2, u_xlat0.xxxx);
    u_xlat1.x = (u_xlatb1.x) ? _LightShadowData.x : float(1.0);
    u_xlat1.y = (u_xlatb1.y) ? _LightShadowData.x : float(1.0);
    u_xlat1.z = (u_xlatb1.z) ? _LightShadowData.x : float(1.0);
    u_xlat1.w = (u_xlatb1.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat1, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_0.x = u_xlat10_6 * u_xlat16_5.x;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat13 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat19);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat2 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.x = dot(u_xlat2, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.y = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat0.xyz = u_xlat0.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat0 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat2.w = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.z = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0.x = sqrt(u_xlat13);
    u_xlat6 = u_xlat13 * _LightPos.w;
    u_xlat10_6 = texture(_LightTextureB0, vec2(u_xlat6)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * 0.970000029;
    u_xlatb1 = lessThan(u_xlat2, u_xlat0.xxxx);
    u_xlat1.x = (u_xlatb1.x) ? _LightShadowData.x : float(1.0);
    u_xlat1.y = (u_xlatb1.y) ? _LightShadowData.x : float(1.0);
    u_xlat1.z = (u_xlatb1.z) ? _LightShadowData.x : float(1.0);
    u_xlat1.w = (u_xlatb1.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat1, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_0.x = u_xlat10_6 * u_xlat16_5.x;
    u_xlat0.xyz = u_xlat16_0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_LightTexture0, tmpvar_26.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_27.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump vec2 tmpvar_34;
  tmpvar_34.x = dot ((viewDir_33 - (2.0 * 
    (dot (tmpvar_31, viewDir_33) * tmpvar_31)
  )), lightDir_7);
  tmpvar_34.y = (1.0 - clamp (dot (tmpvar_31, viewDir_33), 0.0, 1.0));
  mediump vec2 tmpvar_35;
  tmpvar_35.x = ((tmpvar_34 * tmpvar_34) * (tmpvar_34 * tmpvar_34)).x;
  tmpvar_35.y = (1.0 - gbuffer1_3.w);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (unity_NHxRoughness, tmpvar_35);
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = ((gbuffer0_4.xyz + (
    (tmpvar_36.w * 16.0)
   * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_31, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_26 = dot((-u_xlat0.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat0.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_LightTexture0, tmpvar_26.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_27.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump float specularTerm_34;
  mediump vec3 tmpvar_35;
  mediump vec3 inVec_36;
  inVec_36 = (lightDir_7 + viewDir_33);
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_31, tmpvar_35), 0.0, 1.0);
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_38 * tmpvar_38);
  specularTerm_34 = ((tmpvar_39 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_35), 0.0, 1.0)) * (1.5 + tmpvar_39))
   * 
    (((tmpvar_37 * tmpvar_37) * ((tmpvar_39 * tmpvar_39) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_34, 0.0, 100.0);
  specularTerm_34 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_40 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_31, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp float tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2(tmpvar_13)).w;
  atten_6 = tmpvar_14;
  highp vec4 shadowVals_15;
  highp float mydist_16;
  mydist_16 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_15.x = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.y = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.z = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_15.w = dot (textureCube (_ShadowMapTexture, (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (shadowVals_15, vec4(mydist_16));
  mediump vec4 tmpvar_18;
  tmpvar_18 = _LightShadowData.xxxx;
  mediump float tmpvar_19;
  if (tmpvar_17.x) {
    tmpvar_19 = tmpvar_18.x;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_17.y) {
    tmpvar_20 = tmpvar_18.y;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_17.z) {
    tmpvar_21 = tmpvar_18.z;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_17.w) {
    tmpvar_22 = tmpvar_18.w;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump vec4 tmpvar_23;
  tmpvar_23.x = tmpvar_19;
  tmpvar_23.y = tmpvar_20;
  tmpvar_23.z = tmpvar_21;
  tmpvar_23.w = tmpvar_22;
  mediump float tmpvar_24;
  tmpvar_24 = dot (tmpvar_23, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_LightTexture0, tmpvar_26.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_27.w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump float specularTerm_34;
  mediump vec3 tmpvar_35;
  mediump vec3 inVec_36;
  inVec_36 = (lightDir_7 + viewDir_33);
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_31, tmpvar_35), 0.0, 1.0);
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_38 * tmpvar_38);
  specularTerm_34 = ((tmpvar_39 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_35), 0.0, 1.0)) * (1.5 + tmpvar_39))
   * 
    (((tmpvar_37 * tmpvar_37) * ((tmpvar_39 * tmpvar_39) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_34, 0.0, 100.0);
  specularTerm_34 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_40 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_31, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat16_5.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_26, 0.319999993);
    u_xlat10_4 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_4.w) + 1.0;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_4.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat16_5.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_26, 0.319999993);
    u_xlat10_4 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_4.w) + 1.0;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_4.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    u_xlat16_0 = exp2((-u_xlat16_0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_6);
  tmpvar_20.y = (1.0 - clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0));
  mediump vec2 tmpvar_21;
  tmpvar_21.x = ((tmpvar_20 * tmpvar_20) * (tmpvar_20 * tmpvar_20)).x;
  tmpvar_21.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (unity_NHxRoughness, tmpvar_21);
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_22.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_17, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_23;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat13;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat10_18) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.xyz = u_xlat2.xyz * u_xlat16_4.xxx;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat10_15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0 = u_xlat16_4.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_21;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat10_15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0 = u_xlat16_4.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_21;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump vec2 tmpvar_15;
  tmpvar_15.x = dot ((viewDir_14 - (2.0 * 
    (dot (tmpvar_12, viewDir_14) * tmpvar_12)
  )), lightDir_5);
  tmpvar_15.y = (1.0 - clamp (dot (tmpvar_12, viewDir_14), 0.0, 1.0));
  mediump vec2 tmpvar_16;
  tmpvar_16.x = ((tmpvar_15 * tmpvar_15) * (tmpvar_15 * tmpvar_15)).x;
  tmpvar_16.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_NHxRoughness, tmpvar_16);
  mediump vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_17.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_12, lightDir_5)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_18;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat16_18 = dot((-u_xlat0.xyz), u_xlat16_3.xyz);
    u_xlat16_18 = u_xlat16_18 + u_xlat16_18;
    u_xlat16_4.xyz = u_xlat16_3.xyz * (-vec3(u_xlat16_18)) + (-u_xlat0.xyz);
    u_xlat16_3.x = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xxx * _LightColor.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_18 = u_xlat16_18 * u_xlat16_18;
    u_xlat16_4.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_15 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_15 = u_xlat10_15 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_15) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
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
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump float specularTerm_15;
  mediump vec3 tmpvar_16;
  mediump vec3 inVec_17;
  inVec_17 = (lightDir_5 + viewDir_14);
  tmpvar_16 = (inVec_17 * inversesqrt(max (0.001, 
    dot (inVec_17, inVec_17)
  )));
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_12, tmpvar_16), 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  specularTerm_15 = ((tmpvar_20 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_16), 0.0, 1.0)) * (1.5 + tmpvar_20))
   * 
    (((tmpvar_18 * tmpvar_18) * ((tmpvar_20 * tmpvar_20) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (specularTerm_15, 0.0, 100.0);
  specularTerm_15 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_21 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_12, lightDir_5), 0.0, 1.0));
  gl_FragData[0] = tmpvar_22;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
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
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump float specularTerm_15;
  mediump vec3 tmpvar_16;
  mediump vec3 inVec_17;
  inVec_17 = (lightDir_5 + viewDir_14);
  tmpvar_16 = (inVec_17 * inversesqrt(max (0.001, 
    dot (inVec_17, inVec_17)
  )));
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_12, tmpvar_16), 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  specularTerm_15 = ((tmpvar_20 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_16), 0.0, 1.0)) * (1.5 + tmpvar_20))
   * 
    (((tmpvar_18 * tmpvar_18) * ((tmpvar_20 * tmpvar_20) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (specularTerm_15, 0.0, 100.0);
  specularTerm_15 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_21 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_12, lightDir_5), 0.0, 1.0));
  gl_FragData[0] = tmpvar_22;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_0 = u_xlat16_18 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_0, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_0 = u_xlat16_18 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_0, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_15.w;
  atten_5 = (tmpvar_16 * float((tmpvar_13.w < 0.0)));
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = (atten_5 * tmpvar_18.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec2 tmpvar_25;
  tmpvar_25.x = dot ((viewDir_24 - (2.0 * 
    (dot (tmpvar_22, viewDir_24) * tmpvar_22)
  )), lightDir_6);
  tmpvar_25.y = (1.0 - clamp (dot (tmpvar_22, viewDir_24), 0.0, 1.0));
  mediump vec2 tmpvar_26;
  tmpvar_26.x = ((tmpvar_25 * tmpvar_25) * (tmpvar_25 * tmpvar_25)).x;
  tmpvar_26.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (unity_NHxRoughness, tmpvar_26);
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_27.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_22, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_19;
lowp float u_xlat10_19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_19 = u_xlat10_19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_18 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_15.w;
  atten_5 = (tmpvar_16 * float((tmpvar_13.w < 0.0)));
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = (atten_5 * tmpvar_18.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_6 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_31 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_22, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  highp float tmpvar_16;
  tmpvar_16 = tmpvar_15.w;
  atten_5 = (tmpvar_16 * float((tmpvar_13.w < 0.0)));
  highp float tmpvar_17;
  tmpvar_17 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTextureB0, vec2(tmpvar_17));
  atten_5 = (atten_5 * tmpvar_18.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_6 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_31 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_22, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat10_0;
    u_xlat0.x = u_xlat10_13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_9;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_LightTexture0, tmpvar_15.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_16.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec2 tmpvar_23;
  tmpvar_23.x = dot ((viewDir_22 - (2.0 * 
    (dot (tmpvar_20, viewDir_22) * tmpvar_20)
  )), lightDir_6);
  tmpvar_23.y = (1.0 - clamp (dot (tmpvar_20, viewDir_22), 0.0, 1.0));
  mediump vec2 tmpvar_24;
  tmpvar_24.x = ((tmpvar_23 * tmpvar_23) * (tmpvar_23 * tmpvar_23)).x;
  tmpvar_24.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (unity_NHxRoughness, tmpvar_24);
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_25.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_20, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_26;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat13;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_19;
lowp float u_xlat10_19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat10_18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_19 = u_xlat10_19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0 = u_xlat10_0 * u_xlat10_18;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_9;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_LightTexture0, tmpvar_15.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_16.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_9;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_LightTexture0, tmpvar_15.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_16.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0 = u_xlat10_0 * u_xlat10_13;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
lowp float u_xlat10_13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat10_13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat16_0 = u_xlat10_0 * u_xlat10_13;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0);
  atten_5 = tmpvar_13.w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_6);
  tmpvar_20.y = (1.0 - clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0));
  mediump vec2 tmpvar_21;
  tmpvar_21.x = ((tmpvar_20 * tmpvar_20) * (tmpvar_20 * tmpvar_20)).x;
  tmpvar_21.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (unity_NHxRoughness, tmpvar_21);
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_22.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_17, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_23;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_10;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_18) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat6.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0);
  atten_5 = tmpvar_13.w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0);
  atten_5 = tmpvar_13.w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-005;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = vec3(u_xlat10_0) * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 tmpvar_25;
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
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump vec2 tmpvar_34;
  tmpvar_34.x = dot ((viewDir_33 - (2.0 * 
    (dot (tmpvar_31, viewDir_33) * tmpvar_31)
  )), lightDir_6);
  tmpvar_34.y = (1.0 - clamp (dot (tmpvar_31, viewDir_33), 0.0, 1.0));
  mediump vec2 tmpvar_35;
  tmpvar_35.x = ((tmpvar_34 * tmpvar_34) * (tmpvar_34 * tmpvar_34)).x;
  tmpvar_35.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (unity_NHxRoughness, tmpvar_35);
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_36.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_31, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_37;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec3 u_xlat16_0;
vec3 u_xlat1;
lowp vec4 u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
lowp float u_xlat10_22;
bool u_xlatb22;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1.x * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_21 = inversesqrt(u_xlat16_21);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = vec3(u_xlat16_21) * u_xlat1.xyz;
    u_xlat1.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat1.x = inversesqrt(u_xlat1.x);
    u_xlat1.xyz = u_xlat1.xxx * u_xlat3.xyz;
    u_xlat16_21 = dot((-u_xlat1.xyz), u_xlat16_0.xyz);
    u_xlat16_21 = u_xlat16_21 + u_xlat16_21;
    u_xlat16_0.xyz = u_xlat16_0.xyz * (-vec3(u_xlat16_21)) + (-u_xlat1.xyz);
    u_xlat16_0.x = dot(u_xlat16_0.xyz, u_xlat4.xyz);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat10_1 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_0.y = (-u_xlat10_1.w) + 1.0;
    u_xlat10_22 = texture(unity_NHxRoughness, u_xlat16_0.xy).w;
    u_xlat16_22 = u_xlat10_22 * 16.0;
    u_xlat16_0.xyz = vec3(u_xlat16_22) * u_xlat10_1.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_0.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 tmpvar_25;
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
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump float specularTerm_34;
  mediump vec3 tmpvar_35;
  mediump vec3 inVec_36;
  inVec_36 = (lightDir_6 + viewDir_33);
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_31, tmpvar_35), 0.0, 1.0);
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_38 * tmpvar_38);
  specularTerm_34 = ((tmpvar_39 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_35), 0.0, 1.0)) * (1.5 + tmpvar_39))
   * 
    (((tmpvar_37 * tmpvar_37) * ((tmpvar_39 * tmpvar_39) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_34, 0.0, 100.0);
  specularTerm_34 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_40 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_31, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_41;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 tmpvar_25;
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
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_30;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_32;
  tmpvar_32 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_33;
  viewDir_33 = -(tmpvar_32);
  mediump float specularTerm_34;
  mediump vec3 tmpvar_35;
  mediump vec3 inVec_36;
  inVec_36 = (lightDir_6 + viewDir_33);
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  mediump float tmpvar_37;
  tmpvar_37 = clamp (dot (tmpvar_31, tmpvar_35), 0.0, 1.0);
  mediump float tmpvar_38;
  tmpvar_38 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_39;
  tmpvar_39 = (tmpvar_38 * tmpvar_38);
  specularTerm_34 = ((tmpvar_39 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_35), 0.0, 1.0)) * (1.5 + tmpvar_39))
   * 
    (((tmpvar_37 * tmpvar_37) * ((tmpvar_39 * tmpvar_39) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_40;
  tmpvar_40 = clamp (specularTerm_34, 0.0, 100.0);
  specularTerm_34 = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41.w = 1.0;
  tmpvar_41.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_40 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_31, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_41;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_16;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
bool u_xlatb22;
mediump float u_xlat16_23;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat22 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat22) + u_xlat4.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_22 = max(u_xlat16_21, 0.00100000005);
    u_xlat16_21 = inversesqrt(u_xlat16_22);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_22 = max(u_xlat16_21, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_21 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_16 = u_xlat16_21 * u_xlat16_21 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_21;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_16;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_0.x = dot(u_xlat16_6.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_7 = min(max(u_xlat16_7, 0.0), 1.0);
#else
    u_xlat16_7 = clamp(u_xlat16_7, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_23 = u_xlat16_21 * u_xlat16_21 + -1.0;
    u_xlat16_23 = u_xlat16_0.x * u_xlat16_23 + 1.00001001;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_21 / u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_22, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    SV_Target0.xyz = vec3(u_xlat16_7) * u_xlat16_0.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat15;
lowp float u_xlat10_15;
mediump float u_xlat16_16;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_22;
bool u_xlatb22;
mediump float u_xlat16_23;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat22 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat22 = _ZBufferParams.x * u_xlat22 + _ZBufferParams.y;
    u_xlat22 = float(1.0) / u_xlat22;
    u_xlat3.xyz = vec3(u_xlat22) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_1 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = (-u_xlat1.z) * u_xlat22 + u_xlat1.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat1.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat16_0.x + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb22 = !!(u_xlat8.z<0.0);
#else
    u_xlatb22 = u_xlat8.z<0.0;
#endif
    u_xlat22 = u_xlatb22 ? 1.0 : float(0.0);
    u_xlat10_8 = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat22 * u_xlat10_8;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat15) * u_xlat4.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat8.x = u_xlat10_15 * u_xlat8.x;
    u_xlat1.x = u_xlat1.x * u_xlat8.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat22 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat22) + u_xlat4.xyz;
    u_xlat16_21 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_22 = max(u_xlat16_21, 0.00100000005);
    u_xlat16_21 = inversesqrt(u_xlat16_22);
    u_xlat16_0.xyz = vec3(u_xlat16_21) * u_xlat16_0.xyz;
    u_xlat16_21 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_21 = min(max(u_xlat16_21, 0.0), 1.0);
#else
    u_xlat16_21 = clamp(u_xlat16_21, 0.0, 1.0);
#endif
    u_xlat16_22 = max(u_xlat16_21, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_21 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_16 = u_xlat16_21 * u_xlat16_21 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_21;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_16;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_0.x = dot(u_xlat16_6.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_7 = min(max(u_xlat16_7, 0.0), 1.0);
#else
    u_xlat16_7 = clamp(u_xlat16_7, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_23 = u_xlat16_21 * u_xlat16_21 + -1.0;
    u_xlat16_23 = u_xlat16_0.x * u_xlat16_23 + 1.00001001;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_21 / u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_22, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    SV_Target0.xyz = vec3(u_xlat16_7) * u_xlat16_0.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_6);
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0));
  mediump vec2 tmpvar_22;
  tmpvar_22.x = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21)).x;
  tmpvar_22.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_NHxRoughness, tmpvar_22);
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_23.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_18, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_24;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat6.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat6.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10 = u_xlat16_10 * u_xlat16_10;
    u_xlat16_5.x = u_xlat16_10 * u_xlat16_10;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_6 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_6 = u_xlat10_6 * 16.0;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xyz = u_xlat16_4.xxx * u_xlat0.xzw;
    u_xlat16_5.xyz = vec3(u_xlat16_6) * u_xlat10_2.xyz + u_xlat10_3.xyz;
    SV_Target0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_6 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_27 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_6 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_27 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (unity_WorldToLight * tmpvar_15).xy;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  atten_5 = (atten_5 * tmpvar_17.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = dot ((viewDir_23 - (2.0 * 
    (dot (tmpvar_21, viewDir_23) * tmpvar_21)
  )), lightDir_6);
  tmpvar_24.y = (1.0 - clamp (dot (tmpvar_21, viewDir_23), 0.0, 1.0));
  mediump vec2 tmpvar_25;
  tmpvar_25.x = ((tmpvar_24 * tmpvar_24) * (tmpvar_24 * tmpvar_24)).x;
  tmpvar_25.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (unity_NHxRoughness, tmpvar_25);
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_26.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_21, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
float u_xlat18;
mediump float u_xlat16_18;
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
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_22 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_18 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_18 = u_xlat10_18 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (unity_WorldToLight * tmpvar_15).xy;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  atten_5 = (atten_5 * tmpvar_17.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_6 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_30 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_31;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_7);
  highp float tmpvar_14;
  tmpvar_14 = clamp ((tmpvar_13.x + clamp (
    ((mix (tmpvar_8.z, sqrt(
      dot (tmpvar_10, tmpvar_10)
    ), unity_ShadowFadeCenterAndType.w) * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_12 = tmpvar_14;
  atten_5 = tmpvar_12;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_9;
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (unity_WorldToLight * tmpvar_15).xy;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_LightTexture0, tmpvar_16.xy, -8.0);
  atten_5 = (atten_5 * tmpvar_17.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_6 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_30 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_31;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec2 u_xlat6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat0.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat0.x = u_xlat10_6 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec2 tmpvar_23;
  tmpvar_23.x = dot ((viewDir_22 - (2.0 * 
    (dot (tmpvar_20, viewDir_22) * tmpvar_20)
  )), lightDir_6);
  tmpvar_23.y = (1.0 - clamp (dot (tmpvar_20, viewDir_22), 0.0, 1.0));
  mediump vec2 tmpvar_24;
  tmpvar_24.x = ((tmpvar_23 * tmpvar_23) * (tmpvar_23 * tmpvar_23)).x;
  tmpvar_24.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (unity_NHxRoughness, tmpvar_24);
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_25.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_20, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_26;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat13;
float u_xlat18;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat2.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat10_6 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_6 = u_xlat10_6 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat16_6) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6 = sqrt(u_xlat18);
    u_xlat12 = u_xlat18 * _LightPos.w;
    u_xlat10_12 = texture(_LightTextureB0, vec2(u_xlat12)).w;
    u_xlat6 = u_xlat6 * _LightPositionRange.w;
    u_xlat6 = u_xlat6 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat6);
#else
    u_xlatb0 = u_xlat0.x<u_xlat6;
#endif
    u_xlat16_5.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0 = u_xlat10_12 * u_xlat16_5.x;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_7 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_7);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_7 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_14 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_14 = u_xlat16_5.x * u_xlat16_14 + 1.00001001;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_7 = u_xlat16_26 / u_xlat16_7;
    u_xlat16_7 = u_xlat16_7 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_7, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat7);
#else
    u_xlatb0 = u_xlat0.x<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat0.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_7 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_7);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_7 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_14 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_14 = u_xlat16_5.x * u_xlat16_14 + 1.00001001;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_7;
    u_xlat16_7 = u_xlat16_26 / u_xlat16_7;
    u_xlat16_7 = u_xlat16_7 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_7, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0.x<u_xlat7);
#else
    u_xlatb0 = u_xlat0.x<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_0 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.w = -8.0;
  tmpvar_18.xyz = (unity_WorldToLight * tmpvar_17).xyz;
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_LightTexture0, tmpvar_18.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_19.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec2 tmpvar_26;
  tmpvar_26.x = dot ((viewDir_25 - (2.0 * 
    (dot (tmpvar_23, viewDir_25) * tmpvar_23)
  )), lightDir_6);
  tmpvar_26.y = (1.0 - clamp (dot (tmpvar_23, viewDir_25), 0.0, 1.0));
  mediump vec2 tmpvar_27;
  tmpvar_27.x = ((tmpvar_26 * tmpvar_26) * (tmpvar_26 * tmpvar_26)).x;
  tmpvar_27.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (unity_NHxRoughness, tmpvar_27);
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_28.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_23, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_29;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
mediump float u_xlat16_15;
lowp float u_xlat10_15;
bool u_xlatb15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
float u_xlat22;
float u_xlat23;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat2.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_21 = texture(_LightTexture0, u_xlat2.xyz, -8.0).w;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat2.xyz);
    u_xlat15 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat22 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat23 = sqrt(u_xlat22);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat23);
#else
    u_xlatb15 = u_xlat15<u_xlat23;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat15 = u_xlat22 * _LightPos.w;
    u_xlat22 = inversesqrt(u_xlat22);
    u_xlat2.xyz = vec3(u_xlat22) * u_xlat2.xyz;
    u_xlat10_15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_15 = u_xlat16_4.x * u_xlat10_15;
    u_xlat16_21 = u_xlat10_21 * u_xlat16_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.w = -8.0;
  tmpvar_18.xyz = (unity_WorldToLight * tmpvar_17).xyz;
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_LightTexture0, tmpvar_18.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_19.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_6 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_32 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp float mydist_14;
  mydist_14 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_15;
  tmpvar_15 = dot (textureCube (_ShadowMapTexture, tmpvar_10), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_16;
  if ((tmpvar_15 < mydist_14)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.0;
  };
  atten_5 = (atten_5 * tmpvar_16);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.w = -8.0;
  tmpvar_18.xyz = (unity_WorldToLight * tmpvar_17).xyz;
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_LightTexture0, tmpvar_18.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_19.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_6 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_32 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat22) * u_xlat3.xyz;
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat22 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat4.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_21 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_21);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat4.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_1 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_1 = u_xlat16_5.x * u_xlat16_1 + 1.00001001;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_21 = u_xlat16_26 / u_xlat16_21;
    u_xlat16_21 = u_xlat16_21 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_21, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat22<u_xlat7);
#else
    u_xlatb7 = u_xlat22<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat16_0 = u_xlat10_0 * u_xlat16_7;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat15;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat15 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat4.xyz = vec3(u_xlat22) * u_xlat3.xyz;
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat22 = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat16_5.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat4.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_21 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_21);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat4.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_1 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_1 = u_xlat16_5.x * u_xlat16_1 + 1.00001001;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_1;
    u_xlat16_21 = u_xlat16_26 / u_xlat16_21;
    u_xlat16_21 = u_xlat16_21 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_21, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_0 = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat7 = sqrt(u_xlat15);
    u_xlat14 = u_xlat15 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7 = u_xlat7 * _LightPositionRange.w;
    u_xlat7 = u_xlat7 * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat22<u_xlat7);
#else
    u_xlatb7 = u_xlat22<u_xlat7;
#endif
    u_xlat16_6.x = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_6.x;
    u_xlat16_0 = u_xlat10_0 * u_xlat16_7;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 shadowVals_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  shadowVals_25.x = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_25.y = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_25.z = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_25.w = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_27;
  tmpvar_27 = lessThan (shadowVals_25, tmpvar_26.zzzz);
  mediump vec4 tmpvar_28;
  tmpvar_28 = _LightShadowData.xxxx;
  mediump float tmpvar_29;
  if (tmpvar_27.x) {
    tmpvar_29 = tmpvar_28.x;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_27.y) {
    tmpvar_30 = tmpvar_28.y;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_27.z) {
    tmpvar_31 = tmpvar_28.z;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_27.w) {
    tmpvar_32 = tmpvar_28.w;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump vec4 tmpvar_33;
  tmpvar_33.x = tmpvar_29;
  tmpvar_33.y = tmpvar_30;
  tmpvar_33.z = tmpvar_31;
  tmpvar_33.w = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((tmpvar_24 + tmpvar_21), 0.0, 1.0);
  tmpvar_20 = tmpvar_35;
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_36;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_40;
  tmpvar_40 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_41;
  viewDir_41 = -(tmpvar_40);
  mediump vec2 tmpvar_42;
  tmpvar_42.x = dot ((viewDir_41 - (2.0 * 
    (dot (tmpvar_39, viewDir_41) * tmpvar_39)
  )), lightDir_6);
  tmpvar_42.y = (1.0 - clamp (dot (tmpvar_39, viewDir_41), 0.0, 1.0));
  mediump vec2 tmpvar_43;
  tmpvar_43.x = ((tmpvar_42 * tmpvar_42) * (tmpvar_42 * tmpvar_42)).x;
  tmpvar_43.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_44;
  tmpvar_44 = texture2D (unity_NHxRoughness, tmpvar_43);
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_44.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_39, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_45;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
lowp vec4 u_xlat10_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
lowp float u_xlat10_25;
bool u_xlatb25;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat16_0.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = vec3(u_xlat16_24) * u_xlat1.xyz;
    u_xlat1.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat1.x = inversesqrt(u_xlat1.x);
    u_xlat1.xyz = u_xlat1.xxx * u_xlat3.xyz;
    u_xlat16_24 = dot((-u_xlat1.xyz), u_xlat16_0.xyz);
    u_xlat16_24 = u_xlat16_24 + u_xlat16_24;
    u_xlat16_0.xyz = u_xlat16_0.xyz * (-vec3(u_xlat16_24)) + (-u_xlat1.xyz);
    u_xlat16_0.x = dot(u_xlat16_0.xyz, u_xlat4.xyz);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat10_1 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_0.y = (-u_xlat10_1.w) + 1.0;
    u_xlat10_25 = texture(unity_NHxRoughness, u_xlat16_0.xy).w;
    u_xlat16_25 = u_xlat10_25 * 16.0;
    u_xlat16_0.xyz = vec3(u_xlat16_25) * u_xlat10_1.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_7.xyz * u_xlat16_0.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 shadowVals_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  shadowVals_25.x = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_25.y = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_25.z = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_25.w = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_27;
  tmpvar_27 = lessThan (shadowVals_25, tmpvar_26.zzzz);
  mediump vec4 tmpvar_28;
  tmpvar_28 = _LightShadowData.xxxx;
  mediump float tmpvar_29;
  if (tmpvar_27.x) {
    tmpvar_29 = tmpvar_28.x;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_27.y) {
    tmpvar_30 = tmpvar_28.y;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_27.z) {
    tmpvar_31 = tmpvar_28.z;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_27.w) {
    tmpvar_32 = tmpvar_28.w;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump vec4 tmpvar_33;
  tmpvar_33.x = tmpvar_29;
  tmpvar_33.y = tmpvar_30;
  tmpvar_33.z = tmpvar_31;
  tmpvar_33.w = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((tmpvar_24 + tmpvar_21), 0.0, 1.0);
  tmpvar_20 = tmpvar_35;
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_36;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_40;
  tmpvar_40 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_41;
  viewDir_41 = -(tmpvar_40);
  mediump float specularTerm_42;
  mediump vec3 tmpvar_43;
  mediump vec3 inVec_44;
  inVec_44 = (lightDir_6 + viewDir_41);
  tmpvar_43 = (inVec_44 * inversesqrt(max (0.001, 
    dot (inVec_44, inVec_44)
  )));
  mediump float tmpvar_45;
  tmpvar_45 = clamp (dot (tmpvar_39, tmpvar_43), 0.0, 1.0);
  mediump float tmpvar_46;
  tmpvar_46 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_47;
  tmpvar_47 = (tmpvar_46 * tmpvar_46);
  specularTerm_42 = ((tmpvar_47 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_43), 0.0, 1.0)) * (1.5 + tmpvar_47))
   * 
    (((tmpvar_45 * tmpvar_45) * ((tmpvar_47 * tmpvar_47) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_48;
  tmpvar_48 = clamp (specularTerm_42, 0.0, 100.0);
  specularTerm_42 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_48 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_39, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_49;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_LightTexture0, tmpvar_15.xy, -8.0);
  highp float tmpvar_17;
  tmpvar_17 = tmpvar_16.w;
  atten_5 = (tmpvar_17 * float((tmpvar_14.w < 0.0)));
  highp float tmpvar_18;
  tmpvar_18 = (dot (tmpvar_11, tmpvar_11) * _LightPos.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTextureB0, vec2(tmpvar_18));
  atten_5 = (atten_5 * tmpvar_19.w);
  mediump float tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_9;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_WorldToShadow[0] * tmpvar_22);
  lowp float tmpvar_24;
  highp vec4 shadowVals_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_23.xyz / tmpvar_23.w);
  shadowVals_25.x = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_25.y = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_25.z = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_25.w = texture2D (_ShadowMapTexture, (tmpvar_26.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_27;
  tmpvar_27 = lessThan (shadowVals_25, tmpvar_26.zzzz);
  mediump vec4 tmpvar_28;
  tmpvar_28 = _LightShadowData.xxxx;
  mediump float tmpvar_29;
  if (tmpvar_27.x) {
    tmpvar_29 = tmpvar_28.x;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_27.y) {
    tmpvar_30 = tmpvar_28.y;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_27.z) {
    tmpvar_31 = tmpvar_28.z;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_27.w) {
    tmpvar_32 = tmpvar_28.w;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump vec4 tmpvar_33;
  tmpvar_33.x = tmpvar_29;
  tmpvar_33.y = tmpvar_30;
  tmpvar_33.z = tmpvar_31;
  tmpvar_33.w = tmpvar_32;
  mediump float tmpvar_34;
  tmpvar_34 = dot (tmpvar_33, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_24 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp ((tmpvar_24 + tmpvar_21), 0.0, 1.0);
  tmpvar_20 = tmpvar_35;
  atten_5 = (atten_5 * tmpvar_20);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_36;
  lowp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_37;
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_40;
  tmpvar_40 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_41;
  viewDir_41 = -(tmpvar_40);
  mediump float specularTerm_42;
  mediump vec3 tmpvar_43;
  mediump vec3 inVec_44;
  inVec_44 = (lightDir_6 + viewDir_41);
  tmpvar_43 = (inVec_44 * inversesqrt(max (0.001, 
    dot (inVec_44, inVec_44)
  )));
  mediump float tmpvar_45;
  tmpvar_45 = clamp (dot (tmpvar_39, tmpvar_43), 0.0, 1.0);
  mediump float tmpvar_46;
  tmpvar_46 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_47;
  tmpvar_47 = (tmpvar_46 * tmpvar_46);
  specularTerm_42 = ((tmpvar_47 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_43), 0.0, 1.0)) * (1.5 + tmpvar_47))
   * 
    (((tmpvar_45 * tmpvar_45) * ((tmpvar_47 * tmpvar_47) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_48;
  tmpvar_48 = clamp (specularTerm_42, 0.0, 100.0);
  specularTerm_42 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_48 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_39, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_49;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
mediump float u_xlat16_8;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_18;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
bool u_xlatb25;
mediump float u_xlat16_26;
mediump float u_xlat16_31;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_25 = max(u_xlat16_24, 0.00100000005);
    u_xlat16_24 = inversesqrt(u_xlat16_25);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_25 = max(u_xlat16_24, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_24 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_18 = u_xlat16_24 * u_xlat16_24 + 1.5;
    u_xlat16_24 = u_xlat16_24 * u_xlat16_24;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_18;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_0.x = dot(u_xlat16_7.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_8 = dot(u_xlat16_7.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_8 = min(max(u_xlat16_8, 0.0), 1.0);
#else
    u_xlat16_8 = clamp(u_xlat16_8, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_26 = u_xlat16_24 * u_xlat16_24 + -1.0;
    u_xlat16_26 = u_xlat16_0.x * u_xlat16_26 + 1.00001001;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_26;
    u_xlat16_25 = u_xlat16_24 / u_xlat16_25;
    u_xlat16_25 = u_xlat16_25 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_25, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    SV_Target0.xyz = vec3(u_xlat16_8) * u_xlat16_0.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
mediump float u_xlat16_1;
vec2 u_xlat2;
lowp vec3 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
lowp vec3 u_xlat10_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_7;
mediump float u_xlat16_8;
vec3 u_xlat9;
lowp float u_xlat10_9;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_18;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_25;
bool u_xlatb25;
mediump float u_xlat16_26;
mediump float u_xlat16_31;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat1.xyz = u_xlat1.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat25 = texture(_CameraDepthTexture, u_xlat2.xy).x;
    u_xlat25 = _ZBufferParams.x * u_xlat25 + _ZBufferParams.y;
    u_xlat25 = float(1.0) / u_xlat25;
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat1.xyz;
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat3.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat3.zzz + u_xlat3.xyw;
    u_xlat3.xyw = u_xlat3.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.wwww + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    u_xlat5.xyz = u_xlat4.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat5.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat6.xyz = u_xlat4.xyz + _ShadowOffsets[2].xyz;
    u_xlat4.xyz = u_xlat4.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat5.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat6.z);
    u_xlat5.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat16_0 = u_xlat5 * u_xlat16_0.xxxx + _LightShadowData.xxxx;
    u_xlat16_1 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat9.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat9.x = sqrt(u_xlat9.x);
    u_xlat9.x = (-u_xlat1.z) * u_xlat25 + u_xlat9.x;
    u_xlat9.x = unity_ShadowFadeCenterAndType.w * u_xlat9.x + u_xlat3.z;
    u_xlat9.x = u_xlat9.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat9.x + u_xlat16_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat9.xyz;
    u_xlat9.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat9.xyz;
    u_xlat9.xyz = u_xlat9.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat9.xy = u_xlat9.xy / u_xlat9.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb25 = !!(u_xlat9.z<0.0);
#else
    u_xlatb25 = u_xlat9.z<0.0;
#endif
    u_xlat25 = u_xlatb25 ? 1.0 : float(0.0);
    u_xlat10_9 = texture(_LightTexture0, u_xlat9.xy, -8.0).w;
    u_xlat9.x = u_xlat25 * u_xlat10_9;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat9.x = u_xlat10_17 * u_xlat9.x;
    u_xlat1.x = u_xlat1.x * u_xlat9.x;
    u_xlat1.xyz = u_xlat1.xxx * _LightColor.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat16_0.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat16_24 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_25 = max(u_xlat16_24, 0.00100000005);
    u_xlat16_24 = inversesqrt(u_xlat16_25);
    u_xlat16_0.xyz = vec3(u_xlat16_24) * u_xlat16_0.xyz;
    u_xlat16_24 = dot(u_xlat4.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_24 = min(max(u_xlat16_24, 0.0), 1.0);
#else
    u_xlat16_24 = clamp(u_xlat16_24, 0.0, 1.0);
#endif
    u_xlat16_25 = max(u_xlat16_24, 0.319999993);
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat2.xy);
    u_xlat16_24 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_18 = u_xlat16_24 * u_xlat16_24 + 1.5;
    u_xlat16_24 = u_xlat16_24 * u_xlat16_24;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_18;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat2.xy).xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture0, u_xlat2.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_0.x = dot(u_xlat16_7.xyz, u_xlat16_0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_0.x = min(max(u_xlat16_0.x, 0.0), 1.0);
#else
    u_xlat16_0.x = clamp(u_xlat16_0.x, 0.0, 1.0);
#endif
    u_xlat16_8 = dot(u_xlat16_7.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_8 = min(max(u_xlat16_8, 0.0), 1.0);
#else
    u_xlat16_8 = clamp(u_xlat16_8, 0.0, 1.0);
#endif
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_0.x;
    u_xlat16_26 = u_xlat16_24 * u_xlat16_24 + -1.0;
    u_xlat16_26 = u_xlat16_0.x * u_xlat16_26 + 1.00001001;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_26;
    u_xlat16_25 = u_xlat16_24 / u_xlat16_25;
    u_xlat16_25 = u_xlat16_25 + -9.99999975e-005;
    u_xlat16_0.x = max(u_xlat16_25, 0.0);
    u_xlat16_0.x = min(u_xlat16_0.x, 100.0);
    u_xlat16_0.xzw = u_xlat16_0.xxx * u_xlat10_3.xyz + u_xlat10_2.xyz;
    u_xlat16_0.xzw = u_xlat1.xyz * u_xlat16_0.xzw;
    SV_Target0.xyz = vec3(u_xlat16_8) * u_xlat16_0.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump vec2 tmpvar_30;
  tmpvar_30.x = dot ((viewDir_29 - (2.0 * 
    (dot (tmpvar_27, viewDir_29) * tmpvar_27)
  )), lightDir_6);
  tmpvar_30.y = (1.0 - clamp (dot (tmpvar_27, viewDir_29), 0.0, 1.0));
  mediump vec2 tmpvar_31;
  tmpvar_31.x = ((tmpvar_30 * tmpvar_30) * (tmpvar_30 * tmpvar_30)).x;
  tmpvar_31.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (unity_NHxRoughness, tmpvar_31);
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_32.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_27, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_26 = dot((-u_xlat0.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat0.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump float specularTerm_30;
  mediump vec3 tmpvar_31;
  mediump vec3 inVec_32;
  inVec_32 = (lightDir_6 + viewDir_29);
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_27, tmpvar_31), 0.0, 1.0);
  mediump float tmpvar_34;
  tmpvar_34 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_35;
  tmpvar_35 = (tmpvar_34 * tmpvar_34);
  specularTerm_30 = ((tmpvar_35 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_31), 0.0, 1.0)) * (1.5 + tmpvar_35))
   * 
    (((tmpvar_33 * tmpvar_33) * ((tmpvar_35 * tmpvar_35) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_36 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_37;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump float specularTerm_30;
  mediump vec3 tmpvar_31;
  mediump vec3 inVec_32;
  inVec_32 = (lightDir_6 + viewDir_29);
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_27, tmpvar_31), 0.0, 1.0);
  mediump float tmpvar_34;
  tmpvar_34 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_35;
  tmpvar_35 = (tmpvar_34 * tmpvar_34);
  specularTerm_30 = ((tmpvar_35 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_31), 0.0, 1.0)) * (1.5 + tmpvar_35))
   * 
    (((tmpvar_33 * tmpvar_33) * ((tmpvar_35 * tmpvar_35) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_36 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_37;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat13 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat19);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat2 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.x = dot(u_xlat2, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.y = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat0.xyz = u_xlat0.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat0 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat2.w = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.z = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0.x = sqrt(u_xlat13);
    u_xlat6 = u_xlat13 * _LightPos.w;
    u_xlat10_6 = texture(_LightTextureB0, vec2(u_xlat6)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * 0.970000029;
    u_xlatb1 = lessThan(u_xlat2, u_xlat0.xxxx);
    u_xlat1.x = (u_xlatb1.x) ? _LightShadowData.x : float(1.0);
    u_xlat1.y = (u_xlatb1.y) ? _LightShadowData.x : float(1.0);
    u_xlat1.z = (u_xlatb1.z) ? _LightShadowData.x : float(1.0);
    u_xlat1.w = (u_xlatb1.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat1, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_0 = u_xlat10_6 * u_xlat16_5.x;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat13 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat3.xyz = u_xlat0.xyz * vec3(u_xlat19);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-005;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat2 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.x = dot(u_xlat2, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.y = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat1.xyw = u_xlat0.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat0.xyz = u_xlat0.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat0 = texture(_ShadowMapTexture, u_xlat0.xyz);
    u_xlat2.w = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0 = texture(_ShadowMapTexture, u_xlat1.xyw);
    u_xlat2.z = dot(u_xlat0, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat0.x = sqrt(u_xlat13);
    u_xlat6 = u_xlat13 * _LightPos.w;
    u_xlat10_6 = texture(_LightTextureB0, vec2(u_xlat6)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * 0.970000029;
    u_xlatb1 = lessThan(u_xlat2, u_xlat0.xxxx);
    u_xlat1.x = (u_xlatb1.x) ? _LightShadowData.x : float(1.0);
    u_xlat1.y = (u_xlatb1.y) ? _LightShadowData.x : float(1.0);
    u_xlat1.z = (u_xlatb1.z) ? _LightShadowData.x : float(1.0);
    u_xlat1.w = (u_xlatb1.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat1, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_0 = u_xlat10_6 * u_xlat16_5.x;
    u_xlat0.xyz = vec3(u_xlat16_0) * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D unity_NHxRoughness;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_9;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_LightTexture0, tmpvar_25.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_26.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_32;
  viewDir_32 = -(tmpvar_31);
  mediump vec2 tmpvar_33;
  tmpvar_33.x = dot ((viewDir_32 - (2.0 * 
    (dot (tmpvar_30, viewDir_32) * tmpvar_30)
  )), lightDir_6);
  tmpvar_33.y = (1.0 - clamp (dot (tmpvar_30, viewDir_32), 0.0, 1.0));
  mediump vec2 tmpvar_34;
  tmpvar_34.x = ((tmpvar_33 * tmpvar_33) * (tmpvar_33 * tmpvar_33)).x;
  tmpvar_34.y = (1.0 - gbuffer1_2.w);
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (unity_NHxRoughness, tmpvar_34);
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = ((gbuffer0_3.xyz + (
    (tmpvar_35.w * 16.0)
   * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_30, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat16_26 = dot((-u_xlat0.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat0.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat10_21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat16_21 = u_xlat10_21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat16_21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_9;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_LightTexture0, tmpvar_25.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_26.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_32;
  viewDir_32 = -(tmpvar_31);
  mediump float specularTerm_33;
  mediump vec3 tmpvar_34;
  mediump vec3 inVec_35;
  inVec_35 = (lightDir_6 + viewDir_32);
  tmpvar_34 = (inVec_35 * inversesqrt(max (0.001, 
    dot (inVec_35, inVec_35)
  )));
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_30, tmpvar_34), 0.0, 1.0);
  mediump float tmpvar_37;
  tmpvar_37 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_38;
  tmpvar_38 = (tmpvar_37 * tmpvar_37);
  specularTerm_33 = ((tmpvar_38 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_34), 0.0, 1.0)) * (1.5 + tmpvar_38))
   * 
    (((tmpvar_36 * tmpvar_36) * ((tmpvar_38 * tmpvar_38) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_39;
  tmpvar_39 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_39;
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_39 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_30, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_40;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
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
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (dot (tmpvar_10, tmpvar_10) * _LightPos.w);
  lowp float tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2(tmpvar_12)).w;
  atten_5 = tmpvar_13;
  highp vec4 shadowVals_14;
  highp float mydist_15;
  mydist_15 = ((sqrt(
    dot (tmpvar_10, tmpvar_10)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_14.x = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.y = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.z = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_14.w = dot (textureCube (_ShadowMapTexture, (tmpvar_10 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_16;
  tmpvar_16 = lessThan (shadowVals_14, vec4(mydist_15));
  mediump vec4 tmpvar_17;
  tmpvar_17 = _LightShadowData.xxxx;
  mediump float tmpvar_18;
  if (tmpvar_16.x) {
    tmpvar_18 = tmpvar_17.x;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  if (tmpvar_16.y) {
    tmpvar_19 = tmpvar_17.y;
  } else {
    tmpvar_19 = 1.0;
  };
  mediump float tmpvar_20;
  if (tmpvar_16.z) {
    tmpvar_20 = tmpvar_17.z;
  } else {
    tmpvar_20 = 1.0;
  };
  mediump float tmpvar_21;
  if (tmpvar_16.w) {
    tmpvar_21 = tmpvar_17.w;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump vec4 tmpvar_22;
  tmpvar_22.x = tmpvar_18;
  tmpvar_22.y = tmpvar_19;
  tmpvar_22.z = tmpvar_20;
  tmpvar_22.w = tmpvar_21;
  mediump float tmpvar_23;
  tmpvar_23 = dot (tmpvar_22, vec4(0.25, 0.25, 0.25, 0.25));
  atten_5 = (atten_5 * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_9;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  lowp vec4 tmpvar_26;
  tmpvar_26 = textureCube (_LightTexture0, tmpvar_25.xyz, -8.0);
  atten_5 = (atten_5 * tmpvar_26.w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_32;
  viewDir_32 = -(tmpvar_31);
  mediump float specularTerm_33;
  mediump vec3 tmpvar_34;
  mediump vec3 inVec_35;
  inVec_35 = (lightDir_6 + viewDir_32);
  tmpvar_34 = (inVec_35 * inversesqrt(max (0.001, 
    dot (inVec_35, inVec_35)
  )));
  mediump float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_30, tmpvar_34), 0.0, 1.0);
  mediump float tmpvar_37;
  tmpvar_37 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_38;
  tmpvar_38 = (tmpvar_37 * tmpvar_37);
  specularTerm_33 = ((tmpvar_38 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_34), 0.0, 1.0)) * (1.5 + tmpvar_38))
   * 
    (((tmpvar_36 * tmpvar_36) * ((tmpvar_38 * tmpvar_38) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_39;
  tmpvar_39 = clamp (specularTerm_33, 0.0, 100.0);
  specularTerm_33 = tmpvar_39;
  mediump vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_39 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_30, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_40;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat16_5.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_26, 0.319999993);
    u_xlat10_4 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_4.w) + 1.0;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_4.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPositionRange;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
vec4 u_xlat3;
bvec4 u_xlatb3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
lowp vec3 u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat15;
lowp float u_xlat10_15;
float u_xlat21;
mediump float u_xlat16_21;
lowp float u_xlat10_21;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat3.xyz = u_xlat2.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat3 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat3.x = dot(u_xlat3, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.y = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.z = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat4.xyz = u_xlat2.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat3.w = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = sqrt(u_xlat21);
    u_xlat15 = u_xlat15 * _LightPositionRange.w;
    u_xlat15 = u_xlat15 * 0.970000029;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat15));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat15 = u_xlat21 * _LightPos.w;
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_21 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat16_21 = u_xlat16_5.x * u_xlat10_21;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat16_21 = u_xlat16_21 * u_xlat10_15;
    u_xlat3.xyz = vec3(u_xlat16_21) * _LightColor.xyz;
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat16_5.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_26, 0.319999993);
    u_xlat10_4 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_4.w) + 1.0;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat10_7.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_7.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-005;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_4.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
}
}
 Pass {
  ZClip Off
  ZTest Always
  ZWrite Off
  Cull Off
  Stencil {
   ReadMask 0
   CompFront Equal
   PassFront Keep
   FailFront Keep
   ZFailFront Keep
   CompBack Equal
   PassBack Keep
   FailBack Keep
   ZFailBack Keep
  }
  GpuProgramID 103316
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
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


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
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


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
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


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
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
}
}