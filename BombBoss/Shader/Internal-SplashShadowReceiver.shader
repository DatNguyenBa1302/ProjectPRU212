//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/InternalSplashShadowReceiver" {
SubShader { 
 Pass {
  Cull Off
  GpuProgramID 20110
Program "vp" {
}
Program "fp" {
}
 }
}
Fallback Off
}