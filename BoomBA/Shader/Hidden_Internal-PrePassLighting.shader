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
  Tags { "SHADOWSUPPORT" = "true" }
  Blend DstColor Zero, DstColor Zero
  ZClip Off
  ZWrite Off
  GpuProgramID 13514
Program "vp" {
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(res_2));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(res_2));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(res_2));
  tmpvar_1 = tmpvar_30;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(res_2));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(res_2));
  tmpvar_1 = tmpvar_45;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(res_2));
  tmpvar_1 = tmpvar_45;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(res_2));
  tmpvar_1 = tmpvar_45;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(res_2));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    u_xlat16_0 = exp2((-u_xlat0));
    SV_Target0 = u_xlat16_0;
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
}
}
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  Blend One One, One One
  ZClip Off
  ZWrite Off
  GpuProgramID 86331
Program "vp" {
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (dot (tmpvar_12, tmpvar_12) * _LightPos.w);
  lowp float tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2(tmpvar_14)).w;
  atten_6 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat10_14 * u_xlat16_5.x;
    u_xlat16_14 = u_xlat10_14;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat10_7 = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat10_7;
    u_xlat7.x = u_xlat10_14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
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
  tmpvar_16.xyz = tmpvar_10;
  highp vec4 tmpvar_17;
  tmpvar_17.w = -8.0;
  tmpvar_17.xyz = (unity_WorldToLight * tmpvar_16).xyz;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_LightTexture0, tmpvar_17.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_18.w);
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat16_7 = u_xlat10_7 * u_xlat10_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0);
  atten_6 = tmpvar_15.w;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_6;
lowp float u_xlat10_6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_6 = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat16_12 = u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_6 = u_xlat10_6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat16_6) * _LightColor.xyz;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, tmpvar_25);
  mediump float tmpvar_28;
  if ((tmpvar_27.x < (tmpvar_25.z / tmpvar_25.w))) {
    tmpvar_28 = _LightShadowData.x;
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_29;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec3 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec3 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec3 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
mediump float u_xlat16_5;
vec3 u_xlat7;
lowp float u_xlat10_7;
vec2 u_xlat13;
lowp float u_xlat10_13;
float u_xlat15;
bool u_xlatb15;
mediump float u_xlat16_18;
float u_xlat19;
lowp float u_xlat10_19;
float u_xlat21;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat13.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat13.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat7.xyz;
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
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat1.x = (-u_xlat7.z) * u_xlat1.x + u_xlat7.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat7.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat16_0.x + u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat13.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat4.z<0.0);
#else
    u_xlatb15 = u_xlat4.z<0.0;
#endif
    u_xlat15 = u_xlatb15 ? 1.0 : float(0.0);
    u_xlat10_13 = texture(_LightTexture0, u_xlat13.xy, -8.0).w;
    u_xlat13.x = u_xlat15 * u_xlat10_13;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = u_xlat19 * _LightPos.w;
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat4.xyz = vec3(u_xlat19) * u_xlat4.xyz;
    u_xlat10_19 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat13.x = u_xlat10_19 * u_xlat13.x;
    u_xlat7.x = u_xlat7.x * u_xlat13.x;
    u_xlat13.x = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat13.x = min(max(u_xlat13.x, 0.0), 1.0);
#else
    u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
#endif
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat19) + u_xlat4.xyz;
    u_xlat19 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat19);
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_5, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_18;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat7.x = u_xlat13.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat7.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
vec2 u_xlat13;
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
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat12 = u_xlat6.x * u_xlat16_10;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat12 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_8);
  highp float tmpvar_16;
  tmpvar_16 = clamp ((tmpvar_15.x + clamp (
    ((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w)
  , 0.0, 1.0)), 0.0, 1.0);
  tmpvar_14 = tmpvar_16;
  atten_6 = tmpvar_14;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_10;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_LightTexture0, tmpvar_18.xy, -8.0);
  atten_6 = (atten_6 * tmpvar_19.w);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
float u_xlat6;
vec2 u_xlat12;
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
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat6 = u_xlat6 + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat6 = min(max(u_xlat6, 0.0), 1.0);
#else
    u_xlat6 = clamp(u_xlat6, 0.0, 1.0);
