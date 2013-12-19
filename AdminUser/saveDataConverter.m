function saveDataConverter(name,model, test, dateTest, vout, channel, address, pass, vIn, iLoad, iMon, iOut, vMon, vOut)
    action = {name, model, test, dateTest, vout, channel, address, pass};
    insert(connection, 'CONVERTER', {'NAME','MODEL', 'TEST', 'DATEC','VOUT', 'CHANNEL', 'ADDRESS', 'PASSTEST'}, action);
    [rImon ColIload] = size(iLoad);
    [rImon ColVin] = size(vIn);
    % Write data to database.
    for j=1:ColIload
        for z=1:ColVin
            action = {name, vIn(z), iLoad(j), iMon(z,j), iOut(z,j), vMon(z,j), vOut(z,j), test, channel};
            insert(connection, 'DCDC_CONVERTER', {'NAME', 'V_IN', 'I_LOAD','IMON', 'IOUT', 'VMON', 'VOUT', 'TEST', 'CHANNEL'}, action);
        end
    end
