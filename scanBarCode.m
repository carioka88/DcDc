%%Function that load the python file to be able to scan the barcode in an interface.
%%% Return a cell{1,3}: cell{1}(1) is the model,
%%%                     cell{1}(2) is the number
%%%                     cell{1}(3) is the voltage
%%% The model and the number together form the converter name

function dataConverter = scanBarCode()

global connection;
global TEST_STATE;
global exitVar;

TEST_STATE = 0;

connection = open_dcdc_tracking();
if connection.Message ~= 0
    'ERROR'
    return;
end

exitVar = 0;
msg = '';
while exitVar ~= 3
    while exitVar ~= 3
        systemCommand = ['C:\Python27\python.exe scanner.py ' '' msg '' ];
        [status data] = system(systemCommand);
        dataConverter = {strsplit(data,',')};
        [f c] = size(dataConverter{1});
        if(strfind(data, 'Exit') == 1)
            exitVar = 1;
            return;
        else
            %c = 3 because there are 3 element,
            if (c == 3)
                %Check if the converter is connected
                try 
                    if(str2double(dataConverter{1}(3)) < 0)
                        exitVar = 3;    
                    else
                        try
                            cd('./TestConverter'); %Change folder
                            if(checkConnectivity() < 0.3)
                                cd('..'); %Change folder
                                exitVar = 2;
                                msg = 'CHECK_ALL_THE_INSTRUMENTS';
                            else
                                cd('..'); %Change folder
                                exitVar = 3;   
                            end
                        catch
                            cd('..'); %Change folder
                        end
                    end
                catch
                    exitVar = 2;
                    msg = 'CHECK_THE_CONNECTIVITY';
                end
            else
                msg = 'ERROR_SCANNING';
            end
        end
    end

    if (exitVar == 1 )
        guidata(hObject, handles);
        return;
    elseif (exitVar == 3)
       %Check that the first argument is a correct dcdc Model
       action = ['SELECT * FROM CONFIG_DCDC WHERE MODEL = ' '''' str2mat(dataConverter{1}(1)) ''' '];
       cursor = exec(connection, action);
       cursor = fetch(cursor);
       if(strcmp(cursor.Data{1},'No Data'))
           exitVar = 2;
           msg = 'THIS_MODEL_HAS_NOT_BEEN_CONFIGURATED';
       else
           namedcdc = strcat(dataConverter{1}(1),'-',dataConverter{1}(2));
           action = ['SELECT * FROM CONVERTER WHERE MODEL = ' '''' str2mat(dataConverter{1}(1)) ''' AND NAME=' '''' str2mat(namedcdc) ''' '];
           cursor = exec(connection, action);
           cursor = fetch(cursor);
           if(strcmp(cursor.Data{1},'No Data'))
               exitVar = 3;
           else
               exitVar = 2;
               msg = 'CONVERTER_ALREADY_TESTED';
           end
       end
    end
end
