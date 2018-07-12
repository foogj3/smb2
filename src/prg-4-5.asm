;
; Bank 4 & Bank 5
; ===============
;
; What's inside:
;
;   - Music engine
;   - Song data
;

; .segment BANK4
; * =  $8000

; =============== S U B R O U T I N E =======================================

StartProcessingSoundQueue:
      LDA     #$FF
      STA     JOY2
      LDA     StackArea
      CMP     #$41 ; various values otherwise
      BNE     ProcessMusicAndSfxQueues

      LDA     #%00001100 ; Mute the two square channels
      STA     SND_CHN
      ; You would think you could skip processing,
      ; since if the game is paused, nothing should
      ; be setting new music or whatever.
      ;
      ; You would be correct, except for the suicide code!
      ; That sets MusicQueue2.
      ;
      ; If not for processing it, the music would not
      ; change (or stop) when you used the code. Welp!
      JMP     ProcessOnlyMusicQueue2

; ---------------------------------------------------------------------------

ProcessMusicAndSfxQueues:
      JSR     ProcessSoundEffectQueue2

      JSR     ProcessSoundEffectQueue1

      JSR     ProcessSoundEffectQueue3

      JSR     ProcessDPCMQueue

ProcessOnlyMusicQueue2:
      JSR     ProcessMusicQueue2

      LDA     #0
      STA     SoundEffectQueue2
      STA     MusicQueue2
      STA     SoundEffectQueue1
      STA     DPCMQueue
      STA     Music1Queue
      STA     SoundEffectQueue3
      RTS

; End of function StartProcessingSoundQueue

; ---------------------------------------------------------------------------

loc_BANK4_8038:
      LDA     #$42
      LDX     #$82
      LDY     #$A8
      JSR     sub_BANK4_86C8

      LDA     #$22
      STA     byte_RAM_C4

loc_BANK4_8045:
      LDA     byte_RAM_C4
      CMP     #$20
      BNE     loc_BANK4_8051

      LDX     #$DF
      LDY     #$F6
      BNE     loc_BANK4_8059

loc_BANK4_8051:
      CMP     #$1A
      BNE     loc_BANK4_8076

      LDX     #$C1
      LDY     #$BC

loc_BANK4_8059:
      JSR     sub_BANK4_86BA

      BNE     loc_BANK4_8076

loc_BANK4_805E:
      LDA     #$35
      LDX     #$8D
      STA     byte_RAM_C4
      LDY     #$7F

loc_BANK4_8066:
      LDA     #$5E
      JSR     sub_BANK4_86C8

loc_BANK4_806B:
      LDA     byte_RAM_C4
      CMP     #$30
      BNE     loc_BANK4_8076

      LDA     #$54
      STA     SQ1_LO

loc_BANK4_8076:
      BNE     loc_BANK4_80D3

; =============== S U B R O U T I N E =======================================

ProcessSoundEffectQueue2:
      LDA     byte_RAM_60D
      CMP     #2
      BEQ     loc_BANK4_80D3

      LDY     SoundEffectQueue2

loc_BANK4_8082:
      BEQ     loc_BANK4_80A5

      STY     byte_RAM_60D
      LSR     SoundEffectQueue2
      BCS     loc_BANK4_8038

      LSR     SoundEffectQueue2
      BCS     loc_BANK4_80C3

      LSR     SoundEffectQueue2
      BCS     loc_BANK4_805E

      LSR     SoundEffectQueue2
      BCS     loc_BANK4_80E7

      LSR     SoundEffectQueue2
      BCS     loc_BANK4_80BD

      LSR     SoundEffectQueue2
      BCS     loc_BANK4_8103

loc_BANK4_80A5:
      LDA     byte_RAM_60D
      BEQ     locret_BANK4_80BC

      LSR     A
      BCS     loc_BANK4_8045

      LSR     A
      BCS     loc_BANK4_80D3

      LSR     A
      BCS     loc_BANK4_806B

      LSR     A
      BCS     loc_BANK4_80EB

      LSR     A
      BCS     loc_BANK4_80D3

      LSR     A
      BCS     loc_BANK4_8107

locret_BANK4_80BC:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_80BD:
      LDA     #$60
      LDY     #$A5
      BNE     loc_BANK4_80CA

loc_BANK4_80C3:
      STY     byte_RAM_60D
      LDA     #5
      LDY     #$9C

loc_BANK4_80CA:
      LDX     #$9E
      STA     byte_RAM_C4
      LDA     #$60
      JSR     sub_BANK4_86C8

loc_BANK4_80D3:
      DEC     byte_RAM_C4
      BNE     locret_BANK4_80E6

      LDX     #$E
      STX     SND_CHN
      LDX     #$F
      STX     SND_CHN
      LDX     #0
      STX     byte_RAM_60D

locret_BANK4_80E6:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_80E7:
      LDA     #$2F
      STA     byte_RAM_C4

loc_BANK4_80EB:
      LDA     byte_RAM_C4
      LSR     A
      BCS     loc_BANK4_8100

      LSR     A
      BCS     loc_BANK4_8100

      AND     #2
      BEQ     loc_BANK4_8100

      LDY     #$91
      LDX     #$9A
      LDA     #$68
      JSR     sub_BANK4_86C8

loc_BANK4_8100:
      JMP     loc_BANK4_80D3

; ---------------------------------------------------------------------------

loc_BANK4_8103:
      LDA     #$36
      STA     byte_RAM_C4

loc_BANK4_8107:
      LDA     byte_RAM_C4
      LSR     A
      BCS     loc_BANK4_80D3

      TAY
      LDA     MushroomSoundData-1,Y
      LDX     #$5D
      LDY     #$7F
      JSR     sub_BANK4_86C8

loc_BANK4_8117:
      JMP     loc_BANK4_80D3

; End of function ProcessSoundEffectQueue2

; ---------------------------------------------------------------------------
MushroomSoundData:
      .BYTE $6A, $74, $6A, $64, $5C, $52, $5C, $52, $4C, $44, $66, $70, $66, $60, $58, $4E
      .BYTE $58, $4E, $48, $40, $56, $60, $56, $50, $48, $3E, $48, $3E, $38, $30 ; $10

; =============== S U B R O U T I N E =======================================

ProcessSoundEffectQueue1:
      LDA     SoundEffectQueue1
      BEQ     loc_BANK4_8146

      CMP     #SoundEffect1_StopwatchTick
      BNE     loc_BANK4_814C

      LDX     byte_RAM_607
      BEQ     loc_BANK4_814C

loc_BANK4_8146:
      LDA     byte_RAM_607
      BNE     loc_BANK4_815A

      RTS

; ---------------------------------------------------------------------------

loc_BANK4_814C:
      STA     byte_RAM_607
      LDY     #0

loc_BANK4_8151:
      INY
      LSR     A
      BCC     loc_BANK4_8151

      LDA     locret_BANK4_818E,Y
      STA     byte_RAM_C1

loc_BANK4_815A:
      LDY     byte_RAM_C1
      INC     byte_RAM_C1
      LDA     SoundEffectPointers,Y
      BMI     loc_BANK4_8178

      BNE     loc_BANK4_8182

      LDX     #$90
      STX     SQ2_VOL
      LDX     #$18
      STX     SQ2_HI
      LDX     #0
      STX     SQ2_LO
      STX     byte_RAM_607
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8178:
      STA     SQ2_VOL
      LDY     byte_RAM_C1
      INC     byte_RAM_C1
      LDA     SoundEffectPointers,Y

loc_BANK4_8182:
      CMP     #$7E
      BEQ     loc_BANK4_8189

      JSR     sub_BANK4_873F

loc_BANK4_8189:
      LDA     #$7F
      STA     SQ2_SWEEP

locret_BANK4_818E:
      RTS

; End of function ProcessSoundEffectQueue1

; ---------------------------------------------------------------------------
SoundEffectPointers:
      .BYTE SoundEffect1Data_BirdoShot - SoundEffectPointers
      .BYTE SoundEffect1Data_PotionDoorBong - SoundEffectPointers
      .BYTE SoundEffect1Data_CherryGet - SoundEffectPointers
      .BYTE SoundEffect1Data_ThrowItem - SoundEffectPointers
      .BYTE SoundEffect1Data_1UP - SoundEffectPointers
      .BYTE SoundEffect1Data_EnemyHit - SoundEffectPointers
      .BYTE SoundEffect1Data_StopwatchTick - SoundEffectPointers
      .BYTE SoundEffect1Data_HawkOpen_WartBarf - SoundEffectPointers
SoundEffect1Data_PotionDoorBong:
      .BYTE $9F
      .BYTE $10, $0E, $0C, $7E, $7E, $7E
      .BYTE $10, $0E, $0C, $7E, $7E, $7E
      .BYTE $86
      .BYTE $10, $0E, $0C, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $00
SoundEffect1Data_ThrowItem:
      .BYTE $9F, $64, $7E, $7E
      .BYTE $9E, $68, $7E, $7E
      .BYTE $9D, $6A, $7E, $7E
      .BYTE $9C, $6E, $7E, $7E
      .BYTE $9B, $72, $7E, $7E
      .BYTE $9A, $76, $7E, $7E
      .BYTE $84, $78, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $00
SoundEffect1Data_BirdoShot:
      .BYTE $9F, $30, $34, $36, $38
      .BYTE $9F, $3C, $3E, $40, $42
      .BYTE $9A, $3A, $3C, $3E, $40
      .BYTE $9C, $38, $3A, $3C, $3E
      .BYTE $96, $36, $38, $3A, $3C
      .BYTE $98, $34, $36, $38, $36
      .BYTE $00
SoundEffect1Data_CherryGet:
      .BYTE $81, $56, $7E, $64, $7E, $68
      .BYTE $00
SoundEffect1Data_EnemyHit:
      .BYTE $99, $18, $1A, $18, $1C, $18, $1A
      .BYTE $9B, $18, $1C, $18, $20, $18, $22
      .BYTE $9F, $18, $3C, $24, $30, $3C, $18, $30
      .BYTE $00
SoundEffect1Data_StopwatchTick:
      .BYTE $80
      .BYTE $68, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $60, $7E, $7E
      .BYTE $64, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $56, $7E, $7E
      .BYTE $00
SoundEffect1Data_HawkOpen_WartBarf:
      .BYTE $80, $1E, $1C, $1E, $1A, $18, $16, $1C, $18, $1A, $1E, $18
      .BYTE $16, $14, $12, $14, $16, $14, $12, $2C, $2C, $2A, $2E, $2C
      .BYTE $2A, $28, $26, $28, $24, $22, $20, $1E, $1C, $1A, $18, $16
      .BYTE $14, $14, $12, $10, $0E, $0C, $0A, $08, $08, $06, $04, $02, $02
      .BYTE $00
SoundEffect1Data_1UP:
      .BYTE $81
      .BYTE $5E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $64, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $76, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $6E, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $72, $7E, $7E, $7E, $7E, $7E, $7E
      .BYTE $7C, $7E, $7E
      .BYTE $00
; ---------------------------------------------------------------------------

loc_BANK4_828E:
      LDA     #$02
      STA     byte_RAM_611

loc_BANK4_8293:
      LDA     #$1A
      STA     NOISE_VOL
      LDA     #$04
      STA     NOISE_LO
      STA     NOISE_HI
      BNE     loc_BANK4_82E8

; =============== S U B R O U T I N E =======================================

ProcessSoundEffectQueue3:
      LDY     SoundEffectQueue3
      BEQ     loc_BANK4_82B9

      STY     byte_RAM_60E
      LSR     SoundEffectQueue3
      BCS     loc_BANK4_828E

      LSR     SoundEffectQueue3
      BCS     loc_BANK4_82C6

loc_BANK4_82B4:
      LSR     SoundEffectQueue3
      BCS     loc_BANK4_82C6

loc_BANK4_82B9:
      LDA     byte_RAM_60E
      LSR     A
      BCS     loc_BANK4_8293

      LSR     A
      BCS     loc_BANK4_82CB

      LSR     A
      BCS     loc_BANK4_82CB

      RTS

; ---------------------------------------------------------------------------

loc_BANK4_82C6:
      LDA     #$7F
      STA     byte_RAM_611

loc_BANK4_82CB:
      LDY     byte_RAM_611
      LDA     ProcessMusicQueue2,Y ; @TODO ??? Uhhhhhhhhhhhhhhhhh????????
      ORA     #$C
      STA     NOISE_LO
      LDA     byte_RAM_611
      LSR     A
      LSR     A
      LSR     A
      AND     #$1F
      ORA     #$10
      STA     NOISE_VOL
      LDA     #$18
      STA     NOISE_HI

loc_BANK4_82E8:
      DEC     byte_RAM_611
      BNE     locret_BANK4_82FC

      LDX     #$07
      STX     SND_CHN
      LDX     #$0F
      STX     SND_CHN
      LDX     #$00
      STX     byte_RAM_60E

locret_BANK4_82FC:
      RTS

; End of function ProcessSoundEffectQueue3

; =============== S U B R O U T I N E =======================================

ProcessDPCMQueue:
      LDA     DPCMQueue
      BNE     loc_BANK4_8317

      LDA     byte_RAM_608
      BEQ     loc_BANK4_830C

      DEC     byte_RAM_60A
      BNE     locret_BANK4_8316

loc_BANK4_830C:
      LDA     #$00
      STA     byte_RAM_608
      LDA     #$F
      STA     SND_CHN

locret_BANK4_8316:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8317:
      STA     byte_RAM_608
      LDY     #0

loc_BANK4_831C:
      INY
      LSR     A
      BCC     loc_BANK4_831C

      LDA     DMCFreqTable-1,Y
      STA     DMC_FREQ

loc_BANK4_8326:
      LDA     DMCStartTable-1,Y
      STA     DMC_START
      LDA     DMCLengthTable-1,Y
      STA     DMC_LEN
      LDA     #$A0
      STA     byte_RAM_60A
      LDA     #$F
      STA     SND_CHN
      LDA     #$1F
      STA     SND_CHN
      RTS

; End of function ProcessDPCMQueue

; ---------------------------------------------------------------------------
DMCStartTable:
      .BYTE $4F
; @TODO
; It seems that the references to these tables are off by one byte, maybe intentionally?
; Need to fix this in the final disassembly
      .BYTE $60
      .BYTE $4B
      .BYTE $00
      .BYTE $31
      .BYTE $60
      .BYTE $0E
      .BYTE $1D
DMCLengthTable:
      .BYTE $43

      .BYTE $14
      .BYTE $10
      .BYTE $38
      .BYTE $48
      .BYTE $28
      .BYTE $3C
      .BYTE $50
DMCFreqTable:
      .BYTE $0E

      .BYTE $0E
      .BYTE $0F
      .BYTE $0F
      .BYTE $0F
      .BYTE $0F
      .BYTE $0F
      .BYTE $0F
      .BYTE $60
