;1E000 - 1FFFF

{ ;E4BF - E4EB
rng:
    inc rng+2
    ror rng+1
    ror rng+0
    lda rng+1
    sec
    sbc $22
    clc
    adc $1B
    eor $02
    eor rng+0
    sta rng+1
    lda rng+0
    clc
    adc $1A
    adc rng+2
    eor rng+1
    sec
    sbc $23
    sta rng+0
    rts
}

{ ;EEEB - F168
_1EEEB:
    stx $4D
    ldx $4F
    lda $F3EA,X
    clc
    ldy #$02
    adc ($48),Y
    sta $1A
    lda $F408,X
    iny
    adc ($48),Y
    sta $1B
    lda #$C0 : sta $22 ;looks like a 16-bit pointer
    lda #$63 : sta $23
    lda $F3EA,X
    clc
    ldy #$00
    adc ($48),Y
    sta $26
    lda $F408,X
    iny
    adc ($48),Y
    sta $27
    lda #$00 : sta $2A
    lda #$60 : sta $2B
    lda $50 : sec : sbc $4F : tax
.EF29:
    ldy #$3F
.EF2B:
    lda ($1A),Y : sta ($22),Y
    lda ($26),Y : sta ($2A),Y
    dey
    bpl .EF2B

    lda $1A : clc : adc #$40 : sta $1A
    bcc .EF41

    inc $1B
.EF41:
    lda $22 : clc : adc #$40 : sta $22
    bcc .EF4C

    inc $23
.EF4C:
    lda $26 : clc : adc #$40 : sta $26
    bcc .EF57

    inc $27
.EF57:
    lda $2A : clc : adc #$40 : sta $2A
    bcc .EF62

    inc $2B
.EF62:
    dex
    bne .EF29

    lda #$C0 : sta $22 
    lda #$63 : sta $23
    lda $4F : sta $26
    lda $50 : sec : sbc $4F : sta $28
.EF78:
    lda #$00 : sta $27
.EF7C:
    ldx $27
    lda $26
    clc
    adc #$04
    tay
    jsr _1F30F
    ldy #$00
    lda ($22),Y
    beq .EF98

    lda #$FF : and $7182 : ora $6780,X : sta $6780,X
.EF98:
    inc $22
    bne .EF9E

    inc $23
.EF9E:
    inc $27
    lda $27
    cmp #$40
    bne .EF7C

    inc $26
    dec $28
    bne .EF78

    ldy #$00
    lda ($4B),Y
    sta $54
    iny
    lda ($4B),Y : sta $53
    ldy #$0E
    lda ($48),Y : sta $7186
    lda #$00 : sta $1A
.EFC2:
    jsr rng
    cmp $53
    bcs .EFC2

    ldy #$00
.EFCB:
    cpy $1A
    beq .EFD7

    cmp $6900,Y
    beq .EFC2

    iny
    bne .EFCB

.EFD7:
    sta $6900,Y
    inc $1A
    lda $1A
    cmp $53
    bne .EFC2

    lda $4B : clc : adc #$02 : sta $4B
    bcc .EFED

    inc $4C
.EFED:
    lda $4D
    cmp $4A
    beq .EFF6

    jmp .F06A

.EFF6:
    jsr rng : and #$0F ; random number 0-15
    beq .F01F

    cmp $54
    bcs .EFF6

    sta $1A
.F003:
    lda $4B : clc : adc #$06 : sta $4B
    bcc .F00E

    inc $4C
.F00E:
    dec $1A
    bne .F003

    ldy #$00
    lda ($4B),Y : sta $718D
    iny
    lda ($4B),Y : sta $718E
.F01F:
    jsr rng : and #$0F ;random number 0-15
    sta $23
    clc
    adc $4F
    sta $22
    sta waldo_y
    ldy #$01
    clc
    adc ($4B),Y
    cmp $50
    beq .F039

    bcs .F01F

.F039:
    jsr rng : and #$3F ;random number 0-63
    ldx difficulty
    cmp level_width,X
    bcs .F039 ;roll a new number if it's out of range for the current difficulty

    cmp #$02
    bcc .F039 ;also roll a new number if less than 2

    sta $24
    sta waldo_x
    jsr _1F26A
    bcs .F01F

    lda $7185
    bne $F01F

    lda difficulty
    bne .F067

    lda $7186 : sta $7180
    dec $7185
.F067:
    jsr _1F169_F1AC
.F06A:
    ldy #$05
    lda ($4B),Y
    bpl .F07D

    lda $4B : clc : adc #$06 : sta $4B
    bcc .F06A

    inc $4C
    bne .F06A

.F07D:
    lda $4B : sta $4D
    lda $4C : sta $4E
    ldx #$00
.F087:
    ldy #$04
    lda ($4B),Y : sta $6880,X
    lda $4B : clc : adc #$06 : sta $4B
    bcc .F099

    inc $4C
.F099:
    inx
    cpx $53
    bne .F087

.F09E:
    lda #$00 : sta $52 : sta $51
.F0A4:
    lda $4D : sta $4B
    lda $4E : sta $4C
    ldy $51
    lda $6900,Y
    tax
    tay
    beq .F0C3

.F0B5:
    lda $4B : clc : adc #$06 : sta $4B
    bcc .F0C0

    inc $4C
.F0C0:
    dey
    bne .F0B5

.F0C3:
    lda $6880,X
    beq .F0DF

    jsr _1F169
    bcs .F0DF

    ldy $51
    ldx $6900,Y
    lda $6880,X
    cmp #$FF
    beq .F0F1

    dec $6880,X
    jmp .F0F1

.F0DF:
    ldy $51
    ldx $6900,Y
    lda #$00 : sta $6880,X
    inc $52
    lda $52
    cmp $53
    beq .F0FB

.F0F1:
    inc $51
    lda $51
    cmp $53
    bne .F0A4

    beq .F09E

.F0FB:
    lda #$00 : sta $2A
    lda #$60 : sta $2B
    lda $4F : clc : adc #$04 : tax
    lda $9EFE,X : clc : adc #$80 : sta $1A
    lda $9EE0,X       : adc #$49 : sta $1B
    jsr .F13E
    lda #$20 : sta $2A
    lda #$60 : sta $2B
    lda $4F
    clc
    adc #$04
    tax
    lda $4F
    clc
    adc #$04
    tax
    lda $9EFE,X : clc : adc #$80 : sta $1A
    lda $9EE0,X       : adc #$4D : sta $1B
.F13E:
    lda $50 : sec : sbc $4F : tax
.F144:
    ldy #$00
.F146:
    lda ($2A),Y : sta ($1A),Y
    iny
    cpy #$20
    bne .F146

    lda $2A : clc : adc #$40 : sta $2A
    bcc .F15A

    inc $2B
.F15A:
    lda $1A : clc : adc #$20 : sta $1A
    bcc .F165

    inc $1B
.F165:
    dex
    bne .F144

    rts
}

