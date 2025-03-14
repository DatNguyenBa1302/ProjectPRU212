//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/InternalSplashShadowCaster" {
SubShader { 
 Pass {
  ZTest Always
  Cull Off
  Blend One One
  GpuProgramID 54741
Program "vp" {
}
Program "fp" {
}
 }
}
Fallback Off
}