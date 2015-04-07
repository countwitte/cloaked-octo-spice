#include <Timer.h>
#include <stdio.h>
#include <string.h>

module TempTestC
{
	uses
	{
		// General interfaces
		interface Boot;
		interface Timer<TMilli>;
		interface Leds;
		
		// Read
		interface Read<uint16_t> as TempRead;	
	}
}

implementation
{


	event void Boot.booted()
	{
		call Timer.startPeriodic(1024);
		call Leds.led1On();
	}
	
	event void Timer.fired()
	{
		if(call TempRead.read() == SUCCESS)
		{
			call Leds.led2Toggle();
		}
		else
		{
			call Leds.led0Toggle();
		}
	}
	
	event void TempRead.readDone(error_t result, uint16_t val){
	{
		if(result == SUCCESS)
		{
			printf("Current temp is: %d", val);
		}
		else 
		{
			printf("Error reading from sensor!");
		}
	}
	}
	
}