{ ;F169 - F269
_1F169:
    lda $4F  : sta $22
    lda #$00 : sta $23
.F171:
    lda #$00 : sta $24
.F175:
    jsr _1F26A
    bcs .F192

    ldy #$05
    lda ($4B),Y
    cmp #$40
    bcc .F1AC

    ldy $7185
    bne .F192

    and #$03
    sta $7180
    dec $7185
    jmp .F1AC

.F192:
    inc $24
    lda $24
    cmp #$40
    bne .F175

    inc $23
    inc $22
    lda $22
    ldy #$01
    clc
    adc ($4B),Y
    cmp $50
    beq .F171
    bcc .F171

    rts

.F1AC:
    jsr rng : and #$03 : sta $7181
    ldx $23
    lda $F3EA,X : clc : adc #$C0 : sta $1A
    lda $F408,X       : adc #$63 : sta $1B
    lda $1A     : clc : adc $24  : sta $1A
    bcc .F1D0

    inc $1B
.F1D0:
    lda $F3EA,X : clc : adc #$00 : sta $2A
    lda $F408,X       : adc #$60 : sta $2B
    lda $2A     : clc : adc $24  : sta $2A
    bcc .F1EA

    inc $2B
.F1EA:
    ldy #$02
    lda ($4B),Y : sta $26
    iny
    lda ($4B),Y : sta $27
    ldy #$01
    lda ($4B),Y : sta $1C
.F1FB:
    ldy #$00
    lda ($4B),Y : sta $1D
.F201:
    lda ($26),Y : sta ($2A),Y
    lda #$01    : sta ($1A),Y
    iny
    dec $1D
    bne .F201

    ldy #$00
    lda ($4B),Y : sta $1D
    lda $24 : pha
    lda $1A : pha
.F21A:
    ldx $24
    lda $22
    clc
    adc #$04
    tay
    jsr _1F30F
    ldy $7181
    lda $7185
    beq .F230

    ldy $7180
.F230:
    jsr _1F339
    inc $24
    dec $1D
    bne .F21A

    pla : sta $1A
    pla : sta $24
    lda $1A : clc : adc #$40 : sta $1A
    bcc .F24A

    inc $1B
.F24A:
    lda $2A : clc : adc #$40 : sta $2A
    bcc .F255

    inc $2B
.F255:
    ldy #$00
    lda ($4B),Y : clc : adc $26 : sta $26
    bcc .F262

    inc $27
.F262:
    inc $22
    dec $1C
    bne .F1FB

    clc
    rts
}

