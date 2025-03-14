//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/CubeBlur" {
Properties {
 _MainTex ("Main", CUBE) = "" { }
 _Texel ("Texel", Float) = 0.0078125
 _Level ("Level", Float) = 0
 _Scale ("Scale", Float) = 1
}
SubShader { 
 LOD 200
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 46430
Program "vp" {
SubProgram "gles " {
"!!GLES


#ifdef VERTEX

attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying mediump vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0;
  mediump vec4 tmpvar_2;
  tmpvar_2 = tmpvar_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shader_texture_lod : enable
vec4 impl_textureCubeLodEXT(samplerCube sampler, vec3 coord, float lod)
{
#if defined(GL_EXT_shader_texture_lod)
 return textureCubeLodEXT(sampler, coord, lod);
#else
 return textureCube(sampler, coord, lod);
#endif
}

uniform lowp samplerCube _MainTex;
uniform mediump float _Texel;
uniform mediump float _Level;
uniform mediump float _Scale;
varying mediump vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 tmpvar_1;
  tmpvar_1 = abs(xlv_TEXCOORD0.xyz);
  bvec3 tmpvar_2;
  tmpvar_2 = equal (tmpvar_1, vec3(1.0, 1.0, 1.0));
  lowp vec3 tmpvar_3;
  tmpvar_3 = vec3(tmpvar_2);
  mediump vec3 tmpvar_4;
  tmpvar_4 = mix (vec3(0.0, 0.0, 0.0), xlv_TEXCOORD0.xyz, tmpvar_3);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.zxy * _Texel);
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.yzx * _Texel);
  mediump vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (xlv_TEXCOORD0.xyz * (vec3(1.0, 1.0, 1.0) - abs(tmpvar_4)));
  mediump float tmpvar_8;
  tmpvar_8 = inversesqrt((1.0 + dot (tmpvar_7.xyz, tmpvar_7.xyz)));
  mediump float d_9;
  d_9 = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  mediump vec3 tmpvar_10;
  tmpvar_10.x = d_9;
  tmpvar_10.y = (3.0 * d_9);
  tmpvar_10.z = (5.0 * d_9);
  mediump vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * _Scale);
  mediump vec3 tmpvar_12;
  tmpvar_12 = exp((-(tmpvar_11) * tmpvar_11));
  mediump vec3 tmpvar_13;
  mediump vec3 st_14;
  st_14 = (xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5));
  mediump vec3 tmpvar_15;
  tmpvar_15 = min (max (st_14, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = abs((st_14 - tmpvar_15));
  tmpvar_13 = (tmpvar_15 - (max (
    max (tmpvar_16.x, tmpvar_16.y)
  , tmpvar_16.z) * tmpvar_4));
  mediump vec3 tmpvar_17;
  mediump vec3 st_18;
  st_18 = (xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5));
  mediump vec3 tmpvar_19;
  tmpvar_19 = min (max (st_18, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_20;
  tmpvar_20 = abs((st_18 - tmpvar_19));
  tmpvar_17 = (tmpvar_19 - (max (
    max (tmpvar_20.x, tmpvar_20.y)
  , tmpvar_20.z) * tmpvar_4));
  mediump vec3 tmpvar_21;
  mediump vec3 st_22;
  st_22 = (xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5));
  mediump vec3 tmpvar_23;
  tmpvar_23 = min (max (st_22, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_24;
  tmpvar_24 = abs((st_22 - tmpvar_23));
  tmpvar_21 = (tmpvar_23 - (max (
    max (tmpvar_24.x, tmpvar_24.y)
  , tmpvar_24.z) * tmpvar_4));
  mediump vec3 tmpvar_25;
  mediump vec3 st_26;
  st_26 = (xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5));
  mediump vec3 tmpvar_27;
  tmpvar_27 = min (max (st_26, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_28;
  tmpvar_28 = abs((st_26 - tmpvar_27));
  tmpvar_25 = (tmpvar_27 - (max (
    max (tmpvar_28.x, tmpvar_28.y)
  , tmpvar_28.z) * tmpvar_4));
  mediump vec3 tmpvar_29;
  mediump vec3 st_30;
  st_30 = (xlv_TEXCOORD0.xyz + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_31;
  tmpvar_31 = min (max (st_30, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_32;
  tmpvar_32 = abs((st_30 - tmpvar_31));
  tmpvar_29 = (tmpvar_31 - (max (
    max (tmpvar_32.x, tmpvar_32.y)
  , tmpvar_32.z) * tmpvar_4));
  mediump vec3 tmpvar_33;
  mediump vec3 st_34;
  st_34 = (xlv_TEXCOORD0.xyz - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_35;
  tmpvar_35 = min (max (st_34, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_36;
  tmpvar_36 = abs((st_34 - tmpvar_35));
  tmpvar_33 = (tmpvar_35 - (max (
    max (tmpvar_36.x, tmpvar_36.y)
  , tmpvar_36.z) * tmpvar_4));
  mediump vec3 tmpvar_37;
  mediump vec3 st_38;
  st_38 = (xlv_TEXCOORD0.xyz + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_39;
  tmpvar_39 = min (max (st_38, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_40;
  tmpvar_40 = abs((st_38 - tmpvar_39));
  tmpvar_37 = (tmpvar_39 - (max (
    max (tmpvar_40.x, tmpvar_40.y)
  , tmpvar_40.z) * tmpvar_4));
  mediump vec3 tmpvar_41;
  mediump vec3 st_42;
  st_42 = (xlv_TEXCOORD0.xyz - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_43;
  tmpvar_43 = min (max (st_42, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_44;
  tmpvar_44 = abs((st_42 - tmpvar_43));
  tmpvar_41 = (tmpvar_43 - (max (
    max (tmpvar_44.x, tmpvar_44.y)
  , tmpvar_44.z) * tmpvar_4));
  mediump vec3 tmpvar_45;
  tmpvar_45 = (tmpvar_12 * tmpvar_12.zzz);
  mediump vec3 tmpvar_46;
  tmpvar_46 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_47;
  tmpvar_47 = min (max (tmpvar_46, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_48;
  tmpvar_48 = abs((tmpvar_46 - tmpvar_47));
  mediump vec4 tmpvar_49;
  tmpvar_49.xyz = (tmpvar_47 - (max (
    max (tmpvar_48.x, tmpvar_48.y)
  , tmpvar_48.z) * tmpvar_4));
  tmpvar_49.w = _Level;
  lowp vec4 tmpvar_50;
  tmpvar_50 = impl_textureCubeLodEXT (_MainTex, tmpvar_49.xyz, _Level);
  mediump vec4 tmpvar_51;
  tmpvar_51 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_50);
  mediump vec3 tmpvar_52;
  tmpvar_52 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_53;
  tmpvar_53 = min (max (tmpvar_52, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_54;
  tmpvar_54 = abs((tmpvar_52 - tmpvar_53));
  mediump vec4 tmpvar_55;
  tmpvar_55.xyz = (tmpvar_53 - (max (
    max (tmpvar_54.x, tmpvar_54.y)
  , tmpvar_54.z) * tmpvar_4));
  tmpvar_55.w = _Level;
  lowp vec4 tmpvar_56;
  tmpvar_56 = impl_textureCubeLodEXT (_MainTex, tmpvar_55.xyz, _Level);
  mediump vec4 tmpvar_57;
  tmpvar_57 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_56);
  mediump vec4 tmpvar_58;
  tmpvar_58.xyz = (tmpvar_41 - (0.5 * tmpvar_5));
  tmpvar_58.w = _Level;
  lowp vec4 tmpvar_59;
  tmpvar_59 = impl_textureCubeLodEXT (_MainTex, tmpvar_58.xyz, _Level);
  mediump vec4 tmpvar_60;
  tmpvar_60 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_59);
  mediump vec4 tmpvar_61;
  tmpvar_61.xyz = (tmpvar_41 + (0.5 * tmpvar_5));
  tmpvar_61.w = _Level;
  lowp vec4 tmpvar_62;
  tmpvar_62 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_61.xyz, _Level));
  mediump vec3 tmpvar_63;
  tmpvar_63 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_64;
  tmpvar_64 = min (max (tmpvar_63, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_65;
  tmpvar_65 = abs((tmpvar_63 - tmpvar_64));
  mediump vec4 tmpvar_66;
  tmpvar_66.xyz = (tmpvar_64 - (max (
    max (tmpvar_65.x, tmpvar_65.y)
  , tmpvar_65.z) * tmpvar_4));
  tmpvar_66.w = _Level;
  lowp vec4 tmpvar_67;
  tmpvar_67 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_66.xyz, _Level));
  mediump vec3 tmpvar_68;
  tmpvar_68 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_69;
  tmpvar_69 = min (max (tmpvar_68, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_70;
  tmpvar_70 = abs((tmpvar_68 - tmpvar_69));
  mediump vec4 tmpvar_71;
  tmpvar_71.xyz = (tmpvar_69 - (max (
    max (tmpvar_70.x, tmpvar_70.y)
  , tmpvar_70.z) * tmpvar_4));
  tmpvar_71.w = _Level;
  lowp vec4 tmpvar_72;
  tmpvar_72 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_71.xyz, _Level));
  mediump vec3 tmpvar_73;
  tmpvar_73 = (tmpvar_12 * tmpvar_12.yyy);
  mediump vec3 tmpvar_74;
  tmpvar_74 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_75;
  tmpvar_75 = min (max (tmpvar_74, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_76;
  tmpvar_76 = abs((tmpvar_74 - tmpvar_75));
  mediump vec4 tmpvar_77;
  tmpvar_77.xyz = (tmpvar_75 - (max (
    max (tmpvar_76.x, tmpvar_76.y)
  , tmpvar_76.z) * tmpvar_4));
  tmpvar_77.w = _Level;
  lowp vec4 tmpvar_78;
  tmpvar_78 = impl_textureCubeLodEXT (_MainTex, tmpvar_77.xyz, _Level);
  mediump vec4 tmpvar_79;
  tmpvar_79 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_78);
  mediump vec3 tmpvar_80;
  tmpvar_80 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_81;
  tmpvar_81 = min (max (tmpvar_80, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_82;
  tmpvar_82 = abs((tmpvar_80 - tmpvar_81));
  mediump vec4 tmpvar_83;
  tmpvar_83.xyz = (tmpvar_81 - (max (
    max (tmpvar_82.x, tmpvar_82.y)
  , tmpvar_82.z) * tmpvar_4));
  tmpvar_83.w = _Level;
  lowp vec4 tmpvar_84;
  tmpvar_84 = impl_textureCubeLodEXT (_MainTex, tmpvar_83.xyz, _Level);
  mediump vec4 tmpvar_85;
  tmpvar_85 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_84);
  mediump vec4 tmpvar_86;
  tmpvar_86.xyz = (tmpvar_33 + (0.5 * tmpvar_5));
  tmpvar_86.w = _Level;
  lowp vec4 tmpvar_87;
  tmpvar_87 = impl_textureCubeLodEXT (_MainTex, tmpvar_86.xyz, _Level);
  mediump vec4 tmpvar_88;
  tmpvar_88 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_87);
  mediump vec4 tmpvar_89;
  tmpvar_89.xyz = (tmpvar_33 - (0.5 * tmpvar_5));
  tmpvar_89.w = _Level;
  lowp vec4 tmpvar_90;
  tmpvar_90 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_89.xyz, _Level));
  mediump vec3 tmpvar_91;
  tmpvar_91 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_92;
  tmpvar_92 = min (max (tmpvar_91, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_93;
  tmpvar_93 = abs((tmpvar_91 - tmpvar_92));
  mediump vec4 tmpvar_94;
  tmpvar_94.xyz = (tmpvar_92 - (max (
    max (tmpvar_93.x, tmpvar_93.y)
  , tmpvar_93.z) * tmpvar_4));
  tmpvar_94.w = _Level;
  lowp vec4 tmpvar_95;
  tmpvar_95 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_94.xyz, _Level));
  mediump vec3 tmpvar_96;
  tmpvar_96 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_97;
  tmpvar_97 = min (max (tmpvar_96, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_98;
  tmpvar_98 = abs((tmpvar_96 - tmpvar_97));
  mediump vec4 tmpvar_99;
  tmpvar_99.xyz = (tmpvar_97 - (max (
    max (tmpvar_98.x, tmpvar_98.y)
  , tmpvar_98.z) * tmpvar_4));
  tmpvar_99.w = _Level;
  lowp vec4 tmpvar_100;
  tmpvar_100 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_99.xyz, _Level));
  mediump vec3 tmpvar_101;
  tmpvar_101 = (tmpvar_12 * tmpvar_12.xxx);
  mediump vec4 tmpvar_102;
  tmpvar_102.xyz = (tmpvar_25 - (0.5 * tmpvar_6));
  tmpvar_102.w = _Level;
  lowp vec4 tmpvar_103;
  tmpvar_103 = impl_textureCubeLodEXT (_MainTex, tmpvar_102.xyz, _Level);
  mediump vec4 tmpvar_104;
  tmpvar_104 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_103);
  mediump vec4 tmpvar_105;
  tmpvar_105.xyz = (tmpvar_17 - (0.5 * tmpvar_6));
  tmpvar_105.w = _Level;
  lowp vec4 tmpvar_106;
  tmpvar_106 = impl_textureCubeLodEXT (_MainTex, tmpvar_105.xyz, _Level);
  mediump vec4 tmpvar_107;
  tmpvar_107 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_106);
  mediump vec4 tmpvar_108;
  tmpvar_108.xyz = ((xlv_TEXCOORD0.xyz - (0.5 * tmpvar_5)) - (0.5 * tmpvar_6));
  tmpvar_108.w = _Level;
  lowp vec4 tmpvar_109;
  tmpvar_109 = impl_textureCubeLodEXT (_MainTex, tmpvar_108.xyz, _Level);
  mediump vec4 tmpvar_110;
  tmpvar_110 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_109);
  mediump vec4 tmpvar_111;
  tmpvar_111.xyz = ((xlv_TEXCOORD0.xyz + (0.5 * tmpvar_5)) - (0.5 * tmpvar_6));
  tmpvar_111.w = _Level;
  lowp vec4 tmpvar_112;
  tmpvar_112 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_111.xyz, _Level));
  mediump vec4 tmpvar_113;
  tmpvar_113.xyz = (tmpvar_13 - (0.5 * tmpvar_6));
  tmpvar_113.w = _Level;
  lowp vec4 tmpvar_114;
  tmpvar_114 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_113.xyz, _Level));
  mediump vec4 tmpvar_115;
  tmpvar_115.xyz = (tmpvar_21 - (0.5 * tmpvar_6));
  tmpvar_115.w = _Level;
  lowp vec4 tmpvar_116;
  tmpvar_116 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_115.xyz, _Level));
  mediump vec3 tmpvar_117;
  tmpvar_117 = (tmpvar_12 * tmpvar_12.xxx);
  mediump vec4 tmpvar_118;
  tmpvar_118.xyz = (tmpvar_21 + (0.5 * tmpvar_6));
  tmpvar_118.w = _Level;
  lowp vec4 tmpvar_119;
  tmpvar_119 = impl_textureCubeLodEXT (_MainTex, tmpvar_118.xyz, _Level);
  mediump vec4 tmpvar_120;
  tmpvar_120 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_119);
  mediump vec4 tmpvar_121;
  tmpvar_121.xyz = (tmpvar_13 + (0.5 * tmpvar_6));
  tmpvar_121.w = _Level;
  lowp vec4 tmpvar_122;
  tmpvar_122 = impl_textureCubeLodEXT (_MainTex, tmpvar_121.xyz, _Level);
  mediump vec4 tmpvar_123;
  tmpvar_123 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_122);
  mediump vec4 tmpvar_124;
  tmpvar_124.xyz = ((xlv_TEXCOORD0.xyz + (0.5 * tmpvar_5)) + (0.5 * tmpvar_6));
  tmpvar_124.w = _Level;
  lowp vec4 tmpvar_125;
  tmpvar_125 = impl_textureCubeLodEXT (_MainTex, tmpvar_124.xyz, _Level);
  mediump vec4 tmpvar_126;
  tmpvar_126 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_125);
  mediump vec4 tmpvar_127;
  tmpvar_127.xyz = ((xlv_TEXCOORD0.xyz - (0.5 * tmpvar_5)) + (0.5 * tmpvar_6));
  tmpvar_127.w = _Level;
  lowp vec4 tmpvar_128;
  tmpvar_128 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_127.xyz, _Level));
  mediump vec4 tmpvar_129;
  tmpvar_129.xyz = (tmpvar_17 + (0.5 * tmpvar_6));
  tmpvar_129.w = _Level;
  lowp vec4 tmpvar_130;
  tmpvar_130 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_129.xyz, _Level));
  mediump vec4 tmpvar_131;
  tmpvar_131.xyz = (tmpvar_25 + (0.5 * tmpvar_6));
  tmpvar_131.w = _Level;
  lowp vec4 tmpvar_132;
  tmpvar_132 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_131.xyz, _Level));
  mediump vec3 tmpvar_133;
  tmpvar_133 = (tmpvar_12 * tmpvar_12.yyy);
  mediump vec3 tmpvar_134;
  tmpvar_134 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_135;
  tmpvar_135 = min (max (tmpvar_134, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_136;
  tmpvar_136 = abs((tmpvar_134 - tmpvar_135));
  mediump vec4 tmpvar_137;
  tmpvar_137.xyz = (tmpvar_135 - (max (
    max (tmpvar_136.x, tmpvar_136.y)
  , tmpvar_136.z) * tmpvar_4));
  tmpvar_137.w = _Level;
  lowp vec4 tmpvar_138;
  tmpvar_138 = impl_textureCubeLodEXT (_MainTex, tmpvar_137.xyz, _Level);
  mediump vec4 tmpvar_139;
  tmpvar_139 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_138);
  mediump vec3 tmpvar_140;
  tmpvar_140 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_141;
  tmpvar_141 = min (max (tmpvar_140, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_142;
  tmpvar_142 = abs((tmpvar_140 - tmpvar_141));
  mediump vec4 tmpvar_143;
  tmpvar_143.xyz = (tmpvar_141 - (max (
    max (tmpvar_142.x, tmpvar_142.y)
  , tmpvar_142.z) * tmpvar_4));
  tmpvar_143.w = _Level;
  lowp vec4 tmpvar_144;
  tmpvar_144 = impl_textureCubeLodEXT (_MainTex, tmpvar_143.xyz, _Level);
  mediump vec4 tmpvar_145;
  tmpvar_145 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_144);
  mediump vec4 tmpvar_146;
  tmpvar_146.xyz = (tmpvar_29 - (0.5 * tmpvar_5));
  tmpvar_146.w = _Level;
  lowp vec4 tmpvar_147;
  tmpvar_147 = impl_textureCubeLodEXT (_MainTex, tmpvar_146.xyz, _Level);
  mediump vec4 tmpvar_148;
  tmpvar_148 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_147);
  mediump vec4 tmpvar_149;
  tmpvar_149.xyz = (tmpvar_29 + (0.5 * tmpvar_5));
  tmpvar_149.w = _Level;
  lowp vec4 tmpvar_150;
  tmpvar_150 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_149.xyz, _Level));
  mediump vec3 tmpvar_151;
  tmpvar_151 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_152;
  tmpvar_152 = min (max (tmpvar_151, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_153;
  tmpvar_153 = abs((tmpvar_151 - tmpvar_152));
  mediump vec4 tmpvar_154;
  tmpvar_154.xyz = (tmpvar_152 - (max (
    max (tmpvar_153.x, tmpvar_153.y)
  , tmpvar_153.z) * tmpvar_4));
  tmpvar_154.w = _Level;
  lowp vec4 tmpvar_155;
  tmpvar_155 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_154.xyz, _Level));
  mediump vec3 tmpvar_156;
  tmpvar_156 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_157;
  tmpvar_157 = min (max (tmpvar_156, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_158;
  tmpvar_158 = abs((tmpvar_156 - tmpvar_157));
  mediump vec4 tmpvar_159;
  tmpvar_159.xyz = (tmpvar_157 - (max (
    max (tmpvar_158.x, tmpvar_158.y)
  , tmpvar_158.z) * tmpvar_4));
  tmpvar_159.w = _Level;
  lowp vec4 tmpvar_160;
  tmpvar_160 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_159.xyz, _Level));
  mediump vec3 tmpvar_161;
  tmpvar_161 = (tmpvar_12 * tmpvar_12.zzz);
  mediump vec3 tmpvar_162;
  tmpvar_162 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_163;
  tmpvar_163 = min (max (tmpvar_162, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_164;
  tmpvar_164 = abs((tmpvar_162 - tmpvar_163));
  mediump vec4 tmpvar_165;
  tmpvar_165.xyz = (tmpvar_163 - (max (
    max (tmpvar_164.x, tmpvar_164.y)
  , tmpvar_164.z) * tmpvar_4));
  tmpvar_165.w = _Level;
  lowp vec4 tmpvar_166;
  tmpvar_166 = impl_textureCubeLodEXT (_MainTex, tmpvar_165.xyz, _Level);
  mediump vec4 tmpvar_167;
  tmpvar_167 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_166);
  mediump vec3 tmpvar_168;
  tmpvar_168 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_169;
  tmpvar_169 = min (max (tmpvar_168, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_170;
  tmpvar_170 = abs((tmpvar_168 - tmpvar_169));
  mediump vec4 tmpvar_171;
  tmpvar_171.xyz = (tmpvar_169 - (max (
    max (tmpvar_170.x, tmpvar_170.y)
  , tmpvar_170.z) * tmpvar_4));
  tmpvar_171.w = _Level;
  lowp vec4 tmpvar_172;
  tmpvar_172 = impl_textureCubeLodEXT (_MainTex, tmpvar_171.xyz, _Level);
  mediump vec4 tmpvar_173;
  tmpvar_173 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_172);
  mediump vec4 tmpvar_174;
  tmpvar_174.xyz = (tmpvar_37 + (0.5 * tmpvar_5));
  tmpvar_174.w = _Level;
  lowp vec4 tmpvar_175;
  tmpvar_175 = impl_textureCubeLodEXT (_MainTex, tmpvar_174.xyz, _Level);
  mediump vec4 tmpvar_176;
  tmpvar_176 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_175);
  mediump vec4 tmpvar_177;
  tmpvar_177.xyz = (tmpvar_37 - (0.5 * tmpvar_5));
  tmpvar_177.w = _Level;
  lowp vec4 tmpvar_178;
  tmpvar_178 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_177.xyz, _Level));
  mediump vec3 tmpvar_179;
  tmpvar_179 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_180;
  tmpvar_180 = min (max (tmpvar_179, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_181;
  tmpvar_181 = abs((tmpvar_179 - tmpvar_180));
  mediump vec4 tmpvar_182;
  tmpvar_182.xyz = (tmpvar_180 - (max (
    max (tmpvar_181.x, tmpvar_181.y)
  , tmpvar_181.z) * tmpvar_4));
  tmpvar_182.w = _Level;
  lowp vec4 tmpvar_183;
  tmpvar_183 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_182.xyz, _Level));
  mediump vec3 tmpvar_184;
  tmpvar_184 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_185;
  mediump vec3 tmpvar_186;
  tmpvar_186 = min (max (tmpvar_184, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_187;
  tmpvar_187 = abs((tmpvar_184 - tmpvar_186));
  tmpvar_185 = (tmpvar_186 - (max (
    max (tmpvar_187.x, tmpvar_187.y)
  , tmpvar_187.z) * tmpvar_4));
  lowp vec4 tmpvar_188;
  tmpvar_188 = max (vec4(0.0, 0.0, 0.0, 0.0), impl_textureCubeLodEXT (_MainTex, tmpvar_185, _Level));
  gl_FragData[0] = (((
    ((((
      ((((
        ((tmpvar_45.z * (tmpvar_51 + tmpvar_72)) + ((tmpvar_45.x * (tmpvar_60 + tmpvar_62)) + (tmpvar_45.y * (tmpvar_57 + tmpvar_67))))
       + 
        (tmpvar_73.z * (tmpvar_79 + tmpvar_100))
      ) + (
        (tmpvar_73.x * (tmpvar_88 + tmpvar_90))
       + 
        (tmpvar_73.y * (tmpvar_85 + tmpvar_95))
      )) + (tmpvar_101.z * (tmpvar_104 + tmpvar_116))) + ((tmpvar_101.x * (tmpvar_110 + tmpvar_112)) + (tmpvar_101.y * (tmpvar_107 + tmpvar_114))))
     + 
      (tmpvar_117.z * (tmpvar_120 + tmpvar_132))
    ) + (
      (tmpvar_117.x * (tmpvar_126 + tmpvar_128))
     + 
      (tmpvar_117.y * (tmpvar_123 + tmpvar_130))
    )) + (tmpvar_133.z * (tmpvar_139 + tmpvar_160))) + ((tmpvar_133.x * (tmpvar_148 + tmpvar_150)) + (tmpvar_133.y * (tmpvar_145 + tmpvar_155))))
   + 
    (tmpvar_161.z * (tmpvar_167 + tmpvar_188))
  ) + (
    (tmpvar_161.x * (tmpvar_176 + tmpvar_178))
   + 
    (tmpvar_161.y * (tmpvar_173 + tmpvar_183))
  )) / ((
    (((dot (tmpvar_45, vec3(2.0, 2.0, 2.0)) + dot (tmpvar_73, vec3(2.0, 2.0, 2.0))) + dot (tmpvar_101, vec3(2.0, 2.0, 2.0))) + dot (tmpvar_117, vec3(2.0, 2.0, 2.0)))
   + 
    dot (tmpvar_133, vec3(2.0, 2.0, 2.0))
  ) + dot (tmpvar_161, vec3(2.0, 2.0, 2.0))));
}



#endif"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX


in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
out mediump vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0;
  mediump vec4 tmpvar_2;
  tmpvar_2 = tmpvar_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
}



