function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 03-Dec-2013 10:56:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

%Initialize variables
handles.c = cell(1,5);


% Choose default command line output for interface
handles.output = hObject;

connectFunction;
set(handles.TypeCmenu, 'Visible', 'on');

global connection;
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
close(cursor);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Connectbutton.
function connectFunction
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connection;
connection = open_dcdc_tracking();

if connection.Message ~= 0
    'ERROR'
    return;
end

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
    Eff = abs(Pout./Pin);

    figure1 = figure;

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
   
catch
    withoutData  
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

try
    set(handles.TypeCmenu, 'Visible', 'off');
    set(handles.Allbutton, 'Visible', 'off');
    set(handles.listConverter,'Visible', 'off');
    set(handles.graphicButton, 'Visible', 'off');

    set(handles.pushBack, 'Visible', 'on');


    numberList = get(handles.listConverter, 'Value');
    convertList = get(handles.listConverter, 'String');
    converterName = convertList(numberList);
    modelC = get(handles.actualModel, 'String');
    action = ['SELECT VOUT, TEST, PASSTEST FROM CONVERTER WHERE NAME = ' '''' converterName{1} '''  '];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    expectedVout = cursor.Data{1};
    passTest = cursor.Data{3};
    
    [totalTest col] = size(cursor.Data);
    numberTest = [];
    for i=1:totalTest
        numberTest = [numberTest; i];
    end
    
    voutTest = calculateVOUT(converterName{1}, str2mat(modelC));
    %changeResults(converterName{1}, expectedVout, totalTest, numberTest, handles, str2mat(modelC));
    set(handles.textName,'string', converterName{1});
    set(handles.numberTestEdit,'string', totalTest);
    set(handles.popupTEST,'string', numberTest);
    set(handles.text2,'Visible', 'on');
%     set(handles.text3,'Visible', 'on');
%     set(handles.text6,'Visible', 'on');
    set(handles.textName,'Visible', 'on');
%     set(handles.checkVout,'Visible', 'on');
%     set(handles.voutDefault,'Visible', 'on');
    set(handles.numberTestEdit,'Visible', 'on');
    set(handles.graphicButton, 'Visible', 'on');
    set(handles.popupTEST,'Visible', 'on');
    set(handles.pushResult,'Visible', 'off');
    set(handles.newResult,'Visible', 'on');
    set(handles.text11,'Visible', 'on');
%     set(handles.text13,'Visible', 'on');
%     set(handles.text15,'Visible', 'on');
%     set(handles.checkEff,'Visible', 'on');
%     set(handles.text17,'Visible', 'on');
%     set(handles.checkIin,'Visible', 'on');
%     set(handles.textPass,'Visible', 'on');
%     set(handles.text20,'Visible', 'on');
%     set(handles.textLog,'Visible', 'on');
    set(handles.uipanel2,'Visible', 'on');
    
    if( passTest)
%         set(handles.textPass,'String', 'YES');
        msgTest = ['The converter has been tested correctly and has the correct results'];
    end
    efficiencyCallback(hObject, eventdata, handles, msgTest, expectedVout, voutTest);
catch
    withoutData 
    set(handles.TypeCmenu, 'Visible', 'on');
    set(handles.Allbutton, 'Visible', 'on');
    set(handles.listConverter,'Visible', 'on');
    set(handles.graphicButton, 'Visible', 'off');

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
    action = ['SELECT VALUE FROM CONFIG_DCDC WHERE POINT = ''1'' AND CONFIG = ''VIN'' AND MODEL =' '''' modelC '''' ];
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    vinPoint = cursor.Data{1};

    action = ['SELECT VALUE FROM CONFIG_DCDC WHERE POINT = ''1'' AND CONFIG = ''ILOAD'' AND MODEL =' '''' modelC '''' ];
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
set(handles.graphicButton, 'Visible', 'off');
set(handles.pushBack, 'Visible', 'off');
set(handles.text2,'Visible', 'off');
set(handles.textName,'Visible', 'off');
set(handles.numberTestEdit,'Visible', 'off');
set(handles.popupTEST,'Visible', 'off');
set(handles.pushResult,'Visible', 'on');
set(handles.newResult,'Visible', 'off');
set(handles.text11,'Visible', 'off');
set(handles.uipanel2,'Visible', 'off');

set(handles.checkVout, 'Visible', 'off');
set(handles.checkEff, 'Visible', 'off');
set(handles.checkIin, 'Visible', 'off');
set(handles.checkDrop, 'Visible', 'off');


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
    action = ['SELECT VOUT FROM CONVERTER WHERE TEST = ''' mat2str(converterTest) ''' AND NAME =' '''' str2mat(converterName) ''' '];
   
    cursor = exec(connection,  action);
    cursor = fetch(cursor);
    
    expectedVout = cursor.Data{1};
    
    voutTest = calculateVOUT(str2mat(converterName), str2mat(modelC));
    
    set(handles.checkVout,'string', expectedVout);
    set(handles.voutDefault,'string', voutTest);
    
    
catch
    withoutData 
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


% --- Executes on button press in efficiencyButton.
function efficiencyCallback(hObject, eventdata, handles, message, voutValue, voutTested)
% hObject    handle to efficiencyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
global converterModel;
global connection;
global converterName;
[effV, voutV] = getEfficiency(str2mat(converterName));
% voutValue = get(handles.checkVout, 'String');
% voutTested = get(handles.voutDefault, 'String');
set(handles.checkVout, 'Visible', 'on');
set(handles.checkEff, 'Visible', 'on');
set(handles.checkIin, 'Visible', 'on');
set(handles.checkDrop, 'Visible', 'on');   

try
    [msgTEST voutValid effValid iinValid dropValid] = efficiency(converterName, converterModel, effV, voutV, voutTested, mat2str(voutValue))
    message = [message, '.  ', msgTEST];
    
    if(voutValid)
        set(handles.checkVout, 'Value', 1);    
    end
    if(effValid)
        set(handles.checkEff, 'Value', 1);    
    end
    if(iinValid)
        set(handles.checkIin, 'Value', 1);    
    end
    if(dropValid)
        set(handles.checkDrop, 'Value', 1);    
    end
catch
    message = 'There is not efficiency data to compare with this model';
end
%set(handles.textLog, 'String', message);


function [effValue, V_out] = getEfficiency(nameConverter)
    global connection,
    action = ['SELECT ALL V_IN, I_LOAD, IMON, IOUT, VMON, VOUT FROM DCDC_CONVERTER WHERE NAME = ' '''' nameConverter '''  '];
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