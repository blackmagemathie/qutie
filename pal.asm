pal_runWrites:
    ldx !pal_index          ; get queue index into x.
    bne +                   ; zero?
    rtl                     ; if yes, return.
    +
    lda.b #!pal_queue_page  ; adjust sas mapping.
    sta $2224               ;
    lda #$02                ; set dma parameters.
    sta $4320               ;
    lda #$22                ; set target register.
    sta $4321               ;
    ldy #$00                ; initialise queue index.
    .loop:
        lda.w !pal_size_lo,y    ; set transfer size.
        sta $4325               ;
        lda.w !pal_size_hi,y    ;
        sta $4326               ;
        lda.w !pal_num,y        ; set palette number to start at.
        sta $2121               ;
        lda.w !pal_ram_lo,y     ; set source ram.
        sta $4322               ;
        lda.w !pal_ram_hi,y     ;
        sta $4323               ;
        lda.w !pal_ram_bk,y     ;
        sta $4324               ;
        lda #$04                ; execute dma.
        sta $420b               ;
    .next:
        iny         ; next queue slot.
        dex         ; current slot done.
        bne .loop   ; all done? if no, keep going.
    .done
        stz $2224       ; restore sas mapping.
        stz !pal_index  ; clear queue index.
        rtl             ;