#endif
#ifdef FRAGMENT


layout(location=0) out mediump vec4 _glesFragData[4];
uniform lowp samplerCube _MainTex;
uniform mediump float _Texel;
uniform mediump float _Level;
uniform mediump float _Scale;
in mediump vec4 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 tmpvar_1;
  tmpvar_1 = abs(xlv_TEXCOORD0.xyz);
  bvec3 tmpvar_2;
  tmpvar_2 = equal (tmpvar_1, vec3(1.0, 1.0, 1.0));
  lowp vec3 tmpvar_3;
  tmpvar_3 = vec3(tmpvar_2);
  mediump vec3 tmpvar_4;
  tmpvar_4 = mix (vec3(0.0, 0.0, 0.0), xlv_TEXCOORD0.xyz, tmpvar_3);
  mediump vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.zxy * _Texel);
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.yzx * _Texel);
  mediump vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (xlv_TEXCOORD0.xyz * (vec3(1.0, 1.0, 1.0) - abs(tmpvar_4)));
  mediump float tmpvar_8;
  tmpvar_8 = inversesqrt((1.0 + dot (tmpvar_7.xyz, tmpvar_7.xyz)));
  mediump float d_9;
  d_9 = ((tmpvar_8 * tmpvar_8) * tmpvar_8);
  mediump vec3 tmpvar_10;
  tmpvar_10.x = d_9;
  tmpvar_10.y = (3.0 * d_9);
  tmpvar_10.z = (5.0 * d_9);
  mediump vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * _Scale);
  mediump vec3 tmpvar_12;
  tmpvar_12 = exp((-(tmpvar_11) * tmpvar_11));
  mediump vec3 tmpvar_13;
  mediump vec3 st_14;
  st_14 = (xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5));
  mediump vec3 tmpvar_15;
  tmpvar_15 = min (max (st_14, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_16;
  tmpvar_16 = abs((st_14 - tmpvar_15));
  tmpvar_13 = (tmpvar_15 - (max (
    max (tmpvar_16.x, tmpvar_16.y)
  , tmpvar_16.z) * tmpvar_4));
  mediump vec3 tmpvar_17;
  mediump vec3 st_18;
  st_18 = (xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5));
  mediump vec3 tmpvar_19;
  tmpvar_19 = min (max (st_18, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_20;
  tmpvar_20 = abs((st_18 - tmpvar_19));
  tmpvar_17 = (tmpvar_19 - (max (
    max (tmpvar_20.x, tmpvar_20.y)
  , tmpvar_20.z) * tmpvar_4));
  mediump vec3 tmpvar_21;
  mediump vec3 st_22;
  st_22 = (xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5));
  mediump vec3 tmpvar_23;
  tmpvar_23 = min (max (st_22, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_24;
  tmpvar_24 = abs((st_22 - tmpvar_23));
  tmpvar_21 = (tmpvar_23 - (max (
    max (tmpvar_24.x, tmpvar_24.y)
  , tmpvar_24.z) * tmpvar_4));
  mediump vec3 tmpvar_25;
  mediump vec3 st_26;
  st_26 = (xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5));
  mediump vec3 tmpvar_27;
  tmpvar_27 = min (max (st_26, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_28;
  tmpvar_28 = abs((st_26 - tmpvar_27));
  tmpvar_25 = (tmpvar_27 - (max (
    max (tmpvar_28.x, tmpvar_28.y)
  , tmpvar_28.z) * tmpvar_4));
  mediump vec3 tmpvar_29;
  mediump vec3 st_30;
  st_30 = (xlv_TEXCOORD0.xyz + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_31;
  tmpvar_31 = min (max (st_30, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_32;
  tmpvar_32 = abs((st_30 - tmpvar_31));
  tmpvar_29 = (tmpvar_31 - (max (
    max (tmpvar_32.x, tmpvar_32.y)
  , tmpvar_32.z) * tmpvar_4));
  mediump vec3 tmpvar_33;
  mediump vec3 st_34;
  st_34 = (xlv_TEXCOORD0.xyz - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_35;
  tmpvar_35 = min (max (st_34, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_36;
  tmpvar_36 = abs((st_34 - tmpvar_35));
  tmpvar_33 = (tmpvar_35 - (max (
    max (tmpvar_36.x, tmpvar_36.y)
  , tmpvar_36.z) * tmpvar_4));
  mediump vec3 tmpvar_37;
  mediump vec3 st_38;
  st_38 = (xlv_TEXCOORD0.xyz + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_39;
  tmpvar_39 = min (max (st_38, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_40;
  tmpvar_40 = abs((st_38 - tmpvar_39));
  tmpvar_37 = (tmpvar_39 - (max (
    max (tmpvar_40.x, tmpvar_40.y)
  , tmpvar_40.z) * tmpvar_4));
  mediump vec3 tmpvar_41;
  mediump vec3 st_42;
  st_42 = (xlv_TEXCOORD0.xyz - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_43;
  tmpvar_43 = min (max (st_42, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_44;
  tmpvar_44 = abs((st_42 - tmpvar_43));
  tmpvar_41 = (tmpvar_43 - (max (
    max (tmpvar_44.x, tmpvar_44.y)
  , tmpvar_44.z) * tmpvar_4));
  mediump vec3 tmpvar_45;
  tmpvar_45 = (tmpvar_12 * tmpvar_12.zzz);
  mediump vec3 tmpvar_46;
  tmpvar_46 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_47;
  tmpvar_47 = min (max (tmpvar_46, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_48;
  tmpvar_48 = abs((tmpvar_46 - tmpvar_47));
  mediump vec4 tmpvar_49;
  tmpvar_49.xyz = (tmpvar_47 - (max (
    max (tmpvar_48.x, tmpvar_48.y)
  , tmpvar_48.z) * tmpvar_4));
  tmpvar_49.w = _Level;
  lowp vec4 tmpvar_50;
  tmpvar_50 = textureLod (_MainTex, tmpvar_49.xyz, _Level);
  mediump vec4 tmpvar_51;
  tmpvar_51 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_50);
  mediump vec3 tmpvar_52;
  tmpvar_52 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_53;
  tmpvar_53 = min (max (tmpvar_52, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_54;
  tmpvar_54 = abs((tmpvar_52 - tmpvar_53));
  mediump vec4 tmpvar_55;
  tmpvar_55.xyz = (tmpvar_53 - (max (
    max (tmpvar_54.x, tmpvar_54.y)
  , tmpvar_54.z) * tmpvar_4));
  tmpvar_55.w = _Level;
  lowp vec4 tmpvar_56;
  tmpvar_56 = textureLod (_MainTex, tmpvar_55.xyz, _Level);
  mediump vec4 tmpvar_57;
  tmpvar_57 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_56);
  mediump vec4 tmpvar_58;
  tmpvar_58.xyz = (tmpvar_41 - (0.5 * tmpvar_5));
  tmpvar_58.w = _Level;
  lowp vec4 tmpvar_59;
  tmpvar_59 = textureLod (_MainTex, tmpvar_58.xyz, _Level);
  mediump vec4 tmpvar_60;
  tmpvar_60 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_59);
  mediump vec4 tmpvar_61;
  tmpvar_61.xyz = (tmpvar_41 + (0.5 * tmpvar_5));
  tmpvar_61.w = _Level;
  lowp vec4 tmpvar_62;
  tmpvar_62 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_61.xyz, _Level));
  mediump vec3 tmpvar_63;
  tmpvar_63 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_64;
  tmpvar_64 = min (max (tmpvar_63, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_65;
  tmpvar_65 = abs((tmpvar_63 - tmpvar_64));
  mediump vec4 tmpvar_66;
  tmpvar_66.xyz = (tmpvar_64 - (max (
    max (tmpvar_65.x, tmpvar_65.y)
  , tmpvar_65.z) * tmpvar_4));
  tmpvar_66.w = _Level;
  lowp vec4 tmpvar_67;
  tmpvar_67 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_66.xyz, _Level));
  mediump vec3 tmpvar_68;
  tmpvar_68 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) - (2.5 * tmpvar_6));
  mediump vec3 tmpvar_69;
  tmpvar_69 = min (max (tmpvar_68, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_70;
  tmpvar_70 = abs((tmpvar_68 - tmpvar_69));
  mediump vec4 tmpvar_71;
  tmpvar_71.xyz = (tmpvar_69 - (max (
    max (tmpvar_70.x, tmpvar_70.y)
  , tmpvar_70.z) * tmpvar_4));
  tmpvar_71.w = _Level;
  lowp vec4 tmpvar_72;
  tmpvar_72 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_71.xyz, _Level));
  mediump vec3 tmpvar_73;
  tmpvar_73 = (tmpvar_12 * tmpvar_12.yyy);
  mediump vec3 tmpvar_74;
  tmpvar_74 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_75;
  tmpvar_75 = min (max (tmpvar_74, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_76;
  tmpvar_76 = abs((tmpvar_74 - tmpvar_75));
  mediump vec4 tmpvar_77;
  tmpvar_77.xyz = (tmpvar_75 - (max (
    max (tmpvar_76.x, tmpvar_76.y)
  , tmpvar_76.z) * tmpvar_4));
  tmpvar_77.w = _Level;
  lowp vec4 tmpvar_78;
  tmpvar_78 = textureLod (_MainTex, tmpvar_77.xyz, _Level);
  mediump vec4 tmpvar_79;
  tmpvar_79 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_78);
  mediump vec3 tmpvar_80;
  tmpvar_80 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_81;
  tmpvar_81 = min (max (tmpvar_80, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_82;
  tmpvar_82 = abs((tmpvar_80 - tmpvar_81));
  mediump vec4 tmpvar_83;
  tmpvar_83.xyz = (tmpvar_81 - (max (
    max (tmpvar_82.x, tmpvar_82.y)
  , tmpvar_82.z) * tmpvar_4));
  tmpvar_83.w = _Level;
  lowp vec4 tmpvar_84;
  tmpvar_84 = textureLod (_MainTex, tmpvar_83.xyz, _Level);
  mediump vec4 tmpvar_85;
  tmpvar_85 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_84);
  mediump vec4 tmpvar_86;
  tmpvar_86.xyz = (tmpvar_33 + (0.5 * tmpvar_5));
  tmpvar_86.w = _Level;
  lowp vec4 tmpvar_87;
  tmpvar_87 = textureLod (_MainTex, tmpvar_86.xyz, _Level);
  mediump vec4 tmpvar_88;
  tmpvar_88 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_87);
  mediump vec4 tmpvar_89;
  tmpvar_89.xyz = (tmpvar_33 - (0.5 * tmpvar_5));
  tmpvar_89.w = _Level;
  lowp vec4 tmpvar_90;
  tmpvar_90 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_89.xyz, _Level));
  mediump vec3 tmpvar_91;
  tmpvar_91 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_92;
  tmpvar_92 = min (max (tmpvar_91, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_93;
  tmpvar_93 = abs((tmpvar_91 - tmpvar_92));
  mediump vec4 tmpvar_94;
  tmpvar_94.xyz = (tmpvar_92 - (max (
    max (tmpvar_93.x, tmpvar_93.y)
  , tmpvar_93.z) * tmpvar_4));
  tmpvar_94.w = _Level;
  lowp vec4 tmpvar_95;
  tmpvar_95 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_94.xyz, _Level));
  mediump vec3 tmpvar_96;
  tmpvar_96 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) - (1.5 * tmpvar_6));
  mediump vec3 tmpvar_97;
  tmpvar_97 = min (max (tmpvar_96, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_98;
  tmpvar_98 = abs((tmpvar_96 - tmpvar_97));
  mediump vec4 tmpvar_99;
  tmpvar_99.xyz = (tmpvar_97 - (max (
    max (tmpvar_98.x, tmpvar_98.y)
  , tmpvar_98.z) * tmpvar_4));
  tmpvar_99.w = _Level;
  lowp vec4 tmpvar_100;
  tmpvar_100 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_99.xyz, _Level));
  mediump vec3 tmpvar_101;
  tmpvar_101 = (tmpvar_12 * tmpvar_12.xxx);
  mediump vec4 tmpvar_102;
  tmpvar_102.xyz = (tmpvar_25 - (0.5 * tmpvar_6));
  tmpvar_102.w = _Level;
  lowp vec4 tmpvar_103;
  tmpvar_103 = textureLod (_MainTex, tmpvar_102.xyz, _Level);
  mediump vec4 tmpvar_104;
  tmpvar_104 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_103);
  mediump vec4 tmpvar_105;
  tmpvar_105.xyz = (tmpvar_17 - (0.5 * tmpvar_6));
  tmpvar_105.w = _Level;
  lowp vec4 tmpvar_106;
  tmpvar_106 = textureLod (_MainTex, tmpvar_105.xyz, _Level);
  mediump vec4 tmpvar_107;
  tmpvar_107 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_106);
  mediump vec4 tmpvar_108;
  tmpvar_108.xyz = ((xlv_TEXCOORD0.xyz - (0.5 * tmpvar_5)) - (0.5 * tmpvar_6));
  tmpvar_108.w = _Level;
  lowp vec4 tmpvar_109;
  tmpvar_109 = textureLod (_MainTex, tmpvar_108.xyz, _Level);
  mediump vec4 tmpvar_110;
  tmpvar_110 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_109);
  mediump vec4 tmpvar_111;
  tmpvar_111.xyz = ((xlv_TEXCOORD0.xyz + (0.5 * tmpvar_5)) - (0.5 * tmpvar_6));
  tmpvar_111.w = _Level;
  lowp vec4 tmpvar_112;
  tmpvar_112 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_111.xyz, _Level));
  mediump vec4 tmpvar_113;
  tmpvar_113.xyz = (tmpvar_13 - (0.5 * tmpvar_6));
  tmpvar_113.w = _Level;
  lowp vec4 tmpvar_114;
  tmpvar_114 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_113.xyz, _Level));
  mediump vec4 tmpvar_115;
  tmpvar_115.xyz = (tmpvar_21 - (0.5 * tmpvar_6));
  tmpvar_115.w = _Level;
  lowp vec4 tmpvar_116;
  tmpvar_116 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_115.xyz, _Level));
  mediump vec3 tmpvar_117;
  tmpvar_117 = (tmpvar_12 * tmpvar_12.xxx);
  mediump vec4 tmpvar_118;
  tmpvar_118.xyz = (tmpvar_21 + (0.5 * tmpvar_6));
  tmpvar_118.w = _Level;
  lowp vec4 tmpvar_119;
  tmpvar_119 = textureLod (_MainTex, tmpvar_118.xyz, _Level);
  mediump vec4 tmpvar_120;
  tmpvar_120 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_119);
  mediump vec4 tmpvar_121;
  tmpvar_121.xyz = (tmpvar_13 + (0.5 * tmpvar_6));
  tmpvar_121.w = _Level;
  lowp vec4 tmpvar_122;
  tmpvar_122 = textureLod (_MainTex, tmpvar_121.xyz, _Level);
  mediump vec4 tmpvar_123;
  tmpvar_123 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_122);
  mediump vec4 tmpvar_124;
  tmpvar_124.xyz = ((xlv_TEXCOORD0.xyz + (0.5 * tmpvar_5)) + (0.5 * tmpvar_6));
  tmpvar_124.w = _Level;
  lowp vec4 tmpvar_125;
  tmpvar_125 = textureLod (_MainTex, tmpvar_124.xyz, _Level);
  mediump vec4 tmpvar_126;
  tmpvar_126 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_125);
  mediump vec4 tmpvar_127;
  tmpvar_127.xyz = ((xlv_TEXCOORD0.xyz - (0.5 * tmpvar_5)) + (0.5 * tmpvar_6));
  tmpvar_127.w = _Level;
  lowp vec4 tmpvar_128;
  tmpvar_128 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_127.xyz, _Level));
  mediump vec4 tmpvar_129;
  tmpvar_129.xyz = (tmpvar_17 + (0.5 * tmpvar_6));
  tmpvar_129.w = _Level;
  lowp vec4 tmpvar_130;
  tmpvar_130 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_129.xyz, _Level));
  mediump vec4 tmpvar_131;
  tmpvar_131.xyz = (tmpvar_25 + (0.5 * tmpvar_6));
  tmpvar_131.w = _Level;
  lowp vec4 tmpvar_132;
  tmpvar_132 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_131.xyz, _Level));
  mediump vec3 tmpvar_133;
  tmpvar_133 = (tmpvar_12 * tmpvar_12.yyy);
  mediump vec3 tmpvar_134;
  tmpvar_134 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_135;
  tmpvar_135 = min (max (tmpvar_134, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_136;
  tmpvar_136 = abs((tmpvar_134 - tmpvar_135));
  mediump vec4 tmpvar_137;
  tmpvar_137.xyz = (tmpvar_135 - (max (
    max (tmpvar_136.x, tmpvar_136.y)
  , tmpvar_136.z) * tmpvar_4));
  tmpvar_137.w = _Level;
  lowp vec4 tmpvar_138;
  tmpvar_138 = textureLod (_MainTex, tmpvar_137.xyz, _Level);
  mediump vec4 tmpvar_139;
  tmpvar_139 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_138);
  mediump vec3 tmpvar_140;
  tmpvar_140 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_141;
  tmpvar_141 = min (max (tmpvar_140, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_142;
  tmpvar_142 = abs((tmpvar_140 - tmpvar_141));
  mediump vec4 tmpvar_143;
  tmpvar_143.xyz = (tmpvar_141 - (max (
    max (tmpvar_142.x, tmpvar_142.y)
  , tmpvar_142.z) * tmpvar_4));
  tmpvar_143.w = _Level;
  lowp vec4 tmpvar_144;
  tmpvar_144 = textureLod (_MainTex, tmpvar_143.xyz, _Level);
  mediump vec4 tmpvar_145;
  tmpvar_145 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_144);
  mediump vec4 tmpvar_146;
  tmpvar_146.xyz = (tmpvar_29 - (0.5 * tmpvar_5));
  tmpvar_146.w = _Level;
  lowp vec4 tmpvar_147;
  tmpvar_147 = textureLod (_MainTex, tmpvar_146.xyz, _Level);
  mediump vec4 tmpvar_148;
  tmpvar_148 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_147);
  mediump vec4 tmpvar_149;
  tmpvar_149.xyz = (tmpvar_29 + (0.5 * tmpvar_5));
  tmpvar_149.w = _Level;
  lowp vec4 tmpvar_150;
  tmpvar_150 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_149.xyz, _Level));
  mediump vec3 tmpvar_151;
  tmpvar_151 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_152;
  tmpvar_152 = min (max (tmpvar_151, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_153;
  tmpvar_153 = abs((tmpvar_151 - tmpvar_152));
  mediump vec4 tmpvar_154;
  tmpvar_154.xyz = (tmpvar_152 - (max (
    max (tmpvar_153.x, tmpvar_153.y)
  , tmpvar_153.z) * tmpvar_4));
  tmpvar_154.w = _Level;
  lowp vec4 tmpvar_155;
  tmpvar_155 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_154.xyz, _Level));
  mediump vec3 tmpvar_156;
  tmpvar_156 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) + (1.5 * tmpvar_6));
  mediump vec3 tmpvar_157;
  tmpvar_157 = min (max (tmpvar_156, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_158;
  tmpvar_158 = abs((tmpvar_156 - tmpvar_157));
  mediump vec4 tmpvar_159;
  tmpvar_159.xyz = (tmpvar_157 - (max (
    max (tmpvar_158.x, tmpvar_158.y)
  , tmpvar_158.z) * tmpvar_4));
  tmpvar_159.w = _Level;
  lowp vec4 tmpvar_160;
  tmpvar_160 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_159.xyz, _Level));
  mediump vec3 tmpvar_161;
  tmpvar_161 = (tmpvar_12 * tmpvar_12.zzz);
  mediump vec3 tmpvar_162;
  tmpvar_162 = ((xlv_TEXCOORD0.xyz + (2.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_163;
  tmpvar_163 = min (max (tmpvar_162, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_164;
  tmpvar_164 = abs((tmpvar_162 - tmpvar_163));
  mediump vec4 tmpvar_165;
  tmpvar_165.xyz = (tmpvar_163 - (max (
    max (tmpvar_164.x, tmpvar_164.y)
  , tmpvar_164.z) * tmpvar_4));
  tmpvar_165.w = _Level;
  lowp vec4 tmpvar_166;
  tmpvar_166 = textureLod (_MainTex, tmpvar_165.xyz, _Level);
  mediump vec4 tmpvar_167;
  tmpvar_167 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_166);
  mediump vec3 tmpvar_168;
  tmpvar_168 = ((xlv_TEXCOORD0.xyz + (1.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_169;
  tmpvar_169 = min (max (tmpvar_168, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_170;
  tmpvar_170 = abs((tmpvar_168 - tmpvar_169));
  mediump vec4 tmpvar_171;
  tmpvar_171.xyz = (tmpvar_169 - (max (
    max (tmpvar_170.x, tmpvar_170.y)
  , tmpvar_170.z) * tmpvar_4));
  tmpvar_171.w = _Level;
  lowp vec4 tmpvar_172;
  tmpvar_172 = textureLod (_MainTex, tmpvar_171.xyz, _Level);
  mediump vec4 tmpvar_173;
  tmpvar_173 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_172);
  mediump vec4 tmpvar_174;
  tmpvar_174.xyz = (tmpvar_37 + (0.5 * tmpvar_5));
  tmpvar_174.w = _Level;
  lowp vec4 tmpvar_175;
  tmpvar_175 = textureLod (_MainTex, tmpvar_174.xyz, _Level);
  mediump vec4 tmpvar_176;
  tmpvar_176 = max (vec4(0.0, 0.0, 0.0, 0.0), tmpvar_175);
  mediump vec4 tmpvar_177;
  tmpvar_177.xyz = (tmpvar_37 - (0.5 * tmpvar_5));
  tmpvar_177.w = _Level;
  lowp vec4 tmpvar_178;
  tmpvar_178 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_177.xyz, _Level));
  mediump vec3 tmpvar_179;
  tmpvar_179 = ((xlv_TEXCOORD0.xyz - (1.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_180;
  tmpvar_180 = min (max (tmpvar_179, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_181;
  tmpvar_181 = abs((tmpvar_179 - tmpvar_180));
  mediump vec4 tmpvar_182;
  tmpvar_182.xyz = (tmpvar_180 - (max (
    max (tmpvar_181.x, tmpvar_181.y)
  , tmpvar_181.z) * tmpvar_4));
  tmpvar_182.w = _Level;
  lowp vec4 tmpvar_183;
  tmpvar_183 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_182.xyz, _Level));
  mediump vec3 tmpvar_184;
  tmpvar_184 = ((xlv_TEXCOORD0.xyz - (2.5 * tmpvar_5)) + (2.5 * tmpvar_6));
  mediump vec3 tmpvar_185;
  mediump vec3 tmpvar_186;
  tmpvar_186 = min (max (tmpvar_184, vec3(-1.0, -1.0, -1.0)), vec3(1.0, 1.0, 1.0));
  mediump vec3 tmpvar_187;
  tmpvar_187 = abs((tmpvar_184 - tmpvar_186));
  tmpvar_185 = (tmpvar_186 - (max (
    max (tmpvar_187.x, tmpvar_187.y)
  , tmpvar_187.z) * tmpvar_4));
  lowp vec4 tmpvar_188;
  tmpvar_188 = max (vec4(0.0, 0.0, 0.0, 0.0), textureLod (_MainTex, tmpvar_185, _Level));
  _glesFragData[0] = (((
    ((((
      ((((
        ((tmpvar_45.z * (tmpvar_51 + tmpvar_72)) + ((tmpvar_45.x * (tmpvar_60 + tmpvar_62)) + (tmpvar_45.y * (tmpvar_57 + tmpvar_67))))
       + 
        (tmpvar_73.z * (tmpvar_79 + tmpvar_100))
      ) + (
        (tmpvar_73.x * (tmpvar_88 + tmpvar_90))
       + 
        (tmpvar_73.y * (tmpvar_85 + tmpvar_95))
      )) + (tmpvar_101.z * (tmpvar_104 + tmpvar_116))) + ((tmpvar_101.x * (tmpvar_110 + tmpvar_112)) + (tmpvar_101.y * (tmpvar_107 + tmpvar_114))))
     + 
      (tmpvar_117.z * (tmpvar_120 + tmpvar_132))
    ) + (
      (tmpvar_117.x * (tmpvar_126 + tmpvar_128))
     + 
      (tmpvar_117.y * (tmpvar_123 + tmpvar_130))
    )) + (tmpvar_133.z * (tmpvar_139 + tmpvar_160))) + ((tmpvar_133.x * (tmpvar_148 + tmpvar_150)) + (tmpvar_133.y * (tmpvar_145 + tmpvar_155))))
   + 
    (tmpvar_161.z * (tmpvar_167 + tmpvar_188))
  ) + (
    (tmpvar_161.x * (tmpvar_176 + tmpvar_178))
   + 
    (tmpvar_161.y * (tmpvar_173 + tmpvar_183))
  )) / ((
    (((dot (tmpvar_45, vec3(2.0, 2.0, 2.0)) + dot (tmpvar_73, vec3(2.0, 2.0, 2.0))) + dot (tmpvar_101, vec3(2.0, 2.0, 2.0))) + dot (tmpvar_117, vec3(2.0, 2.0, 2.0)))
   + 
    dot (tmpvar_133, vec3(2.0, 2.0, 2.0))
  ) + dot (tmpvar_161, vec3(2.0, 2.0, 2.0))));
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
}