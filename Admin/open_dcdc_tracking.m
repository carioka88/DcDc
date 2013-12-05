function [ conn ] = open_dcdc_tracking( )
%OPEN_DCDC_TRACKING Summary of this function goes here
%   Detailed explanation goes here

    % Set preferences with setdbprefs.
    s.DataReturnFormat = 'cellarray';
    s.ErrorHandling = 'store';
    s.NullNumberRead = 'NaN';
    s.NullNumberWrite = 'NaN';
    s.NullStringRead = 'null';
    s.NullStringWrite = 'null';
    s.JDBCDataSourceFile = '';
    s.UseRegistryForSources = 'yes';
    s.TempDirForRegistryOutput = 'C:\Users\blanchot\AppData\Local\Temp';
    s.DefaultRowPreFetch = '10000';
    setdbprefs(s);
    
    % Connection parameters
    dbname   = 'dcdc_tracking';
    dbschema = 'dcdc_tracking';
    dbpwd    = 'DcDc_prod';

    % Make connection to database.  Note that the password has been omitted.
    % Using ODBC driver.
    conn = database(dbname,dbschema,dbpwd);

end

