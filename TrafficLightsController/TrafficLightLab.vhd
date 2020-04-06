-- CREATED BY: Richard Blair
-- DATE: 1/11/2019
-- Student ID: 000947441


library ieee;
use ieee.std_logic_1164.all;

entity TrafficLightLab is 
			port(
				clk,PedButton : in bit;
				red1, red2, amber1, amber2, green1, green2 : out bit;
				PedLight1, PedLight2 : out std_logic_vector(7 downto 0) --holds the appropriate seven segment code for decimal digits
			);
						
end TrafficLightLab;

architecture behaviour of TrafficLightLab is
Type state IS (RED, REDAMBER, AMBER, GREEN); -- Declaration of states
constant sec : integer := 50000000  ;  --clock is 50MHz, so 50 x 10^6 clock edge count will take 1 second

CONSTANT MaximumTime 	: INTEGER := 15*sec;
CONSTANT RedTimer 		: INTEGER := 15*sec;
CONSTANT RedAmberTimer  : INTEGER := 4*sec;
CONSTANT GreenTimer  	: INTEGER := 15*sec;
CONSTANT AmberTimer  	: INTEGER := 4*sec;

SIGNAL Current_Light_State, Next_Light_State : state;
SIGNAL time: INTEGER RANGE 0 TO MaximumTime;

BEGIN
PROCESS(clk, PedButton)
VARIABLE count: INTEGER RANGE 0 TO MaximumTime;
BEGIN
		IF (PedButton = '1') THEN Current_Light_State <= RED;
		
		ELSIF (clk'event) AND(clk = '1') THEN count:= count +1;
		
		IF (count = time) THEN Current_Light_State <= Next_Light_State;
		count :=0;
		
		END IF;
		
		END IF;
		
END PROCESS;

PROCESS(Current_Light_State)
BEGIN
CASE Current_Light_State IS

		WHEN RED => red1 <='1'; red2 <='1'; amber1 <='0'; amber2 <='0'; green1 <='0'; green2 <='0'; 
		time <=RedTimer;
		Next_Light_State <= REDAMBER;
		
		WHEN REDAMBER => red1 <='1'; red2 <='1'; amber1 <='1'; amber2 <='1'; green1 <='0'; green2 <='0';
		time <=AmberTimer;
		Next_Light_State <= GREEN;
		
		WHEN GREEN => red1 <='0'; red2 <='0'; amber1 <='0'; amber2 <='0'; green1 <='1'; green2 <='1'; PedLight1 <="11000000"; PedLight2 <="11000000";
		time <=GREENTimer;
		Next_Light_State <= AMBER;

      WHEN AMBER => red1 <='0'; red2 <='0'; amber1 <='1'; amber2 <='1'; green1 <='0'; green2 <='0'; PedLight1 <="11000000"; PedLight2 <="11000000";
		time <=AmberTimer;
		Next_Light_State <= RED;		

END CASE;
END PROCESS;
END behaviour;		