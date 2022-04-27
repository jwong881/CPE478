LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY player IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        right : in std_logic ;
        up : in std_logic ;
        left : in std_logic ;
        down : in std_logic 
    );
END player;

ARCHITECTURE Behavioral OF player IS
    CONSTANT bsize : INTEGER := 10; -- ball size in pixels
    -- distance ball moves each frame
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    -- current ball position - intitialized to center of screen
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    constant gap : integer := 5;
BEGIN
    red <= NOT bat_on or ball_on; -- color setup for red ball and cyan bat on white background
    green <= NOT ball_on;
    blue <= NOT ball_on;
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_on <= '1';
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    batdraw : process (pixel_row, pixel_col) is
    begin
        if pixel_col <= 450 and pixel_col >= 350 then
            if (pixel_row >= 250 and pixel_row <= 270) or
            (pixel_row >= 290 and pixel_row <= 310) or
            (pixel_row >= 330 and pixel_row <= 350) then
                bat_on <= '1';
            elsif (pixel_row >= 270 and pixel_row <= 290) or
            (pixel_row >= 310 and pixel_row <= 330) then
                if (pixel_col >= 350 and pixel_col <= 370) or
                (pixel_col >= 390 and pixel_col <= 410) or
                (pixel_col >= 430 and pixel_col <= 450) then
                    bat_on <= '1';
                else
                    bat_on <= '0';
                end if;
            else
                bat_on <= '0';
            end if;
        else
            bat_on <= '0';
        end if;
    end process;
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' THEN -- test for new serve
            ball_x <= CONV_STD_LOGIC_VECTOR(400, 11);
            ball_y <= CONV_STD_LOGIC_VECTOR(300, 11);
        END IF;
        IF right = '1' AND ball_x < 440 THEN -- bounce off right wall
            if ball_y - gap <= 260 and ball_y + gap >= 260 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 300 and ball_y + gap >= 300 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(300, 11);
            elsif ball_y - gap <= 340 and ball_y + gap >= 340 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(340, 11);
            end if;
        ELSIF left = '1' AND ball_x > 360 THEN -- bounce off left wall
            if ball_y - gap <= 260 and ball_y + gap >= 260 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 300 and ball_y + gap >= 300 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(300, 11);
            elsif ball_y - gap <= 340 and ball_y + gap >= 340 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(340, 11);
            end if;
        elsif up = '1' AND ball_y > 260 then
            if ball_x - gap <= 360 and ball_x + gap >= 360 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(360, 11);
            elsif ball_x - gap <= 400 and ball_x + gap >= 400 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(400, 11);
            elsif ball_x - gap <= 440 and ball_x + gap >= 440 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(440, 11);
            end if;
        elsif down = '1' and ball_y < 340 then
            if ball_x - gap <= 360 and ball_x + gap >= 360 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(360, 11);
            elsif ball_x - gap <= 400 and ball_x + gap >= 400 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(400, 11);
            elsif ball_x - gap <= 440 and ball_x + gap >= 440 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(440, 11);
            end if;
        END IF;
    END PROCESS;
END Behavioral;