#endif
    u_xlat12.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat12.xy;
    u_xlat12.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat12.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat12.xy = u_xlat12.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat10_12 = texture(_LightTexture0, u_xlat12.xy, -8.0).w;
    u_xlat6 = u_xlat10_12 * u_xlat6;
    u_xlat12.x = u_xlat6;
#ifdef UNITY_ADRENO_ES3
    u_xlat12.x = min(max(u_xlat12.x, 0.0), 1.0);
#else
    u_xlat12.x = clamp(u_xlat12.x, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6 = u_xlat6 * u_xlat16_4.x;
    u_xlat1.xyz = vec3(u_xlat6) * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6 = u_xlat12.x * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_20 = texture2D (_CameraNormalsTexture, P_21);
  nspec_5 = tmpvar_20;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.0, dot (h_4, tmpvar_22)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_24;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_22)
  ) * atten_6));
  mediump vec3 rgb_25;
  rgb_25 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_25, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_26;
  tmpvar_26 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_26);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
bool u_xlatb7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat7.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat7.x = u_xlat7.x * _LightPositionRange.w;
    u_xlat7.x = u_xlat7.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat21<u_xlat7.x);
#else
    u_xlatb7 = u_xlat21<u_xlat7.x;
#endif
    u_xlat16_19 = (u_xlatb7) ? _LightShadowData.x : 1.0;
    u_xlat16_7 = u_xlat10_14 * u_xlat16_19;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_7 = u_xlat16_14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  highp float tmpvar_18;
  tmpvar_18 = dot (textureCube (_ShadowMapTexture, tmpvar_13), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  mediump float tmpvar_19;
  if ((tmpvar_18 < mydist_17)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.0;
  };
  atten_6 = (atten_6 * tmpvar_19);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21.w = -8.0;
  tmpvar_21.xyz = (unity_WorldToLight * tmpvar_20).xyz;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_LightTexture0, tmpvar_21.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_22.w);
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_23 = texture2D (_CameraNormalsTexture, P_24);
  nspec_5 = tmpvar_23;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.0, dot (h_4, tmpvar_25)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_27;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_25)
  ) * atten_6));
  mediump vec3 rgb_28;
  rgb_28 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_28, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_29);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
float u_xlat14;
mediump float u_xlat16_14;
lowp float u_xlat10_14;
bool u_xlatb14;
float u_xlat21;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_7 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat4.x = sqrt(u_xlat24);
    u_xlat4.x = u_xlat4.x * _LightPositionRange.w;
    u_xlat4.x = u_xlat4.x * 0.970000029;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat4.x);
