//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/InternalSplashShadowBlur" {
SubShader { 
 Pass {
  ZTest Always
  Cull Off
  GpuProgramID 37455
Program "vp" {
}
Program "fp" {
}
 }
 Pass {
  ZTest Always
  Cull Off
  GpuProgramID 74124
Program "vp" {
}
Program "fp" {
}
 }
}
Fallback Off
}