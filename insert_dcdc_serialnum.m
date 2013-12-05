function  insert_dcdc_serialnum( conn, serialnum )
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
    
    % Write data to database.
    insert(conn,'TEST_TABLE',{'SERIALNUM'},serialnum);


end

