conn = open_dcdc_tracking();
x = [10;11;12];
insert_dcdc_serialnum(conn,x);
close_dcdc_tracking(conn);