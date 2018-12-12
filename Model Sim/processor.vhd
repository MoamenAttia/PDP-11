LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity myProcessor is
    Generic (n : integer := 16);
    port(
           decoder_srcA_selector , decoder_srcB_selector, decoder_dist_selector , aluSelector    : in    std_logic_vector(3 downto 0);
           decoder_srcA_enable   , decoder_srcB_enable  , decoder_dist_enable  , aluCarryIn      : in    std_logic;
           clkRam , clkNormal    , rst , writeMem , readMem                                      : in    std_logic;
           busA , busB , busC                                                                    : inout std_logic_vector(n-1 downto 0)
        );
End myProcessor;

Architecture a_myProcessor of myProcessor is
    signal srcA_enable  : std_logic_vector(n-1 downto 0);
    signal srcB_enable  : std_logic_vector(n-1 downto 0);
    signal dist_enable : std_logic_vector(n-1 downto 0);
    signal RoOut   : std_logic_vector(n-1 downto 0);
    signal R1Out   : std_logic_vector(n-1 downto 0);
    signal R2Out   : std_logic_vector(n-1 downto 0);
    signal R3Out   : std_logic_vector(n-1 downto 0);
    signal R4Out   : std_logic_vector(n-1 downto 0);
    signal R5Out   : std_logic_vector(n-1 downto 0);
    signal R6Out   : std_logic_vector(n-1 downto 0);
    signal R7Out   : std_logic_vector(n-1 downto 0);
    signal MAROut  : std_logic_vector(5 downto 0);
    signal MDROut  : std_logic_vector(n-1 downto 0);
    signal readBus : std_logic;
    signal dataMemory : std_logic_vector(n-1 downto 0);
    signal tempCarryOut   : std_logic;
    begin

    decoder_dist : entity work.decoder4x16 port map ( decoder_dist_selector , dist_enable , decoder_dist_enable );    -- elly gaylak mn el left

    decoder_srcA  : entity work.decoder4x16 port map ( decoder_srcA_selector  , srcA_enable  , decoder_srcA_enable  );    -- elly gaylak mn el left
    decoder_srcB  : entity work.decoder4x16 port map ( decoder_srcB_selector  , srcB_enable  , decoder_srcB_enable  );    -- elly gaylak mn el left

    Ro : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(0) , busC , RoOut );
    R1 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(1) , busC , R1Out );
    R2 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(2) , busC , R2Out );
    R3 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(3) , busC , R3Out );
    R4 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(4) , busC , R4Out );
    R5 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(5) , busC , R5Out );
    R6 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(6) , busC , R6Out );
    R7 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(7) , busC , R7Out );




    myMAR : entity work.mar generic map (6) port map ( clkNormal , rst , busC(5 downto 0) , MAROut , dist_enable(8) );
    myMDR : entity work.mdr generic map (n) port map ( clkNormal , rst , readBus , readMem , dataMemory , busC , MDROut );

    myRama : entity work.real_ram generic map(n) port map ( clkRam , writeMem , MAROut , MDROut , dataMemory ) ;

    tri_state_Ro_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(0) , RoOut , busA );
    tri_state_Ro_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(0)  , RoOut , busB );

    tri_state_R1_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(1) , R1Out , busA );
    tri_state_R1_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(1) , R1Out , busB );

    tri_state_R2_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(2) , R2Out , busA );
    tri_state_R2_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(2) , R2Out , busB );

    tri_state_R3_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(3) , R3Out , busA );
    tri_state_R3_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(3) , R3Out , busB );

    tri_state_R4_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(4) , R4Out , busA );
    tri_state_R4_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(4) , R4Out , busB );

    tri_state_R5_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(5) , R5Out , busA );
    tri_state_R5_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(5) , R5Out , busB );

    tri_state_R6_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(6) , R6Out , busA );
    tri_state_R6_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(6) , R6Out , busB );

    tri_state_R7_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(7) , R7Out , busA );
    tri_state_R7_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(7) , R7Out , busB );

    tri_state_MDR_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(9) , MDROut , busA );
    tri_state_MDR_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(9) , MDROut , busB );

    myALU : entity work.ALU generic map(n) port map( busA , busB , aluSelector , aluCarryIn , busC , tempCarryOut );

    readBus <= '0' when readMem='1' else
    dist_enable(9);

End a_myProcessor;