#else
    u_xlatb14 = u_xlat14<u_xlat4.x;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat14 = u_xlat24 * _LightPos.w;
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat16_14 = u_xlat16_5.x * u_xlat10_14;
    u_xlat16_7 = u_xlat10_7 * u_xlat16_14;
    u_xlat16_14 = u_xlat16_7;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_7 = u_xlat16_7 * u_xlat16_5.x;
    u_xlat1.xyz = vec3(u_xlat16_7) * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat16_7 = u_xlat16_14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_7 * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_LightTexture0, tmpvar_17.xy, -8.0);
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_18.w;
  atten_6 = (tmpvar_19 * float((tmpvar_16.w < 0.0)));
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20));
  atten_6 = (atten_6 * tmpvar_21.w);
  mediump float tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_WorldToShadow[0] * tmpvar_24);
  lowp float tmpvar_26;
  highp vec4 shadowVals_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_25.xyz / tmpvar_25.w);
  shadowVals_27.x = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_27.y = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_27.z = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_27.w = texture2D (_ShadowMapTexture, (tmpvar_28.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_29;
  tmpvar_29 = lessThan (shadowVals_27, tmpvar_28.zzzz);
  mediump vec4 tmpvar_30;
  tmpvar_30 = _LightShadowData.xxxx;
  mediump float tmpvar_31;
  if (tmpvar_29.x) {
    tmpvar_31 = tmpvar_30.x;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump float tmpvar_32;
  if (tmpvar_29.y) {
    tmpvar_32 = tmpvar_30.y;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_29.z) {
    tmpvar_33 = tmpvar_30.z;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_29.w) {
    tmpvar_34 = tmpvar_30.w;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump vec4 tmpvar_35;
  tmpvar_35.x = tmpvar_31;
  tmpvar_35.y = tmpvar_32;
  tmpvar_35.z = tmpvar_33;
  tmpvar_35.w = tmpvar_34;
  mediump float tmpvar_36;
  tmpvar_36 = dot (tmpvar_35, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_26 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((tmpvar_26 + tmpvar_23), 0.0, 1.0);
  tmpvar_22 = tmpvar_37;
  atten_6 = (atten_6 * tmpvar_22);
  lowp vec4 tmpvar_38;
  highp vec2 P_39;
  P_39 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_38 = texture2D (_CameraNormalsTexture, P_39);
  nspec_5 = tmpvar_38;
  mediump vec3 tmpvar_40;
  tmpvar_40 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_41;
  tmpvar_41 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = pow (max (0.0, dot (h_4, tmpvar_40)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_42;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_40)
  ) * atten_6));
  mediump vec3 rgb_43;
  rgb_43 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_43, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_44;
  tmpvar_44 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_44);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTexture0;
uniform lowp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec3 u_xlat6;
mediump float u_xlat16_7;
vec3 u_xlat9;
mediump float u_xlat16_9;
vec2 u_xlat17;
lowp float u_xlat10_17;
float u_xlat19;
bool u_xlatb19;
mediump float u_xlat16_24;
float u_xlat25;
lowp float u_xlat10_25;
float u_xlat27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat17.x = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat1.x = _ZBufferParams.x * u_xlat17.x + _ZBufferParams.y;
    u_xlat1.x = float(1.0) / u_xlat1.x;
    u_xlat9.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat9.xyz = u_xlat9.xxx * vs_TEXCOORD1.xyz;
    u_xlat3.xyz = u_xlat1.xxx * u_xlat9.xyz;
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
    u_xlat16_9 = dot(u_xlat16_0, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat3.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat17.x = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17.x = sqrt(u_xlat17.x);
    u_xlat1.x = (-u_xlat9.z) * u_xlat1.x + u_xlat17.x;
    u_xlat1.x = unity_ShadowFadeCenterAndType.w * u_xlat1.x + u_xlat3.z;
    u_xlat17.x = u_xlat1.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat1.x = u_xlat1.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat1.x = (-u_xlat1.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat9.x = u_xlat17.x + u_xlat16_9;
#ifdef UNITY_ADRENO_ES3
    u_xlat9.x = min(max(u_xlat9.x, 0.0), 1.0);
#else
    u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat17.xy = u_xlat4.xy / u_xlat4.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb19 = !!(u_xlat4.z<0.0);
#else
    u_xlatb19 = u_xlat4.z<0.0;
#endif
    u_xlat19 = u_xlatb19 ? 1.0 : float(0.0);
    u_xlat10_17 = texture(_LightTexture0, u_xlat17.xy, -8.0).w;
    u_xlat17.x = u_xlat19 * u_xlat10_17;
    u_xlat4.xyz = (-u_xlat3.xyw) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat25 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat27 = u_xlat25 * _LightPos.w;
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat4.xyz = vec3(u_xlat25) * u_xlat4.xyz;
    u_xlat10_25 = texture(_LightTextureB0, vec2(u_xlat27)).w;
    u_xlat17.x = u_xlat10_25 * u_xlat17.x;
    u_xlat9.x = u_xlat9.x * u_xlat17.x;
    u_xlat17.x = u_xlat9.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat17.x = min(max(u_xlat17.x, 0.0), 1.0);
#else
    u_xlat17.x = clamp(u_xlat17.x, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat25) + u_xlat4.xyz;
    u_xlat25 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat25 = inversesqrt(u_xlat25);
    u_xlat3.xyz = vec3(u_xlat25) * u_xlat3.xyz;
    u_xlat16_0.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = u_xlat10_2.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_0.xyz, u_xlat16_0.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_0.xyz = u_xlat16_0.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat3.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = dot(u_xlat4.xyz, u_xlat16_0.xyz);
    u_xlat16_0.x = max(u_xlat16_0.x, 0.0);
    u_xlat9.x = u_xlat9.x * u_xlat16_0.x;
    u_xlat2.xyz = u_xlat9.xxx * _LightColor.xyz;
    u_xlat16_0.x = max(u_xlat16_7, 0.0);
    u_xlat16_0.x = log2(u_xlat16_0.x);
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_24;
    u_xlat16_0.x = exp2(u_xlat16_0.x);
    u_xlat9.x = u_xlat17.x * u_xlat16_0.x;
    u_xlat16_0.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat2.w = u_xlat16_0.x * u_xlat9.x;
    u_xlat0 = u_xlat1.xxxx * u_xlat2;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
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
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform sampler2D _LightTextureB0;
uniform lowp samplerCube _LightTexture0;
uniform highp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
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
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (dot (tmpvar_13, tmpvar_13) * _LightPos.w);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (_LightTextureB0, vec2(tmpvar_15)).w;
  atten_6 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * 0.97);
  shadowVals_17.x = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.y = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.z = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVals_17.w = dot (textureCube (_ShadowMapTexture, (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125))), vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_19;
  tmpvar_19 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_20;
  tmpvar_20 = _LightShadowData.xxxx;
  mediump float tmpvar_21;
  if (tmpvar_19.x) {
    tmpvar_21 = tmpvar_20.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  if (tmpvar_19.y) {
    tmpvar_22 = tmpvar_20.y;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  if (tmpvar_19.z) {
    tmpvar_23 = tmpvar_20.z;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  if (tmpvar_19.w) {
    tmpvar_24 = tmpvar_20.w;
  } else {
    tmpvar_24 = 1.0;
  };
  mediump vec4 tmpvar_25;
  tmpvar_25.x = tmpvar_21;
  tmpvar_25.y = tmpvar_22;
  tmpvar_25.z = tmpvar_23;
  tmpvar_25.w = tmpvar_24;
  mediump float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, vec4(0.25, 0.25, 0.25, 0.25));
  atten_6 = (atten_6 * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = tmpvar_10;
  highp vec4 tmpvar_28;
  tmpvar_28.w = -8.0;
  tmpvar_28.xyz = (unity_WorldToLight * tmpvar_27).xyz;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, tmpvar_28.xyz, -8.0);
  atten_6 = (atten_6 * tmpvar_29.w);
  lowp vec4 tmpvar_30;
  highp vec2 P_31;
  P_31 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_30 = texture2D (_CameraNormalsTexture, P_31);
  nspec_5 = tmpvar_30;
  mediump vec3 tmpvar_32;
  tmpvar_32 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.0, dot (h_4, tmpvar_32)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_34;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_32)
  ) * atten_6));
  mediump vec3 rgb_35;
  rgb_35 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_35, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_36;
  tmpvar_36 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_36);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _LightTextureB0;
uniform highp samplerCube _ShadowMapTexture;
uniform lowp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
bvec4 u_xlatb4;
vec4 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
float u_xlat16;
mediump float u_xlat16_16;
lowp float u_xlat10_16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat4.x = dot(u_xlat4, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.y = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.z = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat5 = texture(_ShadowMapTexture, u_xlat5.xyz);
    u_xlat4.w = dot(u_xlat5, vec4(1.0, 0.00392156886, 1.53787005e-005, 6.03086292e-008));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * 0.970000029;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat10_8 = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat16_8 = u_xlat16_6.x * u_xlat10_8;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat10_16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat16_8 = u_xlat10_16 * u_xlat16_8;
    u_xlat16_16 = u_xlat16_8;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat4.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat2.x = sqrt(u_xlat2.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat2.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat4.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat16_8 = u_xlat16_8 * u_xlat16_6.x;
    u_xlat1.xyz = vec3(u_xlat16_8) * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat16_8 = u_xlat16_16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_8 * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
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
}
}
}
}