; Level 2-1, Area 0

LevelData_2_1_Area0:
      .BYTE $80, $EC, $90, $00
      .BYTE $00, $0E
      .BYTE $14, $11
      .BYTE $12, $10
      .BYTE $1C, $10
      .BYTE $4A, $17
      .BYTE $12, $17
      .BYTE $8A, $10
      .BYTE $27, $17
      .BYTE $E2, $10
      .BYTE $14, $11
      .BYTE $4A, $07
      .BYTE $0F, $D3
      .BYTE $11, $D5
      .BYTE $0E, $D1
      .BYTE $10, $D1
      .BYTE $06, $D1
      .BYTE $0D, $D1
      .BYTE $77, $10
      .BYTE $19, $11
      .BYTE $48, $29
      .BYTE $1C, $D3
      .BYTE $12, $D1
      .BYTE $0B, $D1
      .BYTE $0F, $D1
      .BYTE $13, $D1
      .BYTE $0A, $D1
      .BYTE $B8, $26
      .BYTE $0A, $22
      .BYTE $0B, $2B
      .BYTE $0C, $22
      .BYTE $0D, $22
      .BYTE $17, $36
      .BYTE $14, $07
      .BYTE $08, $34
      .BYTE $17, $36
      .BYTE $10, $D1
      .BYTE $08, $34
      .BYTE $8E, $10
      .BYTE $39, $29
      .BYTE $37, $0F
      .BYTE $0A, $0F
      .BYTE $1D, $D2
      .BYTE $F0, $0C
      .BYTE $F6, $01
      .BYTE $93, $11
      .BYTE $47, $0F
      .BYTE $0F, $37
      .BYTE $1E, $39
      .BYTE $1D, $3B
      .BYTE $F1, $8C
      .BYTE $F6, $00
      .BYTE $89, $10
      .BYTE $10, $29
      .BYTE $05, $29
      .BYTE $1F, $29
      .BYTE $11, $33
      .BYTE $10, $35
      .BYTE $1C, $0F
      .BYTE $F2
      .BYTE $7D, $0F
      .BYTE $F0, $0C
      .BYTE $F6, $01
      .BYTE $F1, $8C
      .BYTE $F6, $00
      .BYTE $A3, $10
      .BYTE $11, $11
      .BYTE $07, $17
      .BYTE $59, $0B
IFNDEF DISABLE_DOOR_POINTERS
      .BYTE $03, $10
ENDIF
IFDEF DISABLE_DOOR_POINTERS
      .BYTE $F5, $03, $10
ENDIF
      .BYTE $FF