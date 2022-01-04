library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cache is
    Port ( address : in STD_LOGIC_VECTOR (19 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           datamem : in STD_LOGIC_VECTOR (31 downto 0);
           dataproc : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end cache;

architecture Behavioral of cache is

component sram is
    Port ( wr : in STD_LOGIC;
           en : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR(9 downto 0);
           data_in : in STD_LOGIC_VECTOR(7 downto 0);
           data_out : out STD_LOGIC_VECTOR(7 downto 0));
end component;

--signals for each sram
signal wr, en: std_logic := '0'; 
signal index: std_logic_vector(9 downto 0) := (others => '0');
type sram_io is array (0 to 3) of std_logic_vector(7 downto 0);
signal data_out_sram: sram_io := (others => "00000000");
signal data_in_sram: sram_io := (others => "00000000");
signal sram_tag: std_logic_vector(7 downto 0) := "00000000";

--signals from address input
signal offset: std_logic_vector(1 downto 0) := "00"; 
signal wanted_tag: std_logic_vector(7 downto 0) := (others => '0');

--signal for comparator
signal cmp: std_logic := '0';
    --if 1, hit
    --if 0, miss
    
--signal for data_in selection
signal source: std_logic := '0';
    --if 1, memory
    --if 0, processor

begin

--if miss, write from memory, else write from processor where you wanted it to be written
control_unit: process(read, write, cmp, address)
begin
    if read = '1' then
        wr <= '0';
        en <= '1';
        source <= '0'; 
    else
        if write = '1' then
            if cmp = '0' then
                en <= '1';
                
            else
            if cmp = '1' then
                en <= '1';
                wr <= '1';
                source <= '1';
            end if;
            end if;
         end if;
    end if;
end process;

data_out_mux: process(offset, data_out_sram)
begin
    data_out <= data_out_sram(conv_integer(offset));
end process;

tag_comparison: process(wanted_tag, sram_tag)
begin
    if wanted_tag = sram_tag then
        cmp <= '1';
    else
        cmp <= '0';
    end if;
end process;

D0: sram port map (wr => wr, en => en, address => index, data_in => data_in_sram(0), data_out => data_out_sram(0));
D1: sram port map (wr => wr, en => en, address => index, data_in => data_in_sram(1), data_out => data_out_sram(1));
D2: sram port map (wr => wr, en => en, address => index, data_in => data_in_sram(2), data_out => data_out_sram(2));
D3: sram port map (wr => wr, en => en, address => index, data_in => data_in_sram(3), data_out => data_out_sram(3));
tag: sram port map (wr => wr, en => en, address => index, data_in => wanted_tag, data_out => sram_tag);


end Behavioral;
