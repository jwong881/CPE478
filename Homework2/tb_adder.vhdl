--https://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration for your testbench. 
--Notice that the entity port list is empty here.
entity tb_adder is
end tb_adder;

architecture behavior of tb_adder is

-- component declaration for the unit under test (uut)
component adder is
port (clk : in std_logic;
      reset :in std_logic;
      count : out unsigned(3 downto 0)
     );
end component;

--declare inputs and initialize them to zero.
signal clk : std_logic := '0';
signal reset : std_logic := '0';

--declare outputs
signal count : unsigned(3 downto 0);

-- define the period of clock here.
-- It's recommended to use CAPITAL letters to define constants.
-- https://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
constant CLK_PERIOD : time := 10 ns;

begin

    -- instantiate the unit under test (uut)
   uut : adder port map (
            Clk => Clk,
            reset => reset, 
            count => count
        );      

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   Clk_process :process
   begin
        Clk <= '0';
        wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
        Clk <= '1';
        wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
   end process;
    
   -- Stimulus process, Apply inputs here.
  stim_proc: process
   begin        
        wait for CLK_PERIOD*10; --wait for 10 clock cycles.
        reset <='1';                    --then apply reset for 2 clock cycles.
        wait for CLK_PERIOD*2;
        reset <='0';                    --then pull down reset for 20 clock cycles.
        wait for CLK_PERIOD*20;
        reset <= '1';               --then apply reset for one clock cycle.
        wait for CLK_PERIOD;
        reset <= '0';               --pull down reset and let the counter run.
        wait;
  end process;

end;
