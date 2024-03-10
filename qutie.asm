incsrc "def.asm"

freecode

run:
    lda #$80 : sta $2115
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
        lda #$81 : sta $2200 ; step 1
        lda.w !qutie_gp_lo,y : sta $2116
        lda.w !qutie_gp_hi,y : sta $2117
        lda #$01 : sta $4320
        lda #$18 : sta $4321
        lda.w !qutie_ram_lo,y : sta $2232 : sta $4322 ; \ step 2
        lda.w !qutie_ram_hi,y : sta $2233 : sta $4323 ; |
        lda.w !qutie_ram_bk,y : sta $2234 : sta $4324 ; /
        lda.w !qutie_cc_params,y : sta $2231 ; step 3
        stz $2235 ; \ step 4
        lda #$37  ; |
        sta $2236 ; /
        -         ; \ step 5
        lda $2300 ; |
        bit #$20  ; |
        beq -     ; /
        lda #$04 : sta $420b ; step 6
        lda #$80 : sta $2231 ; \ step 7
        lda #$82 : sta $2200 ; /
        jmp .next
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