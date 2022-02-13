-- https://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
port (clk : in std_logic;
      reset :in std_logic;
      count : out unsigned(3 downto 0)  --output of the design. 4 bit count value.
     );
end adder;

architecture behavioral of adder is

--initializing the count to zero.
signal c : unsigned(3 downto 0) :=(others => '0');  

begin

count <= c;

process(clk,reset)
begin
    if(reset = '1') then    --active high reset for the counter.
        c <= (others => '0');
    elsif(rising_edge(clk)) then
    -- when count reaches its maximum(that is 15) reset it to 0
        if(c = 15) then
            c <= (others => '0');
        else    
            c <= c + 1;  --increment count at every positive edge of clk.
        end if;
    end if; 
end process;

end behavioral;
