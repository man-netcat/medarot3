INCLUDE "game/src/common/constants.asm"

SECTION "Bank Tracking 1", WRAM0[$C4C0]
ReturnBank:: ds 1

SECTION "Bank Tracking 2", WRAM0[$C4C2]
CurrentBank:: ds 1

SECTION "rst0", ROM0[$0]
Rst00::
  pop hl
  add a ;a = a+a
  rst $28
  ld a, [hli] ; a = *hl++
  ld h, [hl] ; h = *hl
  ld l, a ;l = a
  jp hl

SECTION "rst8",ROM0[$8] ;Return, enable interrupt
Rst08::
  ld [$C4CE], a
  ldh [hRegSVBK], a
  ret

SECTION "rst10, bank swap",ROM0[$10]
Rst10::
  ld [CurrentBank], a
  ld [$2000], a
  ret

SECTION "rst18",ROM0[$18] ;Bank swap from memory
Rst18::
  ld a, [ReturnBank]
  jr Rst10

SECTION "rst20",ROM0[$20]
Rst20::
  ldh a, [hLCDStat]
  and 2
  jr nz, Rst20
  ret

SECTION "rst28",ROM0[$28]
Rst28::
  ld b, 0
  ld c, a
  sla c
  rl b
  ret
 
SECTION "rst30",ROM0[$30]
Rst30::
  rst $28
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ret

SECTION "rst38",ROM0[$38]
Rst38::
  ret
