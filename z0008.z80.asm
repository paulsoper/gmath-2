; z0008.asm
; 2024 01 12
; 
; 
            .ORG    0800h 
            .BINFROM 0800h 
            .BINTO  2000h 
; 
;==============================================================
START:               
            LD      sp,0FFFEh 
            LD      a,48h 
            LD      b,0BFh 
            LD      c,7Dh 
            LD      de,254Ah 
            LD      hl,9000h 
; 
            CALL    register_dump 
            CALL    main_menu 
; 
; 
LEVEL_1_COMMAND_LOOP:  
; 
            CALL    get_char 
; 
            CP      72h ; is it "r"?
            CALL    z,register_dump 
            CP      64h ; is it "d"?
            CALL    z,memory_dump 
            CP      68h ; is it "h"?
            CALL    z,get_hl 
            CP      65h ; is it "e"?
            CALL    z,get_de 
            CP      20h ; is it " "?
            CALL    z,load_hl 
            CP      39h ; is it "9"?
            CALL    z,reset_9 
            CP      6Dh ; is it "m"?
            CALL    z,math_commands 
; 
            JP      level_1_command_loop 
; 
            RET      
; 
;==============================================================
REGISTER_DUMP:       
            PUSH    af 
            CALL    out_crlf 
            LD      a,41h ; "A"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            POP     af 
            PUSH    af 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,42h ; "B"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,b 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,43h ; "C"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,c 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,44h ; "D"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,d 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,45h ; "E"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,e 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,48h ; "H"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,h 
            CALL    out_byte 
            CALL    out_4_space 
; 
            LD      a,4Ch ; "L"
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
            LD      a,l 
            CALL    out_byte 
            CALL    out_4_space 
; 
            CALL    out_crlf 
            CALL    out_crlf 
; 
            POP     af 
; 
            RET      
; 
;==============================================================
MEMORY_DUMP:         
; dump 16 bytes of memory at from (hl)...
; 
            PUSH    af 
; 
; output address, then a colon
            LD      a,h 
            CALL    out_byte 
            LD      a,l 
            CALL    out_byte 
            CALL    out_colon 
            CALL    out_4_space 
; 
            LD      b,10h 
; 
MD_LOOP:             
            LD      a,(hl) 
            CALL    out_byte 
            CALL    out_space 
            INC     hl 
            DJNZ    md_loop 
; 
            CALL    out_crlf 
; 
            POP     af 
            RET      
; 
;==============================================================
GET_HL:              
            PUSH    af 
            LD      a,48h 
            CALL    out_character 
            LD      a,4Ch 
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
; 
            CALL    get_good_hex 
            LD      b,a 
            CALL    out_character 
            CALL    get_good_hex 
            LD      c,a 
            CALL    out_character 
            CALL    chars_to_byte 
            LD      h,a 
            CALL    get_good_hex 
            LD      b,a 
            CALL    out_character 
            CALL    get_good_hex 
            LD      c,a 
            CALL    out_character 
            CALL    chars_to_byte 
            LD      l,a 
; 
            CALL    out_crlf 
; 
            POP     af 
            RET      
; 
;==============================================================
GET_DE:              
            PUSH    af 
            LD      a,44h 
            CALL    out_character 
            LD      a,45h 
            CALL    out_character 
            CALL    out_colon 
            CALL    out_space 
; 
            CALL    get_good_hex 
            LD      b,a 
            CALL    out_character 
            CALL    get_good_hex 
            LD      c,a 
            CALL    out_character 
            CALL    chars_to_byte 
            LD      d,a 
            CALL    get_good_hex 
            LD      b,a 
            CALL    out_character 
            CALL    get_good_hex 
            LD      c,a 
            CALL    out_character 
            CALL    chars_to_byte 
            LD      e,a 
; 
            CALL    out_crlf 
; 
            POP     af 
            RET      
; 
;==============================================================
LOAD_HL:             
            PUSH    af 
            LD      a,h 
            CALL    out_byte 
            LD      a,l 
            CALL    out_byte 
            CALL    out_colon 
            CALL    out_space 
; 
            CALL    get_good_hex 
            LD      b,a 
            CALL    out_character 
            CALL    get_good_hex 
            LD      c,a 
            CALL    out_character 
            CALL    chars_to_byte 
            LD      (hl),a 
            INC     hl 
            CALL    out_crlf 
; 
            POP     af 
            RET      
; 
; 
;==============================================================
RESET_9:             
            LD      hl,9000h 
            RET      
