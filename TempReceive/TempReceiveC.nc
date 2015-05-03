#include <Timer.h>
#include <stdio.h>
#include <string.h>
#include "TempReceive.h"

module TempReceiveC
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
		interface Receive;	
	}
}

implementation
{
	bool busy = FALSE;
	message_t pkt;
	uint16_t valc;

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
			valc = (-39.60 + 0.01*val);
			if (!busy) {
				TempToRadioMsg* btrpkt = (TempToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (TempToRadioMsg)));
    			btrpkt->nodeid = TOS_NODE_ID;
    			btrpkt->temp = valc;
    			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TempToRadioMsg)) == SUCCESS) {
      				busy = TRUE;
      			}	
    		}	
			printf("Node ID: %d, Current temp is: %d\n",TOS_NODE_ID, valc);
		}
		else 
		{
			printf("Error reading from sensor!");
		}
	
	}
	
	event void AMSend.sendDone(message_t *msg, error_t error){
		if (&pkt == msg) {
			busy = FALSE;
			call Leds.led2Toggle();
		}	
	}
	
	event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){
		if (len == sizeof(TempToRadioMsg)) {
			TempToRadioMsg* ttrpkt = (TempToRadioMsg*)payload;
			printf("Node ID: %d, Current temp is: %d\n", (ttrpkt->nodeid), (ttrpkt->temp));
		}
		return msg;	
	}
}