; ---------------------------------------------------------------------------

loc_BANK4_835B:
      JMP     loc_BANK4_8429

; ---------------------------------------------------------------------------

loc_BANK4_835E:
      JMP     StopMusic

; =============== S U B R O U T I N E =======================================

ProcessMusicQueue2:
      LDA     MusicQueue2
      BMI     loc_BANK4_835E

      CMP     #Music2_EndingAndCast
      BEQ     loc_BANK4_837D

      LDA     MusicQueue2
      BNE     loc_BANK4_83C5

      LDA     Music1Queue
      BNE     loc_BANK4_8389

      LDA     byte_RAM_606
      ORA     byte_RAM_609
      BNE     loc_BANK4_835B

      RTS

; ---------------------------------------------------------------------------

loc_BANK4_837D:
      STA     byte_RAM_606
      LDY     #0
      STY     byte_RAM_609
      LDY     #8
      BNE     loc_BANK4_8397

loc_BANK4_8389:
      STA     byte_RAM_609
      LDY     #0
      STY     byte_RAM_606
      LDY     #$FF

loc_BANK4_8393:
      INY
      LSR     A
      BCC     loc_BANK4_8393

loc_BANK4_8397:
      LDA     MusicPointersFirstPart,Y
      STA     byte_RAM_5EE
      LDA     MusicPointersEndPart,Y
      CLC
      ADC     #2
      STA     byte_RAM_5EF
      LDA     MusicPointersLoopPart,Y
      STA     byte_RAM_5F0
      LDA     byte_RAM_5EE

loc_BANK4_83AF:
      STA     byte_RAM_5EC

loc_BANK4_83B2:
      INC     byte_RAM_5EC
      LDY     byte_RAM_5EC
      CPY     byte_RAM_5EF
      BNE     loc_BANK4_83D7

      LDA     byte_RAM_5F0
      BNE     loc_BANK4_83AF

      JMP     StopMusic

; ---------------------------------------------------------------------------

loc_BANK4_83C5:
      STA     byte_RAM_606
      LDY     byte_RAM_609
      STY     byte_RAM_5F3
      LDY     #0
      STY     byte_RAM_609

loc_BANK4_83D3:
      INY
      LSR     A
      BCC     loc_BANK4_83D3

loc_BANK4_83D7:
      LDA     MusicPartPointers-1,Y
      TAY
      LDA     MusicPartPointers,Y
      STA     MusicTempoSetting
      LDA     MusicPartPointers+1,Y
      STA     CurrentMusicPointer
      LDA     MusicPartPointers+2,Y
      STA     CurrentMusicPointer+1
      LDA     MusicPartPointers+3,Y
      STA     byte_RAM_615
      LDA     MusicPartPointers+4,Y
      STA     byte_RAM_614
      LDA     MusicPartPointers+5,Y
      STA     byte_RAM_616
      STA     byte_RAM_5F5
      STA     byte_RAM_5FF
      STA     byte_RAM_5FC
      LDA     #1
      STA     byte_RAM_618
      STA     byte_RAM_61A
      STA     byte_RAM_61D
      STA     byte_RAM_61E
      STA     byte_RAM_5FA
      LDA     #0
      STA     byte_RAM_613
      STA     byte_RAM_60C
      LDA     #$B
      STA     SND_CHN
      LDA     #$F
      STA     SND_CHN

loc_BANK4_8429:
      DEC     byte_RAM_618
      BNE     loc_BANK4_84A1

      LDY     byte_RAM_613
      INC     byte_RAM_613
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_843C

      BPL     loc_BANK4_847D

      BNE     loc_BANK4_8468

loc_BANK4_843C:
      LDA     byte_RAM_609
      BNE     loc_BANK4_8462

loc_BANK4_8441:
      LDA     byte_RAM_606
      CMP     #4
      BEQ     loc_BANK4_8462

      AND     #$25
      BEQ     StopMusic

      LDA     byte_RAM_5F3
      BNE     loc_BANK4_8465

StopMusic:
      LDA     #$00 ; Pretty sure this stops the music
      STA     byte_RAM_606
      STA     byte_RAM_609
      STA     SND_CHN

loc_BANK4_845C:
      LDX     #$F
      STX     SND_CHN
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8462:
      JMP     loc_BANK4_83B2

; ---------------------------------------------------------------------------

loc_BANK4_8465:
      JMP     loc_BANK4_8389

; ---------------------------------------------------------------------------

loc_BANK4_8468:
      TAX
      AND     #$F0
      STA     byte_RAM_5F1
      TXA
      JSR     sub_BANK4_8629

      STA     byte_RAM_617
      LDY     byte_RAM_613
      INC     byte_RAM_613
      LDA     (CurrentMusicPointer),Y

loc_BANK4_847D:
      LDX     byte_RAM_607
      BNE     loc_BANK4_849B

      JSR     sub_BANK4_873F

      TAY
      BNE     loc_BANK4_848D

      LDA     byte_RAM_BF
      JMP     loc_BANK4_8495

; ---------------------------------------------------------------------------

loc_BANK4_848D:
      LDA     byte_RAM_617
      LDX     byte_RAM_BF

loc_BANK4_8492:
      JSR     sub_BANK4_8634

loc_BANK4_8495:
      STA     byte_RAM_619
      JSR     sub_BANK4_86C1

loc_BANK4_849B:
      LDA     byte_RAM_617
      STA     byte_RAM_618

loc_BANK4_84A1:
      LDX     byte_RAM_607
      BNE     loc_BANK4_84BF

      LDY     byte_RAM_619
      BEQ     loc_BANK4_84AE

      DEC     byte_RAM_619

loc_BANK4_84AE:
      LDA     byte_RAM_617
      LDX     byte_RAM_5F1
      JSR     sub_BANK4_8643

      STA     SQ2_VOL
      LDX     #$7F
      STX     SQ2_SWEEP

loc_BANK4_84BF:
      DEC     byte_RAM_61A
      BNE     loc_BANK4_8518

loc_BANK4_84C4:
      LDY     byte_RAM_614
      INC     byte_RAM_614
      LDA     (CurrentMusicPointer),Y
      BPL     loc_BANK4_84E3

      TAX
      AND     #$F0
      STA     byte_RAM_5F2
      TXA
      JSR     sub_BANK4_8629

      STA     byte_RAM_5ED
      LDY     byte_RAM_614
      INC     byte_RAM_614
      LDA     (CurrentMusicPointer),Y

loc_BANK4_84E3:
      TAY
      BNE     loc_BANK4_84F5

      LDA     #$83
      STA     SQ1_VOL
      LDA     #$94
      STA     SQ1_SWEEP
      STA     byte_RAM_60C
      BNE     loc_BANK4_84C4

loc_BANK4_84F5:
      LDY     byte_RAM_60D
      BNE     loc_BANK4_8512

      JSR     sub_BANK4_86CE

      BNE     loc_BANK4_8504

loc_BANK4_84FF:
      LDA     byte_RAM_BF
      JMP     loc_BANK4_850C

; ---------------------------------------------------------------------------

loc_BANK4_8504:
      LDA     byte_RAM_5ED
      LDX     byte_RAM_C0
      JSR     sub_BANK4_8634

loc_BANK4_850C:
      STA     byte_RAM_61B
      JSR     sub_BANK4_86BA

loc_BANK4_8512:
      LDA     byte_RAM_5ED
      STA     byte_RAM_61A

loc_BANK4_8518:
      LDA     byte_RAM_60D
      BNE     loc_BANK4_853B

      LDY     byte_RAM_61B
      BEQ     loc_BANK4_8525

      DEC     byte_RAM_61B

loc_BANK4_8525:
      LDA     byte_RAM_5ED
      LDX     byte_RAM_5F2
      JSR     sub_BANK4_8643

      STA     SQ1_VOL
      LDA     byte_RAM_60C
      BNE     loc_BANK4_8538

      LDA     #$7F

loc_BANK4_8538:
      STA     SQ1_SWEEP

loc_BANK4_853B:
      LDA     byte_RAM_615
      BEQ     loc_BANK4_8585

      DEC     byte_RAM_61D
      BNE     loc_BANK4_8585

      LDY     byte_RAM_615
      INC     byte_RAM_615
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_8582

      BPL     loc_BANK4_8566

      JSR     sub_BANK4_8629

      STA     byte_RAM_61C
      LDA     #$1F
      STA     TRI_LINEAR
      LDY     byte_RAM_615
      INC     byte_RAM_615
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_8582

loc_BANK4_8566:
      JSR     loc_BANK4_8743

      LDX     byte_RAM_61C
      STX     byte_RAM_61D
      TXA
      CMP     #$A
      BCC     loc_BANK4_857C

      CMP     #$1E

loc_BANK4_8576:
      BCS     loc_BANK4_8580

      LDA     #$24
      BNE     loc_BANK4_8582

loc_BANK4_857C:
      LDA     #$18

loc_BANK4_857E:
      BNE     loc_BANK4_8582

loc_BANK4_8580:
      LDA     #$6F

loc_BANK4_8582:
      STA     TRI_LINEAR

loc_BANK4_8585:
      LDA     byte_RAM_609
      AND     #$14
      BNE     loc_BANK4_85E0

      LDA     byte_RAM_616
      BEQ     loc_BANK4_85CC

      DEC     byte_RAM_61E
      BNE     loc_BANK4_85CC

loc_BANK4_8596:
      LDY     byte_RAM_616
      INC     byte_RAM_616
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_85CF

      BPL     loc_BANK4_85B2

      JSR     sub_BANK4_8629

      STA     byte_RAM_61F
      LDY     byte_RAM_616
      INC     byte_RAM_616
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_85CF

loc_BANK4_85B2:
      LSR     A
      TAY
      LDA     NoiseVolTable,Y
      STA     NOISE_VOL
      LDA     NoiseLoTable,Y
      STA     NOISE_LO
      LDA     NoiseHiTable,Y
      STA     NOISE_HI
      LDA     byte_RAM_61F
      STA     byte_RAM_61E

loc_BANK4_85CC:
      JMP     loc_BANK4_85D8

; ---------------------------------------------------------------------------

loc_BANK4_85CF:
      LDA     byte_RAM_5F5
      STA     byte_RAM_616
      JMP     loc_BANK4_8596

; ---------------------------------------------------------------------------

loc_BANK4_85D8:
      LDA     byte_RAM_609
      AND     #$14
      BNE     loc_BANK4_85E0

      RTS

; ---------------------------------------------------------------------------

loc_BANK4_85E0:
      LDA     byte_RAM_5FF
      BEQ     locret_BANK4_8613

      DEC     byte_RAM_5FA
      BNE     locret_BANK4_8613

loc_BANK4_85EA:
      LDY     byte_RAM_5FF
      INC     byte_RAM_5FF
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_8614

      BPL     loc_BANK4_8606

      JSR     sub_BANK4_8629

      STA     byte_RAM_5FB
      LDY     byte_RAM_5FF
      INC     byte_RAM_5FF
      LDA     (CurrentMusicPointer),Y
      BEQ     loc_BANK4_8614

loc_BANK4_8606:
      ASL     A
      STA     DPCMQueue
      JSR     ProcessDPCMQueue

      LDA     byte_RAM_5FB
      STA     byte_RAM_5FA

locret_BANK4_8613:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8614:
      LDA     byte_RAM_5FC
      STA     byte_RAM_5FF
      JMP     loc_BANK4_85EA

; End of function ProcessMusicQueue2

; ---------------------------------------------------------------------------
NoiseVolTable:
      .BYTE $10,$1E,$1F,$16
NoiseLoTable:
      .BYTE $00,$03,$0A,2
NoiseHiTable:
      .BYTE $00,$18,$18,$58 ; =============== S U B R O U T I N E =======================================

sub_BANK4_8629:
      AND     #$F
      CLC
      ADC     MusicTempoSetting
      TAY
      LDA     NoteLengthTable,Y
      RTS

; End of function sub_BANK4_8629

; =============== S U B R O U T I N E =======================================

sub_BANK4_8634:
      CMP     #$13
      BCC     loc_BANK4_863C

      LDA     #$3F
      BNE     loc_BANK4_863E

loc_BANK4_863C:
      LDA     #$16

loc_BANK4_863E:
      LDX     #$82
      LDY     #$7F
      RTS

; End of function sub_BANK4_8634

; =============== S U B R O U T I N E =======================================

sub_BANK4_8643:
      CPX     #$90
      BEQ     loc_BANK4_866C

      CPX     #$E0
      BEQ     loc_BANK4_866C

      CPX     #$A0
      BEQ     loc_BANK4_8679

      CPX     #$B0
      BEQ     loc_BANK4_8686

      CPX     #$C0
      BEQ     loc_BANK4_8693

      CPX     #$D0
      BEQ     loc_BANK4_86AD

      CPX     #$F0
      BEQ     loc_BANK4_86A0

      CMP     #$13
      BCC     loc_BANK4_8668

      LDA     byte_BANK5_A18D,Y
      BNE     locret_BANK4_866B

loc_BANK4_8668:
      LDA     byte_BANK5_A1CD,Y

locret_BANK4_866B:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_866C:
      CMP     #$13
      BCC     loc_BANK4_8675

      LDA     byte_BANK5_A1E4,Y
      BNE     locret_BANK4_8678

loc_BANK4_8675:
      LDA     byte_BANK5_A224,Y

locret_BANK4_8678:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8679:
      CMP     #$13
      BCC     loc_BANK4_8682

      LDA     byte_BANK5_A23B,Y
      BNE     locret_BANK4_8685

loc_BANK4_8682:
      LDA     byte_BANK5_A27B,Y

locret_BANK4_8685:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8686:
      CMP     #$13
      BCC     loc_BANK4_868F

      LDA     byte_BANK5_A293,Y
      BNE     locret_BANK4_8692

loc_BANK4_868F:
      LDA     byte_BANK5_A2D3,Y

locret_BANK4_8692:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8693:
      CMP     #$13
      BCC     loc_BANK4_869C

      LDA     byte_BANK5_A301,Y
      BNE     locret_BANK4_869F

loc_BANK4_869C:
      LDA     byte_BANK5_A2EA,Y

locret_BANK4_869F:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_86A0:
      CMP     #$13
      BCC     loc_BANK4_86A9

      LDA     byte_BANK5_A3AF,Y
      BNE     locret_BANK4_86AC

loc_BANK4_86A9:
      LDA     byte_BANK5_A398,Y

locret_BANK4_86AC:
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_86AD:
      CMP     #$13
      BCC     loc_BANK4_86B6

      LDA     unk_BANK5_A341,Y
      BNE     locret_BANK4_86B9

loc_BANK4_86B6:
      LDA     unk_BANK5_A381,Y

locret_BANK4_86B9:
      RTS

; End of function sub_BANK4_8643

; =============== S U B R O U T I N E =======================================

sub_BANK4_86BA:
      STY     SQ1_SWEEP
      STX     SQ1_VOL
      RTS

