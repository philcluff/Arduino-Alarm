// Poll a reed switch and send its current state via serial.
// The reed switch in this case is closed when the magnet is
// within range of the sensor.

// Configuration
int warn_led = 13;
int ok_led = 11;
int serialSpeed = 9600;
int sensor = 7;
int val = 0;

// Setup the I/O pins and set the serial rate
void setup() {
  pinMode(ok_led, OUTPUT);
  pinMode(warn_led, OUTPUT);
  pinMode(sensor, INPUT);
  Serial.begin(9600);
}

// Looooooooop!
void loop() {
    delay(500); 
    val = digitalRead(sensor);
 
   // If the switch is closed (Door closed)
   if(val == HIGH) {
      digitalWrite(warn_led, LOW);
      digitalWrite(ok_led, HIGH);
      Serial.println("OK");
    }
    
   // If the switch is open (Door open)
    else {
      digitalWrite(warn_led, HIGH);
      digitalWrite(ok_led, LOW);
      Serial.println("WARN");
    }

}
