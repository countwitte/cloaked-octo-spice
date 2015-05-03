#include <Timer.h>
#include <stdio.h>
#include <string.h>
#include "TempTest.h"

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
		
		// Radio
		interface Packet;
		interface AMPacket;
		interface AMSend;
		interface SplitControl as AMControl;	
	}
}

implementation
{
	bool busy = FALSE;
	message_t pkt;

	event void Boot.booted()
	{
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t error){
		if (error == SUCCESS) {
			call Timer.startPeriodic(TIMER_PERIOD_MILLI);
			call Leds.led1On();
		}
		else {
			call AMControl.start();	
		}
	}
	
	event void AMControl.stopDone(error_t error){
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
	
		if(result == SUCCESS)
		{
			if (!busy) {
				TempToRadioMsg* ttrpkt = (TempToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (TempToRadioMsg)));
				ttrpkt ->nodeid = TOS_NODE_ID;
				ttrpkt->temp = val;
				if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof (TempToRadioMsg)) == SUCCESS) {
					busy = TRUE;
				}	
			}
			//printf("Current temp is: %d", val);
		}
		else 
		{
			printf("Error reading from sensor!");
		}
	
	}
	
	event void AMSend.sendDone(message_t *msg, error_t error){
		if (&pkt == msg) {
			busy = FALSE;
		}	
	}
	
	
	
}