function varargout = insertNewModel(varargin)
% INSERTNEWMODEL MATLAB code for insertNewModel.fig
%      INSERTNEWMODEL by itself, creates a new INSERTNEWMODEL or raises the
%      existing singleton*.
%
%      H = INSERTNEWMODEL returns the handle to a new INSERTNEWMODEL or the handle to
%      the existing singleton*.
%
%      INSERTNEWMODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSERTNEWMODEL.M with the given input arguments.
%
%      INSERTNEWMODEL('Property','Value',...) creates a new INSERTNEWMODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before insertNewModel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to insertNewModel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help insertNewModel

% Last Modified by GUIDE v2.5 11-Oct-2013 11:14:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @insertNewModel_OpeningFcn, ...
                   'gui_OutputFcn',  @insertNewModel_OutputFcn, ...
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

% --- Executes just before insertNewModel is made visible.
function insertNewModel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to insertNewModel (see VARARGIN)

% Choose default command line output for insertNewModel
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.textVIN, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

set(handles.figure1, 'Colormap', IconCMap);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes insertNewModel wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = insertNewModel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(size(handles)~= [0 0])
    varargout{1} = handles.output;
    delete(handles.figure1);
else
    handles.ouput = 'NO';
end
% --- Executes on button press in acceptbutton.
function acceptbutton_Callback(hObject, eventdata, handles)
% hObject    handle to acceptbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.output = get(hObject,'String');

inputDataModel = cell(1,3);
try
    model = get(handles.modelEdit, 'String');
   
    vin = get(handles.editVIN, 'String');
    iload = get(handles.editIload, 'String');
    
    vin = strsplit(vin,',');
    iload = strsplit(iload,',');
    [inputDataModel{2}, inputDataModel{3}] = checkDATA(vin, iload);

    if(isempty(find(inputDataModel{3} > 4)) ~= 1)
        'ERROR ILOAD'
        errorVinIload;
    elseif(isempty(find(inputDataModel{2} > 12)) ~= 1)
        'ERROR VIN'
        errorVinIload;
    else
        inputDataModel{1} = model;
        handles.output = inputDataModel;
        % Update handles structure
        guidata(hObject, handles);

        % Use UIRESUME instead of delete because the OutputFcn needs
        % to get the updated handles structure.
        uiresume(handles.figure1);    
    end
catch
    errorValues;
end


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = 'NO';
% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function editVIN_Callback(hObject, eventdata, handles)
% hObject    handle to editVIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVIN as text
%        str2double(get(hObject,'String')) returns contents of editVIN as a double


% --- Executes during object creation, after setting all properties.
function editVIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIload_Callback(hObject, eventdata, handles)
% hObject    handle to editIload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIload as text
%        str2double(get(hObject,'String')) returns contents of editIload as a double


% --- Executes during object creation, after setting all properties.
function editIload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [vinValues iloadValues] = checkDATA(inputVin, inputLoad)
    
    [row col] = size(inputVin);
    vinValues = [];
    for i=1:col
        vinValues(i) = str2num(cell2mat(inputVin(i)));
    end
    
    [row col] = size(inputLoad);
    iloadValues = [];
    for i=1:col
        iloadValues(i) = str2num(cell2mat(inputLoad(i)));
    end

function nameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelEdit as text
%        str2double(get(hObject,'String')) returns contents of modelEdit as a double


% --- Executes during object creation, after setting all properties.
function nameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modelEdit as text
%        str2double(get(hObject,'String')) returns contents of modelEdit as a double


% --- Executes during object creation, after setting all properties.
function modelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVout_Callback(hObject, eventdata, handles)
% hObject    handle to editVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVout as text
%        str2double(get(hObject,'String')) returns contents of editVout as a double


% --- Executes during object creation, after setting all properties.
function editVout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
