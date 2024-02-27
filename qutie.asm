incsrc "def.asm"

freecode

run:
    lda #$80 : sta $2215
    lda.b #!qutie_queue_page : sta $2224
    ldy #$00
    .slot:
        lda.w !qutie_size_lo,y : sta $4325
        lda.w !qutie_size_hi,y : sta $4326
        lda.w !qutie_type,y
        asl
        tax
        jmp (.types,x)
    .next:
        iny
        cpy !qutie_index
        bcc .slot
        stz $2224
        stz !qutie_index
        rtl
    ; ----
    .types:
        dw .gfx_write
        dw .gfx_read
        dw .pal_write
        dw .pal_read
        dw .ccdma
    ; ----
    .ccdma:
        lda.w !qutie_cc_params,y : sta $2231
        lda #$81 : sta $2200
        lda.w !qutie_gp_lo,y : sta $2116
        lda.w !qutie_gp_hi,y : sta $2117
        lda.w !qutie_ram_lo,y : sta $4322 : sta $2232
        lda.w !qutie_ram_hi,y : sta $4323 : sta $2233
        lda.w !qutie_ram_bk,y : sta $4324 : sta $2234
        rep #$20
        lda #$1801 : sta $4320
        lda #$3700 : sta $2235
        sep #$20
        lda #$04 : sta $420b
        lda #$80 : sta $2231
        lda #$82 : sta $2200
        bra .next
    .gfx_read:
        lda #$81 : sta $4320
        lda #$39 : sta $4321
        sec
        bra .gfx_shared
    .gfx_write:
        lda #$01 : sta $4320
        lda #$18 : sta $4321
        clc
    .gfx_shared:
        lda.w !qutie_gp_lo,y : sta $2116
        lda.w !qutie_gp_hi,y : sta $2117
        bcc .set_ram
        lda $213a
        bra .set_ram
    .pal_read:
        lda #$82 : sta $4320
        lda #$3b : sta $4321
        bra .pal_shared
    .pal_write:
        lda #$02 : sta $4320
        lda #$22 : sta $4321
    .pal_shared:
        lda.w !qutie_gp_lo,y  : sta $2121
    .set_ram:
        lda.w !qutie_ram_lo,y : sta $4322
        lda.w !qutie_ram_hi,y : sta $4323
        lda.w !qutie_ram_bk,y : sta $4324
        lda #$04 : sta $420b
        jmp .next