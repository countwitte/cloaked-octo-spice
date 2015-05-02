configuration TempTestAppC
{
}

implementation
{
	//General Components
	components TempTestC as App;
	components MainC, LedsC;
	components new TimerMilliC();
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer -> TimerMilliC;
	
	//Radio
	components ActiveMessageC;
	components new AMSenderC(AM_TEMPTORADIO);
	
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	
	// For wiring into serial port
	components SerialPrintfC;
	
	// Temperature Sensor
	components new SensirionSht11C() as TempSensor;
	
	App.TempRead -> TempSensor.Temperature;
	
}