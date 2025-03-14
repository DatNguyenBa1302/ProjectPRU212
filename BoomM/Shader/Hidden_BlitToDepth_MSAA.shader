//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/BlitToDepth_MSAA" {
Properties {
_MainTex ("DepthTexture", any) = "" { }
}
SubShader {
 Pass {
  ColorMask 0 0
  ZTest Always
  Cull Off
  GpuProgramID 4079
}
}
}