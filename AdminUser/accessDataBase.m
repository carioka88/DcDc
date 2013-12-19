function varargout = accessDataBase(varargin)
% ACCESSDATABASE MATLAB code for accessDataBase.fig
%      ACCESSDATABASE, by itself, creates a new ACCESSDATABASE or raises the existing
%      singleton*.
%
%      H = ACCESSDATABASE returns the handle to a new ACCESSDATABASE or the handle to
%      the existing singleton*.
%
%      ACCESSDATABASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACCESSDATABASE.M with the given input arguments.
%
%      ACCESSDATABASE('Property','Value',...) creates a new ACCESSDATABASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before accessDataBase_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to accessDataBase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help accessDataBase

% Last Modified by GUIDE v2.5 06-Dec-2013 09:40:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @accessDataBase_OpeningFcn, ...
                   'gui_OutputFcn',  @accessDataBase_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before accessDataBase is made visible.
function accessDataBase_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to accessDataBase (see VARARGIN)

%Initialize variables
handles.c = cell(1,5);


% Choose default command line output for accessDataBase
handles.output = hObject;

global connection;
global converterModel;

connection = open_dcdc_tracking();

if connection.Message ~= 0
    'ERROR'
    return;
end

set(handles.TypeCmenu, 'Visible', 'on');

cursor = exec(connection,'SELECT DISTINCT MODEL FROM DCDC_TRACKING.CONVERTER');
cursor = fetch(cursor);
[row col] = size(cursor.Data);


typeModels = (cursor.Data)';

for i=1:row
    finalName = cell2mat(typeModels(i));
    typeModels(i) = mat2cell(finalName);
end

set(handles.Allbutton, 'Visible', 'on');
set(handles.TypeCmenu, 'String', typeModels);

popup_sel_index = get(handles.TypeCmenu, 'Value');

models = get(handles.TypeCmenu, 'String');
converterModel = models(popup_sel_index);

