library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sram is
    Port ( wr : in STD_LOGIC;
           en : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR(9 downto 0);
           data_in : in STD_LOGIC_VECTOR(7 downto 0);
           data_out : out STD_LOGIC_VECTOR(7 downto 0));
end sram;

architecture Behavioral of sram is

type memtype is array(0 to 1023) of std_logic_vector(7 downto 0);

signal SRAM: memtype := (others =>X"00000000");

begin

process(wr,en,address,data_in)
begin
    if en = '1' then
        if wr = '0' then
            data_out <= SRAM(conv_integer(address));
        else if wr = '1' then
            SRAM(conv_integer(address)) <= data_in;
            end if;
        end if;
    end if;
end process;

end Behavioral;
