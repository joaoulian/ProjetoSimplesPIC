
_interrupt:

;trabalho.c,76 :: 		void interrupt(){
;trabalho.c,77 :: 		if (INTCON.TMR0IF == 1){    // Se o flag de estouro do TIMER0 for igual a 1, ent�o
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;trabalho.c,78 :: 		TMR0L = 0X7B;                  // Carrega valores de contagem
	MOVLW       123
	MOVWF       TMR0L+0 
;trabalho.c,79 :: 		TMR0H = 0XE1;                  // Carrega valores de contagem
	MOVLW       225
	MOVWF       TMR0H+0 
;trabalho.c,80 :: 		INTCON.TMR0IF = 0;             // Seta T0IE, apaga flag de entouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,81 :: 		iReg_timer1 = TMR1L*(60/7);    // Pega valor lido do timer1 e multiplica por 60 para saber rota��o por minuto.
	MOVLW       3
	MOVWF       R0 
	MOVF        TMR1L+0, 0 
	MOVWF       _iReg_timer1+0 
	MOVLW       0
	MOVWF       _iReg_timer1+1 
	MOVF        R0, 0 
L__interrupt19:
	BZ          L__interrupt20
	RLCF        _iReg_timer1+0, 1 
	BCF         _iReg_timer1+0, 0 
	RLCF        _iReg_timer1+1, 1 
	ADDLW       255
	GOTO        L__interrupt19
L__interrupt20:
;trabalho.c,83 :: 		TMR1L = 0;                     // Limpa contador.
	CLRF        TMR1L+0 
;trabalho.c,84 :: 		}
L_interrupt0:
;trabalho.c,85 :: 		}
L_end_interrupt:
L__interrupt18:
	RETFIE      1
; end of _interrupt

_main:

;trabalho.c,87 :: 		void main(){
;trabalho.c,88 :: 		TRISB = 0;                        // Define PORTB como saida.
	CLRF        TRISB+0 
;trabalho.c,89 :: 		TRISD = 0;                        // Define PORTD como saida.
	CLRF        TRISD+0 
;trabalho.c,90 :: 		TRISC.RC0 = 1;                    // Define PORTC.RC0 como entrada.
	BSF         TRISC+0, 0 
;trabalho.c,91 :: 		TRISC.RC2 = 0;                    // Define PORTC.RC2 como saida.
	BCF         TRISC+0, 2 
;trabalho.c,92 :: 		TRISC.RC5 = 0;                    // Define PORTC.RC5 como saida.
	BCF         TRISC+0, 5 
;trabalho.c,93 :: 		TRISC.RC1 = 0;                    // Define PORTC.RC1 como saida.
	BCF         TRISC+0, 1 
;trabalho.c,94 :: 		TRISB.RB3 = 1;                      // Define o PORTB.RB3 como saida.
	BSF         TRISB+0, 3 
;trabalho.c,95 :: 		TRISE = 0;                        // Define PORTE como saida.
	CLRF        TRISE+0 
;trabalho.c,96 :: 		PORTB = 0;                        // Limpa PORTB.
	CLRF        PORTB+0 
;trabalho.c,99 :: 		TRISA.RA3=0;         // Define o pino RA3 do PORTA como saida(Sele��o Display 2).
	BCF         TRISA+0, 3 
;trabalho.c,100 :: 		TRISA.RA4=0;         // Define o pino RA4 do PORTA como saida(Sele��o Display 3).
	BCF         TRISA+0, 4 
;trabalho.c,101 :: 		TRISA.RA5=0;         // Define o pino RA5 do PORTA como saida(Sele��o Display 4).
	BCF         TRISA+0, 5 
;trabalho.c,104 :: 		INTCON.GIEH = 1;   // Habilita as interrup��es e a interrup��o de alta prioridade.
	BSF         INTCON+0, 7 
;trabalho.c,105 :: 		INTCON.GIEL = 1;   // Habilita as interrup��es e a interrup��o de baixa prioridade
	BSF         INTCON+0, 6 
;trabalho.c,106 :: 		RCON.IPEN = 1;     // Configura 2 niveis de interrup��o.
	BSF         RCON+0, 7 
;trabalho.c,109 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;trabalho.c,110 :: 		INTCON2.TMR0IP = 1;
	BSF         INTCON2+0, 2 
;trabalho.c,111 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;trabalho.c,113 :: 		T0CON = 0B10000100; // Configura timer modo 16 bits, com prescaler
	MOVLW       132
	MOVWF       T0CON+0 
;trabalho.c,115 :: 		TMR0H = 0xDB;            // Carrega o valor alto do n�mero 57723.
	MOVLW       219
	MOVWF       TMR0H+0 
;trabalho.c,116 :: 		TMR0L = 0x61;            // Carrega o valor baixo do numero 57723.
	MOVLW       97
	MOVWF       TMR0L+0 
;trabalho.c,117 :: 		INTCON.TMR0IF = 0;  // Apaga flag de estouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,120 :: 		T1CON = 0B10000011; // Liga TIMER1 como Contador em RC0, prescaler 1:1, modo 16bits.
	MOVLW       131
	MOVWF       T1CON+0 
;trabalho.c,121 :: 		TMR1L = 0;          // Carrega valor de contagem baixa do TIMER1
	CLRF        TMR1L+0 
;trabalho.c,122 :: 		TMR1H = 0;          // Carrega valor de contagem alta do TIMER1
	CLRF        TMR1H+0 
;trabalho.c,123 :: 		PIR1.TMR1IF = 0;    // Apaga flag de estouro do TIMER1
	BCF         PIR1+0, 0 
;trabalho.c,125 :: 		ADCON0 = 0b00000001;              // Configura conversor A/D Canal 0, convers�o desligada, A/D ligado.
	MOVLW       1
	MOVWF       ADCON0+0 
;trabalho.c,126 :: 		ADCON1 = 0b00001100;              // Configura todos canais como Digital menos AN0,AN1 E AN2 e REF Interna.
	MOVLW       12
	MOVWF       ADCON1+0 
;trabalho.c,127 :: 		ADCON2 = 0b10111110;              // Configura conversor A/D para resultado justificado a direita, clock de 20 TAD, clock de Fosc/64.
	MOVLW       190
	MOVWF       ADCON2+0 
;trabalho.c,130 :: 		Lcd_Init();                               // Inicializa LCD.
	CALL        _Lcd_Init+0, 0
;trabalho.c,131 :: 		Lcd_Cmd(_LCD_CLEAR);                      // Apaga display.
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,132 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor.
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,133 :: 		Lcd_Out(1, 1, "TempMedia: ");            // Escreve mensagem no LCD.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,134 :: 		Lcd_Out(2, 1, "Rot: ");            // Escreve mensagem no LCD.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,136 :: 		PWM1_Init(5000);                  // Inicializa m�dulo PWM com 5Khz
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;trabalho.c,137 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,138 :: 		PWM1_Start();                     // Inicia PWM.
	CALL        _PWM1_Start+0, 0
;trabalho.c,139 :: 		PORTC.RC5 = 1;                            // Liga resistencia de aquecimento.
	BSF         PORTC+0, 5 
;trabalho.c,140 :: 		PORTC.RC1 = 1;
	BSF         PORTC+0, 1 
;trabalho.c,141 :: 		PORTC.RB0 = 0;
	BCF         PORTC+0, 0 
;trabalho.c,142 :: 		while(1){
L_main1:
;trabalho.c,143 :: 		temperatura = ADC_Read(2);          // L� Canal AD 2
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temperatura+0 
	MOVF        R1, 0 
	MOVWF       _temperatura+1 
;trabalho.c,144 :: 		temperatura/=2;                    // Converte valor do sensor LM35
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	MOVF        R2, 0 
	MOVWF       _temperatura+0 
	MOVF        R3, 0 
	MOVWF       _temperatura+1 
;trabalho.c,145 :: 		EEPROM_Write(amostragem,temperatura);
	MOVF        _amostragem+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R2, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;trabalho.c,146 :: 		amostragem++;
	INFSNZ      _amostragem+0, 1 
	INCF        _amostragem+1, 1 
;trabalho.c,147 :: 		if (amostragem == 150){
	MOVLW       0
	XORWF       _amostragem+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main22
	MOVLW       150
	XORWF       _amostragem+0, 0 
L__main22:
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;trabalho.c,148 :: 		tempDisplay = temperatura;
	MOVF        _temperatura+0, 0 
	MOVWF       _tempDisplay+0 
	MOVF        _temperatura+1, 0 
	MOVWF       _tempDisplay+1 
;trabalho.c,149 :: 		calculaMedia();
	CALL        _calculaMedia+0, 0
;trabalho.c,150 :: 		amostragem = 0;
	CLRF        _amostragem+0 
	CLRF        _amostragem+1 
;trabalho.c,151 :: 		}
L_main3:
;trabalho.c,152 :: 		iLeituraAD= ADC_Read(0);          // L� Canal AD 0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;trabalho.c,153 :: 		iLeituraAD=(iLeituraAD*0.24);     // Converte valor para o duty cycle [255/(1023 pontos do A/D)]
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
;trabalho.c,154 :: 		if (temperatura > 30) {
	MOVLW       0
	MOVWF       R0 
	MOVF        _temperatura+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main23
	MOVF        _temperatura+0, 0 
	SUBLW       30
L__main23:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;trabalho.c,155 :: 		PWM1_Set_Duty(temperatura*3);        // Envia o valor lido de "iLeituraAD" para o m�dulo CCP1 PWM
	MOVLW       3
	MULWF       _temperatura+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,156 :: 		PORTC.RC1 = 0;
	BCF         PORTC+0, 1 
;trabalho.c,157 :: 		}
	GOTO        L_main5
L_main4:
;trabalho.c,159 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,160 :: 		}
L_main5:
;trabalho.c,162 :: 		if (Button(&PORTB, 3, 1, 1)){
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
;trabalho.c,163 :: 		check_btn1 = 1;
	MOVLW       1
	MOVWF       _check_btn1+0 
	MOVLW       0
	MOVWF       _check_btn1+1 
;trabalho.c,164 :: 		}
L_main6:
;trabalho.c,165 :: 		if (check_btn1 && Button(&PORTB, 3, 1, 0)){
	MOVF        _check_btn1+0, 0 
	IORWF       _check_btn1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
L__main16:
;trabalho.c,166 :: 		PORTC.RC5 = ~PORTC.RC5;
	BTG         PORTC+0, 5 
;trabalho.c,167 :: 		PORTB.RB0 = ~PORTB.RB0;
	BTG         PORTB+0, 0 
;trabalho.c,168 :: 		check_btn1 = 0;
	CLRF        _check_btn1+0 
	CLRF        _check_btn1+1 
;trabalho.c,169 :: 		}
L_main9:
;trabalho.c,171 :: 		quebraDezenas(0,tempDisplay);
	CLRF        FARG_quebraDezenas_temperatura1+0 
	CLRF        FARG_quebraDezenas_temperatura1+1 
	MOVF        _tempDisplay+0, 0 
	MOVWF       FARG_quebraDezenas_temperatura2+0 
	MOVF        _tempDisplay+1, 0 
	MOVWF       FARG_quebraDezenas_temperatura2+1 
	CALL        _quebraDezenas+0, 0
;trabalho.c,172 :: 		imprimeDisplay(digitoB,digitoC,digitoD);
	MOVF        _digitoB+0, 0 
	MOVWF       FARG_imprimeDisplay_b+0 
	MOVF        _digitoB+1, 0 
	MOVWF       FARG_imprimeDisplay_b+1 
	MOVF        _digitoC+0, 0 
	MOVWF       FARG_imprimeDisplay_c+0 
	MOVF        _digitoC+1, 0 
	MOVWF       FARG_imprimeDisplay_c+1 
	MOVF        _digitoD+0, 0 
	MOVWF       FARG_imprimeDisplay_d+0 
	MOVF        _digitoD+1, 0 
	MOVWF       FARG_imprimeDisplay_d+1 
	CALL        _imprimeDisplay+0, 0
;trabalho.c,178 :: 		WordToStr(iReg_timer1, ucTexto);  // Converte o valor lido no iReg_timer1 em string
	MOVF        _iReg_timer1+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _iReg_timer1+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _ucTexto+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;trabalho.c,179 :: 		Lcd_Out(2,6,ucTexto);             // Imprime no LCD o valor da RPM.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,181 :: 		}
	GOTO        L_main1
;trabalho.c,182 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_quebraDezenas:

;trabalho.c,184 :: 		void quebraDezenas(int temperatura1,int temperatura2){
;trabalho.c,185 :: 		digitoA=temperatura1/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_quebraDezenas_temperatura1+0, 0 
	MOVWF       R0 
	MOVF        FARG_quebraDezenas_temperatura1+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digitoA+0 
	MOVF        R1, 0 
	MOVWF       _digitoA+1 
;trabalho.c,186 :: 		digitoB=temperatura1%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_quebraDezenas_temperatura1+0, 0 
	MOVWF       R0 
	MOVF        FARG_quebraDezenas_temperatura1+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digitoB+0 
	MOVF        R1, 0 
	MOVWF       _digitoB+1 
;trabalho.c,187 :: 		digitoC=temperatura2/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_quebraDezenas_temperatura2+0, 0 
	MOVWF       R0 
	MOVF        FARG_quebraDezenas_temperatura2+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digitoC+0 
	MOVF        R1, 0 
	MOVWF       _digitoC+1 
;trabalho.c,188 :: 		digitoD=temperatura2%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_quebraDezenas_temperatura2+0, 0 
	MOVWF       R0 
	MOVF        FARG_quebraDezenas_temperatura2+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digitoD+0 
	MOVF        R1, 0 
	MOVWF       _digitoD+1 
;trabalho.c,189 :: 		}
L_end_quebraDezenas:
	RETURN      0
; end of _quebraDezenas

_imprimeDisplay:

;trabalho.c,190 :: 		void imprimeDisplay( int b, int c, int d){
;trabalho.c,192 :: 		unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x21,0x03,0x40};
	MOVLW       63
	MOVWF       imprimeDisplay_ucMask_L0+0 
	MOVLW       6
	MOVWF       imprimeDisplay_ucMask_L0+1 
	MOVLW       91
	MOVWF       imprimeDisplay_ucMask_L0+2 
	MOVLW       79
	MOVWF       imprimeDisplay_ucMask_L0+3 
	MOVLW       102
	MOVWF       imprimeDisplay_ucMask_L0+4 
	MOVLW       109
	MOVWF       imprimeDisplay_ucMask_L0+5 
	MOVLW       125
	MOVWF       imprimeDisplay_ucMask_L0+6 
	MOVLW       7
	MOVWF       imprimeDisplay_ucMask_L0+7 
	MOVLW       127
	MOVWF       imprimeDisplay_ucMask_L0+8 
	MOVLW       111
	MOVWF       imprimeDisplay_ucMask_L0+9 
	MOVLW       33
	MOVWF       imprimeDisplay_ucMask_L0+10 
	MOVLW       3
	MOVWF       imprimeDisplay_ucMask_L0+11 
	MOVLW       64
	MOVWF       imprimeDisplay_ucMask_L0+12 
;trabalho.c,193 :: 		PORTD = ucMask[b];
	MOVLW       imprimeDisplay_ucMask_L0+0
	ADDWF       FARG_imprimeDisplay_b+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(imprimeDisplay_ucMask_L0+0)
	ADDWFC      FARG_imprimeDisplay_b+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;trabalho.c,194 :: 		PORTA.RA3 = 1;
	BSF         PORTA+0, 3 
;trabalho.c,195 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_imprimeDisplay10:
	DECFSZ      R13, 1, 1
	BRA         L_imprimeDisplay10
	DECFSZ      R12, 1, 1
	BRA         L_imprimeDisplay10
	NOP
;trabalho.c,196 :: 		PORTA.RA3 = 0;
	BCF         PORTA+0, 3 
;trabalho.c,197 :: 		PORTD = ucMask[c];
	MOVLW       imprimeDisplay_ucMask_L0+0
	ADDWF       FARG_imprimeDisplay_c+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(imprimeDisplay_ucMask_L0+0)
	ADDWFC      FARG_imprimeDisplay_c+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;trabalho.c,198 :: 		PORTA.RA4 = 1;
	BSF         PORTA+0, 4 
;trabalho.c,199 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_imprimeDisplay11:
	DECFSZ      R13, 1, 1
	BRA         L_imprimeDisplay11
	DECFSZ      R12, 1, 1
	BRA         L_imprimeDisplay11
	NOP
;trabalho.c,200 :: 		PORTA.RA4 = 0;
	BCF         PORTA+0, 4 
;trabalho.c,201 :: 		PORTD = ucMask[d];
	MOVLW       imprimeDisplay_ucMask_L0+0
	ADDWF       FARG_imprimeDisplay_d+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(imprimeDisplay_ucMask_L0+0)
	ADDWFC      FARG_imprimeDisplay_d+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;trabalho.c,202 :: 		PORTA.RA5 = 1;
	BSF         PORTA+0, 5 
;trabalho.c,203 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_imprimeDisplay12:
	DECFSZ      R13, 1, 1
	BRA         L_imprimeDisplay12
	DECFSZ      R12, 1, 1
	BRA         L_imprimeDisplay12
	NOP
;trabalho.c,204 :: 		PORTA.RA5 = 0;
	BCF         PORTA+0, 5 
;trabalho.c,205 :: 		}
L_end_imprimeDisplay:
	RETURN      0