; End of function sub_BANK4_86BA

; =============== S U B R O U T I N E =======================================

sub_BANK4_86C1:
      STX     SQ2_VOL
      STY     SQ2_SWEEP
      RTS

; End of function sub_BANK4_86C1

; =============== S U B R O U T I N E =======================================

sub_BANK4_86C8:
      STX     SQ1_VOL
      STY     SQ1_SWEEP

; End of function sub_BANK4_86C8

; =============== S U B R O U T I N E =======================================

sub_BANK4_86CE:
      LDX     #$00

loc_BANK4_86D0:
      CMP     #$7E
      BNE     loc_BANK4_86DC

      LDA     #$10
      STA     SQ1_VOL,X
      LDA     #$00
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_86DC:
      LDY     #$01
      STY     NextOctave
      PHA
      TAY
      BMI     loc_BANK4_86ED

loc_BANK4_86E5:
      INC     NextOctave
      SEC
      SBC     #$18
      BPL     loc_BANK4_86E5

loc_BANK4_86ED:
      CLC
      ADC     #$18
      TAY
      LDA     NoteFrequencyData,Y
      STA     NextFrequencyLo
      LDA     NoteFrequencyData+1,Y
      STA     NextFrequencyHi

loc_BANK4_86FB:
      LSR     NextFrequencyHi
      ROR     NextFrequencyLo
      DEC     NextOctave
      BNE     loc_BANK4_86FB

      PLA
      CMP     #$38
      BCC     loc_BANK4_870B

      DEC     NextFrequencyLo

loc_BANK4_870B:
      TXA

loc_BANK4_870C:
      CMP     #4
      BNE     loc_BANK4_8717

      LDA     byte_RAM_5F2
      CMP     #$E0
      BEQ     loc_BANK4_8727

loc_BANK4_8717:
      LDA     NextFrequencyLo
      STA     SQ1_LO,X
      STA     unk_RAM_5F9,X
      LDA     NextFrequencyHi
      ORA     #8
      STA     SQ1_HI,X
      RTS

; ---------------------------------------------------------------------------

loc_BANK4_8727:
      LDA     NextFrequencyLo
      SEC
      SBC     #2
      STA     SQ2_LO
      STA     byte_RAM_C2
      LDA     NextFrequencyHi
      ORA     #8
      STA     SQ2_HI
      RTS

; End of function sub_BANK4_86CE

; ---------------------------------------------------------------------------
      STX     SQ2_VOL
      STY     SQ2_SWEEP

; =============== S U B R O U T I N E =======================================

sub_BANK4_873F:
      LDX     #4
      BNE     loc_BANK4_86D0

; End of function sub_BANK4_873F

loc_BANK4_8743:
      LDX     #8
      BNE     loc_BANK4_86D0

; ---------------------------------------------------------------------------
NoteFrequencyData:
      .WORD $1AB8 ; C
      .WORD $1938 ; C# / Db
      .WORD $17CC ; D
      .WORD $1678 ; D# / Eb
      .WORD $1534 ; E
      .WORD $1404 ; F
      .WORD $12E4 ; F# / Gb
      .WORD $11D4 ; G
      .WORD $10D4 ; G# / Ab
      .WORD $0FE0 ; A
      .WORD $0EFC ; A# / Bb
      .WORD $0E24 ; B

IFDEF PRESERVE_UNUSED_SPACE
; Unused space in the original
; $875F - $8EFF
ENDIF
; @TODO
; Music pointers are not currently defined and labeled yet,
; so we have to keep proper alignment
      .pad $8F00, $FF


; [000007A1 BYTES: END OF AREA UNUSED-BANK4:875F. PRESS KEYPAD "-" TO COLLAPSE]
NoteLengthTable:
      .BYTE $03, $03, $04, $04, $06, $09, $08, $08, $0C, $12, $18, $24, $30, $03, $04, $05
      .BYTE $04, $07, $0A, $09, $0A, $0E, $15, $1C, $2A, $38, $0B, $04, $04, $05, $06, $08 ; $10
      .BYTE $0C, $0B, $0A, $10, $18, $20, $30, $40, $04, $05, $06, $06, $09, $0D, $0C, $0C ; $20
      .BYTE $12, $1B, $24, $36, $48, $0E, $03, $05, $05, $07, $06, $0A, $0F, $0D, $0E, $14 ; $30
      .BYTE $1E, $28, $3C, $50, $05, $06, $07, $08, $0B, $10, $0F, $0E, $16, $21, $2C, $42 ; $40
      .BYTE $58, $11, $06, $06, $08, $08, $0C, $12, $10, $10, $18, $24, $30, $48, $60, $02 ; $50
      .BYTE $06, $07, $09, $08, $0D, $13, $11, $12, $1A, $27, $34, $4E, $68, $14, $07, $07 ; $60
      .BYTE $09, $0A, $0E, $15, $13, $12, $1C, $2A, $38, $54, $70, $03, $04, $07, $08, $0A ; $70
      .BYTE $0A, $0F, $16, $14, $14, $1E, $2D, $3C, $5A, $78, $17, $08, $08, $0B, $0A, $10 ; $80
      .BYTE $18, $15, $16, $20, $30, $40, $60, $80, $08, $09, $0B, $0C, $11, $19, $15, $16 ; $90
      .BYTE $22, $33, $44, $60, $88, $1A, $09, $09, $0C, $0C, $12, $1B, $18, $18, $24, $36 ; $A0
      .BYTE $48, $6C, $90 ; $B0
IFDEF PRESERVE_UNUSED_SPACE
      ; Unused space in the original
      ; $8FB3 - $8FFF
ENDIF
      ; @TODO
      ; Music pointers are not currently defined and labeled yet,
      ; so we have to keep proper alignment
      .pad $9000, $FF


MusicPartPointers:
      ; Mushroom
      .BYTE MusicHeaderMushroomBonusChance - MusicPartPointers
      ; Boss beaten
      .BYTE MusicHeaderBossBeaten - MusicPartPointers
      ; Crystal fanfare (not sure where this one is used)
      .BYTE MusicHeaderCrystal - MusicPartPointers
      ; Death / Lose
      .BYTE MusicHeaderDeath - MusicPartPointers
      ; Game Over
      .BYTE MusicHeaderGameOver - MusicPartPointers
      ; Crystal fanfare
      .BYTE MusicHeaderCrystal - MusicPartPointers
      ; Bonus chance
      .BYTE MusicHeaderMushroomBonusChance - MusicPartPointers
      ; Character select
      .BYTE $2A
      .BYTE $30
      .BYTE $36
      .BYTE $30
      .BYTE $3C
      .BYTE $42
      .BYTE $A9
      .BYTE $9E
      .BYTE $93
      ; Overworld
      .BYTE $48
      .BYTE $4E
      .BYTE $54
      .BYTE $5A
      .BYTE $54
      .BYTE $60
      .BYTE $66
      ; Boss
      .BYTE MusicHeaderBoss - MusicPartPointers
      ; Star
      .BYTE MusicHeaderStar - MusicPartPointers
      ; Wart
      .BYTE MusicHeaderWart - MusicPartPointers
      ; Title screen
      .BYTE MusicHeaderTitleScreen1 - MusicPartPointers
      .BYTE MusicHeaderTitleScreen2 - MusicPartPointers
      .BYTE MusicHeaderTitleScreen3 - MusicPartPointers
      .BYTE MusicHeaderTitleScreen4 - MusicPartPointers
      ; Subspace
      .BYTE MusicHeaderSubspace1 - MusicPartPointers
      .BYTE MusicHeaderSubspace2 - MusicPartPointers
      .BYTE MusicHeaderSubspace3 - MusicPartPointers
      .BYTE MusicHeaderSubspace2 - MusicPartPointers
      .BYTE MusicHeaderSubspace4 - MusicPartPointers
      ; Ending
      .BYTE MusicHeaderEnding1 - MusicPartPointers
      .BYTE MusicHeaderEnding2 - MusicPartPointers
      .BYTE MusicHeaderEnding3 - MusicPartPointers
      .BYTE MusicHeaderEnding4 - MusicPartPointers
      .BYTE MusicHeaderEnding5 - MusicPartPointers
      .BYTE MusicHeaderEnding6 - MusicPartPointers
      ; Underground
      .BYTE MusicHeaderUnderground - MusicPartPointers

MusicPartHeaders:
MusicHeaderCharacterSelect1:
      .BYTE $00, $AD, $98, $6B, $36, $A0
MusicHeaderCharacterSelect2:
      .BYTE $00, $5C, $99, $8E, $48, $B0
MusicHeaderCharacterSelect3:
      .BYTE $00, $9A, $99, $6F, $48, $76
MusicHeaderCharacterSelect4:
      .BYTE $00, $9E, $99, $6B, $47, $72
MusicHeaderCharacterSelect5:
      .BYTE $00, $26, $9A, $8A, $46, $AC
MusicHeaderOverworld1:
      .BYTE $28, $D4, $9B, $2B, $16, $3D
MusicHeaderOverworld2:
      .BYTE $28, $20, $9C, $A8, $54, $C9
MusicHeaderOverworld3:
      .BYTE $28, $F9, $9C, $DD, $73, $6C
MusicHeaderOverworld4:
      .BYTE $28, $3F, $9D, $B2, $73, $26
MusicHeaderOverworld5:
      .BYTE $28, $00, $9E, $38, $1D, $46
MusicHeaderOverworld6:
      .BYTE $28, $4D, $9E, $A7, $4F, $C8
MusicHeaderUnderground:
      .BYTE $6E, $BD, $94, $53, $2A, $84
MusicHeaderBoss:
      .BYTE $28, $1C, $9F, $83, $42, $00
MusicHeaderStar:
      .BYTE $00, $69, $94, $37, $1A, $49
MusicHeaderWart:
      .BYTE $28, $C7, $9F, $96, $4B, $00
MusicHeaderCrystal:
      .BYTE $00, $48, $A1, $1B, $0D
MusicHeaderGameOver:
      .BYTE $00, $CE, $A0, $1B, $0E
MusicHeaderBossBeaten:
      .BYTE $00, $F2, $A0, $41, $27
MusicHeaderCharacterSelect8:
      .BYTE $00, $93, $9B, $2F, $21, $38
MusicHeaderMushroomBonusChance:
      .BYTE $52, $BB, $A0, $00, $0A
MusicHeaderCharacterSelect7:
      .BYTE $00, $DF, $9A, $97, $61, $B0
MusicHeaderDeath:
      .BYTE $28, $6F, $A1, $17, $0C
MusicHeaderCharacterSelect6:
      .BYTE $00, $5D, $9A, $6C, $45, $79
MusicHeaderTitleScreen2:
      .BYTE $1B, $A7, $96, $BC, $64, $59
MusicHeaderTitleScreen1:
      .BYTE $1B, $3E, $96, $43, $22, $57
MusicHeaderTitleScreen3:
      .BYTE $1B, $94, $97, $8D, $47, $BA
MusicHeaderTitleScreen4:
      .BYTE $1B, $78, $98, $24, $12, $29
MusicHeaderSubspace1:
      .BYTE $28, $50, $95, $38, $1C, $83
MusicHeaderSubspace2:
      .BYTE $28, $A3, $95, $24, $12, $30
MusicHeaderSubspace3:
      .BYTE $28, $E0, $95, $22, $10, $51
MusicHeaderSubspace4:
      .BYTE $28, $0F, $96, $17, $0A, $22
MusicHeaderEnding1:
      .BYTE $6E, $1E, $91, $3D, $1F, $6D
MusicHeaderEnding3:
      .BYTE $6E, $9C, $91, $41, $21, $8C
MusicHeaderEnding2:
      .BYTE $6E, $80, $92, $2A, $5A, $19
MusicHeaderEnding5:
      .BYTE $6E, $F2, $92, $4C, $14, $68
MusicHeaderEnding4:
      .BYTE $6E, $0D, $92, $43, $29, $1B
MusicHeaderEnding6:
      .BYTE $6E, $76, $93, $00, $72, $00

MusicPointersFirstPart:
      .BYTE $10
      .BYTE $07
      .BYTE $29
      .BYTE $17
      .BYTE $18
      .BYTE $1E
      .BYTE $19
      .BYTE $1A
      .BYTE $23

MusicPointersEndPart:
      .BYTE $16
      .BYTE $0F
      .BYTE $29
      .BYTE $17
      .BYTE $18
      .BYTE $22
      .BYTE $19
      .BYTE $1D
      .BYTE $28

MusicPointersLoopPart:
      .BYTE $11
      .BYTE $08
      .BYTE $29
      .BYTE $17
      .BYTE $18
      .BYTE $1E
      .BYTE $19
      .BYTE $00
      .BYTE $28

