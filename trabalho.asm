
_interrupt:

;trabalho.c,69 :: 		void interrupt(){
;trabalho.c,70 :: 		if (INTCON.TMR0IF == 1){    // Se o flag de estouro do TIMER0 for igual a 1, então
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;trabalho.c,71 :: 		PORTB.RB0 = ~PORTB.RB0;  // Inverte o estado do PORTB.RB0.
	BTG         PORTB+0, 0 
;trabalho.c,72 :: 		TMR0L = 0X7B;                  // Carrega valores de contagem
	MOVLW       123
	MOVWF       TMR0L+0 
;trabalho.c,73 :: 		TMR0H = 0XE1;                  // Carrega valores de contagem
	MOVLW       225
	MOVWF       TMR0H+0 
;trabalho.c,74 :: 		INTCON.TMR0IF = 0;             // Seta T0IE, apaga flag de entouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,75 :: 		iReg_timer1 = TMR1L*(60/7);    // Pega valor lido do timer1 e multiplica por 60 para saber rotação por minuto.
	MOVLW       3
	MOVWF       R0 
	MOVF        TMR1L+0, 0 
	MOVWF       _iReg_timer1+0 
	MOVLW       0
	MOVWF       _iReg_timer1+1 
	MOVF        R0, 0 
L__interrupt12:
	BZ          L__interrupt13
	RLCF        _iReg_timer1+0, 1 
	BCF         _iReg_timer1+0, 0 
	RLCF        _iReg_timer1+1, 1 
	ADDLW       255
	GOTO        L__interrupt12
L__interrupt13:
;trabalho.c,77 :: 		TMR1L = 0;                     // Limpa contador.
	CLRF        TMR1L+0 
;trabalho.c,78 :: 		}
L_interrupt0:
;trabalho.c,79 :: 		}
L_end_interrupt:
L__interrupt11:
	RETFIE      1
; end of _interrupt

_main:

;trabalho.c,81 :: 		void main(){
;trabalho.c,82 :: 		TRISB = 0;                        // Define PORTB como saida.
	CLRF        TRISB+0 
;trabalho.c,83 :: 		TRISD = 0;                        // Define PORTD como saida.
	CLRF        TRISD+0 
;trabalho.c,84 :: 		TRISC.RC0 = 1;                    // Define PORTC.RC0 como entrada.
	BSF         TRISC+0, 0 
;trabalho.c,85 :: 		TRISC.RC2 = 0;                    // Define PORTC.RC2 como saida.
	BCF         TRISC+0, 2 
;trabalho.c,86 :: 		TRISC.RC5 = 0;                    // Define PORTC.RC5 como saida.
	BCF         TRISC+0, 5 
;trabalho.c,87 :: 		TRISC.RC1 = 0;                    // Define PORTC.RC1 como saida.
	BCF         TRISC+0, 1 
;trabalho.c,88 :: 		TRISB.RB3=1;                      // Define o PORTB.RB3 como saida.
	BSF         TRISB+0, 3 
;trabalho.c,89 :: 		TRISE = 0;                        // Define PORTE como saida.
	CLRF        TRISE+0 
;trabalho.c,90 :: 		PORTB = 0;                        // Limpa PORTB.
	CLRF        PORTB+0 
;trabalho.c,93 :: 		INTCON.GIEH = 1;   // Habilita as interrupções e a interrupção de alta prioridade.
	BSF         INTCON+0, 7 
;trabalho.c,94 :: 		INTCON.GIEL = 1;   // Habilita as interrupções e a interrupção de baixa prioridade
	BSF         INTCON+0, 6 
;trabalho.c,95 :: 		RCON.IPEN = 1;     // Configura 2 niveis de interrupção.
	BSF         RCON+0, 7 
;trabalho.c,98 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;trabalho.c,99 :: 		INTCON2.TMR0IP = 1;
	BSF         INTCON2+0, 2 
;trabalho.c,100 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;trabalho.c,102 :: 		T0CON = 0B10000100; // Configura timer modo 16 bits, com prescaler
	MOVLW       132
	MOVWF       T0CON+0 
;trabalho.c,103 :: 		TMR0L = 0X7B;       // Carrega valores de contagem
	MOVLW       123
	MOVWF       TMR0L+0 
;trabalho.c,104 :: 		TMR0H = 0XE1;       // Carrega valores de contagem
	MOVLW       225
	MOVWF       TMR0H+0 
;trabalho.c,105 :: 		INTCON.TMR0IF = 0;  // Apaga flag de estouro do TIMER0
	BCF         INTCON+0, 2 
;trabalho.c,108 :: 		T1CON = 0B10000011; // Liga TIMER1 como Contador em RC0, prescaler 1:1, modo 16bits.
	MOVLW       131
	MOVWF       T1CON+0 
;trabalho.c,109 :: 		TMR1L = 0;          // Carrega valor de contagem baixa do TIMER1
	CLRF        TMR1L+0 
;trabalho.c,110 :: 		TMR1H = 0;          // Carrega valor de contagem alta do TIMER1
	CLRF        TMR1H+0 
;trabalho.c,111 :: 		PIR1.TMR1IF = 0;    // Apaga flag de estouro do TIMER1
	BCF         PIR1+0, 0 
;trabalho.c,113 :: 		ADCON0 = 0b00000001;              // Configura conversor A/D Canal 0, conversão desligada, A/D ligado.
	MOVLW       1
	MOVWF       ADCON0+0 
;trabalho.c,114 :: 		ADCON1 = 0b00001100;              // Configura todos canais como Digital menos AN0,AN1 E AN2 e REF Interna.
	MOVLW       12
	MOVWF       ADCON1+0 
;trabalho.c,115 :: 		ADCON2 = 0b10111110;              // Configura conversor A/D para resultado justificado a direita, clock de 20 TAD, clock de Fosc/64.
	MOVLW       190
	MOVWF       ADCON2+0 
;trabalho.c,118 :: 		Lcd_Init();                               // Inicializa LCD.
	CALL        _Lcd_Init+0, 0
;trabalho.c,120 :: 		Lcd_Cmd(_LCD_CLEAR);                      // Apaga display.
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,121 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor.
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;trabalho.c,122 :: 		Lcd_Out(1, 1, "Temp: ");            // Escreve mensagem no LCD.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,123 :: 		Lcd_Out(2, 1, "Rot: ");            // Escreve mensagem no LCD.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_trabalho+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_trabalho+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,125 :: 		PWM1_Init(5000);                  // Inicializa módulo PWM com 5Khz
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;trabalho.c,126 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,127 :: 		PWM1_Start();                     // Inicia PWM.
	CALL        _PWM1_Start+0, 0
;trabalho.c,128 :: 		PORTC.RC5 = 1;                            // Liga resistencia de aquecimento.
	BSF         PORTC+0, 5 
;trabalho.c,129 :: 		PORTC.RC1 = 1;
	BSF         PORTC+0, 1 
;trabalho.c,130 :: 		while(1){   // Aqui Definimos Uma Condição Sempre Verdadeira Como Parametro, Portanto Todo O Bloco Será Repetido Indefinidamente.
L_main1:
;trabalho.c,131 :: 		tempAD= ADC_Read(2);          // Lê Canal AD 2
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _tempAD+0 
	MOVF        R1, 0 
	MOVWF       _tempAD+1 
;trabalho.c,132 :: 		tempAD/=2;                    // Converte valor do sensor LM35
	MOVF        R0, 0 
	MOVWF       _tempAD+0 
	MOVF        R1, 0 
	MOVWF       _tempAD+1 
	RRCF        _tempAD+1, 1 
	RRCF        _tempAD+0, 1 
	BCF         _tempAD+1, 7 
;trabalho.c,133 :: 		iLeituraAD= ADC_Read(0);          // Lê Canal AD 0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;trabalho.c,134 :: 		iLeituraAD=(iLeituraAD*0.24);     // Converte valor para o duty cycle [255/(1023 pontos do A/D)]
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
;trabalho.c,135 :: 		if (tempAD > 30) {
	MOVLW       0
	MOVWF       R0 
	MOVF        _tempAD+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVF        _tempAD+0, 0 
	SUBLW       30
L__main15:
	BTFSC       STATUS+0, 0 
	GOTO        L_main3
;trabalho.c,136 :: 		PWM1_Set_Duty(tempAD*4);        // Envia o valor lido de "iLeituraAD" para o módulo CCP1 PWM
	MOVF        _tempAD+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	RLCF        FARG_PWM1_Set_Duty_new_duty+0, 1 
	BCF         FARG_PWM1_Set_Duty_new_duty+0, 0 
	RLCF        FARG_PWM1_Set_Duty_new_duty+0, 1 
	BCF         FARG_PWM1_Set_Duty_new_duty+0, 0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,137 :: 		PORTC.RC1 = 0;
	BCF         PORTC+0, 1 
;trabalho.c,138 :: 		}
	GOTO        L_main4
L_main3:
;trabalho.c,140 :: 		PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;trabalho.c,141 :: 		}
L_main4:
;trabalho.c,143 :: 		if (Button(&PORTB, 3, 1, 1)){
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
	GOTO        L_main5
;trabalho.c,144 :: 		check_btn1 = 1;
	MOVLW       1
	MOVWF       _check_btn1+0 
	MOVLW       0
	MOVWF       _check_btn1+1 
;trabalho.c,145 :: 		}
L_main5:
;trabalho.c,146 :: 		if (check_btn1 && Button(&PORTB, 3, 1, 0)){
	MOVF        _check_btn1+0, 0 
	IORWF       _check_btn1+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main8
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
	GOTO        L_main8
L__main9:
;trabalho.c,147 :: 		PORTC.RC5 = ~PORTC.RC5;
	BTG         PORTC+0, 5 
;trabalho.c,148 :: 		check_btn1 = 0;
	CLRF        _check_btn1+0 
	CLRF        _check_btn1+1 
;trabalho.c,149 :: 		}
L_main8:
;trabalho.c,151 :: 		iLeituraAD=(iLeituraAD*0.41);     // Converte valor para o duty cycle em %
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
;trabalho.c,152 :: 		WordToStr(tempAD, ucTexto);   // Converte o valor lido no A/D em string
	MOVF        _tempAD+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _tempAD+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _ucTexto+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;trabalho.c,153 :: 		Lcd_Out(1,8,ucTexto);            // Imprime no LCD o valor da temperatura.
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,155 :: 		WordToStr(iReg_timer1, ucTexto);  // Converte o valor lido no iReg_timer1 em string
	MOVF        _iReg_timer1+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _iReg_timer1+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _ucTexto+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;trabalho.c,156 :: 		Lcd_Out(2,5,ucTexto);             // Imprime no LCD o valor da RPM.
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ucTexto+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ucTexto+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;trabalho.c,157 :: 		Lcd_Out_CP(" RPM");               // Unidade "RPM".
	MOVLW       ?lstr3_trabalho+0
	MOVWF       FARG_Lcd_Out_CP_text+0 
	MOVLW       hi_addr(?lstr3_trabalho+0)
	MOVWF       FARG_Lcd_Out_CP_text+1 
	CALL        _Lcd_Out_CP+0, 0
;trabalho.c,159 :: 		}
	GOTO        L_main1
;trabalho.c,160 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