; end of _imprimeDisplay

_calculaMedia:

;trabalho.c,207 :: 		void calculaMedia(){
;trabalho.c,208 :: 		float aux2=0;
	CLRF        calculaMedia_aux2_L0+0 
	CLRF        calculaMedia_aux2_L0+1 
	CLRF        calculaMedia_aux2_L0+2 
	CLRF        calculaMedia_aux2_L0+3 
;trabalho.c,210 :: 		for(i=0;i<amostragem;i++){
	CLRF        calculaMedia_i_L0+0 
	CLRF        calculaMedia_i_L0+1 
L_calculaMedia13:
	MOVF        _amostragem+1, 0 
	SUBWF       calculaMedia_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__calculaMedia27
	MOVF        _amostragem+0, 0 
	SUBWF       calculaMedia_i_L0+0, 0 
L__calculaMedia27:
	BTFSC       STATUS+0, 0 
	GOTO        L_calculaMedia14
;trabalho.c,211 :: 		aux2 = aux2 + EEPROM_Read(i);
	MOVF        calculaMedia_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	CALL        _byte2double+0, 0
	MOVF        calculaMedia_aux2_L0+0, 0 
	MOVWF       R4 
	MOVF        calculaMedia_aux2_L0+1, 0 
	MOVWF       R5 
	MOVF        calculaMedia_aux2_L0+2, 0 
	MOVWF       R6 
	MOVF        calculaMedia_aux2_L0+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       calculaMedia_aux2_L0+0 
	MOVF        R1, 0 
	MOVWF       calculaMedia_aux2_L0+1 
	MOVF        R2, 0 
	MOVWF       calculaMedia_aux2_L0+2 
	MOVF        R3, 0 
	MOVWF       calculaMedia_aux2_L0+3 
;trabalho.c,210 :: 		for(i=0;i<amostragem;i++){
	INFSNZ      calculaMedia_i_L0+0, 1 
	INCF        calculaMedia_i_L0+1, 1 
;trabalho.c,212 :: 		}
	GOTO        L_calculaMedia13
L_calculaMedia14:
;trabalho.c,213 :: 		FloatToStr((aux2/amostragem),ucTexto);
	MOVF        _amostragem+0, 0 
	MOVWF       R0 
	MOVF        _amostragem+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        calculaMedia_aux2_L0+0, 0 
	MOVWF       R0 
	MOVF        calculaMedia_aux2_L0+1, 0 
	MOVWF       R1 
	MOVF        calculaMedia_aux2_L0+2, 0 
	MOVWF       R2 
	MOVF        calculaMedia_aux2_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
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
;trabalho.c,214 :: 		Lcd_Out(1,12,ucTexto);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,215 :: 		}
L_end_calculaMedia:
	RETURN      0
; end of _calculaMedia
