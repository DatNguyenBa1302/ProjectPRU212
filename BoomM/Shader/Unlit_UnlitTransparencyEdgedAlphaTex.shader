//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Unlit/UnlitTransparencyEdgedAlphaTex" {
Properties {
_MainTex ("Texture", 2D) = "white" { }
_SubTex ("Sub Texture", 2D) = "black" { }
_TeamColor ("TeamColor", Color) = (1,1,1,1)
_Overlay ("Overlay", Color) = (0,0,0,0)
_Alpha ("Alpha", Float) = 1
_Tint ("Tint", Color) = (1,1,1,0)
_DecalTex ("Decal Texture", 2D) = "black" { }
_DecalPosX ("Decal PosX", Range(-1, 1)) = 0
_DecalPosY ("Decal PosY", Range(-1, 1)) = 0
_DecalScale ("Decal Scale", Float) = 1
_Outline ("Outline", Range(0, 0.3)) = 0.02
_OutlineColor ("Outline Color", Color) = (0,0,0,1)
_OutlineColorRatio ("Outline Color Ratio", Range(0, 1)) = 0.4
}
SubShader {
 Tags { "QUEUE" = "Transparent" }
 UsePass "Unlit/Outline/VERTEXEXTENDED_TRANSPARENCY"
 UsePass "Unlit/UnlitTransparencyAlphaTex/MAIN"
}
}