; 
;==============================================================
GET_GOOD_HEX:        
            CALL    get_char 
            CP      30h 
            RET     z 
            CP      31h 
            RET     z 
            CP      32h 
            RET     z 
            CP      33h 
            RET     z 
            CP      34h 
            RET     z 
            CP      35h 
            RET     z 
            CP      36h 
            RET     z 
            CP      37h 
            RET     z 
            CP      38h 
            RET     z 
            CP      39h 
            RET     z 
            CP      41h 
            RET     z 
            CP      42h 
            RET     z 
            CP      43h 
            RET     z 
            CP      44h 
            RET     z 
            CP      45h 
            RET     z 
            CP      46h 
            RET     z 
            JP      get_good_hex 
; 
            RET      
; 
; 
;==============================================================
CHARS_TO_BYTE:       
; put the chars in b and c into a as a byte
            PUSH    de 
; 
            LD      a,b 
            CALL    char_to_nibble 
            LD      d,a 
            LD      a,c 
            CALL    char_to_nibble 
            LD      e,a 
            LD      a,d ; put the high order nibble into a
            SLA     a ; multiply by 16
            SLA     a 
            SLA     a 
            SLA     a 
            ADD     a,e ; add in the low order nibble
; 
            POP     de 
            RET      
; 
CHAR_TO_NIBBLE:      
; take the character in a and turn it into a nibble in a
            CP      3Ah ; is the character A-F
            JR      c,ctn_smaller 
            SUB     07h 
CTN_SMALLER:         
            SUB     30h 
; 
            RET      
; 
; 
;==============================================================
OUT_BYTE:            
; outputs the byte in a
;first, output the most significant byte
            PUSH    af ; preserve a
            RRA      ; shift the most significant nibble into the ls spot
            RRA      
            RRA      
            RRA      
            CALL    out_nibble ; output the nibble
            POP     af ; restore a
            CALL    out_nibble ; output the least significant nibble
            RET      
; 
; 
;==============================================================
OUT_NIBBLE:          
; outputs the least significant nibble in a
; 
            PUSH    af 
            AND     0fh ; choose the least significant nibble in a
            OR      30h ; convert number to ascii
            CP      3Ah ; is the digit bigger than 9?
            JP      c,smaller ; no, just output it
            ADD     a,07h ; yes, add 7 to get it to A-F
SMALLER:             
            CALL    out_character ; send to output
            POP     af 
            RET      
; 
;==============================================================
OUT_SPACE:           
            PUSH    af 
            LD      a,20h ; <sp>
            CALL    out_character 
            POP     af 
            RET      
; 
;==============================================================
OUT_4_SPACE:         
            PUSH    af 
            LD      a,20h ; <sp>
            CALL    out_character 
            CALL    out_character 
            CALL    out_character 
            CALL    out_character 
            POP     af 
            RET      
; 
;==============================================================
OUT_COLON:           
            PUSH    af 
            LD      a,3Ah ; ":"
            CALL    out_character 
            POP     af 
            RET      
; 
;==============================================================
OUT_CHARACTER:       
; output a character in a
; 
; for z80_workbench emulator
;out	(1),a			
; 
; for cpuville sbc
; 
            PUSH    af 
; 
STATUS_CHECK:        
            IN      a,(3) ; get status
            AND     001h ; check TxRDY bit
            JR      z,status_check ; loop if not ready
; 
            POP     af 
            OUT     (2),a 
            RET      
; 
;==============================================================
OUT_CRLF:            
            PUSH    af 
            LD      a,0Dh ; <cr>
            CALL    out_character 
            LD      a,0Ah ; <lf>
            CALL    out_character 
            POP     af 
            RET      
; 
;==============================================================
GET_CHAR:            
GET_CHAR_LOOP:       
            IN      a,(3) 
            AND     002h 
            JR      z,get_char_loop 

            IN      a,(2) 
; 
            RET      
; 
;==============================================================
OUT_LINE:            
            PUSH    af 
            PUSH    bc 
NEXT_CHAR:           
            LD      a,(hl) 
            CALL    out_character 
            INC     hl 
            CP      0 
            JR      nz,next_char 
            CALL    out_crlf 
            POP     bc 
            POP     af 
            RET      
; 
;==============================================================
MATH_COMMANDS:       
; 
            PUSH    hl 
            LD      hl,title_math_operations 
            CALL    out_line 
            POP     hl 
; 
LEVEL_M_COMMAND_LOOP:  
; 
            PUSH    hl 
            CALL    math_operations_menu 
            CALL    out_crlf 
            POP     hl 
