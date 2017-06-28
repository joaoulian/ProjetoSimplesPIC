/*
               Microgenios Soluções Eletrônicas Ltda.
********************************************************************************
 PROGRAMA EXEMPLO: Leitura do canal A/D AN0, mostrar a representação no PWM
                   da ventoinha E utilizar infravermelho para verificar RPM.
         OBJETIVO: Aprender a utilizar o canal PWM E TIMER1 como contador.
            AUTOR: Fabio Mulero.[fabio@microgenios.com.br]
********************************************************************************
 MICROCONTROLADOR: PIC18F4520.
 http://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf
 PLACA DE DESENVOLVIMENTO: KIT PICgenios - PIC18F
 http://www.microgenios.com.br/news/index.php?option=com_content&task=view&id=88&Itemid=134
 SOFTWARE: MikroC PRO for PIC
 http://www.mikroe.com/en/compilers/mikroc/pro/pic/
************************ Configurações do KIT Picgenios ************************
 CRISTAL: 8Mhz.
 CHAVES DE FUNÇÃO:
  --------------------- ----------------------
 |GLCD\LCD ( 1) = ON   |DIS1     ( 1) = OFF   |
 |RX       ( 2) = OFF  |DIS2     ( 2) = OFF   |
 |TX       ( 3) = OFF  |DIS3     ( 3) = OFF   |
 |REL1     ( 4) = OFF  |DIS4     ( 4) = OFF   |
 |REL2     ( 5) = OFF  |INFR     ( 5) = ON    |
 |SCK      ( 6) = OFF  |RESIS    ( 6) = ON   |
 |SDA      ( 7) = OFF  |TEMP     ( 7) = ON   |
 |RTC      ( 8) = OFF  |VENT     ( 8) = ON    |
 |LED1     ( 9) = OFF  |AN0      ( 9) = ON    |
 |LED2     (10) = ON   |AN1      (10) = OFF   |
  --------------------- ----------------------
********************************************************************************
OBS:
- HABILITAR BIBLIOTECA LCD.
- HABILITAR BIBLIOTECA PWM.
- HABILITAR BIBLIOTECA A/D.
- HABILITAR BIBLIOTECA CONVERTIONS.
********************************************************************************
*/


// VARIAVEIS GLOBAIS
unsigned char ucTexto[10];   // Matriz para armazenamento de texto.
unsigned char ucPorcentagem; // Armazena a porcentagem do PWM.
unsigned int iLeituraAD = 0; // Define variável para armazenamento da leitura AD.
unsigned int temperatura = 0; // Define variável para armazenamento da leitura AD.
unsigned int tempDisplay = 0; // Define variável para armazenamento da leitura AD.
unsigned int iReg_timer1;    // Armazena o RPM.
unsigned int check_btn1 = 0;
unsigned int check_btn2 = 0;
unsigned int amostragem = 0;
int digitoA;
int digitoB;
int digitoC;
int digitoD;

//FUNCOES
void calculaMedia();
void imprimeDisplay( int b, int c, int d);
void quebraDezenas(int temperatura1,int temperatura2);

// CONFIGURAÇÃO DOS PINOS DO LCD.
sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// DIREÇÃO DOS PINOS.
sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

void interrupt(){
   if (INTCON.TMR0IF == 1){    // Se o flag de estouro do TIMER0 for igual a 1, então
      TMR0L = 0X7B;                  // Carrega valores de contagem
      TMR0H = 0XE1;                  // Carrega valores de contagem
      INTCON.TMR0IF = 0;             // Seta T0IE, apaga flag de entouro do TIMER0
      iReg_timer1 = TMR1L*(60/7);    // Pega valor lido do timer1 e multiplica por 60 para saber rotação por minuto.
                                     // e divide por 7 pois a ventoinha para dar uma volta completa realiza 7 pulsos.
      TMR1L = 0;                     // Limpa contador.
   }
}

