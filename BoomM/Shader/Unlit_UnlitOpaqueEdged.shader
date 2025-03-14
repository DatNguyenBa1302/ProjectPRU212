//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitOpaqueEdged" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Tint ("Tint", Color) = (1,1,1,0)
_Outline ("Outline", Range(0, 0.3)) = 0.02
_OutlineColor ("Outline Color", Color) = (0,0,0,1)
_OutlineColorRatio ("Outline Color Ratio", Range(0, 1)) = 0.4
}
SubShader {
 Tags { "QUEUE" = "geometry" }
 UsePass "Unlit/Outline/VERTEXEXTENDED"
 UsePass "Unlit/UnlitOpaque/MAIN"
}
}