#ifndef TEMP_TEST_H
#define TEMP_TEST_H

enum {
	AM_TEMPTORADIO = 6,
	TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct TempToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temp;
} TempToRadioMsg;

#endif /* TEMP_TEST_H */
