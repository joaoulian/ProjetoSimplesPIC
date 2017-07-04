/*
 MICROCONTROLADOR: PIC18F4520.
 http://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf
 PLACA DE DESENVOLVIMENTO: KIT PICgenios - PIC18F
 http://www.microgenios.com.br/news/index.php?option=com_content&task=view&id=88&Itemid=134
 SOFTWARE: MikroC PRO for PIC
 http://www.mikroe.com/en/compilers/mikroc/pro/pic/
 CÓDIGO FONTE DESENVOLVIDO POR:
 João Gabriel Ulian
************************ Configuracoes do KIT Picgenios ************************
 CRISTAL: 8Mhz.
 CHAVES DE FUNÇÃO:
  --------------------- ----------------------
 |GLCD\LCD ( 1) = ON   |  DIS1     ( 1) = OFF   |
 |RX       ( 2) = OFF  |  DIS2     ( 2) = ON    |
 |TX       ( 3) = OFF  |  DIS3     ( 3) = ON    |
 |REL1     ( 4) = OFF  |  DIS4     ( 4) = ON    |
 |REL2     ( 5) = OFF  |  INFR     ( 5) = ON    |
 |SCK      ( 6) = OFF  |  RESIS    ( 6) = ON    |
 |SDA      ( 7) = OFF  |  TEMP     ( 7) = ON    |
 |RTC      ( 8) = OFF  |  VENT     ( 8) = ON    |
 |LED1     ( 9) = OFF  |  AN0      ( 9) = ON    |
 |LED2     (10) = ON   |  AN1      (10) = OFF   |
  --------------------- ----------------------
********************************************************************************
OBS:
- HABILITAR BIBLIOTECA LCD.
- HABILITAR BIBLIOTECA PWM.
- HABILITAR BIBLIOTECA A/D.
- HABILITAR BIBLIOTECA CONVERTIONS.
********************************************************************************
*/


//**********VARIAVEIS GLOBAIS**********
unsigned char ucTexto[10];   //Matriz para armazenamento de texto.
unsigned int iLeituraAD = 0; //Armazena a leitura AD do potenciometro
unsigned int temperatura = 0; //Armazena a leitura da temperatura
unsigned int tempDuty = 0; //Duty cicle proporcional a temperatura
unsigned int tempDisplay = 0; //Armazena o valor da temperatura a ser mostrada no display
unsigned int iReg_timer1; // Armazena o RPM.
unsigned int check_btn1 = 0; //Auxilia a contagem de apertos do botão 1
unsigned int check_btn2 = 0; //Auxilia a contagem de apertos do botão 2
unsigned int amostragem = 0; //Armazena o número de leituras da temperatura
int digB;
int digC;
int digD;
unsigned int modo = 0; //Variavel para setar o modo manual ou automático
float dutyCicle = 0; //Variavel que armazena o dutyCicle que liga o PWM da ventoinha

//**********FUNCOES**********
void calculaMedia(); //Calcula a media das temperaturas
void imprime7seg(int b, int c, int d); //Imprime no display de 7 segmentos
void decParaBcd(int x); //Converte um inteiro para BCD

//**********CONFIGURACOES DOS PINOS DO LCD**********
sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

//**********DIRECAO DOS PINOS DO LCD**********
sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

void interrupt(){
  if (INTCON.TMR0IF == 1){ //Se o flag de estouro do TIMER0 for igual a 1, entao
    TMR0L = 0X7B; //Carrega valores de contagem
    TMR0H = 0XE1; //Carrega valores de contagem
    INTCON.TMR0IF = 0; //Seta T0IE, apaga flag de entouro do TIMER0
    iReg_timer1 = TMR1L*(60/7); //Pega valor lido do timer1 e multiplica por 60 para saber rotacao por minuto.
                                //e divide por 7 pois a ventoinha para dar uma volta completa realiza 7 pulsos.
    TMR1L = 0; //Limpa contador.
  }
}

