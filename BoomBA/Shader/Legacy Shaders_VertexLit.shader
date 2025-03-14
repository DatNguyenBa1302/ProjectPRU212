//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Legacy Shaders/VertexLit" {
Properties {
_Color ("Main Color", Color) = (1,1,1,1)
_SpecColor ("Spec Color", Color) = (1,1,1,1)
_Emission ("Emissive Color", Color) = (0,0,0,0)
_Shininess ("Shininess", Range(0.01, 1)) = 0.7
_MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader {
 LOD 100
 Tags { "RenderType" = "Opaque" }
 Pass {
  LOD 100
  Tags { "LIGHTMODE" = "Vertex" "RenderType" = "Opaque" }
  ZClip Off
  Fog {
   Mode Off
  }
  GpuProgramID 84581
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  mediump vec4 color_8;
  color_8 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_1;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_10[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_10[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  eyeNormal_7 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((glstate_matrix_modelview0 * tmpvar_9).xyz);
  viewDir_6 = -(tmpvar_12);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    highp vec3 tmpvar_13;
    tmpvar_13 = unity_LightPosition[il_2].xyz;
    mediump vec3 dirToLight_14;
    dirToLight_14 = tmpvar_13;
    mediump vec3 specColor_15;
    specColor_15 = specColor_4;
    mediump float tmpvar_16;
    tmpvar_16 = max (dot (eyeNormal_7, dirToLight_14), 0.0);
    mediump vec3 tmpvar_17;
    tmpvar_17 = ((tmpvar_16 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_16 > 0.0)) {
      specColor_15 = (specColor_4 + ((0.5 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_14 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_15;
    lcolor_5 = (lcolor_5 + min ((tmpvar_17 * 0.5), vec3(1.0, 1.0, 1.0)));
  };
  color_8.xyz = lcolor_5;
  color_8.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = clamp (color_8, 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  lowp vec3 tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_18;
  xlv_COLOR1 = tmpvar_20;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_22);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  mediump vec4 color_8;
  color_8 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_1;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_10[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_10[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  eyeNormal_7 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((glstate_matrix_modelview0 * tmpvar_9).xyz);
  viewDir_6 = -(tmpvar_12);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    highp vec3 tmpvar_13;
    tmpvar_13 = unity_LightPosition[il_2].xyz;
    mediump vec3 dirToLight_14;
    dirToLight_14 = tmpvar_13;
    mediump vec3 specColor_15;
    specColor_15 = specColor_4;
    mediump float tmpvar_16;
    tmpvar_16 = max (dot (eyeNormal_7, dirToLight_14), 0.0);
    mediump vec3 tmpvar_17;
    tmpvar_17 = ((tmpvar_16 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_16 > 0.0)) {
      specColor_15 = (specColor_4 + ((0.5 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_14 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_15;
    lcolor_5 = (lcolor_5 + min ((tmpvar_17 * 0.5), vec3(1.0, 1.0, 1.0)));
  };
  color_8.xyz = lcolor_5;
  color_8.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = clamp (color_8, 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  lowp vec3 tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_18;
  xlv_COLOR1 = tmpvar_20;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_22);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  mediump vec4 color_8;
  color_8 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_1;
  highp mat3 tmpvar_10;
  tmpvar_10[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_10[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_10[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((tmpvar_10 * _glesNormal));
  eyeNormal_7 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((glstate_matrix_modelview0 * tmpvar_9).xyz);
  viewDir_6 = -(tmpvar_12);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    highp vec3 tmpvar_13;
    tmpvar_13 = unity_LightPosition[il_2].xyz;
    mediump vec3 dirToLight_14;
    dirToLight_14 = tmpvar_13;
    mediump vec3 specColor_15;
    specColor_15 = specColor_4;
    mediump float tmpvar_16;
    tmpvar_16 = max (dot (eyeNormal_7, dirToLight_14), 0.0);
    mediump vec3 tmpvar_17;
    tmpvar_17 = ((tmpvar_16 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_16 > 0.0)) {
      specColor_15 = (specColor_4 + ((0.5 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_14 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_15;
    lcolor_5 = (lcolor_5 + min ((tmpvar_17 * 0.5), vec3(1.0, 1.0, 1.0)));
  };
  color_8.xyz = lcolor_5;
  color_8.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = clamp (color_8, 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  lowp vec3 tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_20 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_18;
  xlv_COLOR1 = tmpvar_20;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_22);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
bool u_xlatb5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat24;
int u_xlati25;
mediump float u_xlat16_26;
mediump float u_xlat16_28;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat24 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat1.xyz = vec3(u_xlat24) * u_xlat1.xyz;
    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_26 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat16_28 = dot(u_xlat1.xyz, unity_LightPosition[u_xlati_loop_1].xyz);
        u_xlat16_28 = max(u_xlat16_28, 0.0);
        u_xlat16_6.xyz = vec3(u_xlat16_28) * _Color.xyz;
        u_xlat16_6.xyz = u_xlat16_6.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb5 = !!(0.0<u_xlat16_28);
#else
        u_xlatb5 = 0.0<u_xlat16_28;
#endif
        if(u_xlatb5){
            u_xlat16_7.xyz = (-u_xlat0.xyz) * vec3(u_xlat24) + unity_LightPosition[u_xlati_loop_1].xyz;
            u_xlat16_28 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = inversesqrt(u_xlat16_28);
            u_xlat16_7.xyz = vec3(u_xlat16_28) * u_xlat16_7.xyz;
            u_xlat16_28 = dot(u_xlat1.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = max(u_xlat16_28, 0.0);
            u_xlat16_28 = log2(u_xlat16_28);
            u_xlat16_28 = u_xlat16_26 * u_xlat16_28;
            u_xlat16_28 = exp2(u_xlat16_28);
            u_xlat16_28 = min(u_xlat16_28, 1.0);
            u_xlat16_28 = u_xlat16_28 * 0.5;
            u_xlat16_4.xyz = vec3(u_xlat16_28) * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(0.5, 0.5, 0.5);
        u_xlat16_6.xyz = min(u_xlat16_6.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_6.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
bool u_xlatb5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat24;
int u_xlati25;
mediump float u_xlat16_26;
mediump float u_xlat16_28;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat24 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat1.xyz = vec3(u_xlat24) * u_xlat1.xyz;
    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_26 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat16_28 = dot(u_xlat1.xyz, unity_LightPosition[u_xlati_loop_1].xyz);
        u_xlat16_28 = max(u_xlat16_28, 0.0);
        u_xlat16_6.xyz = vec3(u_xlat16_28) * _Color.xyz;
        u_xlat16_6.xyz = u_xlat16_6.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb5 = !!(0.0<u_xlat16_28);
#else
        u_xlatb5 = 0.0<u_xlat16_28;
#endif
        if(u_xlatb5){
            u_xlat16_7.xyz = (-u_xlat0.xyz) * vec3(u_xlat24) + unity_LightPosition[u_xlati_loop_1].xyz;
            u_xlat16_28 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = inversesqrt(u_xlat16_28);
            u_xlat16_7.xyz = vec3(u_xlat16_28) * u_xlat16_7.xyz;
            u_xlat16_28 = dot(u_xlat1.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = max(u_xlat16_28, 0.0);
            u_xlat16_28 = log2(u_xlat16_28);
            u_xlat16_28 = u_xlat16_26 * u_xlat16_28;
            u_xlat16_28 = exp2(u_xlat16_28);
            u_xlat16_28 = min(u_xlat16_28, 1.0);
            u_xlat16_28 = u_xlat16_28 * 0.5;
            u_xlat16_4.xyz = vec3(u_xlat16_28) * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(0.5, 0.5, 0.5);
        u_xlat16_6.xyz = min(u_xlat16_6.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_6.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
bool u_xlatb5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat24;
int u_xlati25;
mediump float u_xlat16_26;
mediump float u_xlat16_28;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat24 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat1.xyz = vec3(u_xlat24) * u_xlat1.xyz;
    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_26 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat16_28 = dot(u_xlat1.xyz, unity_LightPosition[u_xlati_loop_1].xyz);
        u_xlat16_28 = max(u_xlat16_28, 0.0);
        u_xlat16_6.xyz = vec3(u_xlat16_28) * _Color.xyz;
        u_xlat16_6.xyz = u_xlat16_6.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb5 = !!(0.0<u_xlat16_28);
#else
        u_xlatb5 = 0.0<u_xlat16_28;
#endif
        if(u_xlatb5){
            u_xlat16_7.xyz = (-u_xlat0.xyz) * vec3(u_xlat24) + unity_LightPosition[u_xlati_loop_1].xyz;
            u_xlat16_28 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = inversesqrt(u_xlat16_28);
            u_xlat16_7.xyz = vec3(u_xlat16_28) * u_xlat16_7.xyz;
            u_xlat16_28 = dot(u_xlat1.xyz, u_xlat16_7.xyz);
            u_xlat16_28 = max(u_xlat16_28, 0.0);
            u_xlat16_28 = log2(u_xlat16_28);
            u_xlat16_28 = u_xlat16_26 * u_xlat16_28;
            u_xlat16_28 = exp2(u_xlat16_28);
            u_xlat16_28 = min(u_xlat16_28, 1.0);
            u_xlat16_28 = u_xlat16_28 * 0.5;
            u_xlat16_4.xyz = vec3(u_xlat16_28) * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(0.5, 0.5, 0.5);
        u_xlat16_6.xyz = min(u_xlat16_6.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_6.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float att_15;
    highp vec3 dirToLight_16;
    dirToLight_16 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_17;
    tmpvar_17 = dot (dirToLight_16, dirToLight_16);
    att_15 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_17))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_17 > unity_LightAtten[il_2].w))) {
      att_15 = 0.0;
    };
    dirToLight_16 = (dirToLight_16 * inversesqrt(max (tmpvar_17, 1e-06)));
    att_15 = (att_15 * 0.5);
    mediump vec3 dirToLight_18;
    dirToLight_18 = dirToLight_16;
    mediump vec3 specColor_19;
    specColor_19 = specColor_4;
    mediump float tmpvar_20;
    tmpvar_20 = max (dot (eyeNormal_7, dirToLight_18), 0.0);
    mediump vec3 tmpvar_21;
    tmpvar_21 = ((tmpvar_20 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_20 > 0.0)) {
      specColor_19 = (specColor_4 + ((att_15 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_18 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_19;
    lcolor_5 = (lcolor_5 + min ((tmpvar_21 * att_15), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = clamp (color_9, 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  lowp vec3 tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_22;
  xlv_COLOR1 = tmpvar_24;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_26);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float att_15;
    highp vec3 dirToLight_16;
    dirToLight_16 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_17;
    tmpvar_17 = dot (dirToLight_16, dirToLight_16);
    att_15 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_17))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_17 > unity_LightAtten[il_2].w))) {
      att_15 = 0.0;
    };
    dirToLight_16 = (dirToLight_16 * inversesqrt(max (tmpvar_17, 1e-06)));
    att_15 = (att_15 * 0.5);
    mediump vec3 dirToLight_18;
    dirToLight_18 = dirToLight_16;
    mediump vec3 specColor_19;
    specColor_19 = specColor_4;
    mediump float tmpvar_20;
    tmpvar_20 = max (dot (eyeNormal_7, dirToLight_18), 0.0);
    mediump vec3 tmpvar_21;
    tmpvar_21 = ((tmpvar_20 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_20 > 0.0)) {
      specColor_19 = (specColor_4 + ((att_15 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_18 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_19;
    lcolor_5 = (lcolor_5 + min ((tmpvar_21 * att_15), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = clamp (color_9, 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  lowp vec3 tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_22;
  xlv_COLOR1 = tmpvar_24;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_26);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float att_15;
    highp vec3 dirToLight_16;
    dirToLight_16 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_17;
    tmpvar_17 = dot (dirToLight_16, dirToLight_16);
    att_15 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_17))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_17 > unity_LightAtten[il_2].w))) {
      att_15 = 0.0;
    };
    dirToLight_16 = (dirToLight_16 * inversesqrt(max (tmpvar_17, 1e-06)));
    att_15 = (att_15 * 0.5);
    mediump vec3 dirToLight_18;
    dirToLight_18 = dirToLight_16;
    mediump vec3 specColor_19;
    specColor_19 = specColor_4;
    mediump float tmpvar_20;
    tmpvar_20 = max (dot (eyeNormal_7, dirToLight_18), 0.0);
    mediump vec3 tmpvar_21;
    tmpvar_21 = ((tmpvar_20 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_20 > 0.0)) {
      specColor_19 = (specColor_4 + ((att_15 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_18 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_19;
    lcolor_5 = (lcolor_5 + min ((tmpvar_21 * att_15), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = clamp (color_9, 0.0, 1.0);
  tmpvar_22 = tmpvar_23;
  lowp vec3 tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_22;
  xlv_COLOR1 = tmpvar_24;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_26);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = u_xlat6 * 0.5;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat32;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = u_xlat6 * 0.5;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat32;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = u_xlat6 * 0.5;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat32;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
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
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp vec4 unity_SpotDirection[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float rho_15;
    mediump float att_16;
    highp vec3 dirToLight_17;
    dirToLight_17 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_18;
    tmpvar_18 = dot (dirToLight_17, dirToLight_17);
    att_16 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_18))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_18 > unity_LightAtten[il_2].w))) {
      att_16 = 0.0;
    };
    dirToLight_17 = (dirToLight_17 * inversesqrt(max (tmpvar_18, 1e-06)));
    highp float tmpvar_19;
    tmpvar_19 = max (dot (dirToLight_17, unity_SpotDirection[il_2].xyz), 0.0);
    rho_15 = tmpvar_19;
    att_16 = (att_16 * clamp ((
      (rho_15 - unity_LightAtten[il_2].x)
     * unity_LightAtten[il_2].y), 0.0, 1.0));
    att_16 = (att_16 * 0.5);
    mediump vec3 dirToLight_20;
    dirToLight_20 = dirToLight_17;
    mediump vec3 specColor_21;
    specColor_21 = specColor_4;
    mediump float tmpvar_22;
    tmpvar_22 = max (dot (eyeNormal_7, dirToLight_20), 0.0);
    mediump vec3 tmpvar_23;
    tmpvar_23 = ((tmpvar_22 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_22 > 0.0)) {
      specColor_21 = (specColor_4 + ((att_16 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_20 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_21;
    lcolor_5 = (lcolor_5 + min ((tmpvar_23 * att_16), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = clamp (color_9, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  lowp vec3 tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_24;
  xlv_COLOR1 = tmpvar_26;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_28);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp vec4 unity_SpotDirection[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float rho_15;
    mediump float att_16;
    highp vec3 dirToLight_17;
    dirToLight_17 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_18;
    tmpvar_18 = dot (dirToLight_17, dirToLight_17);
    att_16 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_18))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_18 > unity_LightAtten[il_2].w))) {
      att_16 = 0.0;
    };
    dirToLight_17 = (dirToLight_17 * inversesqrt(max (tmpvar_18, 1e-06)));
    highp float tmpvar_19;
    tmpvar_19 = max (dot (dirToLight_17, unity_SpotDirection[il_2].xyz), 0.0);
    rho_15 = tmpvar_19;
    att_16 = (att_16 * clamp ((
      (rho_15 - unity_LightAtten[il_2].x)
     * unity_LightAtten[il_2].y), 0.0, 1.0));
    att_16 = (att_16 * 0.5);
    mediump vec3 dirToLight_20;
    dirToLight_20 = dirToLight_17;
    mediump vec3 specColor_21;
    specColor_21 = specColor_4;
    mediump float tmpvar_22;
    tmpvar_22 = max (dot (eyeNormal_7, dirToLight_20), 0.0);
    mediump vec3 tmpvar_23;
    tmpvar_23 = ((tmpvar_22 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_22 > 0.0)) {
      specColor_21 = (specColor_4 + ((att_16 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_20 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_21;
    lcolor_5 = (lcolor_5 + min ((tmpvar_23 * att_16), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = clamp (color_9, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  lowp vec3 tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_24;
  xlv_COLOR1 = tmpvar_26;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_28);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
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
attribute vec4 _glesMultiTexCoord0;
uniform mediump vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform mediump vec4 unity_LightAtten[8];
uniform highp vec4 unity_SpotDirection[8];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform lowp vec4 glstate_lightmodel_ambient;
uniform mediump vec4 _Color;
uniform mediump vec4 _SpecColor;
uniform mediump vec4 _Emission;
uniform mediump float _Shininess;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec3 tmpvar_1;
  tmpvar_1 = _glesVertex.xyz;
  mediump float shininess_3;
  mediump vec3 specColor_4;
  mediump vec3 lcolor_5;
  mediump vec3 viewDir_6;
  mediump vec3 eyeNormal_7;
  highp vec3 eyePos_8;
  mediump vec4 color_9;
  color_9 = vec4(0.0, 0.0, 0.0, 1.1);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = (glstate_matrix_modelview0 * tmpvar_10).xyz;
  eyePos_8 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = glstate_matrix_invtrans_modelview0[0].xyz;
  tmpvar_12[1] = glstate_matrix_invtrans_modelview0[1].xyz;
  tmpvar_12[2] = glstate_matrix_invtrans_modelview0[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_12 * _glesNormal));
  eyeNormal_7 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_11);
  viewDir_6 = -(tmpvar_14);
  lcolor_5 = (_Emission.xyz + (_Color.xyz * glstate_lightmodel_ambient.xyz));
  specColor_4 = vec3(0.0, 0.0, 0.0);
  shininess_3 = (_Shininess * 128.0);
  for (highp int il_2 = 0; il_2 < 8; il_2++) {
    mediump float rho_15;
    mediump float att_16;
    highp vec3 dirToLight_17;
    dirToLight_17 = (unity_LightPosition[il_2].xyz - (eyePos_8 * unity_LightPosition[il_2].w));
    highp float tmpvar_18;
    tmpvar_18 = dot (dirToLight_17, dirToLight_17);
    att_16 = (1.0/((1.0 + (unity_LightAtten[il_2].z * tmpvar_18))));
    if (((unity_LightPosition[il_2].w != 0.0) && (tmpvar_18 > unity_LightAtten[il_2].w))) {
      att_16 = 0.0;
    };
    dirToLight_17 = (dirToLight_17 * inversesqrt(max (tmpvar_18, 1e-06)));
    highp float tmpvar_19;
    tmpvar_19 = max (dot (dirToLight_17, unity_SpotDirection[il_2].xyz), 0.0);
    rho_15 = tmpvar_19;
    att_16 = (att_16 * clamp ((
      (rho_15 - unity_LightAtten[il_2].x)
     * unity_LightAtten[il_2].y), 0.0, 1.0));
    att_16 = (att_16 * 0.5);
    mediump vec3 dirToLight_20;
    dirToLight_20 = dirToLight_17;
    mediump vec3 specColor_21;
    specColor_21 = specColor_4;
    mediump float tmpvar_22;
    tmpvar_22 = max (dot (eyeNormal_7, dirToLight_20), 0.0);
    mediump vec3 tmpvar_23;
    tmpvar_23 = ((tmpvar_22 * _Color.xyz) * unity_LightColor[il_2].xyz);
    if ((tmpvar_22 > 0.0)) {
      specColor_21 = (specColor_4 + ((att_16 * 
        clamp (pow (max (dot (eyeNormal_7, 
          normalize((dirToLight_20 + viewDir_6))
        ), 0.0), shininess_3), 0.0, 1.0)
      ) * unity_LightColor[il_2].xyz));
    };
    specColor_4 = specColor_21;
    lcolor_5 = (lcolor_5 + min ((tmpvar_23 * att_16), vec3(1.0, 1.0, 1.0)));
  };
  color_9.xyz = lcolor_5;
  color_9.w = _Color.w;
  specColor_4 = (specColor_4 * _SpecColor.xyz);
  lowp vec4 tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25 = clamp (color_9, 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  lowp vec3 tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = clamp (specColor_4, 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = tmpvar_1;
  xlv_COLOR0 = tmpvar_24;
  xlv_COLOR1 = tmpvar_26;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_28);
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying lowp vec4 xlv_COLOR0;
varying lowp vec3 xlv_COLOR1;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 col_1;
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  col_1.xyz = (col_1.xyz + xlv_COLOR1);
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat6;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = dot(u_xlat5.xyz, unity_SpotDirection[u_xlati_loop_1].xyz);
        u_xlat32 = max(u_xlat32, 0.0);
        u_xlat16_7.x = u_xlat32 + (-unity_LightAtten[u_xlati_loop_1].x);
        u_xlat16_7.x = u_xlat16_7.x * unity_LightAtten[u_xlati_loop_1].y;
#ifdef UNITY_ADRENO_ES3
        u_xlat16_7.x = min(max(u_xlat16_7.x, 0.0), 1.0);
#else
        u_xlat16_7.x = clamp(u_xlat16_7.x, 0.0, 1.0);
#endif
        u_xlat16_31 = u_xlat16_31 * u_xlat16_7.x;
        u_xlat16_31 = u_xlat16_31 * 0.5;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat6;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = dot(u_xlat5.xyz, unity_SpotDirection[u_xlati_loop_1].xyz);
        u_xlat32 = max(u_xlat32, 0.0);
        u_xlat16_7.x = u_xlat32 + (-unity_LightAtten[u_xlati_loop_1].x);
        u_xlat16_7.x = u_xlat16_7.x * unity_LightAtten[u_xlati_loop_1].y;
#ifdef UNITY_ADRENO_ES3
        u_xlat16_7.x = min(max(u_xlat16_7.x, 0.0), 1.0);
#else
        u_xlat16_7.x = clamp(u_xlat16_7.x, 0.0, 1.0);
#endif
        u_xlat16_31 = u_xlat16_31 * u_xlat16_7.x;
        u_xlat16_31 = u_xlat16_31 * 0.5;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
"#ifdef VERTEX
#version 300 es

uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_modelview0[4];
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[4];
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mediump vec4 _Color;
uniform 	mediump vec4 _SpecColor;
uniform 	mediump vec4 _Emission;
uniform 	mediump float _Shininess;
uniform 	ivec4 unity_VertexLightParams;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_NORMAL0;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out lowp vec3 vs_COLOR1;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec3 u_xlat1;
mediump vec3 u_xlat16_2;
mediump vec4 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
bool u_xlatb5;
float u_xlat6;
mediump vec3 u_xlat16_7;
mediump vec3 u_xlat16_8;
bool u_xlatb15;
mediump vec3 u_xlat16_16;
bool u_xlatb24;
float u_xlat27;
int u_xlati28;
mediump float u_xlat16_29;
mediump float u_xlat16_31;
float u_xlat32;
bool u_xlatb32;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4glstate_matrix_modelview0[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4glstate_matrix_modelview0[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4glstate_matrix_modelview0[3].xyz;
    u_xlat1.xyz = in_NORMAL0.yyy * hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[0].xyz * in_NORMAL0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4glstate_matrix_invtrans_modelview0[2].xyz * in_NORMAL0.zzz + u_xlat1.xyz;
    u_xlat27 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat1.xyz = vec3(u_xlat27) * u_xlat1.xyz;
    u_xlat27 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat27 = inversesqrt(u_xlat27);
    u_xlat16_2.xyz = _Color.xyz * glstate_lightmodel_ambient.xyz + _Emission.xyz;
    u_xlat16_29 = _Shininess * 128.0;
    u_xlat16_3.xyz = u_xlat16_2.xyz;
    u_xlat16_4.x = float(0.0);
    u_xlat16_4.y = float(0.0);
    u_xlat16_4.z = float(0.0);
    for(int u_xlati_loop_1 = 0 ; u_xlati_loop_1<unity_VertexLightParams.x ; u_xlati_loop_1++)
    {
        u_xlat5.xyz = (-u_xlat0.xyz) * unity_LightPosition[u_xlati_loop_1].www + unity_LightPosition[u_xlati_loop_1].xyz;
        u_xlat32 = dot(u_xlat5.xyz, u_xlat5.xyz);
        u_xlat6 = unity_LightAtten[u_xlati_loop_1].z * u_xlat32 + 1.0;
        u_xlat6 = float(1.0) / u_xlat6;
#ifdef UNITY_ADRENO_ES3
        u_xlatb15 = !!(0.0!=unity_LightPosition[u_xlati_loop_1].w);
#else
        u_xlatb15 = 0.0!=unity_LightPosition[u_xlati_loop_1].w;
#endif
#ifdef UNITY_ADRENO_ES3
        u_xlatb24 = !!(unity_LightAtten[u_xlati_loop_1].w<u_xlat32);
#else
        u_xlatb24 = unity_LightAtten[u_xlati_loop_1].w<u_xlat32;
#endif
        u_xlatb15 = u_xlatb24 && u_xlatb15;
        u_xlat16_31 = (u_xlatb15) ? 0.0 : u_xlat6;
        u_xlat32 = max(u_xlat32, 9.99999997e-007);
        u_xlat32 = inversesqrt(u_xlat32);
        u_xlat5.xyz = vec3(u_xlat32) * u_xlat5.xyz;
        u_xlat32 = dot(u_xlat5.xyz, unity_SpotDirection[u_xlati_loop_1].xyz);
        u_xlat32 = max(u_xlat32, 0.0);
        u_xlat16_7.x = u_xlat32 + (-unity_LightAtten[u_xlati_loop_1].x);
        u_xlat16_7.x = u_xlat16_7.x * unity_LightAtten[u_xlati_loop_1].y;
#ifdef UNITY_ADRENO_ES3
        u_xlat16_7.x = min(max(u_xlat16_7.x, 0.0), 1.0);
#else
        u_xlat16_7.x = clamp(u_xlat16_7.x, 0.0, 1.0);
#endif
        u_xlat16_31 = u_xlat16_31 * u_xlat16_7.x;
        u_xlat16_31 = u_xlat16_31 * 0.5;
        u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat5.xyz);
        u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
        u_xlat16_16.xyz = u_xlat16_7.xxx * _Color.xyz;
        u_xlat16_16.xyz = u_xlat16_16.xyz * unity_LightColor[u_xlati_loop_1].xyz;
#ifdef UNITY_ADRENO_ES3
        u_xlatb32 = !!(0.0<u_xlat16_7.x);
#else
        u_xlatb32 = 0.0<u_xlat16_7.x;
#endif
        if(u_xlatb32){
            u_xlat16_8.xyz = (-u_xlat0.xyz) * vec3(u_xlat27) + u_xlat5.xyz;
            u_xlat16_7.x = dot(u_xlat16_8.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = inversesqrt(u_xlat16_7.x);
            u_xlat16_8.xyz = u_xlat16_7.xxx * u_xlat16_8.xyz;
            u_xlat16_7.x = dot(u_xlat1.xyz, u_xlat16_8.xyz);
            u_xlat16_7.x = max(u_xlat16_7.x, 0.0);
            u_xlat16_7.x = log2(u_xlat16_7.x);
            u_xlat16_7.x = u_xlat16_29 * u_xlat16_7.x;
            u_xlat16_7.x = exp2(u_xlat16_7.x);
            u_xlat16_7.x = min(u_xlat16_7.x, 1.0);
            u_xlat16_7.x = u_xlat16_31 * u_xlat16_7.x;
            u_xlat16_4.xyz = u_xlat16_7.xxx * unity_LightColor[u_xlati_loop_1].xyz + u_xlat16_4.xyz;
        //ENDIF
        }
        u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_16.xyz;
        u_xlat16_7.xyz = min(u_xlat16_7.xyz, vec3(1.0, 1.0, 1.0));
        u_xlat16_3.xyz = u_xlat16_3.xyz + u_xlat16_7.xyz;
    }
    u_xlat16_2.xyz = u_xlat16_4.xyz * _SpecColor.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_2.xyz = min(max(u_xlat16_2.xyz, 0.0), 1.0);
#else
    u_xlat16_2.xyz = clamp(u_xlat16_2.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.xyz = min(max(u_xlat16_3.xyz, 0.0), 1.0);
#else
    u_xlat16_3.xyz = clamp(u_xlat16_3.xyz, 0.0, 1.0);
#endif
    u_xlat16_3.w = _Color.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.w = min(max(u_xlat16_3.w, 0.0), 1.0);
#else
    u_xlat16_3.w = clamp(u_xlat16_3.w, 0.0, 1.0);
#endif
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    vs_COLOR0 = u_xlat16_3;
    vs_COLOR1.xyz = u_xlat16_2.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in lowp vec4 vs_COLOR0;
in lowp vec3 vs_COLOR1;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * vs_COLOR0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vs_COLOR1.xyz;
    SV_Target0.w = 1.0;
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
}
}
 Pass {
  LOD 100
  Tags { "LIGHTMODE" = "VertexLM" "RenderType" = "Opaque" }
  ZClip Off
  Fog {
   Mode Off
  }
  GpuProgramID 175433
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  col_1 = (texture2D (unity_Lightmap, xlv_TEXCOORD0) * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD1) * col_1).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  col_1 = (texture2D (unity_Lightmap, xlv_TEXCOORD0) * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD1) * col_1).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 col_1;
  col_1 = (texture2D (unity_Lightmap, xlv_TEXCOORD0) * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD1) * col_1).xyz;
  col_1.xyz = (col_1 * 2.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(unity_Lightmap, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * _Color.xyz;
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD1.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(unity_Lightmap, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * _Color.xyz;
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD1.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec3 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0.xyz = texture(unity_Lightmap, vs_TEXCOORD0.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_0.xyz * _Color.xyz;
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD1.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    SV_Target0.w = 1.0;
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
  LOD 100
  Tags { "LIGHTMODE" = "VertexLMRGBM" "RenderType" = "Opaque" }
  ZClip Off
  Fog {
   Mode Off
  }
  GpuProgramID 207922
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Lightmap_ST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_Lightmap_ST.xy) + unity_Lightmap_ST.zw);
  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  col_1 = (tmpvar_2 * tmpvar_2.w);
  col_1 = (col_1 * 2.0);
  col_1 = (col_1 * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD2) * col_1).xyz;
  col_1.xyz = (col_1 * 4.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Lightmap_ST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_Lightmap_ST.xy) + unity_Lightmap_ST.zw);
  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  col_1 = (tmpvar_2 * tmpvar_2.w);
  col_1 = (col_1 * 2.0);
  col_1 = (col_1 * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD2) * col_1).xyz;
  col_1.xyz = (col_1 * 4.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Lightmap_ST;
uniform highp vec4 _MainTex_ST;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  tmpvar_2 = clamp (vec4(0.0, 0.0, 0.0, 1.1), 0.0, 1.0);
  tmpvar_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _glesVertex.xyz;
  xlv_COLOR0 = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_Lightmap_ST.xy) + unity_Lightmap_ST.zw);
  xlv_TEXCOORD2 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (glstate_matrix_mvp * tmpvar_3);
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  col_1 = (tmpvar_2 * tmpvar_2.w);
  col_1 = (col_1 * 2.0);
  col_1 = (col_1 * _Color);
  col_1.xyz = (texture2D (_MainTex, xlv_TEXCOORD2) * col_1).xyz;
  col_1.xyz = (col_1 * 4.0).xyz;
  col_1.w = 1.0;
  gl_FragData[0] = col_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_Lightmap_ST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD2;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD1.xy * unity_Lightmap_ST.xy + unity_Lightmap_ST.zw;
    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD2;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec4 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0 = texture(unity_Lightmap, vs_TEXCOORD0.xy);
    u_xlat10_1.xyz = u_xlat10_0.www * u_xlat10_0.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * _Color.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD2.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(4.0, 4.0, 4.0);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_Lightmap_ST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD2;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD1.xy * unity_Lightmap_ST.xy + unity_Lightmap_ST.zw;
    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD2;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec4 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0 = texture(unity_Lightmap, vs_TEXCOORD0.xy);
    u_xlat10_1.xyz = u_xlat10_0.www * u_xlat10_0.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * _Color.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD2.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(4.0, 4.0, 4.0);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_Lightmap_ST;
uniform 	vec4 _MainTex_ST;
in highp vec3 in_POSITION0;
in highp vec3 in_TEXCOORD1;
in highp vec3 in_TEXCOORD0;
out lowp vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec2 vs_TEXCOORD2;
vec4 u_xlat0;
void main()
{
    vs_COLOR0 = vec4(0.0, 0.0, 0.0, 1.0);
    vs_TEXCOORD0.xy = in_TEXCOORD1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    vs_TEXCOORD1.xy = in_TEXCOORD1.xy * unity_Lightmap_ST.xy + unity_Lightmap_ST.zw;
    vs_TEXCOORD2.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	lowp vec4 _Color;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D unity_Lightmap;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD2;
layout(location = 0) out lowp vec4 SV_Target0;
lowp vec4 u_xlat10_0;
lowp vec3 u_xlat10_1;
void main()
{
    u_xlat10_0 = texture(unity_Lightmap, vs_TEXCOORD0.xy);
    u_xlat10_1.xyz = u_xlat10_0.www * u_xlat10_0.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * _Color.xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0);
    u_xlat10_0.xyz = texture(_MainTex, vs_TEXCOORD2.xy).xyz;
    u_xlat10_1.xyz = u_xlat10_1.xyz * u_xlat10_0.xyz;
    SV_Target0.xyz = u_xlat10_1.xyz * vec3(4.0, 4.0, 4.0);
    SV_Target0.w = 1.0;
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
  Name "SHADOWCASTER"
  LOD 100
  Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
  ZClip Off
  GpuProgramID 37263
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
void main ()
{
  highp vec3 vertex_1;
  vertex_1 = _glesVertex.xyz;
  highp vec4 clipPos_2;
  if ((unity_LightShadowBias.z != 0.0)) {
    highp vec4 tmpvar_3;
    tmpvar_3.w = 1.0;
    tmpvar_3.xyz = vertex_1;
    highp vec3 tmpvar_4;
    tmpvar_4 = (unity_ObjectToWorld * tmpvar_3).xyz;
    highp mat3 tmpvar_5;
    tmpvar_5[0] = unity_WorldToObject[0].xyz;
    tmpvar_5[1] = unity_WorldToObject[1].xyz;
    tmpvar_5[2] = unity_WorldToObject[2].xyz;
    highp vec3 tmpvar_6;
    tmpvar_6 = normalize((_glesNormal * tmpvar_5));
    highp float tmpvar_7;
    tmpvar_7 = dot (tmpvar_6, normalize((_WorldSpaceLightPos0.xyz - 
      (tmpvar_4 * _WorldSpaceLightPos0.w)
    )));
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = (tmpvar_4 - (tmpvar_6 * (unity_LightShadowBias.z * 
      sqrt((1.0 - (tmpvar_7 * tmpvar_7)))
    )));
    clipPos_2 = (unity_MatrixVP * tmpvar_8);
  } else {
    highp vec4 tmpvar_9;
    tmpvar_9.w = 1.0;
    tmpvar_9.xyz = vertex_1;
    clipPos_2 = (glstate_matrix_mvp * tmpvar_9);
  };
  highp vec4 clipPos_10;
  clipPos_10.xyw = clipPos_2.xyw;
  clipPos_10.z = (clipPos_2.z + clamp ((unity_LightShadowBias.x / clipPos_2.w), 0.0, 1.0));
  clipPos_10.z = mix (clipPos_10.z, max (clipPos_10.z, -(clipPos_2.w)), unity_LightShadowBias.y);
  gl_Position = clipPos_10;
}


#endif
#ifdef FRAGMENT
void main ()
{
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
void main ()
{
  highp vec3 vertex_1;
  vertex_1 = _glesVertex.xyz;
  highp vec4 clipPos_2;
  if ((unity_LightShadowBias.z != 0.0)) {
    highp vec4 tmpvar_3;
    tmpvar_3.w = 1.0;
    tmpvar_3.xyz = vertex_1;
    highp vec3 tmpvar_4;
    tmpvar_4 = (unity_ObjectToWorld * tmpvar_3).xyz;
    highp mat3 tmpvar_5;
    tmpvar_5[0] = unity_WorldToObject[0].xyz;
    tmpvar_5[1] = unity_WorldToObject[1].xyz;
    tmpvar_5[2] = unity_WorldToObject[2].xyz;
    highp vec3 tmpvar_6;
    tmpvar_6 = normalize((_glesNormal * tmpvar_5));
    highp float tmpvar_7;
    tmpvar_7 = dot (tmpvar_6, normalize((_WorldSpaceLightPos0.xyz - 
      (tmpvar_4 * _WorldSpaceLightPos0.w)
    )));
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = (tmpvar_4 - (tmpvar_6 * (unity_LightShadowBias.z * 
      sqrt((1.0 - (tmpvar_7 * tmpvar_7)))
    )));
    clipPos_2 = (unity_MatrixVP * tmpvar_8);
  } else {
    highp vec4 tmpvar_9;
    tmpvar_9.w = 1.0;
    tmpvar_9.xyz = vertex_1;
    clipPos_2 = (glstate_matrix_mvp * tmpvar_9);
  };
  highp vec4 clipPos_10;
  clipPos_10.xyw = clipPos_2.xyw;
  clipPos_10.z = (clipPos_2.z + clamp ((unity_LightShadowBias.x / clipPos_2.w), 0.0, 1.0));
  clipPos_10.z = mix (clipPos_10.z, max (clipPos_10.z, -(clipPos_2.w)), unity_LightShadowBias.y);
  gl_Position = clipPos_10;
}


#endif
#ifdef FRAGMENT
void main ()
{
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_WorldToObject;
uniform highp mat4 unity_MatrixVP;
void main ()
{
  highp vec3 vertex_1;
  vertex_1 = _glesVertex.xyz;
  highp vec4 clipPos_2;
  if ((unity_LightShadowBias.z != 0.0)) {
    highp vec4 tmpvar_3;
    tmpvar_3.w = 1.0;
    tmpvar_3.xyz = vertex_1;
    highp vec3 tmpvar_4;
    tmpvar_4 = (unity_ObjectToWorld * tmpvar_3).xyz;
    highp mat3 tmpvar_5;
    tmpvar_5[0] = unity_WorldToObject[0].xyz;
    tmpvar_5[1] = unity_WorldToObject[1].xyz;
    tmpvar_5[2] = unity_WorldToObject[2].xyz;
    highp vec3 tmpvar_6;
    tmpvar_6 = normalize((_glesNormal * tmpvar_5));
    highp float tmpvar_7;
    tmpvar_7 = dot (tmpvar_6, normalize((_WorldSpaceLightPos0.xyz - 
      (tmpvar_4 * _WorldSpaceLightPos0.w)
    )));
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = (tmpvar_4 - (tmpvar_6 * (unity_LightShadowBias.z * 
      sqrt((1.0 - (tmpvar_7 * tmpvar_7)))
    )));
    clipPos_2 = (unity_MatrixVP * tmpvar_8);
  } else {
    highp vec4 tmpvar_9;
    tmpvar_9.w = 1.0;
    tmpvar_9.xyz = vertex_1;
    clipPos_2 = (glstate_matrix_mvp * tmpvar_9);
  };
  highp vec4 clipPos_10;
  clipPos_10.xyw = clipPos_2.xyw;
  clipPos_10.z = (clipPos_2.z + clamp ((unity_LightShadowBias.x / clipPos_2.w), 0.0, 1.0));
  clipPos_10.z = mix (clipPos_10.z, max (clipPos_10.z, -(clipPos_2.w)), unity_LightShadowBias.y);
  gl_Position = clipPos_10;
}


#endif
#ifdef FRAGMENT
void main ()
{
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
bool u_xlatb2;
float u_xlat6;
float u_xlat9;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_ObjectToWorld[3].xyz;
    u_xlat1.xyz = (-u_xlat0.xyz) * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
    u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
    u_xlat2.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat9 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat2.xyz = vec3(u_xlat9) * u_xlat2.xyz;
    u_xlat9 = dot(u_xlat2.xyz, u_xlat1.xyz);
    u_xlat9 = (-u_xlat9) * u_xlat9 + 1.0;
    u_xlat9 = sqrt(u_xlat9);
    u_xlat9 = u_xlat9 * unity_LightShadowBias.z;
    u_xlat0.xyz = (-u_xlat2.xyz) * vec3(u_xlat9) + u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_MatrixVP[3];
    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4glstate_matrix_mvp[3];
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(unity_LightShadowBias.z!=0.0);
#else
    u_xlatb2 = unity_LightShadowBias.z!=0.0;
#endif
    u_xlat0 = (bool(u_xlatb2)) ? u_xlat0 : u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat6 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat6);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat6) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat6;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
layout(location = 0) out highp vec4 SV_Target0;
void main()
{
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
bool u_xlatb2;
float u_xlat6;
float u_xlat9;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_ObjectToWorld[3].xyz;
    u_xlat1.xyz = (-u_xlat0.xyz) * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
    u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
    u_xlat2.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat9 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat2.xyz = vec3(u_xlat9) * u_xlat2.xyz;
    u_xlat9 = dot(u_xlat2.xyz, u_xlat1.xyz);
    u_xlat9 = (-u_xlat9) * u_xlat9 + 1.0;
    u_xlat9 = sqrt(u_xlat9);
    u_xlat9 = u_xlat9 * unity_LightShadowBias.z;
    u_xlat0.xyz = (-u_xlat2.xyz) * vec3(u_xlat9) + u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_MatrixVP[3];
    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4glstate_matrix_mvp[3];
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(unity_LightShadowBias.z!=0.0);
#else
    u_xlatb2 = unity_LightShadowBias.z!=0.0;
#endif
    u_xlat0 = (bool(u_xlatb2)) ? u_xlat0 : u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat6 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat6);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat6) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat6;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
layout(location = 0) out highp vec4 SV_Target0;
void main()
{
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToObject[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
bool u_xlatb2;
float u_xlat6;
float u_xlat9;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_ObjectToWorld[3].xyz;
    u_xlat1.xyz = (-u_xlat0.xyz) * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
    u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
    u_xlat2.x = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
    u_xlat2.y = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
    u_xlat2.z = dot(in_NORMAL0.xyz, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
    u_xlat9 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat9 = inversesqrt(u_xlat9);
    u_xlat2.xyz = vec3(u_xlat9) * u_xlat2.xyz;
    u_xlat9 = dot(u_xlat2.xyz, u_xlat1.xyz);
    u_xlat9 = (-u_xlat9) * u_xlat9 + 1.0;
    u_xlat9 = sqrt(u_xlat9);
    u_xlat9 = u_xlat9 * unity_LightShadowBias.z;
    u_xlat0.xyz = (-u_xlat2.xyz) * vec3(u_xlat9) + u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_MatrixVP[3];
    u_xlat1 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat1;
    u_xlat1 = u_xlat1 + hlslcc_mtx4x4glstate_matrix_mvp[3];
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(unity_LightShadowBias.z!=0.0);
#else
    u_xlatb2 = unity_LightShadowBias.z!=0.0;
#endif
    u_xlat0 = (bool(u_xlatb2)) ? u_xlat0 : u_xlat1;
    u_xlat1.x = unity_LightShadowBias.x / u_xlat0.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
#else
    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
#endif
    u_xlat6 = u_xlat0.z + u_xlat1.x;
    u_xlat1.x = max((-u_xlat0.w), u_xlat6);
    gl_Position.xyw = u_xlat0.xyw;
    u_xlat0.x = (-u_xlat6) + u_xlat1.x;
    gl_Position.z = unity_LightShadowBias.y * u_xlat0.x + u_xlat6;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
layout(location = 0) out highp vec4 SV_Target0;
void main()
{
    SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((unity_ObjectToWorld * _glesVertex).xyz - _LightPositionRange.xyz);
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_LightShadowBias;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = fract((vec4(1.0, 255.0, 65025.0, 1.658138e+07) * min (
    ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) + unity_LightShadowBias.x) * _LightPositionRange.w)
  , 0.999)));
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 - (tmpvar_1.yzww * 0.003921569));
  gl_FragData[0] = tmpvar_2;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((unity_ObjectToWorld * _glesVertex).xyz - _LightPositionRange.xyz);
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_LightShadowBias;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = fract((vec4(1.0, 255.0, 65025.0, 1.658138e+07) * min (
    ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) + unity_LightShadowBias.x) * _LightPositionRange.w)
  , 0.999)));
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 - (tmpvar_1.yzww * 0.003921569));
  gl_FragData[0] = tmpvar_2;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_ObjectToWorld;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  xlv_TEXCOORD0 = ((unity_ObjectToWorld * _glesVertex).xyz - _LightPositionRange.xyz);
  gl_Position = (glstate_matrix_mvp * tmpvar_1);
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_LightShadowBias;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = fract((vec4(1.0, 255.0, 65025.0, 1.658138e+07) * min (
    ((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) + unity_LightShadowBias.x) * _LightPositionRange.w)
  , 0.999)));
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 - (tmpvar_1.yzww * 0.003921569));
  gl_FragData[0] = tmpvar_2;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
in highp vec4 in_POSITION0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
in highp vec4 in_POSITION0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _LightPositionRange;
uniform 	vec4 hlslcc_mtx4x4glstate_matrix_mvp[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
in highp vec4 in_POSITION0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
void main()
{
    u_xlat0.xyz = in_POSITION0.yyy * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * in_POSITION0.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * in_POSITION0.zzz + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat0.xyz;
    vs_TEXCOORD0.xyz = u_xlat0.xyz + (-_LightPositionRange.xyz);
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4glstate_matrix_mvp[1];
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4glstate_matrix_mvp[2] * in_POSITION0.zzzz + u_xlat0;
    gl_Position = u_xlat0 + hlslcc_mtx4x4glstate_matrix_mvp[3];
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_LightShadowBias;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out highp vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0.x = dot(vs_TEXCOORD0.xyz, vs_TEXCOORD0.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = u_xlat0.x + unity_LightShadowBias.x;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = min(u_xlat0.x, 0.999000013);
    u_xlat0 = u_xlat0.xxxx * vec4(1.0, 255.0, 65025.0, 16581375.0);
    u_xlat0 = fract(u_xlat0);
    SV_Target0 = (-u_xlat0.yzww) * vec4(0.00392156886, 0.00392156886, 0.00392156886, 0.00392156886) + u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_CUBE" }
""
}
}
}
}
}