MusicData:
      .BYTE $8A
      .BYTE $50
      .BYTE $84
      .BYTE $7E
      .BYTE $52
      .BYTE $50
      .BYTE $48
      .BYTE $82
      .BYTE $4C
      .BYTE $7E
      .BYTE $83
      .BYTE $50
      .BYTE $8A
      .BYTE $52
      .BYTE $88
      .BYTE $4C
      .BYTE $8A
      .BYTE $56
      .BYTE $82
      .BYTE $7E
      .BYTE $7E
      .BYTE $52
      .BYTE $52
      .BYTE $83
      .BYTE $50
      .BYTE $4C
      .BYTE $8B
      .BYTE $50
      .BYTE $88
      .BYTE $4C
      .BYTE $00
      .BYTE $8A
      .BYTE $3E
      .BYTE $84
      .BYTE $7E
      .BYTE $42
      .BYTE $3E
      .BYTE $38
      .BYTE $82
      .BYTE $3A
      .BYTE $7E
      .BYTE $83
      .BYTE $3E
      .BYTE $8A
      .BYTE $44
      .BYTE $88
      .BYTE $3A
      .BYTE $8A
      .BYTE $44
      .BYTE $82
      .BYTE $7E
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $83
      .BYTE $3E
      .BYTE $3A
      .BYTE $8B
      .BYTE $3E
      .BYTE $88
      .BYTE $3A
      .BYTE $88
      .BYTE $30
      .BYTE $82
      .BYTE $30
      .BYTE $30
      .BYTE $83
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $88
      .BYTE $30
      .BYTE $82
      .BYTE $30
      .BYTE $30
      .BYTE $83
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $88
      .BYTE $30
      .BYTE $82
      .BYTE $30
      .BYTE $30
      .BYTE $83
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $88
      .BYTE $30
      .BYTE $82
      .BYTE $30
      .BYTE $30
      .BYTE $83
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $2E
      .BYTE $2E
      .BYTE $88
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $83
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $00
      .BYTE $8A
      .BYTE $50
      .BYTE $84
      .BYTE $7E
      .BYTE $52
      .BYTE $50
      .BYTE $48
      .BYTE $82
      .BYTE $4C
      .BYTE $7E
      .BYTE $83
      .BYTE $4C
      .BYTE $8A
      .BYTE $56
      .BYTE $88
      .BYTE $3E
      .BYTE $8A
      .BYTE $4C
      .BYTE $84
      .BYTE $7E
      .BYTE $4E
      .BYTE $4C
      .BYTE $44
      .BYTE $82
      .BYTE $48
      .BYTE $7E
      .BYTE $83
      .BYTE $48
      .BYTE $8A
      .BYTE $52
      .BYTE $88
      .BYTE $3A
      .BYTE $00
      .BYTE $8A
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $48
      .BYTE $48
      .BYTE $3E
      .BYTE $82
      .BYTE $46
      .BYTE $7E
      .BYTE $83
      .BYTE $46
      .BYTE $8A
      .BYTE $4C
      .BYTE $88
      .BYTE $34
      .BYTE $8A
      .BYTE $44
      .BYTE $84
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $3A
      .BYTE $82
      .BYTE $42
      .BYTE $7E
      .BYTE $83
      .BYTE $42
      .BYTE $8A
      .BYTE $48
      .BYTE $88
      .BYTE $30
      .BYTE $88
      .BYTE $30
      .BYTE $82
      .BYTE $30
      .BYTE $30
      .BYTE $83
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $88
      .BYTE $2E
      .BYTE $82
      .BYTE $2E
      .BYTE $2E
      .BYTE $83
      .BYTE $2E
      .BYTE $84
      .BYTE $2E
      .BYTE $2E
      .BYTE $2E
      .BYTE $2E
      .BYTE $88
      .BYTE $2C
      .BYTE $82
      .BYTE $2C
      .BYTE $2C
      .BYTE $83
      .BYTE $2C
      .BYTE $84
      .BYTE $2C
      .BYTE $2C
      .BYTE $2C
      .BYTE $2C
      .BYTE $88
      .BYTE $2A
      .BYTE $82
      .BYTE $2A
      .BYTE $2A
      .BYTE $83
      .BYTE $2A
      .BYTE $84
      .BYTE $2A
      .BYTE $2A
      .BYTE $2A
      .BYTE $2A
      .BYTE $8A
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $48
      .BYTE $4C
      .BYTE $52
      .BYTE $8A
      .BYTE $50
      .BYTE $88
      .BYTE $48
      .BYTE $3E
      .BYTE $8A
      .BYTE $42
      .BYTE $84
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $8A
      .BYTE $42
      .BYTE $84
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $50
      .BYTE $00
      .BYTE $88
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $10
      .BYTE $83
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $10
      .BYTE $10
      .BYTE $00
      .BYTE $8A
      .BYTE $40
      .BYTE $84
      .BYTE $7E
      .BYTE $40
      .BYTE $40
      .BYTE $48
      .BYTE $8A
      .BYTE $48
      .BYTE $88
      .BYTE $3E
      .BYTE $38
      .BYTE $8A
      .BYTE $3A
      .BYTE $84
      .BYTE $7E
      .BYTE $3A
      .BYTE $3A
      .BYTE $42
      .BYTE $8A
      .BYTE $3A
      .BYTE $84
      .BYTE $7E
      .BYTE $3A
      .BYTE $3A
      .BYTE $3A
      .BYTE $88
      .BYTE $28
      .BYTE $82
      .BYTE $28
      .BYTE $28
      .BYTE $83
      .BYTE $28
      .BYTE $84
      .BYTE $28
      .BYTE $28
      .BYTE $28
      .BYTE $28
      .BYTE $88
      .BYTE $26
      .BYTE $82
      .BYTE $26
      .BYTE $26
      .BYTE $83
      .BYTE $26
      .BYTE $84
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $88
      .BYTE $34
      .BYTE $82
      .BYTE $34
      .BYTE $34
      .BYTE $83
      .BYTE $34
      .BYTE $84
      .BYTE $34
      .BYTE $34
      .BYTE $34
      .BYTE $34
      .BYTE $88
      .BYTE $26
      .BYTE $82
      .BYTE $26
      .BYTE $26
      .BYTE $83
      .BYTE $26
      .BYTE $84
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $8A
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $46
      .BYTE $48
      .BYTE $4C
      .BYTE $8A
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $46
      .BYTE $48
      .BYTE $4C
      .BYTE $8A
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $42
      .BYTE $48
      .BYTE $4C
      .BYTE $8A
      .BYTE $56
      .BYTE $7E
      .BYTE $00
      .BYTE $88
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $83
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $00
      .BYTE $88
      .BYTE $2A
      .BYTE $82
      .BYTE $2A
      .BYTE $2A
      .BYTE $83
      .BYTE $2A
      .BYTE $84
      .BYTE $28
      .BYTE $28
      .BYTE $28
      .BYTE $28
      .BYTE $88
      .BYTE $26
      .BYTE $82
      .BYTE $26
      .BYTE $26
      .BYTE $83
      .BYTE $26
      .BYTE $84
      .BYTE $24
      .BYTE $24
      .BYTE $24
      .BYTE $24
      .BYTE $88
      .BYTE $22
      .BYTE $82
      .BYTE $22
      .BYTE $22
      .BYTE $83
      .BYTE $22
      .BYTE $84
      .BYTE $22
      .BYTE $22
      .BYTE $22
      .BYTE $22
      .BYTE $88
      .BYTE $26
      .BYTE $82
      .BYTE $26
      .BYTE $26
      .BYTE $83
      .BYTE $26
      .BYTE $84
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $8A
      .BYTE $38
      .BYTE $84
      .BYTE $7E
      .BYTE $3A
      .BYTE $3A
      .BYTE $3A
      .BYTE $8A
      .BYTE $38
      .BYTE $84
      .BYTE $7E
      .BYTE $36
      .BYTE $36
      .BYTE $36
      .BYTE $8A
      .BYTE $34
      .BYTE $84
      .BYTE $7E
      .BYTE $30
      .BYTE $3A
      .BYTE $3A
      .BYTE $8A
      .BYTE $48
      .BYTE $46
      .BYTE $8A
      .BYTE $48
      .BYTE $48
      .BYTE $88
      .BYTE $48
      .BYTE $84
      .BYTE $26
      .BYTE $26
      .BYTE $26
      .BYTE $8A
      .BYTE $26
      .BYTE $7E
      .BYTE $8C
      .BYTE $7E
      .BYTE $88
      .BYTE $7E
      .BYTE $FC
      .BYTE $7E
      .BYTE $7E
      .BYTE $00
      .BYTE $88
      .BYTE $40
      .BYTE $82
      .BYTE $40
      .BYTE $40
      .BYTE $83
      .BYTE $40
      .BYTE $88
      .BYTE $3A
      .BYTE $82
      .BYTE $3A
      .BYTE $3A
      .BYTE $83
      .BYTE $3A
      .BYTE $88
      .BYTE $38
      .BYTE $84
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $88
      .BYTE $18
      .BYTE $F4
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $42
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $F4
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $42
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $88
      .BYTE $28
      .BYTE $82
      .BYTE $28
      .BYTE $28
      .BYTE $83
      .BYTE $28
      .BYTE $88
      .BYTE $2C
      .BYTE $82
      .BYTE $2C
      .BYTE $2C
      .BYTE $83
      .BYTE $2C
      .BYTE $88
      .BYTE $30
      .BYTE $84
      .BYTE $30
      .BYTE $30
      .BYTE $30
      .BYTE $8A
      .BYTE $30
      .BYTE $7E
      .BYTE $8C
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $88
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $10
      .BYTE $83
      .BYTE $10
      .BYTE $88
      .BYTE $10
      .BYTE $82
      .BYTE $10
      .BYTE $10
      .BYTE $83
      .BYTE $10
      .BYTE $88
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $10
      .BYTE $10
      .BYTE $8A
      .BYTE $10
      .BYTE $01
      .BYTE $8C
      .BYTE $01
      .BYTE $01
      .BYTE $01
      .BYTE $01
      .BYTE $F4
      .BYTE $68
      .BYTE $6A
      .BYTE $6E
      .BYTE $64
      .BYTE $7E
      .BYTE $64
      .BYTE $7E
      .BYTE $64
      .BYTE $60
      .BYTE $64
      .BYTE $68
      .BYTE $5E
      .BYTE $7E
      .BYTE $5E
      .BYTE $7E
      .BYTE $56
      .BYTE $5A
      .BYTE $5E
      .BYTE $60
      .BYTE $56
      .BYTE $7E
      .BYTE $56
      .BYTE $54
      .BYTE $56
      .BYTE $5A
      .BYTE $5E
      .BYTE $60
      .BYTE $5E
      .BYTE $7E
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $68
      .BYTE $6A
      .BYTE $6E
      .BYTE $64
      .BYTE $7E
      .BYTE $64
      .BYTE $6E
      .BYTE $76
      .BYTE $78
      .BYTE $7C
      .BYTE $78
      .BYTE $76
      .BYTE $7E
      .BYTE $72
      .BYTE $6E
      .BYTE $6A
      .BYTE $68
      .BYTE $6A
      .BYTE $6E
      .BYTE $64
      .BYTE $7E
      .BYTE $64
      .BYTE $60
      .BYTE $5E
      .BYTE $60
      .BYTE $7E
      .BYTE $FB
      .BYTE $7E
      .BYTE $F4
      .BYTE $60
      .BYTE $64
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $66
      .BYTE $6A
      .BYTE $6E
      .BYTE $FC
      .BYTE $7E
      .BYTE $F4
      .BYTE $60
      .BYTE $64
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $66
      .BYTE $7E
      .BYTE $6A
      .BYTE $6E
      .BYTE $7E
      .BYTE $FB
      .BYTE $7E
      .BYTE $F4
      .BYTE $60
      .BYTE $64
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $66
      .BYTE $6A
      .BYTE $6E
      .BYTE $7E
      .BYTE $68
      .BYTE $60
      .BYTE $56
      .BYTE $FA
      .BYTE $7E
      .BYTE $F4
      .BYTE $60
      .BYTE $64
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $5A
      .BYTE $5E
      .BYTE $60
      .BYTE $64
      .BYTE $7E
      .BYTE $8B
      .BYTE $7E
      .BYTE $00
      .BYTE $F4
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $42
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $3E
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $3A
      .BYTE $52
      .BYTE $48
      .BYTE $52
      .BYTE $38
      .BYTE $50
      .BYTE $46
      .BYTE $50
      .BYTE $34
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $3E
      .BYTE $52
      .BYTE $46
      .BYTE $52
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $44
      .BYTE $52
      .BYTE $4C
      .BYTE $52
      .BYTE $42
      .BYTE $52
      .BYTE $48
      .BYTE $52
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $3E
      .BYTE $4C
      .BYTE $46
      .BYTE $4C
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $48
      .BYTE $56
      .BYTE $50
      .BYTE $56
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $40
      .BYTE $4E
      .BYTE $48
      .BYTE $4E
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $48
      .BYTE $50
      .BYTE $3C
      .BYTE $4C
      .BYTE $48
      .BYTE $4C
      .BYTE $3C
      .BYTE $4C
      .BYTE $48
      .BYTE $4C
      .BYTE $3E
      .BYTE $4C
      .BYTE $46
      .BYTE $4C
      .BYTE $3E
      .BYTE $52
      .BYTE $4C
      .BYTE $5E
      .BYTE $98
      .BYTE $48
      .BYTE $48
      .BYTE $48
      .BYTE $94
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $99
      .BYTE $48
      .BYTE $98
      .BYTE $48
      .BYTE $48
      .BYTE $46
      .BYTE $46
      .BYTE $46
      .BYTE $94
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $99
      .BYTE $46
      .BYTE $98
      .BYTE $46
      .BYTE $46
      .BYTE $00
      .BYTE $98
      .BYTE $3A
      .BYTE $3A
      .BYTE $3A
      .BYTE $94
      .BYTE $34
      .BYTE $98
      .BYTE $3A
      .BYTE $3A
      .BYTE $94
      .BYTE $34
      .BYTE $3A
      .BYTE $34
      .BYTE $98
      .BYTE $3A
      .BYTE $38
      .BYTE $38
      .BYTE $38
      .BYTE $94
      .BYTE $30
      .BYTE $98
      .BYTE $38
      .BYTE $38
      .BYTE $94
      .BYTE $30
      .BYTE $38
      .BYTE $30
      .BYTE $98
      .BYTE $38
      .BYTE $9A
      .BYTE $34
      .BYTE $99
      .BYTE $42
      .BYTE $4C
      .BYTE $98
      .BYTE $7E
      .BYTE $42
      .BYTE $4C
      .BYTE $9A
      .BYTE $30
      .BYTE $99
      .BYTE $3E
      .BYTE $48
      .BYTE $98
      .BYTE $7E
      .BYTE $3E
      .BYTE $48
      .BYTE $94
      .BYTE $01
      .BYTE $98
      .BYTE $10
      .BYTE $94
      .BYTE $10
      .BYTE $10
      .BYTE $10
      .BYTE $01
      .BYTE $01
      .BYTE $00
      .BYTE $A4
      .BYTE $0A
      .BYTE $18
      .BYTE $22
      .BYTE $84
      .BYTE $40
      .BYTE $7E
      .BYTE $89
      .BYTE $42
      .BYTE $A4
      .BYTE $0A
      .BYTE $18
      .BYTE $22
      .BYTE $84
      .BYTE $40
      .BYTE $7E
      .BYTE $89
      .BYTE $3E
      .BYTE $B8
      .BYTE $7E
      .BYTE $B9
      .BYTE $48
      .BYTE $44
      .BYTE $B8
      .BYTE $3A
      .BYTE $B9
      .BYTE $40
      .BYTE $B8
      .BYTE $44
      .BYTE $B4
      .BYTE $36
      .BYTE $B8
      .BYTE $3A
      .BYTE $B9
      .BYTE $30
      .BYTE $B9
      .BYTE $34
      .BYTE $BB
      .BYTE $36
      .BYTE $B8
      .BYTE $7E
      .BYTE $00
      .BYTE $B4
      .BYTE $0A
      .BYTE $18
      .BYTE $22
      .BYTE $84
      .BYTE $36
      .BYTE $7E
      .BYTE $89
      .BYTE $38
      .BYTE $B4
      .BYTE $0A
      .BYTE $18
      .BYTE $22
      .BYTE $84
      .BYTE $36
      .BYTE $7E
      .BYTE $89
      .BYTE $34
      .BYTE $B8
      .BYTE $7E
      .BYTE $B9
      .BYTE $3A
      .BYTE $36
      .BYTE $B8
      .BYTE $30
      .BYTE $B9
      .BYTE $36
      .BYTE $B8
      .BYTE $3A
      .BYTE $B4
      .BYTE $2C
      .BYTE $B8
      .BYTE $30
      .BYTE $B9
      .BYTE $22
      .BYTE $B9
      .BYTE $26
      .BYTE $BB
      .BYTE $28
      .BYTE $B8
      .BYTE $7E
      .BYTE $84
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $42
      .BYTE $7E
      .BYTE $44
      .BYTE $3A
      .BYTE $30
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $42
      .BYTE $7E
      .BYTE $40
      .BYTE $3A
      .BYTE $30
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $30
      .BYTE $7E
      .BYTE $40
      .BYTE $3A
      .BYTE $30
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $30
      .BYTE $7E
      .BYTE $40
      .BYTE $3A
      .BYTE $30
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $30
      .BYTE $7E
      .BYTE $40
      .BYTE $3A
      .BYTE $30
      .BYTE $22
      .BYTE $30
      .BYTE $3A
      .BYTE $30
      .BYTE $7E
      .BYTE $40
      .BYTE $3A
      .BYTE $30
      .BYTE $85
      .BYTE $01
      .BYTE $8D
      .BYTE $10
      .BYTE $8E
      .BYTE $10
      .BYTE $84
      .BYTE $10
      .BYTE $88
      .BYTE $10
      .BYTE $84
      .BYTE $01
      .BYTE $01
      .BYTE $01
      .BYTE $00
      .BYTE $99
      .BYTE $48
      .BYTE $3E
      .BYTE $38
      .BYTE $98
      .BYTE $42
      .BYTE $46
      .BYTE $94
      .BYTE $44
      .BYTE $42
      .BYTE $7E
      .BYTE $96
      .BYTE $3E
      .BYTE $50
      .BYTE $56
      .BYTE $94
      .BYTE $5A
      .BYTE $7E
      .BYTE $52
      .BYTE $98
      .BYTE $56
      .BYTE $50
      .BYTE $94
      .BYTE $48
      .BYTE $4C
      .BYTE $99
      .BYTE $46
      .BYTE $00
      .BYTE $99
      .BYTE $38
      .BYTE $30
      .BYTE $26
      .BYTE $98
      .BYTE $30
      .BYTE $34 ; 4
      .BYTE $94
      .BYTE $32 ; 2
      .BYTE $98
      .BYTE $30
      .BYTE $96
      .BYTE $30
      .BYTE $3E
      .BYTE $46
      .BYTE $98
      .BYTE $48
      .BYTE $94
      .BYTE $42
      .BYTE $98
      .BYTE $46
      .BYTE $98
      .BYTE $42
      .BYTE $94
      .BYTE $38 ; 8
      .BYTE $3A
      .BYTE $99
      .BYTE $34 ; 4
      .BYTE $99
      .BYTE $3E
      .BYTE $38
      .BYTE $30
      .BYTE $98
      .BYTE $3A
      .BYTE $3E
      .BYTE $94
      .BYTE $3C
      .BYTE $3A
      .BYTE $7E
      .BYTE $96
      .BYTE $38 ; 8
      .BYTE $48
      .BYTE $50
      .BYTE $94
      .BYTE $52
      .BYTE $7E
      .BYTE $4C
      .BYTE $50
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $99
      .BYTE $3E
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $56
      .BYTE $54
      .BYTE $52
      .BYTE $4E
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $40
      .BYTE $42
      .BYTE $48
      .BYTE $7E
      .BYTE $42
      .BYTE $48
      .BYTE $4C
      .BYTE $00
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $50
      .BYTE $4E
      .BYTE $4C
      .BYTE $98
      .BYTE $46
      .BYTE $94
      .BYTE $48
      .BYTE $7E
      .BYTE $38 ; 8
      .BYTE $3A
      .BYTE $3E
      .BYTE $7E
      .BYTE $30
      .BYTE $38 ; 8
      .BYTE $3A
      .BYTE $99
      .BYTE $30
      .BYTE $3E
      .BYTE $98
      .BYTE $48
      .BYTE $99
      .BYTE $3A
      .BYTE $94
      .BYTE $48
      .BYTE $98
      .BYTE $48
      .BYTE $3A
      .BYTE $98
      .BYTE $04
      .BYTE $92
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $98
      .BYTE $06
      .BYTE $92
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $00
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $56
      .BYTE $54
      .BYTE $52
      .BYTE $4E
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $60
      .BYTE $7E
      .BYTE $60
      .BYTE $9A
      .BYTE $60
      .BYTE $00
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $50
      .BYTE $4E
      .BYTE $4C
      .BYTE $98
      .BYTE $46
      .BYTE $94
      .BYTE $48
      .BYTE $7E
      .BYTE $98
      .BYTE $52
      .BYTE $94
      .BYTE $52
      .BYTE $52
      .BYTE $99
      .BYTE $7E
      .BYTE $99
      .BYTE $30
      .BYTE $38 ; 8
      .BYTE $94
      .BYTE $3E
      .BYTE $98
      .BYTE $48
      .BYTE $6E
      .BYTE $94
      .BYTE $6E
      .BYTE $98
      .BYTE $6E
      .BYTE $3E
      .BYTE $98
      .BYTE $7E
      .BYTE $99
      .BYTE $4E
      .BYTE $99
      .BYTE $4C
      .BYTE $9A
      .BYTE $48
      .BYTE $7E
      .BYTE $00
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $40
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $3A
      .BYTE $98
      .BYTE $7E
      .BYTE $9A
      .BYTE $38 ; 8
      .BYTE $7E
      .BYTE $98
      .BYTE $30
      .BYTE $99
      .BYTE $40
      .BYTE $44
      .BYTE $48
      .BYTE $94
      .BYTE $3E
      .BYTE $98
      .BYTE $3E
      .BYTE $30
      .BYTE $98
      .BYTE $04
      .BYTE $92
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $98
      .BYTE $06
      .BYTE $92
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $00
      .BYTE $E4
      .BYTE $6E
      .BYTE $E8
      .BYTE $6A
      .BYTE $E4
      .BYTE $64
      .BYTE $E8
      .BYTE $5E
      .BYTE $E4
      .BYTE $56
      .BYTE $E8
      .BYTE $52
      .BYTE $E4
      .BYTE $4C
      .BYTE $E8
      .BYTE $46
      .BYTE $E4
      .BYTE $3E
      .BYTE $E8
      .BYTE $3C
      .BYTE $E4
      .BYTE $3A
      .BYTE $34
      .BYTE $2E
      .BYTE $E8
      .BYTE $26
      .BYTE $7E
      .BYTE $3E
      .BYTE $E8
      .BYTE $56
      .BYTE $7E
      .BYTE $E9
      .BYTE $3E
      .BYTE $00
      .BYTE $E4
      .BYTE $56
      .BYTE $E8
      .BYTE $52
      .BYTE $E4
      .BYTE $4C
      .BYTE $E8
      .BYTE $46
      .BYTE $E4
      .BYTE $3E
      .BYTE $E8
      .BYTE $3A
      .BYTE $E4
      .BYTE $34
      .BYTE $E8
      .BYTE $2E
      .BYTE $E4
      .BYTE $26
      .BYTE $E8
      .BYTE $24
      .BYTE $E4
      .BYTE $22
      .BYTE $1C
      .BYTE $16
      .BYTE $E8
      .BYTE $0E
      .BYTE $7E
      .BYTE $26
      .BYTE $E8
      .BYTE $46
      .BYTE $7E
      .BYTE $E9
      .BYTE $3E
      .BYTE $EB
      .BYTE $7E
      .BYTE $7E
      .BYTE $E4
      .BYTE $3E
      .BYTE $E8
      .BYTE $3C
      .BYTE $E4
      .BYTE $3A
      .BYTE $34
      .BYTE $2E
      .BYTE $E8
      .BYTE $3E
      .BYTE $7E
      .BYTE $7E
      .BYTE $E8
      .BYTE $4C
      .BYTE $7E
      .BYTE $89
      .BYTE $7E
      .BYTE $E8
      .BYTE $10
      .BYTE $02
      .BYTE $06
      .BYTE $10
      .BYTE $02
      .BYTE $06
      .BYTE $10
      .BYTE $02
      .BYTE $06
      .BYTE $10
      .BYTE $01
      .BYTE $10
      .BYTE $10
      .BYTE $01
      .BYTE $01
      .BYTE $EA
      .BYTE $01
      .BYTE $E4
      .BYTE $50
      .BYTE $3E
      .BYTE $48
      .BYTE $50
      .BYTE $7E
      .BYTE $3E
      .BYTE $4E
      .BYTE $3E
      .BYTE $46
      .BYTE $4E
      .BYTE $7E
      .BYTE $3E
      .BYTE $EB
      .BYTE $50
      .BYTE $E4
      .BYTE $7E
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $4C
      .BYTE $50
      .BYTE $3E
      .BYTE $48
      .BYTE $50
      .BYTE $7E
      .BYTE $3E
      .BYTE $4E
      .BYTE $3E
      .BYTE $46
      .BYTE $52
      .BYTE $7E
      .BYTE $3E
      .BYTE $E9
      .BYTE $50
      .BYTE $E4
      .BYTE $26
      .BYTE $2A
      .BYTE $26
      .BYTE $E8
      .BYTE $2E
      .BYTE $2A
      .BYTE $26
      .BYTE $E4
      .BYTE $4C
      .BYTE $3E
      .BYTE $46
      .BYTE $4C
      .BYTE $7E
      .BYTE $3E
      .BYTE $4A
      .BYTE $3E
      .BYTE $44
      .BYTE $4A
      .BYTE $7E
      .BYTE $3E
      .BYTE $EB
      .BYTE $4C
      .BYTE $E4
      .BYTE $7E
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $4A
      .BYTE $4C
      .BYTE $3E
      .BYTE $46
      .BYTE $4C
      .BYTE $7E
      .BYTE $3E
      .BYTE $46
      .BYTE $3E
      .BYTE $46
      .BYTE $52
      .BYTE $7E
      .BYTE $46
      .BYTE $E9
      .BYTE $50
      .BYTE $E4
      .BYTE $26
      .BYTE $2A
      .BYTE $26
      .BYTE $E8
      .BYTE $2E
      .BYTE $30
      .BYTE $34
      .BYTE $00
      .BYTE $B8
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $B4
      .BYTE $10
      .BYTE $10
      .BYTE $B8
      .BYTE $10
      .BYTE $00
      .BYTE $E4
      .BYTE $38
      .BYTE $3E
      .BYTE $48
      .BYTE $38
      .BYTE $7E
      .BYTE $3E
      .BYTE $36
      .BYTE $3E
      .BYTE $46
      .BYTE $36
      .BYTE $7E
      .BYTE $3E
      .BYTE $EB
      .BYTE $38
      .BYTE $E4
      .BYTE $7E
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $4C
      .BYTE $38
      .BYTE $3E
      .BYTE $48
      .BYTE $38
      .BYTE $7E
      .BYTE $3E
      .BYTE $36
      .BYTE $3E
      .BYTE $46
      .BYTE $3A
      .BYTE $7E
      .BYTE $3E
      .BYTE $E9
      .BYTE $48
      .BYTE $E4
      .BYTE $26
      .BYTE $2A
      .BYTE $26
      .BYTE $E8
      .BYTE $2E
      .BYTE $2A
      .BYTE $26
      .BYTE $E4
      .BYTE $34
      .BYTE $3E
      .BYTE $46
      .BYTE $34
      .BYTE $7E
      .BYTE $3E
      .BYTE $32
      .BYTE $3E
      .BYTE $44
      .BYTE $32
      .BYTE $7E
      .BYTE $3E
      .BYTE $EB
      .BYTE $34
      .BYTE $E4
      .BYTE $7E
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $4A
      .BYTE $34
      .BYTE $3E
      .BYTE $46
      .BYTE $34
      .BYTE $7E
      .BYTE $3E
      .BYTE $2E
      .BYTE $3E
      .BYTE $46
      .BYTE $3A
      .BYTE $7E
      .BYTE $46
      .BYTE $E9
      .BYTE $48
      .BYTE $E4
      .BYTE $26
      .BYTE $2A
      .BYTE $26
      .BYTE $E8
      .BYTE $2E
      .BYTE $30
      .BYTE $34
      .BYTE $88
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $56
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $3E
      .BYTE $56
      .BYTE $56
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $56
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $3E
      .BYTE $56
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $56
      .BYTE $4A
      .BYTE $54
      .BYTE $54
      .BYTE $4C
      .BYTE $56
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $56
      .BYTE $4C
      .BYTE $56
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $56
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $3E
      .BYTE $56
      .BYTE $56
      .BYTE $E4
      .BYTE $56
      .BYTE $48
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $48
      .BYTE $56
      .BYTE $46
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $46
      .BYTE $56
      .BYTE $44
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $44
      .BYTE $56
      .BYTE $7E
      .BYTE $5A
      .BYTE $7E
      .BYTE $E6
      .BYTE $7E
      .BYTE $E4
      .BYTE $56
      .BYTE $52
      .BYTE $42
      .BYTE $7E
      .BYTE $52
      .BYTE $7E
      .BYTE $42
      .BYTE $52
      .BYTE $42
      .BYTE $7E
      .BYTE $52
      .BYTE $7E
      .BYTE $42
      .BYTE $52
      .BYTE $42
      .BYTE $7E
      .BYTE $52
      .BYTE $7E
      .BYTE $42
      .BYTE $52
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $E6
      .BYTE $7E
      .BYTE $E4
      .BYTE $52
      .BYTE $50
      .BYTE $3E
      .BYTE $3E
      .BYTE $50
      .BYTE $7E
      .BYTE $3E
      .BYTE $E8
      .BYTE $42
      .BYTE $46
      .BYTE $52
      .BYTE $E4
      .BYTE $50
      .BYTE $50
      .BYTE $E9
      .BYTE $50
      .BYTE $E4
      .BYTE $46
      .BYTE $00
      .BYTE $E4
      .BYTE $50
      .BYTE $48
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $48
      .BYTE $4C
      .BYTE $46
      .BYTE $7E
      .BYTE $4C
      .BYTE $7E
      .BYTE $46
      .BYTE $4A
      .BYTE $44
      .BYTE $7E
      .BYTE $4A
      .BYTE $7E
      .BYTE $44
      .BYTE $4A
      .BYTE $4A
      .BYTE $4A
      .BYTE $7E
      .BYTE $E6
      .BYTE $7E
      .BYTE $E4
      .BYTE $56
      .BYTE $4C
      .BYTE $42
      .BYTE $7E
      .BYTE $4C
      .BYTE $7E
      .BYTE $42
      .BYTE $4A
      .BYTE $42
      .BYTE $7E
      .BYTE $4A
      .BYTE $7E
      .BYTE $42
      .BYTE $48
      .BYTE $42
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $42
      .BYTE $46
      .BYTE $46
      .BYTE $46
      .BYTE $7E
      .BYTE $E6
      .BYTE $7E
      .BYTE $E4
      .BYTE $52
      .BYTE $30
      .BYTE $3E
      .BYTE $3E
      .BYTE $30
      .BYTE $7E
      .BYTE $3E
      .BYTE $E8
      .BYTE $3A
      .BYTE $3E
      .BYTE $46
      .BYTE $E4
      .BYTE $46
      .BYTE $46
      .BYTE $E9
      .BYTE $46
      .BYTE $E4
      .BYTE $3A
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $46
      .BYTE $56
      .BYTE $56
      .BYTE $44
      .BYTE $56
      .BYTE $56
      .BYTE $4A
      .BYTE $56
      .BYTE $86
      .BYTE $7E
      .BYTE $84
      .BYTE $7E
      .BYTE $88
      .BYTE $4C
      .BYTE $5A
      .BYTE $5A
      .BYTE $4A
      .BYTE $5A
      .BYTE $5A
      .BYTE $48
      .BYTE $5A
      .BYTE $5A
      .BYTE $46
      .BYTE $56
      .BYTE $86
      .BYTE $7E
      .BYTE $84
      .BYTE $7E
      .BYTE $88
      .BYTE $48
      .BYTE $56
      .BYTE $56
      .BYTE $3E
      .BYTE $56
      .BYTE $56
      .BYTE $84
      .BYTE $52
      .BYTE $52
      .BYTE $89
      .BYTE $52
      .BYTE $84
      .BYTE $46
      .BYTE $B8
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $86
      .BYTE $01
      .BYTE $84
      .BYTE $01
      .BYTE $88
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $86
      .BYTE $01
      .BYTE $84
      .BYTE $01
      .BYTE $88
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $02
      .BYTE $10
      .BYTE $10
      .BYTE $48
      .BYTE $7E
      .BYTE $7E
      .BYTE $3E
      .BYTE $38
      .BYTE $34
      .BYTE $30
      .BYTE $7E
      .BYTE $7E
      .BYTE $26
      .BYTE $20
      .BYTE $1C
      .BYTE $E8
      .BYTE $18
      .BYTE $7E
      .BYTE $3E
      .BYTE $48
      .BYTE $00
      .BYTE $30
      .BYTE $7E
      .BYTE $7E
      .BYTE $26
      .BYTE $20
      .BYTE $1C
      .BYTE $18
      .BYTE $7E
      .BYTE $7E
      .BYTE $0E
      .BYTE $08
      .BYTE $04
      .BYTE $E8
      .BYTE $18
      .BYTE $7E
      .BYTE $00
      .BYTE $2E
      .BYTE $38
      .BYTE $EB
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $30
      .BYTE $10
      .BYTE $01
      .BYTE $01
      .BYTE $10
      .BYTE $01
      .BYTE $01
      .BYTE $10
      .BYTE $01
      .BYTE $10
      .BYTE $10
      .BYTE $01
      .BYTE $01
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $98
      .BYTE $50
      .BYTE $7E
      .BYTE $4C
      .BYTE $7E
      .BYTE $00
      .BYTE $96
      .BYTE $3E
      .BYTE $92
      .BYTE $3E
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3E
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3E
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3E
      .BYTE $96
      .BYTE $3C
      .BYTE $92
      .BYTE $3C
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3C
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3C
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3C
      .BYTE $96
      .BYTE $3A
      .BYTE $92
      .BYTE $3A
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3A
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3A
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $3A
      .BYTE $98
      .BYTE $46
      .BYTE $7E
      .BYTE $3A
      .BYTE $7E
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $96
      .BYTE $7E
      .BYTE $92
      .BYTE $48
      .BYTE $98
      .BYTE $3E
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $8A
      .BYTE $04
      .BYTE $01
      .BYTE $00
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $48
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $42
      .BYTE $A8
      .BYTE $50
      .BYTE $50
      .BYTE $A8
      .BYTE $50
      .BYTE $7E
      .BYTE $50
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $50
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $48
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $42
      .BYTE $AA
      .BYTE $3E
      .BYTE $A8
      .BYTE $48
      .BYTE $7E
      .BYTE $48
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $48
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $42
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $3C
      .BYTE $AA
      .BYTE $38
      .BYTE $A8
      .BYTE $50
      .BYTE $7E
      .BYTE $50
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $50
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $48
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $42
      .BYTE $A8
      .BYTE $50
      .BYTE $50
      .BYTE $A4
      .BYTE $48
      .BYTE $A9
      .BYTE $7E
      .BYTE $AA
      .BYTE $7E
      .BYTE $00
      .BYTE $AA
      .BYTE $7E
      .BYTE $7E
      .BYTE $00
      .BYTE $C8
      .BYTE $7E
      .BYTE $48
      .BYTE $4C
      .BYTE $4E
      .BYTE $00
      .BYTE $A8
      .BYTE $3E
      .BYTE $7E
      .BYTE $A8
      .BYTE $3E
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $3E
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $38
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $38
      .BYTE $AA
      .BYTE $30
      .BYTE $A8
      .BYTE $3C
      .BYTE $7E
      .BYTE $3C
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $3C
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $34
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $34
      .BYTE $AA
      .BYTE $30
      .BYTE $A8
      .BYTE $3A
      .BYTE $7E
      .BYTE $3A
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $3A
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $34
      .BYTE $A6
      .BYTE $7E
      .BYTE $A2
      .BYTE $2E
      .BYTE $A8
      .BYTE $3E
      .BYTE $3E
      .BYTE $A4
      .BYTE $38
      .BYTE $A9
      .BYTE $7E
      .BYTE $AA
      .BYTE $7E
      .BYTE $AA
      .BYTE $7E
      .BYTE $7E
      .BYTE $C8
      .BYTE $7E
      .BYTE $38
      .BYTE $3A
      .BYTE $3C
      .BYTE $88
      .BYTE $30
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $8A
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $8A
      .BYTE $7E
      .BYTE $7E
      .BYTE $88
      .BYTE $02
      .BYTE $04
      .BYTE $00
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $04
      .BYTE $86
      .BYTE $04
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $01
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $04
      .BYTE $82
      .BYTE $01
      .BYTE $82
      .BYTE $04
      .BYTE $C8
      .BYTE $50
      .BYTE $7E
      .BYTE $50
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $50
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $4C
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $4C
      .BYTE $50
      .BYTE $C4
      .BYTE $4C
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $C2
      .BYTE $48
      .BYTE $C6
      .BYTE $46
      .BYTE $7E
      .BYTE $C8
      .BYTE $48
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $C8
      .BYTE $4C
      .BYTE $7E
      .BYTE $4C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $4C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $48
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $46
      .BYTE $C4
      .BYTE $42
      .BYTE $7E
      .BYTE $00
      .BYTE $C8
      .BYTE $7E
      .BYTE $46
      .BYTE $48
      .BYTE $4A
      .BYTE $C8
      .BYTE $4C
      .BYTE $7E
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $3E
      .BYTE $C2
      .BYTE $7E
      .BYTE $00
      .BYTE $C8
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $40
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $3C
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $3C
      .BYTE $40
      .BYTE $C4
      .BYTE $38
      .BYTE $7E
      .BYTE $38
      .BYTE $7E
      .BYTE $C2
      .BYTE $38
      .BYTE $C6
      .BYTE $34
      .BYTE $7E
      .BYTE $C8
      .BYTE $38
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $30
      .BYTE $34
      .BYTE $38
      .BYTE $C8
      .BYTE $3C
      .BYTE $7E
      .BYTE $3C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $3C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $38
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $34
      .BYTE $C4
      .BYTE $30
      .BYTE $7E
      .BYTE $C8
      .BYTE $7E
      .BYTE $34
      .BYTE $38
      .BYTE $3A
      .BYTE $C8
      .BYTE $3C
      .BYTE $7E
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $2E
      .BYTE $C2
      .BYTE $7E
      .BYTE $88
      .BYTE $38
      .BYTE $7E
      .BYTE $3C
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $40
      .BYTE $46
      .BYTE $42
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $46
      .BYTE $42
      .BYTE $34
      .BYTE $7E
      .BYTE $38
      .BYTE $7E
      .BYTE $3A
      .BYTE $7E
      .BYTE $3C
      .BYTE $42
      .BYTE $88
      .BYTE $7E
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $46
      .BYTE $7E
      .BYTE $8A
      .BYTE $7E
      .BYTE $88
      .BYTE $02
      .BYTE $04
      .BYTE $00
      .BYTE $88
      .BYTE $02
      .BYTE $04
      .BYTE $04
      .BYTE $04
      .BYTE $02
      .BYTE $02
      .BYTE $7E
      .BYTE $06
      .BYTE $96
      .BYTE $50
      .BYTE $92
      .BYTE $4E
      .BYTE $96
      .BYTE $50
      .BYTE $92
      .BYTE $5E
      .BYTE $96
      .BYTE $58
      .BYTE $92
      .BYTE $50
      .BYTE $96
      .BYTE $68
      .BYTE $92
      .BYTE $5E
      .BYTE $96
      .BYTE $64
      .BYTE $92
      .BYTE $5E
      .BYTE $96
      .BYTE $5A
      .BYTE $92
      .BYTE $5E
      .BYTE $96
      .BYTE $58
      .BYTE $92
      .BYTE $52
      .BYTE $96
      .BYTE $50
      .BYTE $92
      .BYTE $4C
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $46
      .BYTE $96
      .BYTE $48
      .BYTE $92
      .BYTE $4C
      .BYTE $96
      .BYTE $50
      .BYTE $92
      .BYTE $4E
      .BYTE $96
      .BYTE $50
      .BYTE $92
      .BYTE $5A
      .BYTE $96
      .BYTE $58
      .BYTE $92
      .BYTE $50
      .BYTE $96
      .BYTE $4C
      .BYTE $92
      .BYTE $4E
      .BYTE $96
      .BYTE $5A
      .BYTE $92
      .BYTE $50
      .BYTE $96
      .BYTE $56
      .BYTE $92
      .BYTE $54
      .BYTE $96
      .BYTE $52
      .BYTE $92
      .BYTE $50
      .BYTE $96
      .BYTE $52
      .BYTE $92
      .BYTE $5A
      .BYTE $96
      .BYTE $68
      .BYTE $92
      .BYTE $4C
      .BYTE $96
      .BYTE $5A
      .BYTE $92
      .BYTE $58
      .BYTE $96
      .BYTE $56
      .BYTE $92
      .BYTE $68
      .BYTE $96
      .BYTE $56
      .BYTE $92
      .BYTE $54
      .BYTE $96
      .BYTE $52
      .BYTE $92
      .BYTE $64
      .BYTE $96
      .BYTE $5A
      .BYTE $92
      .BYTE $5C
      .BYTE $00
      .BYTE $C8
      .BYTE $50
      .BYTE $7E
      .BYTE $50
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $50
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $4C
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $4C
      .BYTE $50
      .BYTE $C4
      .BYTE $4C
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $C2
      .BYTE $48
      .BYTE $C6
      .BYTE $46
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $48
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $42
      .BYTE $46
      .BYTE $48
      .BYTE $4C
      .BYTE $7E
      .BYTE $4C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C2
      .BYTE $4C
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $48
      .BYTE $C2
      .BYTE $7E
      .BYTE $C8
      .BYTE $46
      .BYTE $C4
      .BYTE $42
      .BYTE $7E
      .BYTE $88
      .BYTE $38
      .BYTE $7E
      .BYTE $3C
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $40
      .BYTE $46
      .BYTE $42
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $46
      .BYTE $42
      .BYTE $34
      .BYTE $7E
      .BYTE $38
      .BYTE $7E
      .BYTE $3A
      .BYTE $7E
      .BYTE $3C
      .BYTE $42
      .BYTE $88
      .BYTE $02
      .BYTE $04
      .BYTE $00
      .BYTE $96
      .BYTE $5E
      .BYTE $92
      .BYTE $5C
      .BYTE $96
      .BYTE $5E
      .BYTE $92
      .BYTE $5A
      .BYTE $96
      .BYTE $56
      .BYTE $92
      .BYTE $52
      .BYTE $96
      .BYTE $42
      .BYTE $92
      .BYTE $46
      .BYTE $96
      .BYTE $56
      .BYTE $92
      .BYTE $52
      .BYTE $96
      .BYTE $46
      .BYTE $92
      .BYTE $42
      .BYTE $96
      .BYTE $52
      .BYTE $92
      .BYTE $46
      .BYTE $96
      .BYTE $42
      .BYTE $92
      .BYTE $3E
      .BYTE $00
      .BYTE $C8
      .BYTE $7E
      .BYTE $46
      .BYTE $48
      .BYTE $4A
      .BYTE $C8
      .BYTE $4C
      .BYTE $7E
      .BYTE $C6
      .BYTE $7E
      .BYTE $C8
      .BYTE $3E
      .BYTE $C2
      .BYTE $7E
      .BYTE $88
      .BYTE $7E
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $46
      .BYTE $7E
      .BYTE $8A
      .BYTE $7E
      .BYTE $88
      .BYTE $02
      .BYTE $04
      .BYTE $04
      .BYTE $04
      .BYTE $02
      .BYTE $02
      .BYTE $7E
      .BYTE $06
      .BYTE $A2
      .BYTE $7E
      .BYTE $7E
      .BYTE $56
      .BYTE $54
      .BYTE $7E
      .BYTE $52
      .BYTE $4C
      .BYTE $7E
      .BYTE $46
      .BYTE $42
      .BYTE $7E
      .BYTE $40
      .BYTE $A4
      .BYTE $3E
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $A8
      .BYTE $3E
      .BYTE $7E
      .BYTE $00
      .BYTE $A2
      .BYTE $7E
      .BYTE $7E
      .BYTE $46
      .BYTE $44
      .BYTE $7E
      .BYTE $42
      .BYTE $3A
      .BYTE $7E
      .BYTE $34
      .BYTE $30
      .BYTE $7E
      .BYTE $2E
      .BYTE $A4
      .BYTE $2E
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $A8
      .BYTE $3A
      .BYTE $7E
      .BYTE $82
      .BYTE $7E
      .BYTE $7E
      .BYTE $4C
      .BYTE $4A
      .BYTE $7E
      .BYTE $48
      .BYTE $46
      .BYTE $7E
      .BYTE $3E
      .BYTE $3A
      .BYTE $7E
      .BYTE $38
      .BYTE $88
      .BYTE $34
      .BYTE $4C
      .BYTE $34
      .BYTE $3E
      .BYTE $8A
      .BYTE $01
      .BYTE $01
      .BYTE $88
      .BYTE $02
      .BYTE $82
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $82
      .BYTE $56
      .BYTE $7E
      .BYTE $48
      .BYTE $50
      .BYTE $7E
      .BYTE $88
      .BYTE $56
      .BYTE $82
      .BYTE $48
      .BYTE $50
      .BYTE $7E
      .BYTE $56
      .BYTE $46
      .BYTE $4E
      .BYTE $56
      .BYTE $5E
      .BYTE $7E
      .BYTE $8A
      .BYTE $5A
      .BYTE $82
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $44
      .BYTE $4C
      .BYTE $7E
      .BYTE $88
      .BYTE $56
      .BYTE $82
      .BYTE $44
      .BYTE $4C
      .BYTE $7E
      .BYTE $56
      .BYTE $4A
      .BYTE $50
      .BYTE $56
      .BYTE $5E
      .BYTE $7E
      .BYTE $8A
      .BYTE $5A
      .BYTE $82
      .BYTE $5E
      .BYTE $60
      .BYTE $7E
      .BYTE $5E
      .BYTE $60
      .BYTE $7E
      .BYTE $88
      .BYTE $5A
      .BYTE $82
      .BYTE $60
      .BYTE $5E
      .BYTE $7E
      .BYTE $5A
      .BYTE $56
      .BYTE $7E
      .BYTE $54
      .BYTE $56
      .BYTE $7E
      .BYTE $88
      .BYTE $50
      .BYTE $82
      .BYTE $4A
      .BYTE $4C
      .BYTE $7E
      .BYTE $50
      .BYTE $52
      .BYTE $7E
      .BYTE $50
      .BYTE $52
      .BYTE $7E
      .BYTE $88
      .BYTE $46
      .BYTE $82
      .BYTE $50
      .BYTE $4C
      .BYTE $7E
      .BYTE $8A
      .BYTE $48
      .BYTE $7E
      .BYTE $82
      .BYTE $7E
      .BYTE $00
      .BYTE $82
      .BYTE $48
      .BYTE $7E
      .BYTE $38
      .BYTE $3E
      .BYTE $7E
      .BYTE $88
      .BYTE $48
      .BYTE $82
      .BYTE $38
      .BYTE $3E
      .BYTE $7E
      .BYTE $48
      .BYTE $36
      .BYTE $3E
      .BYTE $46
      .BYTE $4E
      .BYTE $7E
      .BYTE $8A
      .BYTE $46
      .BYTE $82
      .BYTE $7E
      .BYTE $44
      .BYTE $7E
      .BYTE $34
      .BYTE $3E
      .BYTE $7E
      .BYTE $88
      .BYTE $44
      .BYTE $82
      .BYTE $34
      .BYTE $3E
      .BYTE $7E
      .BYTE $44
      .BYTE $38
      .BYTE $42
      .BYTE $4A
      .BYTE $50
      .BYTE $7E
      .BYTE $8A
      .BYTE $4A
      .BYTE $82
      .BYTE $50
      .BYTE $5A
      .BYTE $7E
      .BYTE $56
      .BYTE $5A
      .BYTE $7E
      .BYTE $88
      .BYTE $52
      .BYTE $82
      .BYTE $5A
      .BYTE $56
      .BYTE $7E
      .BYTE $54
      .BYTE $50
      .BYTE $7E
      .BYTE $4E
      .BYTE $50
      .BYTE $7E
      .BYTE $88
      .BYTE $48
      .BYTE $82
      .BYTE $42
      .BYTE $46
      .BYTE $7E
      .BYTE $4A
      .BYTE $4C
      .BYTE $7E
      .BYTE $48
      .BYTE $4C
      .BYTE $7E
      .BYTE $88
      .BYTE $3E
      .BYTE $82
      .BYTE $48
      .BYTE $46
      .BYTE $7E
      .BYTE $8A
      .BYTE $3E
      .BYTE $8A
      .BYTE $7E
      .BYTE $82
      .BYTE $7E
      .BYTE $88
      .BYTE $30
      .BYTE $3E
      .BYTE $30
      .BYTE $3E
      .BYTE $2E
      .BYTE $3E
      .BYTE $2E
      .BYTE $3E
      .BYTE $2C
      .BYTE $3E
      .BYTE $2C
      .BYTE $3E
      .BYTE $2A
      .BYTE $3E
      .BYTE $2A
      .BYTE $3E
      .BYTE $22
      .BYTE $3A
      .BYTE $24
      .BYTE $3C
      .BYTE $26
      .BYTE $3E
      .BYTE $2A
      .BYTE $42
      .BYTE $34
      .BYTE $3A
      .BYTE $26
      .BYTE $34
      .BYTE $30
      .BYTE $26
      .BYTE $30
      .BYTE $7E
      .BYTE $88
      .BYTE $01
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $88
      .BYTE $01
      .BYTE $02
      .BYTE $82
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $00
      .BYTE $92
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $50
      .BYTE $92
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $7E
      .BYTE $5A
      .BYTE $7E
      .BYTE $9A
      .BYTE $60
      .BYTE $92
      .BYTE $7E
      .BYTE $5A
      .BYTE $7E
      .BYTE $56
      .BYTE $50
      .BYTE $7E
      .BYTE $48
      .BYTE $4C
      .BYTE $7E
      .BYTE $50
      .BYTE $4C
      .BYTE $7E
      .BYTE $50
      .BYTE $4C
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $4C
      .BYTE $90
      .BYTE $42
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $42
      .BYTE $4C
      .BYTE $92
      .BYTE $7E
      .BYTE $98
      .BYTE $4C
      .BYTE $92
      .BYTE $50
      .BYTE $4C
      .BYTE $7E
      .BYTE $50
      .BYTE $4C
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $5A
      .BYTE $92
      .BYTE $56
      .BYTE $5A
      .BYTE $7E
      .BYTE $56
      .BYTE $00
      .BYTE $92
      .BYTE $50
      .BYTE $7E
      .BYTE $4C
      .BYTE $48
      .BYTE $7E
      .BYTE $98
      .BYTE $50
      .BYTE $90
      .BYTE $3E
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $3E
      .BYTE $50
      .BYTE $92
      .BYTE $7E
      .BYTE $7E
      .BYTE $C2
      .BYTE $7E
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $4E
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $00
      .BYTE $88
      .BYTE $06
      .BYTE $82
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $00
      .BYTE $92
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $3E
      .BYTE $92
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $9A
      .BYTE $56
      .BYTE $92
      .BYTE $7E
      .BYTE $50
      .BYTE $7E
      .BYTE $48
      .BYTE $42
      .BYTE $7E
      .BYTE $3E
      .BYTE $3C
      .BYTE $7E
      .BYTE $3E
      .BYTE $3C
      .BYTE $7E
      .BYTE $3E
      .BYTE $3C
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $3C
      .BYTE $90
      .BYTE $34
      .BYTE $3C
      .BYTE $34
      .BYTE $34
      .BYTE $3C
      .BYTE $34
      .BYTE $3C
      .BYTE $34
      .BYTE $3C
      .BYTE $90
      .BYTE $34
      .BYTE $3C
      .BYTE $34
      .BYTE $92
      .BYTE $7E
      .BYTE $98
      .BYTE $3A
      .BYTE $92
      .BYTE $3E
      .BYTE $3A
      .BYTE $7E
      .BYTE $3E
      .BYTE $3A
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $7E
      .BYTE $98
      .BYTE $48
      .BYTE $92
      .BYTE $46
      .BYTE $48
      .BYTE $7E
      .BYTE $46
      .BYTE $92
      .BYTE $3E
      .BYTE $7E
      .BYTE $3A
      .BYTE $38
      .BYTE $7E
      .BYTE $98
      .BYTE $48
      .BYTE $90
      .BYTE $38
      .BYTE $48
      .BYTE $38
      .BYTE $48
      .BYTE $38
      .BYTE $48
      .BYTE $38
      .BYTE $48
      .BYTE $38
      .BYTE $48
      .BYTE $38
      .BYTE $48
      .BYTE $C2
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $3E
      .BYTE $7E
      .BYTE $3A
      .BYTE $7E
      .BYTE $36
      .BYTE $7E
      .BYTE $88
      .BYTE $30
      .BYTE $34
      .BYTE $38
      .BYTE $3E
      .BYTE $42
      .BYTE $3E
      .BYTE $38
      .BYTE $30
      .BYTE $34
      .BYTE $38
      .BYTE $3C
      .BYTE $2A
      .BYTE $82
      .BYTE $34
      .BYTE $7E
      .BYTE $38
      .BYTE $88
      .BYTE $30
      .BYTE $2E
      .BYTE $2A
      .BYTE $26
      .BYTE $3E
      .BYTE $3A
      .BYTE $34
      .BYTE $2E
      .BYTE $26
      .BYTE $88
      .BYTE $2A
      .BYTE $2E
      .BYTE $30
      .BYTE $32
      .BYTE $34
      .BYTE $36
      .BYTE $82
      .BYTE $38
      .BYTE $7E
      .BYTE $2E
      .BYTE $88
      .BYTE $2A
      .BYTE $26
      .BYTE $2E
      .BYTE $92
      .BYTE $5A
      .BYTE $7E
      .BYTE $56
      .BYTE $50
      .BYTE $7E
      .BYTE $9A
      .BYTE $48
      .BYTE $82
      .BYTE $3C
      .BYTE $3E
      .BYTE $7E
      .BYTE $40
      .BYTE $42
      .BYTE $7E
      .BYTE $48
      .BYTE $7E
      .BYTE $7E
      .BYTE $88
      .BYTE $7E
      .BYTE $82
      .BYTE $48
      .BYTE $88
      .BYTE $7E
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $50
      .BYTE $00
      .BYTE $92
      .BYTE $48
      .BYTE $7E
      .BYTE $46
      .BYTE $3E
      .BYTE $7E
      .BYTE $9A
      .BYTE $38
      .BYTE $88
      .BYTE $7E
      .BYTE $82
      .BYTE $7E
      .BYTE $3A
      .BYTE $7E
      .BYTE $38
      .BYTE $7E
      .BYTE $7E
      .BYTE $88
      .BYTE $7E
      .BYTE $82
      .BYTE $38
      .BYTE $88
      .BYTE $7E
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $38
      .BYTE $2A
      .BYTE $2E
      .BYTE $30
      .BYTE $26
      .BYTE $2A
      .BYTE $2E
      .BYTE $30
      .BYTE $82
      .BYTE $7E
      .BYTE $7E
      .BYTE $30
      .BYTE $88
      .BYTE $7E
      .BYTE $7E
      .BYTE $88
      .BYTE $06
      .BYTE $82
      .BYTE $02
      .BYTE $01
      .BYTE $02
      .BYTE $00
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $52
      .BYTE $4E
      .BYTE $7E
      .BYTE $50
      .BYTE $52
      .BYTE $7E
      .BYTE $4E
      .BYTE $50
      .BYTE $7E
      .BYTE $E8
      .BYTE $5E
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $58
      .BYTE $52
      .BYTE $50
      .BYTE $E2
      .BYTE $4C
      .BYTE $E0
      .BYTE $50
      .BYTE $4C
      .BYTE $48
      .BYTE $E2
      .BYTE $46
      .BYTE $7E
      .BYTE $48
      .BYTE $E2
      .BYTE $4C
      .BYTE $7E
      .BYTE $48
      .BYTE $46
      .BYTE $7E
      .BYTE $EA
      .BYTE $48
      .BYTE $E2
      .BYTE $48
      .BYTE $E8
      .BYTE $46
      .BYTE $48
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $E8
      .BYTE $4C
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $4A
      .BYTE $E2
      .BYTE $4C
      .BYTE $7E
      .BYTE $E8
      .BYTE $5A
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $54
      .BYTE $56
      .BYTE $5A
      .BYTE $EA
      .BYTE $5E
      .BYTE $5A
      .BYTE $E8
      .BYTE $58
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $56
      .BYTE $7E
      .BYTE $4C
      .BYTE $46
      .BYTE $7E
      .BYTE $3E
      .BYTE $00
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $3A
      .BYTE $36
      .BYTE $7E
      .BYTE $38
      .BYTE $3A
      .BYTE $7E
      .BYTE $36
      .BYTE $38
      .BYTE $7E
      .BYTE $E8
      .BYTE $46
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $40
      .BYTE $3A
      .BYTE $38
      .BYTE $E2
      .BYTE $34
      .BYTE $E0
      .BYTE $38
      .BYTE $34
      .BYTE $30
      .BYTE $E2
      .BYTE $2E
      .BYTE $7E
      .BYTE $30
      .BYTE $E2
      .BYTE $34
      .BYTE $7E
      .BYTE $30
      .BYTE $2E
      .BYTE $7E
      .BYTE $EA
      .BYTE $30
      .BYTE $E2
      .BYTE $30
      .BYTE $E8
      .BYTE $2E
      .BYTE $30
      .BYTE $E2
      .BYTE $7E
      .BYTE $7E
      .BYTE $E8
      .BYTE $34
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $32
      .BYTE $E2
      .BYTE $34
      .BYTE $7E
      .BYTE $E8
      .BYTE $42
      .BYTE $E2
      .BYTE $7E
      .BYTE $E8
      .BYTE $3C
      .BYTE $3E
      .BYTE $42
      .BYTE $E2
      .BYTE $46
      .BYTE $7E
      .BYTE $44
      .BYTE $46
      .BYTE $7E
      .BYTE $5E
      .BYTE $42
      .BYTE $7E
      .BYTE $40
      .BYTE $42
      .BYTE $7E
      .BYTE $5A
      .BYTE $40
      .BYTE $7E
      .BYTE $3E
      .BYTE $40
      .BYTE $7E
      .BYTE $58
      .BYTE $3E
      .BYTE $7E
      .BYTE $34
      .BYTE $2E
      .BYTE $7E
      .BYTE $26
      .BYTE $88
      .BYTE $38
      .BYTE $46
      .BYTE $40
      .BYTE $3A
      .BYTE $38
      .BYTE $34
      .BYTE $2E
      .BYTE $28
      .BYTE $2A
      .BYTE $2E
      .BYTE $30
      .BYTE $34
      .BYTE $38
      .BYTE $30
      .BYTE $2E
      .BYTE $2A
      .BYTE $34
      .BYTE $38
      .BYTE $3C
      .BYTE $42
      .BYTE $34
      .BYTE $2A
      .BYTE $34
      .BYTE $3C
      .BYTE $3E
      .BYTE $3A
      .BYTE $34
      .BYTE $2E
      .BYTE $34
      .BYTE $2E
      .BYTE $2A
      .BYTE $26
      .BYTE $88
      .BYTE $06
      .BYTE $82
      .BYTE $10
      .BYTE $01
      .BYTE $10
      .BYTE $00
      .BYTE $94
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $36
      .BYTE $34
      .BYTE $36
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $3A
      .BYTE $38
      .BYTE $3A
      .BYTE $00
      .BYTE $94
      .BYTE $7E
      .BYTE $42
      .BYTE $42
      .BYTE $7E
      .BYTE $42
      .BYTE $42
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $42
      .BYTE $42
      .BYTE $7E
      .BYTE $42
      .BYTE $42
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $40
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $40
      .BYTE $7E
      .BYTE $40
      .BYTE $7E
      .BYTE $46
      .BYTE $46
      .BYTE $7E
      .BYTE $46
      .BYTE $46
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $46
      .BYTE $46
      .BYTE $7E
      .BYTE $46
      .BYTE $46
      .BYTE $7E
      .BYTE $46
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $7E
      .BYTE $44
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $7E
      .BYTE $44
      .BYTE $44
      .BYTE $7E
      .BYTE $44
      .BYTE $89
      .BYTE $3C
      .BYTE $3C
      .BYTE $88
      .BYTE $3C
      .BYTE $89
      .BYTE $3C
      .BYTE $3C
      .BYTE $88
      .BYTE $3C
      .BYTE $89
      .BYTE $3A
      .BYTE $3A
      .BYTE $88
      .BYTE $3A
      .BYTE $89
      .BYTE $3A
      .BYTE $3A
      .BYTE $88
      .BYTE $3A
      .BYTE $89
      .BYTE $40
      .BYTE $40
      .BYTE $88
      .BYTE $40
      .BYTE $89
      .BYTE $40
      .BYTE $40
      .BYTE $88
      .BYTE $40
      .BYTE $89
      .BYTE $3E
      .BYTE $3E
      .BYTE $88
      .BYTE $3E
      .BYTE $89
      .BYTE $3E
      .BYTE $3E
      .BYTE $88
      .BYTE $3E
      .BYTE $A9
      .BYTE $56
      .BYTE $54
      .BYTE $A8
      .BYTE $4C
      .BYTE $A9
      .BYTE $54
      .BYTE $52
      .BYTE $A8
      .BYTE $4A
      .BYTE $A9
      .BYTE $52
      .BYTE $50
      .BYTE $A8
      .BYTE $48
      .BYTE $A4
      .BYTE $4E
      .BYTE $AB
      .BYTE $4C
      .BYTE $A4
      .BYTE $7E
      .BYTE $A9
      .BYTE $5A
      .BYTE $58
      .BYTE $A8
      .BYTE $50
      .BYTE $A9
      .BYTE $58
      .BYTE $56
      .BYTE $A8
      .BYTE $4E
      .BYTE $A9
      .BYTE $56
      .BYTE $54
      .BYTE $A8
      .BYTE $4C
      .BYTE $A4
      .BYTE $52
      .BYTE $AB
      .BYTE $50
      .BYTE $A4
      .BYTE $7E
      .BYTE $4E
      .BYTE $4C
      .BYTE $4E
      .BYTE $4C
      .BYTE $4E
      .BYTE $4C
      .BYTE $4E
      .BYTE $4C
      .BYTE $50
      .BYTE $4E
      .BYTE $50
      .BYTE $4E
      .BYTE $50
      .BYTE $4E
      .BYTE $50
