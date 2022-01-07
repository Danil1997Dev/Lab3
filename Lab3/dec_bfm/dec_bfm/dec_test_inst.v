	dec_test u0 (
		.clk_clk           (<connected-to-clk_clk>),           //        clk.clk
		.reset_reset_n     (<connected-to-reset_reset_n>),     //      reset.reset_n
		.sem_export_train  (<connected-to-sem_export_train>),  // sem_export.train
		.sem_export_red    (<connected-to-sem_export_red>),    //           .red
		.sem_export_yellow (<connected-to-sem_export_yellow>), //           .yellow
		.sem_export_green  (<connected-to-sem_export_green>)   //           .green
	);

