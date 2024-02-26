; dma types :
; - negative, first bit clear -> standard vram backup (ram <- vram)
; - negative, first bit set   -> standard vram upload (ram -> vram)
; - positive                  -> ccdma parameters
; ----------------
!qutieSlots     = $40       ; number of slots.
!qutieIndex     = $317c     ; queue index.
!qutieQueue     = $418000   ; queue.
!qutiePage      = (!qutieQueue&$01e000)/$2000       ; sas page of queue, as single byte.
!qutieAbsolute  = $6000+(!qutieQueue&$001fff)       ;                    as ram.
!qutieSourceLo  = !qutieAbsolute+(!qutieSlots*0)    ; ram, lo.
!qutieSourceHi  = !qutieAbsolute+(!qutieSlots*1)    ;      hi.
!qutieSourceBk  = !qutieAbsolute+(!qutieSlots*2)    ;      bank.
!qutieSizeLo    = !qutieAbsolute+(!qutieSlots*3)    ; transfer size, lo.
!qutieSizeHi    = !qutieAbsolute+(!qutieSlots*4)    ;                hi.
!qutieVramLo    = !qutieAbsolute+(!qutieSlots*5)    ; vram position, lo.
!qutieVramHi    = !qutieAbsolute+(!qutieSlots*6)    ;                hi.
!qutieType      = !qutieAbsolute+(!qutieSlots*7)    ; transfer type.
