#line 1 "C:/Users/aluno/joao_pic/ProjetoSimplesPIC/trabalho.c"
#line 46 "C:/Users/aluno/joao_pic/ProjetoSimplesPIC/trabalho.c"
unsigned char ucTexto[10];
unsigned char ucPorcentagem;
unsigned int iLeituraAD = 0;
unsigned int tempAD = 0;
unsigned int iReg_timer1;
unsigned int check_btn1 = 0;
unsigned int check_btn2 = 0;
int amostragem = 1;
short i;
float media;
int value = 0;


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
 TRISB.RB2=1;
 TRISE = 0;


 INTCON.GIEH = 1;
 INTCON.GIEL = 1;
 RCON.IPEN = 1;


 INTCON.TMR0IF = 0;
 INTCON2.TMR0IP = 1;
 INTCON.TMR0IE = 1;

 T0CON = 0B10000100;
 TMR0L = 0X7B;
 TMR0H = 0XE1;
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
 Lcd_Out(1, 1, "Temp: ");
 Lcd_Out(2, 1, "Rot: ");

 PWM1_Init(5000);
 PWM1_Set_Duty(0);
 PWM1_Start();
 PORTC.RC5 = 1;
 PORTC.RC1 = 1;

 while(1){

 tempAD= ADC_Read(2);
 tempAD/=2;
 EEPROM_Write(amostragem,tempAD);
 Delay_ms(100);
 amostragem++;

 iLeituraAD = ADC_Read(0);
 iLeituraAD=(iLeituraAD*0.24);
 if (tempAD > 30) {
 PWM1_Set_Duty(tempAD*3);
 PORTC.RC1 = 0;
 }
 else {
 PWM1_Set_Duty(0);
 }

 if (Button(&PORTB, 2, 1, 1)){
 check_btn1 = 1;
 }
 if (check_btn1 && Button(&PORTB, 2, 1, 0)){
 PORTC.RC5 = ~PORTC.RC5;
 check_btn1 = 0;
 }

 if (Button(&PORTB, 0, 1, 1)){
 check_btn2 = 1;
 }
 if (check_btn2 && Button(&PORTB, 0, 1, 0)){
 for (i = 1; i <= amostragem; i++){
 value = EEPROM_Read(i);;
 media = media + value;
 }
 FloatToStr(media, ucTexto);
 Lcd_Out(2,1,ucTexto);
 Lcd_Out(1, 1, "MEDIA:          ");
 check_btn2 = 0;
 media = media / amostragem;
 FloatToStr(media, ucTexto);
 check_btn1 = 0;
 Lcd_Out(1, 1, "MEDIA:          ");
 Lcd_Out(2,1,ucTexto);
 check_btn1 = 0;
 amostragem = 0;
 }

 iLeituraAD=(iLeituraAD*0.41);
 WordToStr(tempAD, ucTexto);
 Lcd_Out(1,8,ucTexto);

 WordToStr(iReg_timer1, ucTexto);
 Lcd_Out(2,5,ucTexto);
 Lcd_Out_CP(" RPM");
 Delay_10us;
 }
}
