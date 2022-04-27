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
        if pixel_col <= 690 and pixel_col >= 110 then
            if (pixel_row >= 10 and pixel_row <= 30) or
            (pixel_row >= 50 and pixel_row <= 70) or
            (pixel_row >= 90 and pixel_row <= 110) or
            (pixel_row >= 130 and pixel_row <= 150) or
            (pixel_row >= 170 and pixel_row <= 190) or
            (pixel_row >= 210 and pixel_row <= 230) or
            (pixel_row >= 250 and pixel_row <= 270) or
            (pixel_row >= 290 and pixel_row <= 310) or
            (pixel_row >= 330 and pixel_row <= 350) or
            (pixel_row >= 370 and pixel_row <= 390) or
            (pixel_row >= 410 and pixel_row <= 430) or
            (pixel_row >= 450 and pixel_row <= 470) or
            (pixel_row >= 490 and pixel_row <= 510) or
            (pixel_row >= 530 and pixel_row <= 550) or
            (pixel_row >= 570 and pixel_row <= 590) then
                bat_on <= '1';
            elsif (pixel_row >= 30 and pixel_row <= 50) or
            (pixel_row >= 70 and pixel_row <= 90) or
            (pixel_row >= 110 and pixel_row <= 130) or
            (pixel_row >= 150 and pixel_row <= 170) or
            (pixel_row >= 190 and pixel_row <= 210) or
            (pixel_row >= 230 and pixel_row <= 250) or
            (pixel_row >= 270 and pixel_row <= 290) or
            (pixel_row >= 310 and pixel_row <= 330) or
            (pixel_row >= 350 and pixel_row <= 370) or
            (pixel_row >= 390 and pixel_row <= 410) or
            (pixel_row >= 430 and pixel_row <= 450) or
            (pixel_row >= 470 and pixel_row <= 490) or
            (pixel_row >= 510 and pixel_row <= 530) or
            (pixel_row >= 550 and pixel_row <= 570) then
                if (pixel_col >= 110 and pixel_col <= 130) or
                (pixel_col >= 150 and pixel_col <= 170) or
                (pixel_col >= 190 and pixel_col <= 210) or
                (pixel_col >= 230 and pixel_col <= 250) or
                (pixel_col >= 270 and pixel_col <= 290) or
                (pixel_col >= 310 and pixel_col <= 330) or
                (pixel_col >= 350 and pixel_col <= 370) or
                (pixel_col >= 390 and pixel_col <= 410) or
                (pixel_col >= 430 and pixel_col <= 450) or
                (pixel_col >= 470 and pixel_col <= 490) or
                (pixel_col >= 510 and pixel_col <= 530) or
                (pixel_col >= 550 and pixel_col <= 570) or
                (pixel_col >= 590 and pixel_col <= 610) or
                (pixel_col >= 630 and pixel_col <= 650) or
                (pixel_col >= 670 and pixel_col <= 690) then
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
        IF right = '1' AND ball_x < 680 THEN -- bounce off right wall
            if ball_y - gap <= 20 and ball_y + gap >= 20 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(20, 11);
            elsif ball_y - gap <= 60 and ball_y + gap >= 60 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(60, 11);
            elsif ball_y - gap <= 100 and ball_y + gap >= 100 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(100, 11);
            elsif ball_y - gap <= 140 and ball_y + gap >= 140 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(140, 11);
            elsif ball_y - gap <= 180 and ball_y + gap >= 180 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 220 and ball_y + gap >= 220 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 260 and ball_y + gap >= 260 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 300 and ball_y + gap >= 300 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(300, 11);
            elsif ball_y - gap <= 340 and ball_y + gap >= 340 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(340, 11);
            elsif ball_y - gap <= 380 and ball_y + gap >= 380 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(380, 11);
            elsif ball_y - gap <= 420 and ball_y + gap >= 420 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(420, 11);
            elsif ball_y - gap <= 460 and ball_y + gap >= 460 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(460, 11);
            elsif ball_y - gap <= 500 and ball_y + gap >= 500 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(500, 11);
            elsif ball_y - gap <= 540 and ball_y + gap >= 540 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 580 and ball_y + gap >= 580 then
                ball_x <= ball_x + 1;
                ball_y <= conv_std_logic_vector(580, 11);
            end if;
        ELSIF left = '1' AND ball_x > 120 THEN -- bounce off left wall
            if ball_y - gap <= 20 and ball_y + gap >= 20 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(20, 11);
            elsif ball_y - gap <= 60 and ball_y + gap >= 60 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(60, 11);
            elsif ball_y - gap <= 100 and ball_y + gap >= 100 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(100, 11);
            elsif ball_y - gap <= 140 and ball_y + gap >= 140 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(140, 11);
            elsif ball_y - gap <= 180 and ball_y + gap >= 180 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(180, 11);
            elsif ball_y - gap <= 220 and ball_y + gap >= 220 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(220, 11);
            elsif ball_y - gap <= 260 and ball_y + gap >= 260 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(260, 11);
            elsif ball_y - gap <= 300 and ball_y + gap >= 300 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(300, 11);
            elsif ball_y - gap <= 340 and ball_y + gap >= 340 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(340, 11);
            elsif ball_y - gap <= 380 and ball_y + gap >= 380 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(380, 11);
            elsif ball_y - gap <= 420 and ball_y + gap >= 420 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(420, 11);
            elsif ball_y - gap <= 460 and ball_y + gap >= 460 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(460, 11);
            elsif ball_y - gap <= 500 and ball_y + gap >= 500 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(500, 11);
            elsif ball_y - gap <= 540 and ball_y + gap >= 540 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(540, 11);
            elsif ball_y - gap <= 580 and ball_y + gap >= 580 then
                ball_x <= ball_x - 1;
                ball_y <= conv_std_logic_vector(580, 11);
            end if;
        elsif up = '1' AND ball_y > 20 then
            if ball_x - gap <= 120 and ball_x + gap >= 120 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(120, 11);
            elsif ball_x - gap <= 160 and ball_x + gap >= 160 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(160, 11);
            elsif ball_x - gap <= 200 and ball_x + gap >= 200 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(200, 11);
            elsif ball_x - gap <= 240 and ball_x + gap >= 240 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(240, 11);
            elsif ball_x - gap <= 280 and ball_x + gap >= 280 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(280, 11);
            elsif ball_x - gap <= 320 and ball_x + gap >= 320 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(320, 11);
            elsif ball_x - gap <= 360 and ball_x + gap >= 360 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(360, 11);
            elsif ball_x - gap <= 400 and ball_x + gap >= 400 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(400, 11);
            elsif ball_x - gap <= 440 and ball_x + gap >= 440 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(440, 11);
            elsif ball_x - gap <= 480 and ball_x + gap >= 480 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(480, 11);
            elsif ball_x - gap <= 520 and ball_x + gap >= 520 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(520, 11);
            elsif ball_x - gap <= 560 and ball_x + gap >= 560 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(560, 11);
            elsif ball_x - gap <= 600 and ball_x + gap >= 600 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(600, 11);
            elsif ball_x - gap <= 640 and ball_x + gap >= 640 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(640, 11);
            elsif ball_x - gap <= 680 and ball_x + gap >= 680 then
                ball_y <= ball_y - 1;
                ball_x <= conv_std_logic_vector(680, 11);
            end if;
        elsif down = '1' and ball_y < 580 then
            if ball_x - gap <= 120 and ball_x + gap >= 120 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(120, 11);
            elsif ball_x - gap <= 160 and ball_x + gap >= 160 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(160, 11);
            elsif ball_x - gap <= 200 and ball_x + gap >= 200 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(200, 11);
            elsif ball_x - gap <= 240 and ball_x + gap >= 240 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(240, 11);
            elsif ball_x - gap <= 280 and ball_x + gap >= 280 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(280, 11);
            elsif ball_x - gap <= 320 and ball_x + gap >= 320 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(320, 11);
            elsif ball_x - gap <= 360 and ball_x + gap >= 360 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(360, 11);
            elsif ball_x - gap <= 400 and ball_x + gap >= 400 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(400, 11);
            elsif ball_x - gap <= 440 and ball_x + gap >= 440 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(440, 11);
            elsif ball_x - gap <= 480 and ball_x + gap >= 480 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(480, 11);
            elsif ball_x - gap <= 520 and ball_x + gap >= 520 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(520, 11);
            elsif ball_x - gap <= 560 and ball_x + gap >= 560 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(560, 11);
            elsif ball_x - gap <= 600 and ball_x + gap >= 600 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(600, 11);
            elsif ball_x - gap <= 640 and ball_x + gap >= 640 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(640, 11);
            elsif ball_x - gap <= 680 and ball_x + gap >= 680 then
                ball_y <= ball_y + 1;
                ball_x <= conv_std_logic_vector(680, 11);
            end if;
        END IF;
    END PROCESS;
END Behavioral;