void main(){
  TRISB = 0; //Define PORTB como saida.
  TRISD = 0; //Define PORTD como saida.
  TRISC.RC0 = 1; //Define PORTC.RC0 como entrada.
  TRISC.RC2 = 0; //Define PORTC.RC2 como saida.
  TRISC.RC5 = 0; //Define PORTC.RC5 como saida.
  TRISC.RC1 = 0; //Define PORTC.RC1 como saida.
  TRISB.RB3 = 1; //Define o PORTB.RB3 como entrada (Button RB3).
  TRISB.RB4 = 1; //Define o PORTB.RB4 como entrada (Button RB4).
  TRISE = 0; //Define PORTE como saida.
  PORTB = 0; //Limpa PORTB.

  TRISA.RA3 = 0; //Define o pino RA3 do PORTA como saida (Selecao Display 2).
  TRISA.RA4 = 0; //Define o pino RA4 do PORTA como saida (Selecao Display 3).
  TRISA.RA5 = 0; //Define o pino RA5 do PORTA como saida (Selecao Display 4).

  //**********Configuracao das interrupcoes**********
  INTCON.GIEH = 1; //Habilita as interrupcoes e a interrupcoes de alta prioridade.
  INTCON.GIEL = 1; //Habilita as interrupcoes e a interrupcoes de baixa prioridade
  RCON.IPEN = 1; //Configura 2 niveis de interrupcoes.

  //**********Timer 0**********
  INTCON2.TMR0IP = 1; //Alta prioridade da interrupcao do Timer 0
  INTCON.TMR0IE = 1; //Habilita a interrupcao do Timer 0
//  INTCON.TMR0IF = 0; //Apaga flag de estouro do TIMER0
  T0CON = 0B10000100; //Configura timer modo 16 bits, com prescaler 1:32
  // Valor para 1 segundo.
  TMR0H = 0xDB; //Carrega o valor alto do numero 57723.
  TMR0L = 0x61; //Carrega o valor baixo do numero 57723.
  INTCON.TMR0IF = 0; //Apaga flag de estouro do TIMER0

  //**********Timer 1**********
  T1CON = 0B10000011; //Liga TIMER1 como Contador em RC0, prescaler 1:1, modo 16bits.
  TMR1L = 0; //Carrega valor de contagem baixa do TIMER1
  TMR1H = 0; //Carrega valor de contagem alta do TIMER1
  PIR1.TMR1IF = 0; //Apaga flag de estouro do TIMER1

  //**********ADCON**********
  ADCON0 = 0b00000001; //Configura conversor A/D Canal 0, conversao desligada, A/D ligado.
  ADCON1 = 0b00001100; //Configura todos canais como Digital menos AN0,AN1 E AN2 e REF Interna.
  ADCON2 = 0b10111110; //Configura conversor A/D para resultado justificado a direita, clock de 20 TAD, clock de Fosc/64.

  //**********Config. LCD no modo 4 bits**********
  Lcd_Init(); //Inicializa LCD.
  Lcd_Cmd(_LCD_CLEAR); // Apaga display.
  Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga cursor.
  Lcd_Out(1, 1, "TempMedia: "); // Escreve mensagem no LCD.
  Lcd_Out(2, 1, "Rot: "); // Escreve mensagem no LCD.

  PWM1_Init(5000); //Inicializa modulo PWM com 5Khz
  PWM1_Set_Duty(0); //Seta o Duty-cycle do PWM em 100%.
  PWM1_Start(); //Inicia PWM.

  PORTC.RC5 = 1; //Liga resistencia de aquecimento.
  PORTC.RC1 = 1; //Desliga o buzzer
  PORTC.RB0 = 0; //Desliga o LED indicador (if resistencia ligada -> apagado else aceso)

  while(1){
    temperatura = ADC_Read(2); //Le Canal AD 2 (temperatura)
    temperatura/=2; //Converte valor do sensor LM35
    EEPROM_Write(amostragem,temperatura); //EEPROM[amostragem] = temperatura
    amostragem++;
    if (amostragem == 150){
      tempDisplay = temperatura;
      calculaMedia();
      amostragem = 0;
    }
    iLeituraAD = ADC_Read(0); //Le Canal AD 0 (potenciometro)
    iLeituraAD = (iLeituraAD*0.24); //Converte valor para o duty cycle [255/(1023 pontos do A/D)]
    tempDuty = (temperatura/0.24);
    if (modo == 0){ //modo automatico
      if (temperatura > 30) {
        dutyCicle = tempDuty; //dutyCicle recebe o duty proporcional a temperatura
        PORTC.RC1 = 0; //liga o buzzer
      }
      else {
        dutyCicle = 0;
      }
    }
    else if (modo == 1){ //modo manual
      dutyCicle = iLeituraAD; //dutyCicle recebe o duty proporcional ao potenciometro
    }

    PWM1_Set_Duty(dutyCicle); //Envia o dutyCicle para o modulo CCP1 PWM

    if (Button(&PORTB, 3, 1, 1)){
      check_btn1 = 1;
    }
    if (check_btn1 && Button(&PORTB, 3, 1, 0)){
      PORTC.RC5 = ~PORTC.RC5; //desliga a resistencia
      PORTB.RB0 = ~PORTB.RB0; //acende o LED
      check_btn1 = 0;
    }

    if (Button(&PORTB, 4, 1, 1)){
      check_btn2 = 1;
    }
    if (check_btn2 && Button(&PORTB, 4, 1, 0)){
      check_btn2 = 0;
      if (modo == 0){
        modo = 1;
      }
      else {
        modo = 0;
      }
    }

    iLeituraAD = (iLeituraAD*0.41); //Converte valor para o duty cycle em %
    decParaBcd(iLeituraAD); //Converte o duty cycle em BCD
    imprime7seg(digB, digC, digD); //Mostra o duty cycle no display de 7 seg

    WordToStr(iReg_timer1, ucTexto); //Converte o valor lido no iReg_timer1 em string
    Lcd_Out(2,6,ucTexto); //Imprime no LCD o valor da RPM.

    Delay_10us;
  }
}

void decParaBcd(int x){
  digD = x % 10; //103 % 10 = 3
  x = x / 10; //103 / 10 = 10
  digC = x % 10; //10 % 10 = 0
  x = x / 10; //10 / 10 = 1
  digB = x % 10; //1 % 10 = 1
}
void imprime7seg(int b, int c, int d){
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
  float temp = 0;
  int i;
  for(i = 0; i < amostragem; i++){
    temp = temp + EEPROM_Read(i);
  }
  FloatToStr((temp/amostragem),ucTexto); //converte um float para string
  Lcd_Out(1,12,ucTexto); //imprime no display o valor da media
}