; end of 'BANK4'

; ===========================================================================



; -------------------------------------------


; .segment BANK5
; * =  $A000
      .BYTE $4E ; This data continues from the end of bank 4
      .BYTE $52
      .BYTE $50
      .BYTE $52
      .BYTE $50
      .BYTE $52
      .BYTE $50
      .BYTE $52
      .BYTE $50
      .BYTE $54
      .BYTE $52
      .BYTE $54
      .BYTE $52
      .BYTE $54
      .BYTE $52
      .BYTE $54
      .BYTE $52
      .BYTE $00
      .BYTE $A9
      .BYTE $44
      .BYTE $42
      .BYTE $A8
      .BYTE $3A
      .BYTE $A9
      .BYTE $42
      .BYTE $40
      .BYTE $A8
      .BYTE $38
      .BYTE $A9
      .BYTE $40
      .BYTE $3E
      .BYTE $A8
      .BYTE $36
      .BYTE $A4
      .BYTE $3C
      .BYTE $AB
      .BYTE $3A
      .BYTE $A4
      .BYTE $7E
      .BYTE $A9
      .BYTE $48
      .BYTE $46
      .BYTE $A8
      .BYTE $3E
      .BYTE $A9
      .BYTE $46
      .BYTE $44
      .BYTE $A8
      .BYTE $3C
      .BYTE $A9
      .BYTE $44
      .BYTE $42
      .BYTE $A8
      .BYTE $3A
      .BYTE $A4
      .BYTE $42
      .BYTE $AB
      .BYTE $40
      .BYTE $A4
      .BYTE $7E
      .BYTE $A4
      .BYTE $42
      .BYTE $40
      .BYTE $42
      .BYTE $40
      .BYTE $42
      .BYTE $40
      .BYTE $42
      .BYTE $40
      .BYTE $44
      .BYTE $42
      .BYTE $44
      .BYTE $42
      .BYTE $44
      .BYTE $42
      .BYTE $44
      .BYTE $42
      .BYTE $46
      .BYTE $44
      .BYTE $46
      .BYTE $44
      .BYTE $46
      .BYTE $44
      .BYTE $46
      .BYTE $44
      .BYTE $48
      .BYTE $46
      .BYTE $48
      .BYTE $46
      .BYTE $48
      .BYTE $46
      .BYTE $48
      .BYTE $46
      .BYTE $84
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $3E
      .BYTE $44
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $40
      .BYTE $42
      .BYTE $3C
      .BYTE $42
      .BYTE $84
      .BYTE $3A
      .BYTE $88
      .BYTE $3A
      .BYTE $3A
      .BYTE $3A
      .BYTE $84
      .BYTE $3A
      .BYTE $3C
      .BYTE $88
      .BYTE $3C
      .BYTE $3C
      .BYTE $3C
      .BYTE $84
      .BYTE $3C
      .BYTE $3E
      .BYTE $88
      .BYTE $3E
      .BYTE $3E
      .BYTE $3E
      .BYTE $84
      .BYTE $3E
      .BYTE $40
      .BYTE $88
      .BYTE $40
      .BYTE $40
      .BYTE $40
      .BYTE $84
      .BYTE $40
      .BYTE $82
      .BYTE $46
      .BYTE $48
      .BYTE $4A
      .BYTE $4C
      .BYTE $7E
      .BYTE $56
      .BYTE $88
      .BYTE $52
      .BYTE $00
      .BYTE $82
      .BYTE $3E
      .BYTE $42
      .BYTE $44
      .BYTE $46
      .BYTE $7E
      .BYTE $50
      .BYTE $88
      .BYTE $4C
      .BYTE $94
      .BYTE $56
      .BYTE $5A
      .BYTE $60
      .BYTE $3E
      .BYTE $42
      .BYTE $48
      .BYTE $26
      .BYTE $2A
      .BYTE $98
      .BYTE $30
      .BYTE $26
      .BYTE $30
      .BYTE $00
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $30
      .BYTE $98
      .BYTE $7E
      .BYTE $94
      .BYTE $30
      .BYTE $98
      .BYTE $7E
      .BYTE $30
      .BYTE $3A
      .BYTE $38 ; 8
      .BYTE $88
      .BYTE $7E
      .BYTE $89
      .BYTE $60
      .BYTE $48
      .BYTE $88
      .BYTE $30
      .BYTE $3E
      .BYTE $30
      .BYTE $94
      .BYTE $42
      .BYTE $48
      .BYTE $4C
      .BYTE $42
      .BYTE $48
      .BYTE $4C
      .BYTE $3E
      .BYTE $42
      .BYTE $50
      .BYTE $3E
      .BYTE $42
      .BYTE $52
      .BYTE $50
      .BYTE $48
      .BYTE $42
      .BYTE $7E
      .BYTE $3A
      .BYTE $42
      .BYTE $48
      .BYTE $50
      .BYTE $4C
      .BYTE $3E
      .BYTE $42
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $26
      .BYTE $2A
      .BYTE $7E
      .BYTE $26
      .BYTE $20
      .BYTE $7E
      .BYTE $98
      .BYTE $18
      .BYTE $26
      .BYTE $30
      .BYTE $7E
      .BYTE $00
      .BYTE $88
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $30
      .BYTE $7E
      .BYTE $34
      .BYTE $7E
      .BYTE $38
      .BYTE $7E
      .BYTE $42
      .BYTE $7E
      .BYTE $46
      .BYTE $48
      .BYTE $94
      .BYTE $3E
      .BYTE $98
      .BYTE $42
      .BYTE $94
      .BYTE $3E
      .BYTE $98
      .BYTE $38
      .BYTE $30
      .BYTE $7E
      .BYTE $9A
      .BYTE $48
      .BYTE $88
      .BYTE $3A
      .BYTE $52
      .BYTE $3C
      .BYTE $54
      .BYTE $3E
      .BYTE $56
      .BYTE $42
      .BYTE $5A
      .BYTE $4C
      .BYTE $3A
      .BYTE $3E
      .BYTE $4C
      .BYTE $48
      .BYTE $7E
      .BYTE $7E
      .BYTE $7E
      .BYTE $48
      .BYTE $3E
      .BYTE $30
      .BYTE $7E
      .BYTE $89
      .BYTE $40
      .BYTE $84
      .BYTE $40
      .BYTE $88
      .BYTE $40
      .BYTE $88
      .BYTE $56
      .BYTE $56
      .BYTE $52
      .BYTE $8B
      .BYTE $50
      .BYTE $00
      .BYTE $89
      .BYTE $36
      .BYTE $84
      .BYTE $36
      .BYTE $88
      .BYTE $36
      .BYTE $88
      .BYTE $44
      .BYTE $88
      .BYTE $44
      .BYTE $88
      .BYTE $40
      .BYTE $8B
      .BYTE $3E
      .BYTE $89
      .BYTE $40
      .BYTE $84
      .BYTE $40
      .BYTE $88
      .BYTE $40
      .BYTE $88
      .BYTE $4E
      .BYTE $4E
      .BYTE $4A
      .BYTE $8B
      .BYTE $48
      .BYTE $84
      .BYTE $7E
      .BYTE $82
      .BYTE $4E
      .BYTE $7E
      .BYTE $46
      .BYTE $3E
      .BYTE $7E
      .BYTE $3A
      .BYTE $8A
      .BYTE $38
      .BYTE $00
      .BYTE $84
      .BYTE $7E
      .BYTE $82
      .BYTE $3E
      .BYTE $7E
      .BYTE $34
      .BYTE $2E
      .BYTE $7E
      .BYTE $2A
      .BYTE $8A
      .BYTE $26
      .BYTE $84
      .BYTE $7E
      .BYTE $88
      .BYTE $46
      .BYTE $3E
      .BYTE $8A
      .BYTE $30