action = 'SELECT DISTINCT NAME FROM CONVERTER WHERE MODEL = ';
action = [action, '''' cell2mat(converterModel) ''''];

cursor = exec(connection,action);
cursor = fetch(cursor);

arrayData = sort(cursor.Data);
set(handles.listConverter,'Visible', 'on');
set(handles.listConverter,'Value', 1); 
set(handles.textSelectConverter, 'Visible', 'on');
set(handles.textSelectModel, 'Visible', 'on');
set(handles.pushResult, 'Visible', 'on');
set(handles.listConverter,'string', arrayData);
set(handles.actualModel,'string', converterModel);

close(cursor);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes accessDataBase wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = accessDataBase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in TypeCmenu.
function TypeCmenu_Callback(hObject, eventdata, handles)
% hObject    handle to TypeCmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TypeCmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TypeCmenu


% --- Executes during object creation, after setting all properties.
function TypeCmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeCmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Allbutton.
function Allbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Allbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global connection;
    global converterModel;
    popup_sel_index = get(handles.TypeCmenu, 'Value');

    models = get(handles.TypeCmenu, 'String');
    converterModel = models(popup_sel_index);

    action = 'SELECT DISTINCT NAME FROM CONVERTER WHERE MODEL = ';
    action = [action, '''' cell2mat(converterModel) ''''];

    cursor = exec(connection,action);
    cursor = fetch(cursor);

    arrayData = sort(cursor.Data);
    set(handles.listConverter,'Visible', 'on');
    
    set(handles.textSelectConverter, 'Visible', 'on');
    set(handles.textSelectModel, 'Visible', 'on');
    set(handles.listConverter,'Value', 1); 
    set(handles.pushResult, 'Visible', 'on');
    set(handles.listConverter,'string', arrayData);
    set(handles.actualModel,'string', converterModel);
    

    close(cursor);
guidata(hObject, handles);

% --- Executes on button press in addNewModel.
function addNewModel_Callback(hObject, eventdata, handles)
% hObject    handle to addNewModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%algo = get(handles.TypeCmenu, 'Value');
%set(handles.TypeCmenu, 'String', algo);
guidata(hObject, handles);

% --- Executes on selection change in listConverter.
function listConverter_Callback(hObject, eventdata, handles)
% hObject    handle to listConverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listConverter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listConverter
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listConverter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listConverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in graphicButton.
function graphicButton_Callback(hObject, eventdata, handles)
% hObject    handle to graphicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global connection;
numberList = get(handles.listConverter, 'Value');
convertList = get(handles.listConverter, 'String');
converterName = convertList(numberList);

try
    action = ['SELECT ALL V_IN, I_LOAD, IMON, IOUT, VMON, VOUT FROM DCDC_CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);

    [row col] = size(cursor.Data);

    V_mon = [];
    V_out = [];
    I_mon = [];
    I_out = [];

    V_in = cell2mat(cursor.Data(1));
    I_load = cell2mat(cursor.Data(1,2));

    cont_VIN = 1;
    cont_ILOAD = 1;

    for i=1:row

        if (cell2mat(cursor.Data(i, 2)) ~= 0)
            %V_in
            if(V_in(cont_VIN) ~= cell2mat(cursor.Data(i)))
                cont_VIN = cont_VIN + 1;
                V_in(cont_VIN) = cell2mat(cursor.Data(i));
            end

            %I_load
            if(I_load(cont_ILOAD) < cell2mat(cursor.Data(i, 2)))
                cont_ILOAD = cont_ILOAD + 1;
                I_load(cont_ILOAD) = cell2mat(cursor.Data(i, 2));
            end

            vinIndex = find(cell2mat(cursor.Data(i)) == V_in);
            iloadIndex = find(cell2mat(cursor.Data(i,2)) == I_load);

            I_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,3));
            V_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,5));
            I_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,4));
            V_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,6));
        end
    end


    %axes(handles.Graphic);
    %cla;

    %I_load = cell2mat(I_load); 
    %V_in = cell2mat(V_in);

    Pout = V_out.*I_out;
    Pin = V_mon.*I_mon;
    Eff = abs(Pout./Pin);
    
    scrsz = get(0,'ScreenSize');
    %figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2])
    figure1 = figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2]);

    subplot(2,2,1, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),Eff(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end

    legend(lgd, 'Location', 'SouthWest');

    %axis([min(I_load) max(I_load) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Load Current(A)');
    ylabel('Efficiency (%)');
    grid on;
    title('Efficiency vs load Current');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic2);
    %cla;
    subplot(2,2,3, 'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),V_out(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

   % axis([min(V_in) max(V_in) 2 3]);
   if(min(I_load) == 0)
       axis([min(V_in) max(V_in) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   else
       axis([min(V_in) max(V_in) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Output voltage (V)');
    grid on;
    title('Input voltage regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %axes(handles.Graphic3);
    %cla;
    subplot(2,2,4, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),V_out(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthWest');    

    %axis([min(I_load) max(I_load) 2 3]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Output current (A)');
    ylabel('Output voltage (V)');
    grid on;
    title('Load regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic4);
    %cla;
    subplot(2,2,2,'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),Eff(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

    %axis([min(V_in) max(V_in) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(V_in) max(V_in) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(V_in) max(V_in) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Efficiency');
    grid on;
    title('Efficiency vs input voltage');

    action = ['SELECT ALL DATEC FROM CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);

    dateToPrint = cell2mat(cursor.Data);
    dateToPrint = dateToPrint(1:11);

    converterName = cell2mat(converterName);
%     if(converterName(6) == '_')
%         converterName(6) = '-';
%     end

%     converterName = converterName(1:11);
    textTitle = [converterName, '  ', dateToPrint];
    annotation(figure1,'textbox',[0.1 0.92 0.5 0.1],'Interpreter','none',...
        'String', {'' textTitle ''} ,...
        'HorizontalAlignment','right',...
        'FontWeight','bold',...
        'FontSize',16,...
        'FitBoxToText','off',...
        'LineStyle','none');
    
    save2pdf('algo',figure1,600);
   
catch
    %withoutData  
    message = 'There is not data about this converter. Check that it has been tested';
    set(handles.textLog, 'String', message);
    set(handles.textLogTitle, 'Visible', 'on');
    set(handles.textLog, 'Visible', 'on');
end
close(cursor);
guidata(hObject, handles);


% --- Executes on button press in graphicPOP.
function solVOUT = calculateVOUT(namefil, modelfil)
% hObject    handle to graphicPOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global connection;
    [vin iload] = getVinIload(modelfil);
    action = ['SELECT ALL VOUT FROM DCDC_CONVERTER WHERE V_IN = ''' mat2str(vin) ''' AND I_LOAD = ''' mat2str(iload) ''' AND NAME =' '''' namefil '''' ];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    solVOUT = round(cell2mat(cursor.Data(1))*10)/10;
    %update(connection, 'CONVERTER', {'VOUT'}, {number}, action);
    close(cursor);
    
    


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global connection;

% e.Data;
close_dcdc_tracking(connection);

%clc
set(handles.TypeCmenu, 'Visible', 'off');
set(handles.Allbutton, 'Visible', 'off');
set(handles.listConverter,'Visible', 'off');
set(handles.graphicButton, 'Visible', 'off');
set(handles.pushPrint, 'Visible', 'off');
guidata(hObject, handles);

delete(hObject);


% --- Executes on selection change in popupTEST.
function popupTEST_Callback(hObject, eventdata, handles)
% hObject    handle to popupTEST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupTEST contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupTEST


% --- Executes during object creation, after setting all properties.
function popupTEST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupTEST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushResult.
function pushResult_Callback(hObject, eventdata, handles)
% hObject    handle to pushResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
global converterName;
msgTest = '';
try
    %Make not visible the other information
    set(handles.TypeCmenu, 'Visible', 'off');
    set(handles.Allbutton, 'Visible', 'off');
    set(handles.listConverter,'Visible', 'off');
    %set(handles.graphicButton, 'Visible', 'off');
    set(handles.textSelectConverter, 'Visible', 'off');
    set(handles.textSelectModel, 'Visible', 'off');

    set(handles.pushBack, 'Visible', 'on');


    numberList = get(handles.listConverter, 'Value');
    convertList = get(handles.listConverter, 'String');
    converterName = convertList(numberList); %Take the converter name selected
    modelC = get(handles.actualModel, 'String');
    action = ['SELECT VOUT, TEST, PASSTEST FROM CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    expectedVout = cursor.Data{1,1};
    passTest = cursor.Data{1,3};
    
    [totalTest col] = size(cursor.Data);
    numberTest = [];
    for i=1:totalTest
        numberTest = [numberTest; i];
    end
    
    voutTest = calculateVOUT(converterName{1}, char(modelC));
    %changeResults(converterName{1}, expectedVout, totalTest, numberTest, handles, str2mat(modelC));
    set(handles.textName,'string', converterName{1});
    set(handles.numberTestEdit,'string', totalTest);
    set(handles.popupTEST,'string', numberTest);
    set(handles.text2,'Visible', 'on');
    set(handles.textName,'Visible', 'on');
    set(handles.numberTestEdit,'Visible', 'on');
    set(handles.graphicButton, 'Visible', 'on');
    set(handles.pushPrint, 'Visible', 'on');
    set(handles.popupTEST,'Visible', 'on');
    set(handles.pushResult,'Visible', 'off');
    set(handles.newResult,'Visible', 'on');
    set(handles.text11,'Visible', 'on');
    set(handles.uipanel2,'Visible', 'on');
    set(handles.textPass, 'Visible', 'on');
    set(handles.textVoutValue, 'Visible', 'on');
    set(handles.textVoutValue, 'String', [num2str(expectedVout), '  V']);
    
    if( strcmp(passTest, '1'))
%       set(handles.textPass,'String', 'YES');
        msgTest = ['The converter has been tested correctly and has the correct results'];
        set(handles.textPass, 'Value', 1); 
    end
    efficiencyCallback(hObject, eventdata, handles, msgTest, expectedVout, voutTest);
catch
    %withoutData 
    set(handles.TypeCmenu, 'Visible', 'on');
    set(handles.Allbutton, 'Visible', 'on');
    set(handles.listConverter,'Visible', 'on');
    set(handles.graphicButton, 'Visible', 'off');
    set(handles.pushPrint, 'Visible', 'off');
    set(handles.textSelectModel, 'Visible', 'on');
    set(handles.textSelectConverter, 'Visible', 'off');

    set(handles.pushBack, 'Visible', 'off');

end

function changeResults(nameConverter, voutExpected, testNumberTotal, testNumber, handles, modelfil)

    voutTest = calculateVOUT(nameConverter, modelfil);
    
    set(handles.textName,'string', nameConverter);
    set(handles.checkVout,'string', voutExpected);
    set(handles.voutDefault,'string', voutTest);
    set(handles.numberTestEdit,'string', testNumberTotal);
    set(handles.popupTEST,'string', testNumber);
    
function [vinPoint iloadPoint] = getVinIload(modelC)
    global connection;
    
    action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL=' '''' modelC ''' AND CONFIG= ''AVG_V'''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    pointAvg = cursor.Data{1};
    
    action = ['SELECT VALUE FROM CONFIG_DCDC WHERE POINT = ''' mat2str(pointAvg) ''' AND CONFIG = ''VIN'' AND MODEL =' '''' modelC '''' ];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    vinPoint = cursor.Data{1};

    action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL=' '''' modelC ''' AND CONFIG = ''AVG_IL1'''];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    pointAvg = cursor.Data{1};
    
    action = ['SELECT VALUE FROM CONFIG_DCDC WHERE POINT = ''' mat2str(pointAvg) ''' AND CONFIG = ''ILOAD'' AND MODEL =' '''' modelC '''' ];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    iloadPoint = cursor.Data{1};
    
    close(cursor);


% --- Executes on button press in pushBack.
function pushBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.TypeCmenu, 'Visible', 'on');
set(handles.Allbutton, 'Visible', 'on');
set(handles.listConverter,'Visible', 'on');
set(handles.textSelectConverter, 'Visible', 'on');
set(handles.textSelectModel, 'Visible', 'on');
set(handles.graphicButton, 'Visible', 'off');
set(handles.pushPrint, 'Visible', 'off');
set(handles.pushBack, 'Visible', 'off');
set(handles.text2,'Visible', 'off');
set(handles.textName,'Visible', 'off');
set(handles.numberTestEdit,'Visible', 'off');
set(handles.popupTEST,'Visible', 'off');
set(handles.pushResult,'Visible', 'on');
set(handles.newResult,'Visible', 'off');
set(handles.text11,'Visible', 'off');
set(handles.uipanel2,'Visible', 'off');
set(handles.textPass, 'Visible', 'off');

set(handles.checkVout, 'Visible', 'off');
set(handles.checkEff, 'Visible', 'off');
set(handles.checkIin, 'Visible', 'off');
set(handles.checkDrop, 'Visible', 'off');
  
set(handles.textObtained, 'Visible', 'off'); 
set(handles.textExpected, 'Visible', 'off'); 
set(handles.textPoint_E1, 'Visible', 'off'); 
set(handles.textPoint_E2, 'Visible', 'off');  
set(handles.textPoint_D1, 'Visible', 'off'); 
set(handles.textPoint_D2, 'Visible', 'off');

set(handles.textValueDrop1, 'Visible', 'off');
set(handles.textValueDrop2, 'Visible', 'off');
set(handles.textExpectDrop1, 'Visible', 'off');
set(handles.textExpectDrop2, 'Visible', 'off');
set(handles.textValueEff1, 'Visible', 'off');
set(handles.textValueEff2, 'Visible', 'off');
set(handles.textExpectEff1, 'Visible', 'off');
set(handles.textExpectEff2, 'Visible', 'off');

set(handles.textLogTitle, 'Visible', 'off');
set(handles.textLog, 'Visible', 'off');

% --- Executes on button press in newResult.
function newResult_Callback(hObject, eventdata, handles)
% hObject    handle to newResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;

converterTest = get(handles.popupTEST, 'Value');
converterName = get(handles.textName, 'String');
modelC = get(handles.actualModel, 'String');

try
    action = ['SELECT VOUT, PASSTEST FROM CONVERTER WHERE TEST = ''' mat2str(converterTest) ''' AND NAME =' '''' str2mat(converterName) ''' '];
   
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    expectedVout = cursor.Data{1,1};
    passTest = cursor.Data{1,2};
    
    voutTest = calculateVOUT(str2mat(converterName), str2mat(modelC));
    
    set(handles.textName,'string', converterName);
    %set(handles.numberTestEdit,'string', totalTest);
    %set(handles.popupTEST,'string', numberTest);
    
    if( strcmp(passTest, '1'))
%         set(handles.textPass,'String', 'YES');
       msgTest = ['The converter has been tested correctly and has the correct results'];
       set(handles.textPass, 'Value', 1); 
    end
    efficiencyCallback(hObject, eventdata, handles, msgTest, expectedVout, voutTest);
    
catch
    %withoutData 
    message = 'There is not data about this converter. Check that it has been tested';
    set(handles.textLog, 'String', message);
    set(handles.textLogTitle, 'Visible', 'on');
    set(handles.textLog, 'Visible', 'on');
end





% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text2.
function text2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushPrint.
function pushPrint_Callback(hObject, eventdata, handles)
% hObject    handle to pushPrint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global connection;
numberList = get(handles.listConverter, 'Value');
convertList = get(handles.listConverter, 'String');
converterName = convertList(numberList);

try
    action = ['SELECT ALL V_IN, I_LOAD, IMON, IOUT, VMON, VOUT FROM DCDC_CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);

    [row col] = size(cursor.Data);

    V_mon = [];
    V_out = [];
    I_mon = [];
    I_out = [];

    V_in = cell2mat(cursor.Data(1));
    I_load = cell2mat(cursor.Data(1,2));

    cont_VIN = 1;
    cont_ILOAD = 1;

    for i=1:row

        if (cell2mat(cursor.Data(i, 2)) ~= 0)
            %V_in
            if(V_in(cont_VIN) ~= cell2mat(cursor.Data(i)))
                cont_VIN = cont_VIN + 1;
                V_in(cont_VIN) = cell2mat(cursor.Data(i));
            end

            %I_load
            if(I_load(cont_ILOAD) < cell2mat(cursor.Data(i, 2)))
                cont_ILOAD = cont_ILOAD + 1;
                I_load(cont_ILOAD) = cell2mat(cursor.Data(i, 2));
            end

            vinIndex = find(cell2mat(cursor.Data(i)) == V_in);
            iloadIndex = find(cell2mat(cursor.Data(i,2)) == I_load);

            I_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,3));
            V_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,5));
            I_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,4));
            V_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,6));
        end
    end


    %axes(handles.Graphic);
    %cla;

    %I_load = cell2mat(I_load); 
    %V_in = cell2mat(V_in);

    Pout = V_out.*I_out;
    Pin = V_mon.*I_mon;
    Eff = abs(Pout./Pin);
    
    scrsz = get(0,'ScreenSize');
    %figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2])
    figure1 = figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2]);

    subplot(2,2,1, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),Eff(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end

    legend(lgd, 'Location', 'SouthWest');

    %axis([min(I_load) max(I_load) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Load Current(A)');
    ylabel('Efficiency (%)');
    grid on;
    title('Efficiency vs load Current');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic2);
    %cla;
    subplot(2,2,3, 'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),V_out(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

   % axis([min(V_in) max(V_in) 2 3]);
   if(min(I_load) == 0)
       axis([min(V_in) max(V_in) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   else
       axis([min(V_in) max(V_in) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Output voltage (V)');
    grid on;
    title('Input voltage regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %axes(handles.Graphic3);
    %cla;
    subplot(2,2,4, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),V_out(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthWest');    

    %axis([min(I_load) max(I_load) 2 3]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Output current (A)');
    ylabel('Output voltage (V)');
    grid on;
    title('Load regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic4);
    %cla;
    subplot(2,2,2,'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),Eff(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

    %axis([min(V_in) max(V_in) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(V_in) max(V_in) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(V_in) max(V_in) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Efficiency');
    grid on;
    title('Efficiency vs input voltage');

    action = ['SELECT ALL DATEC FROM CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);

    dateToPrint = cell2mat(cursor.Data);
    dateToPrint = dateToPrint(1:11);

    converterName = cell2mat(converterName);
%     if(converterName(6) == '_')
%         converterName(6) = '-';
%     end

%     converterName = converterName(1:11);
    textTitle = [converterName, '  ', dateToPrint];
    annotation(figure1,'textbox',[0.1 0.92 0.5 0.1],'Interpreter','none',...
        'String', {'' textTitle ''} ,...
        'HorizontalAlignment','right',...
        'FontWeight','bold',...
        'FontSize',16,...
        'FitBoxToText','off',...
        'LineStyle','none');
    
    save2pdf(converterName,figure1,600);
    close(figure1);
    open([converterName,'.pdf']);
    
catch
    %withoutData  
    message = 'There is not data about this converter. Check that it has been tested';
    set(handles.textLog, 'String', message);
    set(handles.textLogTitle, 'Visible', 'on');
    set(handles.textLog, 'Visible', 'on');
end
close(cursor);
guidata(hObject, handles);


function [drop1, drop2, dropExp1, dropExp2] = getDropValues(model, avgVIN, avgILOAD_1, avgILOAD_2, voutM, voutValue)
    global voutZERO;
    global connection;
    
    action = ['SELECT V_2_MIN, V_4_MIN FROM EFFICIENCY_DCDC WHERE MODEL =''' char(model) ''' AND VOUT=''' mat2str(voutValue) ''' '];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    
    drop1 = abs(voutZERO) - abs(voutM(avgVIN,avgILOAD_1));
    dropExp1 = abs(cursor.Data{1});
    
    drop2 = abs(voutZERO) - abs(voutM(avgVIN,avgILOAD_2));
    dropExp2 = abs(cursor.Data{2});
    
function [eff1, eff2, effExp1, effExp2] = getEffValues(model, avgVIN, avgILOAD_1, avgILOAD_2, effM, voutValue)
    global connection;
    
    action = ['SELECT EFF2, EFF4 FROM EFFICIENCY_DCDC WHERE MODEL =''' char(model) ''' AND VOUT=''' mat2str(voutValue) ''' '];
    cursor = exec(connection, action);
    cursor = fetch(cursor);
    
    eff1 = abs((effM(avgVIN,avgILOAD_1)*100));
    effExp1 = abs(cursor.Data{1});
   
    eff2 = abs((effM(avgVIN,avgILOAD_2)*100));
    effExp2 = abs(cursor.Data{2});

% --- Executes on button press in efficiencyButton.
function efficiencyCallback(hObject, eventdata, handles, message, voutValue, voutTested)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
global converterModel;
global connection;
global converterName;
global imonZERO;
global voutZERO;

try
    [effV, voutV, avg_vin, avg_iload_1, avg_iload_2, imonZERO, voutZERO] = getEfficiency;
    % voutValue = get(handles.checkVout, 'String');
    % voutTested = get(handles.voutDefault, 'String');


    try
        [msgTEST voutValid effValid iinValid dropValid] = efficiency(converterName, converterModel, effV, voutV, voutTested, voutValue, avg_vin, avg_iload_1, avg_iload_2)
        [drop_1, drop_2, dropExpected_1, dropExpected_2] = getDropValues(converterModel, avg_vin, avg_iload_1, avg_iload_2, voutV, voutValue);
        [eff_1, eff_2, effExpected_1, effExpected_2] = getEffValues(converterModel, avg_vin, avg_iload_1, avg_iload_2,effV, voutValue);
        message = [message, '.  ', msgTEST];

        set(handles.checkVout, 'Visible', 'on');
        set(handles.checkEff, 'Visible', 'on');
        set(handles.checkIin, 'Visible', 'on');
        set(handles.checkDrop, 'Visible', 'on');   
        set(handles.textObtained, 'Visible', 'on'); 
        set(handles.textExpected, 'Visible', 'on'); 
        set(handles.textPoint_E1, 'Visible', 'on'); 
        set(handles.textPoint_E2, 'Visible', 'on');  
        set(handles.textPoint_D1, 'Visible', 'on'); 
        set(handles.textPoint_D2, 'Visible', 'on');  

        set(handles.textValueDrop1, 'String', round(drop_1*1000)/1000);
        set(handles.textValueDrop2, 'String', round(drop_2*1000)/1000);
        set(handles.textValueEff1, 'String', round(eff_1*100)/100);
        set(handles.textValueEff2, 'String', round(eff_2*100)/100);

        set(handles.textExpectDrop1, 'String', ['<=  ', num2str(round(dropExpected_1*1000)/1000)]);
        set(handles.textExpectDrop2, 'String', ['<=  ', num2str(round(dropExpected_2*1000)/1000)]);
        set(handles.textExpectEff1, 'String', ['>=  ', num2str(round(effExpected_1*100)/100)]);
        set(handles.textExpectEff2, 'String', ['>=  ', num2str(round(effExpected_2*100)/100)]);

        set(handles.textValueDrop1, 'Visible', 'on');
        set(handles.textValueDrop2, 'Visible', 'on');
        set(handles.textExpectDrop1, 'Visible', 'on');
        set(handles.textExpectDrop2, 'Visible', 'on');
        set(handles.textValueEff1, 'Visible', 'on');
        set(handles.textValueEff2, 'Visible', 'on');
        set(handles.textExpectEff1, 'Visible', 'on');
        set(handles.textExpectEff2, 'Visible', 'on');
        if(voutValid)
            set(handles.checkVout, 'Value', 1); 
        else
            set(handles.checkVout, 'Value', 0); 
        end
        if(effValid)
            set(handles.checkEff, 'Value', 1);
        else
            set(handles.checkEff, 'Value', 0);  
        end
        if(iinValid)
            set(handles.checkIin, 'Value', 1);    
            set(handles.checkIin, 'String', ['Iin: ', num2str(iinValid*1000), ' mA']);
        else
            set(handles.checkIin, 'Value', 0);    
        end
        if(dropValid)
            set(handles.checkDrop, 'Value', 1);    
        else
            set(handles.checkDrop, 'Value', 0);    
        end

    catch
        message = 'There is not efficiency data to compare with this model';
        set(handles.textLog, 'String', message);
        set(handles.textLogTitle, 'Visible', 'on');
        set(handles.textLog, 'Visible', 'on');
    end
catch
    message = 'There is not efficiency data to compare with this model';
    set(handles.textLog, 'String', message);
    set(handles.textLogTitle, 'Visible', 'on');
    set(handles.textLog, 'Visible', 'on');
end
%set(handles.textLog, 'String', message);


function [effValue, V_out, avgVin, avgIl_point1, avgIl_point2, imonZERO, voutZERO] = getEfficiency()
    global connection;
    global converterModel;
    global converterName;
    
    action = ['SELECT IMON, VOUT FROM DCDC_CONVERTER WHERE NAME = ' '''' char(converterName) '''  AND I_LOAD=''0'''];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    imonZERO = cursor.Data(1,1);
    imonZERO = imonZERO{1};
    voutZERO = cursor.Data(1,2);
    voutZERO = voutZERO{1};
    
    action = ['SELECT ALL V_IN, I_LOAD, IMON, IOUT, VMON, VOUT FROM DCDC_CONVERTER WHERE NAME = ' '''' char(converterName) '''  AND I_LOAD<> ''0'''];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);

    [row col] = size(cursor.Data);

    V_mon = [];
    V_out = [];
    I_mon = [];
    I_out = [];

    V_in = cell2mat(cursor.Data(1));
    I_load = cell2mat(cursor.Data(1,2));

    cont_VIN = 1;
    cont_ILOAD = 1;

    for i=1:row

        %V_in
        if(V_in(cont_VIN) ~= cell2mat(cursor.Data(i)))
            cont_VIN = cont_VIN + 1;
            V_in(cont_VIN) = cell2mat(cursor.Data(i));
        end

        %I_load
        if(I_load(cont_ILOAD) < cell2mat(cursor.Data(i, 2)))
            cont_ILOAD = cont_ILOAD + 1;
            I_load(cont_ILOAD) = cell2mat(cursor.Data(i, 2));
        end

        vinIndex = find(cell2mat(cursor.Data(i)) == V_in);
        iloadIndex = find(cell2mat(cursor.Data(i,2)) == I_load);

        I_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,3));
        V_mon(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,5));
        I_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,4));
        V_out(vinIndex, iloadIndex) =  cell2mat(cursor.Data(i,6));
    end


    %axes(handles.Graphic);
    %cla;

    %I_load = cell2mat(I_load); 
    %V_in = cell2mat(V_in);

    Pout = V_out.*I_out;
    Pin = V_mon.*I_mon;
    effValue = Pout./Pin;
    
    action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(converterModel) ''' AND CONFIG = ''AVG_V'' '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    avgVin = cursor.Data{1};

    action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(converterModel) ''' AND CONFIG = ''AVG_IL1'' '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    avgIl_point1 = cursor.Data{1};

    action = ['SELECT POINT FROM CONFIG_DCDC WHERE MODEL = ' '''' char(converterModel) ''' AND CONFIG = ''AVG_IL2'' '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    avgIl_point2 = cursor.Data{1};


% --- Executes on button press in checkDrop.
function checkDrop_Callback(hObject, eventdata, handles)
% hObject    handle to checkDrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkDrop
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end

% --- Executes on button press in checkControl.
function checkControl_Callback(hObject, eventdata, handles)
% hObject    handle to checkControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkControl
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkIin.
function checkIin_Callback(hObject, eventdata, handles)
% hObject    handle to checkIin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkIin
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkEff.
function checkEff_Callback(hObject, eventdata, handles)
% hObject    handle to checkEff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkEff
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in checkVout.
function checkVout_Callback(hObject, eventdata, handles)
% hObject    handle to checkVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkVout
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end


% --- Executes on button press in textPass.
function textPass_Callback(hObject, eventdata, handles)
% hObject    handle to textPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of textPass
if(get(hObject,'Value') == get(hObject, 'Max'))
    set(hObject, 'Value',0);
else
    set(hObject, 'Value',1);
end
