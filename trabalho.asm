
_interrupt:

;trabalho.c,74 :: 		void interrupt(){
;trabalho.c,75 :: 		if (INTCON.TMR0IF == 1){    // Se o flag de estouro do TIMER0 for igual a 1, então
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;trabalho.c,76 :: 		TMR0L = 0X7B;                  // Carrega valores de contagem
	MOVLW       123
	MOVWF       TMR0L+0 
;trabalho.c,77 :: 		TMR0H = 0XE1;                  // Carrega valores de contagem
	MOVLW       225
	MOVWF       TMR0H+0 
;trabalho.c,78 :: 		INTCON.TMR0IF = 0;             // Seta T0IE, apaga flag de entouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,79 :: 		iReg_timer1 = TMR1L*(60/7);    // Pega valor lido do timer1 e multiplica por 60 para saber rotação por minuto.
	MOVLW       3
	MOVWF       R0 
	MOVF        TMR1L+0, 0 
	MOVWF       _iReg_timer1+0 
	MOVLW       0
	MOVWF       _iReg_timer1+1 
	MOVF        R0, 0 
L__interrupt21:
	BZ          L__interrupt22
	RLCF        _iReg_timer1+0, 1 
	BCF         _iReg_timer1+0, 0 
	RLCF        _iReg_timer1+1, 1 
	ADDLW       255
	GOTO        L__interrupt21
L__interrupt22:
;trabalho.c,81 :: 		TMR1L = 0;                     // Limpa contador.
	CLRF        TMR1L+0 
;trabalho.c,82 :: 		}
L_interrupt0:
;trabalho.c,83 :: 		}
L_end_interrupt:
L__interrupt20:
	RETFIE      1
; end of _interrupt

_main:

;trabalho.c,85 :: 		void main(){
;trabalho.c,86 :: 		TRISB = 0;                        // Define PORTB como saida.
	CLRF        TRISB+0 
;trabalho.c,87 :: 		TRISD = 0;                        // Define PORTD como saida.
	CLRF        TRISD+0 
;trabalho.c,88 :: 		TRISC.RC0 = 1;                    // Define PORTC.RC0 como entrada.
	BSF         TRISC+0, 0 
;trabalho.c,89 :: 		TRISC.RC2 = 0;                    // Define PORTC.RC2 como saida.
	BCF         TRISC+0, 2 
;trabalho.c,90 :: 		TRISC.RC5 = 0;                    // Define PORTC.RC5 como saida.
	BCF         TRISC+0, 5 
;trabalho.c,91 :: 		TRISC.RC1 = 0;                    // Define PORTC.RC1 como saida.
	BCF         TRISC+0, 1 
;trabalho.c,92 :: 		TRISB.RB2=1;                      // Define o PORTB.RB3 como saida.
	BSF         TRISB+0, 2 
;trabalho.c,93 :: 		TRISE = 0;                        // Define PORTE como saida.
	CLRF        TRISE+0 
;trabalho.c,96 :: 		INTCON.GIEH = 1;   // Habilita as interrupções e a interrupção de alta prioridade.
	BSF         INTCON+0, 7 
;trabalho.c,97 :: 		INTCON.GIEL = 1;   // Habilita as interrupções e a interrupção de baixa prioridade
	BSF         INTCON+0, 6 
;trabalho.c,98 :: 		RCON.IPEN = 1;     // Configura 2 niveis de interrupção.
	BSF         RCON+0, 7 
;trabalho.c,101 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;trabalho.c,102 :: 		INTCON2.TMR0IP = 1;
	BSF         INTCON2+0, 2 
;trabalho.c,103 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;trabalho.c,105 :: 		T0CON = 0B10000100; // Configura timer modo 16 bits, com prescaler
	MOVLW       132
	MOVWF       T0CON+0 
;trabalho.c,106 :: 		TMR0L = 0X7B;       // Carrega valores de contagem
	MOVLW       123
	MOVWF       TMR0L+0 
;trabalho.c,107 :: 		TMR0H = 0XE1;       // Carrega valores de contagem
	MOVLW       225
	MOVWF       TMR0H+0 
;trabalho.c,108 :: 		INTCON.TMR0IF = 0;  // Apaga flag de estouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,111 :: 		T1CON = 0B10000011; // Liga TIMER1 como Contador em RC0, prescaler 1:1, modo 16bits.
	MOVLW       131
	MOVWF       T1CON+0 
;trabalho.c,112 :: 		TMR1L = 0;          // Carrega valor de contagem baixa do TIMER1
	CLRF        TMR1L+0 
;trabalho.c,113 :: 		TMR1H = 0;          // Carrega valor de contagem alta do TIMER1
	CLRF        TMR1H+0 
;trabalho.c,114 :: 		PIR1.TMR1IF = 0;    // Apaga flag de estouro do TIMER1
	BCF         PIR1+0, 0 
;trabalho.c,116 :: 		ADCON0 = 0b00000001;              // Configura conversor A/D Canal 0, conversão desligada, A/D ligado.
	MOVLW       1
	MOVWF       ADCON0+0 
;trabalho.c,117 :: 		ADCON1 = 0b00001100;              // Configura todos canais como Digital menos AN0,AN1 E AN2 e REF Interna.
	MOVLW       12
	MOVWF       ADCON1+0 
;trabalho.c,118 :: 		ADCON2 = 0b10111110;              // Configura conversor A/D para resultado justificado a direita, clock de 20 TAD, clock de Fosc/64.
	MOVLW       190
	MOVWF       ADCON2+0 
;trabalho.c,121 :: 		Lcd_Init();                               // Inicializa LCD.
	CALL        _Lcd_Init+0, 0
;trabalho.c,123 :: 		Lcd_Cmd(_LCD_CLEAR);                      // Apaga display.
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,124 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor.
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,125 :: 		Lcd_Out(1, 1, "Temp: ");            // Escreve mensagem no LCD.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,126 :: 		Lcd_Out(2, 1, "Rot: ");            // Escreve mensagem no LCD.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,128 :: 		PWM1_Init(5000);                  // Inicializa módulo PWM com 5Khz
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;trabalho.c,129 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,130 :: 		PWM1_Start();                     // Inicia PWM.
	CALL        _PWM1_Start+0, 0
;trabalho.c,131 :: 		PORTC.RC5 = 1;                            // Liga resistencia de aquecimento.
	BSF         PORTC+0, 5 
;trabalho.c,132 :: 		PORTC.RC1 = 1;
	BSF         PORTC+0, 1 
;trabalho.c,134 :: 		while(1){
L_main1:
;trabalho.c,136 :: 		tempAD= ADC_Read(2);          // Lê Canal AD 2
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _tempAD+0 
	MOVF        R1, 0 
	MOVWF       _tempAD+1 
;trabalho.c,137 :: 		tempAD/=2;                    // Converte valor do sensor LM35
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	MOVF        R2, 0 
	MOVWF       _tempAD+0 
	MOVF        R3, 0 
	MOVWF       _tempAD+1 
;trabalho.c,138 :: 		EEPROM_Write(amostragem,tempAD);   // Grava na EEPROM valores de 0 a 10 em ASCII.
	MOVF        _amostragem+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R2, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;trabalho.c,139 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;trabalho.c,140 :: 		amostragem++;
	INFSNZ      _amostragem+0, 1 
	INCF        _amostragem+1, 1 
;trabalho.c,142 :: 		iLeituraAD = ADC_Read(0);          // Lê Canal AD 0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;trabalho.c,143 :: 		iLeituraAD=(iLeituraAD*0.24);     // Converte valor para o duty cycle [255/(1023 pontos do A/D)]
	CALL        _word2double+0, 0
	MOVLW       143
	MOVWF       R4 
	MOVLW       194
	MOVWF       R5 
	MOVLW       117
	MOVWF       R6 
	MOVLW       124
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;trabalho.c,144 :: 		if (tempAD > 30) {
	MOVLW       0
	MOVWF       R0 
	MOVF        _tempAD+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main24
	MOVF        _tempAD+0, 0 
	SUBLW       30
L__main24:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;trabalho.c,145 :: 		PWM1_Set_Duty(tempAD*3);        // Envia o valor lido de "iLeituraAD" para o módulo CCP1 PWM
	MOVLW       3
	MULWF       _tempAD+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,146 :: 		PORTC.RC1 = 0;
	BCF         PORTC+0, 1 
;trabalho.c,147 :: 		}
	GOTO        L_main5
L_main4:
;trabalho.c,149 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,150 :: 		}
L_main5:
;trabalho.c,152 :: 		if (Button(&PORTB, 2, 1, 1)){
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
;trabalho.c,153 :: 		check_btn1 = 1;
	MOVLW       1
	MOVWF       _check_btn1+0 
	MOVLW       0
	MOVWF       _check_btn1+1 
;trabalho.c,154 :: 		}
L_main6:
;trabalho.c,155 :: 		if (check_btn1 && Button(&PORTB, 2, 1, 0)){
	MOVF        _check_btn1+0, 0 
	IORWF       _check_btn1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
L__main18:
;trabalho.c,156 :: 		PORTC.RC5 = ~PORTC.RC5;
	BTG         PORTC+0, 5 
;trabalho.c,157 :: 		check_btn1 = 0;
	CLRF        _check_btn1+0 
	CLRF        _check_btn1+1 
;trabalho.c,158 :: 		}
L_main9:
;trabalho.c,160 :: 		if (Button(&PORTB, 0, 1, 1)){
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;trabalho.c,161 :: 		check_btn2 = 1;
	MOVLW       1
	MOVWF       _check_btn2+0 
	MOVLW       0
	MOVWF       _check_btn2+1 
;trabalho.c,162 :: 		}
L_main10:
;trabalho.c,163 :: 		if (check_btn2 && Button(&PORTB, 0, 1, 0)){
	MOVF        _check_btn2+0, 0 
	IORWF       _check_btn2+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
L__main17:
;trabalho.c,164 :: 		for (i = 1; i <= amostragem; i++){
	MOVLW       1
	MOVWF       _i+0 
L_main14:
	MOVLW       128
	XORWF       _amostragem+1, 0 
	MOVWF       R0 
	MOVLW       128
	BTFSC       _i+0, 7 
	MOVLW       127
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVF        _i+0, 0 
	SUBWF       _amostragem+0, 0 
L__main25:
	BTFSS       STATUS+0, 0 
	GOTO        L_main15
;trabalho.c,165 :: 		value = EEPROM_Read(i);;
	MOVF        _i+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _value+0 
	MOVLW       0
	MOVWF       _value+1 
;trabalho.c,166 :: 		media = media + value;
	MOVF        _value+0, 0 
	MOVWF       R0 
	MOVF        _value+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        _media+0, 0 
	MOVWF       R4 
	MOVF        _media+1, 0 
	MOVWF       R5 
	MOVF        _media+2, 0 
	MOVWF       R6 
	MOVF        _media+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _media+0 
	MOVF        R1, 0 
	MOVWF       _media+1 
	MOVF        R2, 0 
	MOVWF       _media+2 
	MOVF        R3, 0 
	MOVWF       _media+3 
;trabalho.c,164 :: 		for (i = 1; i <= amostragem; i++){
	INCF        _i+0, 1 
;trabalho.c,167 :: 		}
	GOTO        L_main14
L_main15:
;trabalho.c,168 :: 		FloatToStr(media, ucTexto);
	MOVF        _media+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _media+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _media+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _media+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _ucTexto+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;trabalho.c,169 :: 		Lcd_Out(2,1,ucTexto);             // Imprime no LCD o valor da RPM.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,170 :: 		Lcd_Out(1, 1, "MEDIA:          ");            // Escreve mensagem no LCD.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,171 :: 		check_btn2 = 0;
	CLRF        _check_btn2+0 
	CLRF        _check_btn2+1 
;trabalho.c,172 :: 		media = media / amostragem;
	MOVF        _amostragem+0, 0 
	MOVWF       R0 
	MOVF        _amostragem+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        _media+0, 0 
	MOVWF       R0 
	MOVF        _media+1, 0 
	MOVWF       R1 
	MOVF        _media+2, 0 
	MOVWF       R2 
	MOVF        _media+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _media+0 
	MOVF        R1, 0 
	MOVWF       _media+1 
	MOVF        R2, 0 
	MOVWF       _media+2 
	MOVF        R3, 0 
	MOVWF       _media+3 
;trabalho.c,173 :: 		FloatToStr(media, ucTexto);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _ucTexto+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;trabalho.c,174 :: 		check_btn1 = 0;
	CLRF        _check_btn1+0 
	CLRF        _check_btn1+1 
;trabalho.c,175 :: 		Lcd_Out(1, 1, "MEDIA:          ");            // Escreve mensagem no LCD.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,176 :: 		Lcd_Out(2,1,ucTexto);             // Imprime no LCD o valor da RPM.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,177 :: 		check_btn1 = 0;
	CLRF        _check_btn1+0 
	CLRF        _check_btn1+1 
;trabalho.c,178 :: 		amostragem = 0;
	CLRF        _amostragem+0 
	CLRF        _amostragem+1 
;trabalho.c,179 :: 		}
L_main13:
;trabalho.c,181 :: 		iLeituraAD=(iLeituraAD*0.41);     // Converte valor para o duty cycle em %
	MOVF        _iLeituraAD+0, 0 
	MOVWF       R0 
	MOVF        _iLeituraAD+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVLW       133
	MOVWF       R4 
	MOVLW       235
	MOVWF       R5 
	MOVLW       81
	MOVWF       R6 
	MOVLW       125
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;trabalho.c,182 :: 		WordToStr(tempAD, ucTexto);   // Converte o valor lido no A/D em string
	MOVF        _tempAD+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _tempAD+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _ucTexto+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;trabalho.c,183 :: 		Lcd_Out(1,8,ucTexto);            // Imprime no LCD o valor da temperatura
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,185 :: 		WordToStr(iReg_timer1, ucTexto);  // Converte o valor lido no iReg_timer1 em string
	MOVF        _iReg_timer1+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _iReg_timer1+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _ucTexto+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;trabalho.c,186 :: 		Lcd_Out(2,5,ucTexto);             // Imprime no LCD o valor da RPM.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,187 :: 		Lcd_Out_CP(" RPM");               // Unidade "RPM".
	MOVLW       ?lstr5_trabalho+0
	MOVWF       FARG_Lcd_Out_CP_text+0 
	MOVLW       hi_addr(?lstr5_trabalho+0)
	MOVWF       FARG_Lcd_Out_CP_text+1 
	CALL        _Lcd_Out_CP+0, 0
;trabalho.c,189 :: 		}
	GOTO        L_main1
;trabalho.c,190 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