byte_BANK5_A18D:
      .BYTE $90

InstrumentSoundData:
      .BYTE $95 ; @TODO Should this label be moved up? oops
      .BYTE $95
      .BYTE $95
      .BYTE $95
      .BYTE $95
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $97
      .BYTE $97
      .BYTE $97
      .BYTE $97
      .BYTE $98
      .BYTE $98
byte_BANK5_A1CD:
      .BYTE $90

      .BYTE $92
      .BYTE $94
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $96
      .BYTE $97
      .BYTE $97
      .BYTE $97
      .BYTE $97
      .BYTE $98
      .BYTE $98
byte_BANK5_A1E4:
      .BYTE $51

      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $53
      .BYTE $54
      .BYTE $55
      .BYTE $56
      .BYTE $57
      .BYTE $58
      .BYTE $59
      .BYTE $5A
      .BYTE $5B
byte_BANK5_A224:
      .BYTE $51

      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $53
      .BYTE $54
      .BYTE $55
      .BYTE $56
      .BYTE $57
      .BYTE $58
      .BYTE $59
      .BYTE $5A
      .BYTE $5B
byte_BANK5_A23B:
      .BYTE $10

      .BYTE $11
      .BYTE $11
      .BYTE $11
      .BYTE $12
      .BYTE $12
      .BYTE $12
      .BYTE $13
      .BYTE $13
      .BYTE $14
      .BYTE $14
      .BYTE $14
      .BYTE $14
      .BYTE $15
      .BYTE $15
      .BYTE $15
      .BYTE $15
      .BYTE $16
      .BYTE $16
      .BYTE $16
      .BYTE $17
      .BYTE $17
      .BYTE $17
      .BYTE $17
      .BYTE $17
      .BYTE $17
      .BYTE $17
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $19
      .BYTE $19
      .BYTE $19
      .BYTE $1A
      .BYTE $1A
      .BYTE $1B
      .BYTE $1B
      .BYTE $1C
