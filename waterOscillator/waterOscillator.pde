//WaterOscillator
//MAF_Ocero'12
// Serial communication:
// Send: 'S' to stop
//       'G' to start
//       'A1...A9' to change amplitude
//       'P1...P9' to change phase
//       'O1...O9' to change offset
//       'T1...T9' to change frecuency
//       'Z' and 'X' to change the sign of phase
//  
//--------------------------------------------------------------
//-- ArduSnake library: Locomotion of modular snake robots
//-----------------------------------------------------------
//-- Layer: Oscillator
//------------------------------------------------------------
//-- Example of use of the Oscillator layer
//--
//-- Example 5: A mini-wave is used for the locomotion of
//-- a two modules worm robot
//--------------------------------------------------------------
//-- (c) Juan Gonzalez-Gomez (Obijuan), April-2012
//-- GPL license
//--------------------------------------------------------------
#include <Servo.h>
#include <Oscillator.h>


//-- Declare two oscillators
Oscillator osc[2];

//-- Global parameters for the oscillators
//-- Change this parameters for generating different mini-waves
 int A=20;
 int O=0;
 int T=800;
 int grad=180;
 double phase_diff = DEG2RAD(grad); 
int inbyte = 0;         // incoming serial byte
int temp=0;


void setup()
{
  
   Serial.begin(9600);
   
  //-- Attach the oscillators to the two servos
  //-- SERVO 2 and SERVO 4 for the skymega
  //-- If using arduino, you can use the pin numbers (8 and 9 for example)
  osc[0].attach(8);
  osc[1].attach(9);
  
  for (int i=0; i<2; i++) {
    osc[i].SetO(O);
    osc[i].SetA(A);
    osc[i].SetT(T);
  }

  //-- Set the phase difference
  osc[0].SetPh(0);
  osc[1].SetPh(phase_diff);
  delay(600);
  
  confg();
  
  for (int i=0; i<2; i++) {
        osc[i].Stop();
         }

}

void loop()
{
  
  
  if (Serial.available() > 1) {
    // get incoming byte:
    inbyte = Serial.read();
    // read first analog input, divide by 4 to make the range 0-255:
    switch(inbyte){
      case 'A':     //-- Stop command
        temp= Serial.read();
        //temp = constrain(temp, 0, 40);
        temp=temp-48;
        A=temp*10;
        for (int i=0; i<2; i++) {   
        osc[i].SetA(A);
        }
        confg();
        break;
      case 'O':     
        temp= Serial.read();
        temp=temp-48;
        temp=temp*10;
        temp = constrain(temp, 0, 45);
        
        O=temp;
        for (int i=0; i<2; i++) {
        osc[i].SetO(O);
        }
        confg();
        break;
        
      case 'T':    
        temp= Serial.read();
        temp=temp-48;
        
        temp=map(temp,0,9,2,15);
        temp=temp*100;       
        T=temp;
        for (int i=0; i<2; i++) {
        osc[i].SetT(T);
      }
      confg();
        break;
      case 'Z':
        osc[0].SetPh(0);
        osc[1].SetPh(phase_diff);
        break;
        
      case 'X':
        osc[1].SetPh(0);
        osc[0].SetPh(phase_diff);
        break;
       case 'S':
        
         for (int i=0; i<2; i++) {
        osc[i].Stop();
         }
        break;
       case 'G':
        
       for (int i=0; i<2; i++) {
        osc[i].Play();
         }
        break;
        
        case 'P':    
        temp= Serial.read();
        temp=temp-48;
        
        temp=map(temp,0,9,0,180);
              
        grad=temp;
        phase_diff = DEG2RAD(temp); 
        
         osc[0].SetPh(0);
         osc[1].SetPh(phase_diff);
        
      confg();
        break;
     
    }
     
  }
  temp=0;
  
  //-- Refresh the oscillators
  for (int i=0; i<2; i++)
    osc[i].refresh();
}

void confg(){

   //-- Configure the oscillators with the same parameters
 /* for (int i=0; i<2; i++) {
    osc[i].SetO(O);
    osc[i].SetA(A);
    osc[i].SetT(T);
  }

  //-- Set the phase difference
  osc[0].SetPh(0);
  osc[1].SetPh(phase_diff);*/
  
  Serial.print("A= ");
  Serial.println(A);
  Serial.print("T= ");
  Serial.println(T);
  Serial.print("O= ");
  Serial.println(O);
  Serial.print("P= ");   
  Serial.println(grad);
  Serial.println("===================");
  

}


