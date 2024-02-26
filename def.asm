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
; ----------------
!pal_slots      = $20
!pal_queue      = $418200
!pal_queue_page = (!pal_queue&$01e000)/$2000
!pal_queue_abs  = $6000+(!pal_queue&$001fff)
!pal_ram_lo     = !pal_queue_abs+(!pal_slots*0)
!pal_ram_hi     = !pal_queue_abs+(!pal_slots*1)
!pal_ram_bk     = !pal_queue_abs+(!pal_slots*2)
!pal_size_lo    = !pal_queue_abs+(!pal_slots*3)
!pal_size_hi    = !pal_queue_abs+(!pal_slots*4)
!pal_num        = !pal_queue_abs+(!pal_slots*5)
!pal_index      = $317d