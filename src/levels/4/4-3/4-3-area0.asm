; Level 4-3, Area 0

LevelData_4_3_Area0:
      .BYTE $91, $EA, $02, $11
      .BYTE $4B, $14
IFNDEF DISABLE_DOOR_POINTERS
      .BYTE $0B, $11
ENDIF
IFDEF DISABLE_DOOR_POINTERS
      .BYTE $F5, $0B, $11
ENDIF
      .BYTE $0D, $A8
      .BYTE $F0, $54
      .BYTE $F0, $D3
      .BYTE $F1, $15
      .BYTE $F1, $CA
      .BYTE $FF