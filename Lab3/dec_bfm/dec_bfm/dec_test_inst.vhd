	component dec_test is
		port (
			clk_clk           : in  std_logic := 'X'; -- clk
			reset_reset_n     : in  std_logic := 'X'; -- reset_n
			sem_export_train  : in  std_logic := 'X'; -- train
			sem_export_red    : out std_logic;        -- red
			sem_export_yellow : out std_logic;        -- yellow
			sem_export_green  : out std_logic         -- green
		);
	end component dec_test;

	u0 : component dec_test
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --        clk.clk
			reset_reset_n     => CONNECTED_TO_reset_reset_n,     --      reset.reset_n
			sem_export_train  => CONNECTED_TO_sem_export_train,  -- sem_export.train
			sem_export_red    => CONNECTED_TO_sem_export_red,    --           .red
			sem_export_yellow => CONNECTED_TO_sem_export_yellow, --           .yellow
			sem_export_green  => CONNECTED_TO_sem_export_green   --           .green
		);

