PUBLIC _copyToGraph
PUBLIC _graphToDisp
PUBLIC _copyToDisp
PUBLIC _clearDisp
PUBLIC _getKey

._copyToGraph
	ld hl, 2
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)

	ld hl, de
	ld de, $9340
    ld bc, 64*12
    ldir

	ret

lcd_busy_2:
	push af
	call $000B ; = LCD_BUSY_QUICK
	pop af
	ret

._graphToDisp
	di
	ld hl, $9340
	ld b, 64
	ld a, $07
	call lcd_busy_2
	out ($10), a
	ld a, $7f

graphToDisp_loop1:
	push bc
	inc a
	ld ($8451), a
	call lcd_busy_2
	out ($10), a
	ld a, $20
	call lcd_busy_2
	out ($10), a
	ld b, 12
graphToDisp_loop2:
	ld a, (hl)
	inc hl
	call lcd_busy_2
	out ($11), a
	djnz graphToDisp_loop2

	pop bc
	ld a, ($8451)
	djnz graphToDisp_loop1

	ld a, $05
	call lcd_busy_2
	out ($10), a
	ei
	ret

._copyToDisp
	di

	ld hl, 2
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld hl, de

	ld b, 64
	ld a, $07
	call lcd_busy_2
	out ($10), a
	ld a, $7f

copyToDisp_loop1:
	push bc
	inc a
	ld ($8451), a
	call lcd_busy_2
	out ($10), a
	ld a, $20
	call lcd_busy_2
	out ($10), a
	ld b, 12
copyToDisp_loop2:
	ld a, (hl)
	inc hl
	call lcd_busy_2
	out ($11), a
	djnz copyToDisp_loop2

	pop bc
	ld a, ($8451)
	djnz copyToDisp_loop1

	ld a, $05
	call lcd_busy_2
	out ($10), a
	ei
	ret

._clearDisp ; Not executing these instruction, it's a bcall
	rst $28
	ld b, b
	ld b, l
	ret

._getKey ; First 3 instructions are a bcall
	rst $28
	ld (hl), d
	ld c, c
	
	ld h, 0
	ld l, a
	ret