{ ;F26A - F30E
_1F26A:
    lda $22 : pha
    ldx $23
    lda $F3EA,X : clc : adc #$C0 : sta $1A
    lda $F408,X       : adc #$63 : sta $1B
    lda $1A     : clc : adc $24  : sta $1A
    bcc .F289

    inc $1B
.F289:
    ldy #$01
    lda ($4B),Y : sta $1C
    lda #$00    : sta $7185
.F294:
    ldy #$00
    lda ($4B),Y : sta $1D
.F29A:
    lda ($1A),Y
    bne .F30A

    iny
    dec $1D
    bne .F29A

    lda $24
    pha
    ldy #$00
    lda ($4B),Y : sta $1D
.F2AC:
    lda $22
    clc
    adc #$04
    tay
    ldx $24
    jsr _1F30F
    ldy $7185
    bne .F2CF

    tay
    lda $6800,X
    and $7182
.F2C3:
    cmp #$04
    bcc .F2CB

    lsr #2
    bne .F2C3

.F2CB:
    sta $7180
    tya
.F2CF:
    ora $7185
    sta $7185
    lda $6800,X
    and $7182
.F2DB:
    cmp #$04
    bcc .F2E3

    lsr #2
    bne .F2DB

.F2E3:
    cmp $7180
    bne .F307

    inc $24
    dec $1D
    bne .F2AC

    pla : sta $24
    lda $1A : clc : adc #$40 : sta $1A
    bcc .F2FC

    inc $1B
.F2FC:
    inc $22
    dec $1C
    bne .F294

    pla : sta $22
    clc
    rts

.F307:
    pla : sta $24
.F30A:
    pla : sta $22
    sec
    rts
}

{ ;F30F - F338
_1F30F:
    lda $F444,X : clc : adc $F426,Y : sta $7184
    tya
    and #$02
    bne .F324

    lda $F484,X
    jmp .F327

.F324:
    lda $F4C4,X
.F327:
    sta $7182
    eor #$FF
    sta $7183
    ldx $7184
    lda $6780,X
    and $7182
    rts
}

{ ;F339 - F357
_1F339:
    lda mask,Y  : and $7182               : sta $1A
    lda $6800,X : and $7183 : ora $1A     : sta $6800,X
    lda #$FF    : and $7182 : ora $6780,X : sta $6780,X
    rts
}

{ ;F504 - F50A
    mask: db $00, $55, $AA, $FF
    level_width: db $1E, $2E, $3E
}