; 
            CALL    get_char 
; 
            CP      61h ; is it "a"?
            CALL    z,add_8 
            CP      62h ; is it "b"?
            CALL    z,sub_8 
            CP      63h ; is it "c"?
            CALL    z,ms_8 
            CP      64h ; is it "d"?
            CALL    z,ds_8 
            CP      71h ; is it "q"?
            JR      z,back_to_main 
; 
            JR      level_m_command_loop 
; 
BACK_TO_MAIN:        
            CALL    main_menu 
            CALL    out_crlf 
            LD      a,00h 
; 
            RET      
; 
; 
; 
;==============================================================
ADD_8:               
; addend1 in (HL)
; addend2 in (HL+1)
; sum in (DE)
; 
            PUSH    hl 
            LD      a,(hl) 
            INC     hl 
            ADD     a,(hl) 
            LD      (de),a 
            POP     hl 
            RET      
; 
;==============================================================
SUB_8:               
; first term in (HL)
; second term in (HL+1)
; difference in (DE)
; 
            PUSH    hl 
            LD      a,(hl) 
            INC     hl 
            SUB     (hl) 
            LD      (de),a 
            POP     hl 
            RET      
; 
;==============================================================
MS_8:                
; multiply by successive addition
; first term in (HL)
; second term in (HL+1)
; product in (DE)
; 
            PUSH    hl 
            LD      b,(hl) 
            INC     hl 
            LD      c,(hl) 
            XOR     a 
MS_8_LOOP:           
            ADD     a,c 
            DJNZ    ms_8_loop 
            LD      (de),a 
            POP     hl 
            RET      
; 
;==============================================================
DS_8:                
; division by successive subtraction
; numerator in (HL)
; denominator in (HL+1)
; result in (DE)
; remainder in (DE+1)
; 
            PUSH    hl 
            LD      a,(hl) 
            INC     hl 
            LD      c,(hl) 
            DEC     hl 
            LD      b,00h 
; 
DS_8_LOOP:           
            CP      c 
            JR      c,ds_8_done 
            SUB     c 
            INC     b 
            JR      ds_8_loop 
DS_8_DONE:           
            EX      de,hl 
            LD      (hl),b 
            INC     hl 
            LD      (hl),a 
            EX      de,hl 
            POP     hl 
            RET      
; 
;==============================================================
MAIN_MENU:           
            PUSH    hl 
            LD      hl,title_main 
            CALL    out_line 
            LD      hl,usage_main_r 
            CALL    out_line 
            LD      hl,usage_main_d 
            CALL    out_line 
            LD      hl,usage_main_h 
            CALL    out_line 
            LD      hl,usage_main_e 
            CALL    out_line 
            LD      hl,usage_main_space 
            CALL    out_line 
            LD      hl,usage_main_9 
            CALL    out_line 
            LD      hl,usage_main_m 
            CALL    out_line 
            CALL    out_crlf 
            POP     hl 
            RET      
; 
;==============================================================
MATH_OPERATIONS_MENU:  
            PUSH    hl 
            LD      hl,usage_mo_a 
            CALL    out_line 
            LD      hl,usage_mo_b 
            CALL    out_line 
            LD      hl,usage_mo_c 
            CALL    out_line 
            LD      hl,usage_mo_d 
            CALL    out_line 
            LD      hl,usage_mo_q 
            CALL    out_line 
            POP     hl 
            RET      
; 
; 
; 
; 
TITLE_MAIN: DB      "Main",0h 
USAGE_MAIN_R: DB    "r: register dump",0h 
USAGE_MAIN_D: DB    "d: memory dump",0h 
USAGE_MAIN_H: DB    "h: load HL",0h 
USAGE_MAIN_E: DB    "e: load DE",0h 
USAGE_MAIN_SPACE: DB "<SPACE>: load (HL)",0h 
USAGE_MAIN_9: DB    "9: reset HL to 9000h",0h 
USAGE_MAIN_M: DB    "m: math commands",0h 
; 
TITLE_MATH_OPERATIONS: DB "Math operations",0h 
USAGE_MO_A: DB      "a: 8-bit addition",0h 
USAGE_MO_B: DB      "b: 8-bit subtraction",0h 
USAGE_MO_C: DB      "c: 8/8-bit multiplication",0h 
USAGE_MO_D: DB      "d: 8/8-bit division",0h 
USAGE_MO_Q: DB      "q: back to main",0h 
; 
            .END     
; 
; 