byte_BANK5_A27B:
      .BYTE $10

      .BYTE $11
      .BYTE $12
      .BYTE $13
      .BYTE $14
      .BYTE $15
      .BYTE $16
      .BYTE $17
      .BYTE $17
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $18
      .BYTE $19
      .BYTE $19
      .BYTE $19
      .BYTE $1A
      .BYTE $1A
      .BYTE $1B
      .BYTE $1B
      .BYTE $1C
byte_BANK5_A293:
      .BYTE $51

      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $55
      .BYTE $55
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $56
byte_BANK5_A2D3:
      .BYTE $51

      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $55
      .BYTE $55
      .BYTE $56
      .BYTE $56
byte_BANK5_A2EA:
      .BYTE $51

      .BYTE $52
      .BYTE $53
      .BYTE $54
      .BYTE $54
      .BYTE $55
      .BYTE $56
      .BYTE $56
      .BYTE $57
      .BYTE $58
      .BYTE $59
      .BYTE $5A
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5A
      .BYTE $59
      .BYTE $58
      .BYTE $56
      .BYTE $55
      .BYTE $55
byte_BANK5_A301:
      .BYTE $51

      .BYTE $52
      .BYTE $52
      .BYTE $51
      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $53
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $54
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $55
      .BYTE $56
      .BYTE $56
      .BYTE $56
      .BYTE $57
      .BYTE $57
      .BYTE $57
      .BYTE $57
      .BYTE $57
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $58
      .BYTE $59
      .BYTE $59
      .BYTE $59
      .BYTE $59
      .BYTE $5A
      .BYTE $5A
      .BYTE $5A
      .BYTE $5A
      .BYTE $5A
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5B
      .BYTE $5A
      .BYTE $59
      .BYTE $58
      .BYTE $56
      .BYTE $55
      .BYTE $55
unk_BANK5_A341:
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $53
      .BYTE $54
      .BYTE $55
      .BYTE $56
      .BYTE $57
      .BYTE $58
      .BYTE $19
      .BYTE $DA
      .BYTE $9B
unk_BANK5_A381:
      .BYTE $50
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $53
      .BYTE $54
      .BYTE $55
      .BYTE $56
      .BYTE $57
      .BYTE $58
      .BYTE $19
      .BYTE $DA
      .BYTE $9B
byte_BANK5_A398:
      .BYTE $50

      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $53
      .BYTE $53
      .BYTE $54
      .BYTE $55
byte_BANK5_A3AF:
      .BYTE $50

      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $50
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $51
      .BYTE $52
      .BYTE $52
      .BYTE $52
      .BYTE $53
      .BYTE $53
      .BYTE $54
      .BYTE $55
; The rest of this bank is empty
