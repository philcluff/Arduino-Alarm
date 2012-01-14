int warn_led = 13;
int ok_led = 11;
int serialSpeed = 9600;
int sensor = 7;
int val = 0;

void setup() {
  pinMode(ok_led, OUTPUT);
  pinMode(warn_led, OUTPUT);
  pinMode(sensor, INPUT);
  Serial.begin(9600);
}

void loop() {
    delay(500); 
    val = digitalRead(sensor);
    
    if(val == HIGH) {
      digitalWrite(warn_led, LOW);
      digitalWrite(ok_led, HIGH);
      Serial.println("OK");
    }
    else {
      digitalWrite(warn_led, HIGH);
      digitalWrite(ok_led, LOW);
      Serial.println("WARN");
    }
}
