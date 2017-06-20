#line 1 "C:/Users/aluno/joao_pic/ProjetoSimplesPIC/trabalho.c"
#line 46 "C:/Users/aluno/joao_pic/ProjetoSimplesPIC/trabalho.c"
unsigned char ucTexto[10];
unsigned char ucPorcentagem;
unsigned int iLeituraAD = 0;
unsigned int tempAD = 0;
unsigned int iReg_timer1;


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
 PORTB.RB0 = ~PORTB.RB0;
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
 TRISE = 0;
 PORTB = 0;


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

 PWM1_Init(5000);
 PWM1_Set_Duty(255);
 PWM1_Start();
 PORTC.RC5 = 1;
 while(1){
 tempAD= ADC_Read(2);
 tempAD/=2;
 iLeituraAD= ADC_Read(0);
 iLeituraAD=(iLeituraAD*0.24);
 PWM1_Set_Duty(iLeituraAD);
 iLeituraAD=(iLeituraAD*0.41);
 WordToStr(tempAD, ucTexto);
 Lcd_Out(1,11,ucTexto);

 WordToStr(iReg_timer1, ucTexto);
 Lcd_Out(2,1,ucTexto);
 Lcd_Out_CP(" RPM");
 PORTC.RC1 = ~PORTC.RC1;
 Delay_10us;
 }
}