void main(){
   TRISB = 0;                        // Define PORTB como saida.
   TRISD = 0;                        // Define PORTD como saida.
   TRISC.RC0 = 1;                    // Define PORTC.RC0 como entrada.
   TRISC.RC2 = 0;                    // Define PORTC.RC2 como saida.
   TRISC.RC5 = 0;                    // Define PORTC.RC5 como saida.
   TRISC.RC1 = 0;                    // Define PORTC.RC1 como saida.
   TRISB.RB3 = 1;                      // Define o PORTB.RB3 como saida.
   TRISE = 0;                        // Define PORTE como saida.
   PORTB = 0;                        // Limpa PORTB.
   
   //TRISA.RA2=0;         // Define o pino RA2 do PORTA como saida(Seleção Display 1).
   TRISA.RA3=0;         // Define o pino RA3 do PORTA como saida(Seleção Display 2).
   TRISA.RA4=0;         // Define o pino RA4 do PORTA como saida(Seleção Display 3).
   TRISA.RA5=0;         // Define o pino RA5 do PORTA como saida(Seleção Display 4).
   
   // Configuração das interrupções
   INTCON.GIEH = 1;   // Habilita as interrupções e a interrupção de alta prioridade.
   INTCON.GIEL = 1;   // Habilita as interrupções e a interrupção de baixa prioridade
   RCON.IPEN = 1;     // Configura 2 niveis de interrupção.

   // Timer 0
   INTCON.TMR0IF = 0;
   INTCON2.TMR0IP = 1;
   INTCON.TMR0IE = 1;

   T0CON = 0B10000100; // Configura timer modo 16 bits, com prescaler
   // Valor para 1 segundo.
   TMR0H = 0xDB;            // Carrega o valor alto do número 57723.
   TMR0L = 0x61;            // Carrega o valor baixo do numero 57723.
   INTCON.TMR0IF = 0;  // Apaga flag de estouro do TIMER0

   // Timer 1
   T1CON = 0B10000011; // Liga TIMER1 como Contador em RC0, prescaler 1:1, modo 16bits.
   TMR1L = 0;          // Carrega valor de contagem baixa do TIMER1
   TMR1H = 0;          // Carrega valor de contagem alta do TIMER1
   PIR1.TMR1IF = 0;    // Apaga flag de estouro do TIMER1

   ADCON0 = 0b00000001;              // Configura conversor A/D Canal 0, conversão desligada, A/D ligado.
   ADCON1 = 0b00001100;              // Configura todos canais como Digital menos AN0,AN1 E AN2 e REF Interna.
   ADCON2 = 0b10111110;              // Configura conversor A/D para resultado justificado a direita, clock de 20 TAD, clock de Fosc/64.

   // Config. LCD no modo 4 bits
   Lcd_Init();                               // Inicializa LCD.
   Lcd_Cmd(_LCD_CLEAR);                      // Apaga display.
   Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor.
   Lcd_Out(1, 1, "TempMedia: ");            // Escreve mensagem no LCD.
   Lcd_Out(2, 1, "Rot: ");            // Escreve mensagem no LCD.

   PWM1_Init(5000);                  // Inicializa módulo PWM com 5Khz
   PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
   PWM1_Start();                     // Inicia PWM.
   PORTC.RC5 = 1;                            // Liga resistencia de aquecimento.
   PORTC.RC1 = 1;
   PORTC.RB0 = 0;
   while(1){
      temperatura = ADC_Read(2);          // Lê Canal AD 2
      temperatura/=2;                    // Converte valor do sensor LM35
      EEPROM_Write(amostragem,temperatura);
      amostragem++;
      if (amostragem == 150){
         tempDisplay = temperatura;
         calculaMedia();
         amostragem = 0;
      }
      iLeituraAD= ADC_Read(0);          // Lê Canal AD 0
      iLeituraAD=(iLeituraAD*0.24);     // Converte valor para o duty cycle [255/(1023 pontos do A/D)]
      if (temperatura > 30) {
         PWM1_Set_Duty(temperatura*3);        // Envia o valor lido de "iLeituraAD" para o módulo CCP1 PWM
         PORTC.RC1 = 0;
      }
      else {
         PWM1_Set_Duty(0);               // Seta o Duty-cycle do PWM em 100%.
      }

      if (Button(&PORTB, 3, 1, 1)){
         check_btn1 = 1;
      }
      if (check_btn1 && Button(&PORTB, 3, 1, 0)){
         PORTC.RC5 = ~PORTC.RC5;
         PORTB.RB0 = ~PORTB.RB0;
         check_btn1 = 0;
      }

      quebraDezenas(0,tempDisplay);
      imprimeDisplay(digitoB,digitoC,digitoD);
      
      /*iLeituraAD=(iLeituraAD*0.41);     // Converte valor para o duty cycle em %
      WordToStr(temperatura, ucTexto);   // Converte o valor lido no A/D em string
      Lcd_Out(1,3,ucTexto);            // Imprime no LCD o valor da temperatura. */

      WordToStr(iReg_timer1, ucTexto);  // Converte o valor lido no iReg_timer1 em string
      Lcd_Out(2,6,ucTexto);             // Imprime no LCD o valor da RPM.
      Delay_10us;
   }
}

void quebraDezenas(int temperatura1,int temperatura2){
     digitoA=temperatura1/10;
     digitoB=temperatura1%10;
     digitoC=temperatura2/10;
     digitoD=temperatura2%10;
}
void imprimeDisplay( int b, int c, int d){
                           //  "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "<"  ">"  "-"
    unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x21,0x03,0x40};
    PORTD = ucMask[b];
    PORTA.RA3 = 1;
    Delay_ms(2);
    PORTA.RA3 = 0;
    PORTD = ucMask[c];
    PORTA.RA4 = 1;
    Delay_ms(2);
    PORTA.RA4 = 0;
    PORTD = ucMask[d];
    PORTA.RA5 = 1;
    Delay_ms(2);
    PORTA.RA5 = 0;
}

void calculaMedia(){
      float aux2=0;
      int i;
      for(i=0;i<amostragem;i++){
            aux2 = aux2 + EEPROM_Read(i);
      }
      FloatToStr((aux2/amostragem),ucTexto);
      Lcd_Out(1,12,ucTexto);
}