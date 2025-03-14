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
 _Shininess ("Shininess", Range(0.01,1)) = 0.7
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 
 LOD 100
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "LIGHTMODE"="Vertex" "RenderType"="Opaque" }
  Lighting On
  SeparateSpecular On
  Material {
   Ambient [_Color]
   Diffuse [_Color]
   Emission [_Emission]
   Specular [_SpecColor]
   Shininess [_Shininess]
  }
  SetTexture [_MainTex] { ConstantColor (1,1,1,1) combine texture * primary double, constant alpha }
 }
 Pass {
  Tags { "LIGHTMODE"="VertexLM" "RenderType"="Opaque" }
  BindChannels {
   Bind "vertex", Vertex
   Bind "normal", Normal
   Bind "texcoord1", TexCoord0
   Bind "texcoord", TexCoord1
  }
  SetTexture [unity_Lightmap] { ConstantColor [_Color] Matrix [unity_LightmapMatrix] combine texture * constant }
  SetTexture [_MainTex] { ConstantColor (1,1,1,1) combine texture * previous double, constant alpha }
 }
 Pass {
  Tags { "LIGHTMODE"="VertexLMRGBM" "RenderType"="Opaque" }
  BindChannels {
   Bind "vertex", Vertex
   Bind "normal", Normal
   Bind "texcoord1", TexCoord0
   Bind "texcoord1", TexCoord1
   Bind "texcoord", TexCoord2
  }
  SetTexture [unity_Lightmap] { Matrix [unity_LightmapMatrix] combine texture * texture alpha double }
  SetTexture [unity_Lightmap] { ConstantColor [_Color] combine previous * constant }
  SetTexture [_MainTex] { ConstantColor (1,1,1,1) combine texture * previous quad, constant alpha }
 }
 Pass {
  Name "SHADOWCASTER"
  Tags { "LIGHTMODE"="SHADOWCASTER" "SHADOWSUPPORT"="true" "RenderType"="Opaque" }
  GpuProgramID 33459
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
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
    tmpvar_4 = (_Object2World * tmpvar_3).xyz;
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
    highp float tmpvar_9;
    tmpvar_9 = dot (tmpvar_8, normalize((_WorldSpaceLightPos0.xyz - 
      (tmpvar_4 * _WorldSpaceLightPos0.w)
    )));
    highp vec4 tmpvar_10;
    tmpvar_10.w = 1.0;
    tmpvar_10.xyz = (tmpvar_4 - (tmpvar_8 * (unity_LightShadowBias.z * 
      sqrt((1.0 - (tmpvar_9 * tmpvar_9)))
    )));
    clipPos_2 = (unity_MatrixVP * tmpvar_10);
  } else {
    highp vec4 tmpvar_11;
    tmpvar_11.w = 1.0;
    tmpvar_11.xyz = vertex_1;
    clipPos_2 = (glstate_matrix_mvp * tmpvar_11);
  };
  highp vec4 clipPos_12;
  clipPos_12.xyw = clipPos_2.xyw;
  clipPos_12.z = (clipPos_2.z + clamp ((unity_LightShadowBias.x / clipPos_2.w), 0.0, 1.0));
  clipPos_12.z = mix (clipPos_12.z, max (clipPos_12.z, -(clipPos_2.w)), unity_LightShadowBias.y);
  gl_Position = clipPos_12;
}



#endif
#ifdef FRAGMENT

void main ()
{
  gl_FragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec3 _glesNormal;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec4 unity_LightShadowBias;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
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
    tmpvar_4 = (_Object2World * tmpvar_3).xyz;
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
    highp float tmpvar_9;
    tmpvar_9 = dot (tmpvar_8, normalize((_WorldSpaceLightPos0.xyz - 
      (tmpvar_4 * _WorldSpaceLightPos0.w)
    )));
    highp vec4 tmpvar_10;
    tmpvar_10.w = 1.0;
    tmpvar_10.xyz = (tmpvar_4 - (tmpvar_8 * (unity_LightShadowBias.z * 
      sqrt((1.0 - (tmpvar_9 * tmpvar_9)))
    )));
    clipPos_2 = (unity_MatrixVP * tmpvar_10);
  } else {
    highp vec4 tmpvar_11;
    tmpvar_11.w = 1.0;
    tmpvar_11.xyz = vertex_1;
    clipPos_2 = (glstate_matrix_mvp * tmpvar_11);
  };
  highp vec4 clipPos_12;
  clipPos_12.xyw = clipPos_2.xyw;
  clipPos_12.z = (clipPos_2.z + clamp ((unity_LightShadowBias.x / clipPos_2.w), 0.0, 1.0));
  clipPos_12.z = mix (clipPos_12.z, max (clipPos_12.z, -(clipPos_2.w)), unity_LightShadowBias.y);
  gl_Position = clipPos_12;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
void main ()
{
  _glesFragData[0] = vec4(0.0, 0.0, 0.0, 0.0);
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  xlv_TEXCOORD0 = ((_Object2World * _glesVertex).xyz - _LightPositionRange.xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
}



#endif
#ifdef FRAGMENT

uniform highp vec4 _LightPositionRange;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = fract((vec4(1.0, 255.0, 65025.0, 1.658138e+07) * min (
    (sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w)
  , 0.999)));
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 - (tmpvar_1.yzww * 0.003921569));
  gl_FragData[0] = tmpvar_2;
}



#endif"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_CUBE" }
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
uniform highp vec4 _LightPositionRange;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
out highp vec3 xlv_TEXCOORD0;
void main ()
{
  xlv_TEXCOORD0 = ((_Object2World * _glesVertex).xyz - _LightPositionRange.xyz);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform highp vec4 _LightPositionRange;
in highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = vec4((sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w));
  _glesFragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES3"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles3 " {
Keywords { "SHADOWS_CUBE" }
"!!GLES3"
}
}
 }
}
}