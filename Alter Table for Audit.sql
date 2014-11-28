


	ALTER TABLE <TableName, varchar, tbl_> add
		_user varchar(25) default (suser_sname()) NULL,
		_tstamp datetime default (getdate()) NULL,
		_rowver timestamp NULL,
		_host varchar(25) default (host_name()) NULL,
		_app varchar(25) default (app_name()) NULL
	go