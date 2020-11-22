library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity la_mia_butterfly is
  port (
  clock
  ) ;
end la_mia_butterfly ; 

architecture myArch of la_mia_butterfly is

begin

identifier : process( clock )
begin
  if( rising_edge(clock) ) then
    
  end if ;
end process ; -- identifier
end architecture ;


