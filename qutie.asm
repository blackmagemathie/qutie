incsrc "def.asm"

freecode

incsrc "pal.asm"
    
process:
    ldx !qutieIndex     ; get queue index into x.
    bne +               ; zero?
    rtl                 ; if yes, return.
    +
    lda #$80            ; set vram incrementation mode.
    sta $2215           ;
    lda.b #!qutiePage   ; adjust sas mapping.
    sta $2224           ;
    ldy #$00            ; initialise queue index.
    -
    lda.w !qutieSizeLo,y    ; set transfer size.
    sta $4325               ; 
    lda.w !qutieSizeHi,y    ;
    sta $4326               ;
    lda.w !qutieVramLo,y    ; set vram position.
    sta $2116               ;
    lda.w !qutieVramHi,y    ;
    sta $2117               ;
    lda.w !qutieType,y      ; type positive?
    bpl .ccdma              ; if yes, perform ccdma.
    
    .regular:
        lda.w !qutieSourceLo,y  ; set ram position.
        sta $4322               ;
        lda.w !qutieSourceHi,y  ;
        sta $4323               ;
        lda.w !qutieSourceBk,y  ;
        sta $4324               ;
        lda.w !qutieType,y      ; backup or upload?
        lsr                     ;
        bcs +                   ;
        lda #$81                ; set dma parameters.
        sta $4320               ;
        lda #$39                ; set target register.
        sta $4321               ;
        lda $213a               ; (necessary dummy read)
        bra .activate
        +
        lda #$01                ; set dma parameters.
        sta $4320               ;
        lda #$18                ; set target register.
        sta $4321               ;
        bra .activate
        
    .ccdma:
        sta $2231               ; set ccdma parameters.
        lda #$81                ; tell sa1 to enable ccdma.
        sta $2200               ;
        lda.w !qutieSourceLo,y  ; set source.
        sta $4322               ;
        sta $2232               ;
        lda.w !qutieSourceHi,y  ;
        sta $4323               ;
        sta $2233               ;
        lda.w !qutieSourceBk,y  ;
        sta $4324               ;
        sta $2234               ;
        rep #$20
        lda #$1801              ; set dma parameters, and target register.
        sta $4320               ;
        lda #$3700              ; use i-ram buffer at $3700.
        sta $2235               ;
        sep #$20
        lda #$04                ; execute ccdma.
        sta $420b               ;
        lda #$80                ; signal end of conversion.
        sta $2231               ;
        lda #$82                ; tell sa1 to disable ccdma.
        sta $2200               ;
        bra .next
        
    .activate:
        lda #$04    ; execute dma.
        sta $420b   ;
        
    .next:
        iny             ; next queue slot.
        dex             ; current slot done.
        beq +           ; all done?
        jmp -           ; if no, keep going.
        +
        stz $2224       ; restore sas mapping.
        stz !qutieIndex ; clear queue index.
        rtl             ;