#line 1 "C:/Users/aluno/Desktop/joao/ProjetoSimplesPIC/trabalho.c"
#line 41 "C:/Users/aluno/Desktop/joao/ProjetoSimplesPIC/trabalho.c"
unsigned char ucTexto[10];
unsigned char ucPorcentagem;
unsigned int iLeituraAD = 0;
unsigned int temperatura = 0;
unsigned int tempDisplay = 0;
unsigned int iReg_timer1;
unsigned int check_btn1 = 0;
unsigned int check_btn2 = 0;
unsigned int amostragem = 0;
int digitoA;
int digitoB;
int digitoC;
int digitoD;


void calculaMedia();
void imprimeDisplay( int b, int c, int d);
void quebraDezenas(int temperatura1,int temperatura2);


sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

void interrupt(){
 if (INTCON.TMR0IF == 1){
 TMR0L = 0X7B;
 TMR0H = 0XE1;
 INTCON.TMR0IF = 0;
 iReg_timer1 = TMR1L*(60/7);

 TMR1L = 0;
 }
}

void main(){
 TRISB = 0;
 TRISD = 0;
 TRISC.RC0 = 1;
 TRISC.RC2 = 0;
 TRISC.RC5 = 0;
 TRISC.RC1 = 0;
 TRISB.RB3 = 1;
 TRISE = 0;
 PORTB = 0;


 TRISA.RA3=0;
 TRISA.RA4=0;
 TRISA.RA5=0;


 INTCON.GIEH = 1;
 INTCON.GIEL = 1;
 RCON.IPEN = 1;


 INTCON.TMR0IF = 0;
 INTCON2.TMR0IP = 1;
 INTCON.TMR0IE = 1;

 T0CON = 0B10000100;

 TMR0H = 0xDB;
 TMR0L = 0x61;
 INTCON.TMR0IF = 0;


 T1CON = 0B10000011;
 TMR1L = 0;
 TMR1H = 0;
 PIR1.TMR1IF = 0;

 ADCON0 = 0b00000001;
 ADCON1 = 0b00001100;
 ADCON2 = 0b10111110;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 1, "TempMedia: ");
 Lcd_Out(2, 1, "Rot: ");

 PWM1_Init(5000);
 PWM1_Set_Duty(0);
 PWM1_Start();
 PORTC.RC5 = 1;
 PORTC.RC1 = 1;
 PORTC.RB0 = 0;
 while(1){
 temperatura = ADC_Read(2);
 temperatura/=2;
 EEPROM_Write(amostragem,temperatura);
 amostragem++;
 if (amostragem == 150){
 tempDisplay = temperatura;
 calculaMedia();
 amostragem = 0;
 }
 iLeituraAD= ADC_Read(0);
 iLeituraAD=(iLeituraAD*0.24);
 if (temperatura > 30) {
 PWM1_Set_Duty(temperatura*3);
 PORTC.RC1 = 0;
 }
 else {
 PWM1_Set_Duty(0);
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
#line 178 "C:/Users/aluno/Desktop/joao/ProjetoSimplesPIC/trabalho.c"
 WordToStr(iReg_timer1, ucTexto);
 Lcd_Out(2,6,ucTexto);
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
