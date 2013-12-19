function varargout = errorValues(varargin)
% ERRORVALUES MATLAB code for errorValues.fig
%      ERRORVALUES, by itself, creates a new ERRORVALUES or raises the existing
%      singleton*.
%
%      H = ERRORVALUES returns the handle to a new ERRORVALUES or the handle to
%      the existing singleton*.
%
%      ERRORVALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORVALUES.M with the given input arguments.
%
%      ERRORVALUES('Property','Value',...) creates a new ERRORVALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorValues_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorValues_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorValues

% Last Modified by GUIDE v2.5 22-Oct-2013 17:04:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorValues_OpeningFcn, ...
                   'gui_OutputFcn',  @errorValues_OutputFcn, ...
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


% --- Executes just before errorValues is made visible.
function errorValues_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorValues (see VARARGIN)

% UIWAIT makes errorValues wait for user response (see UIRESUME)
 uiwait(handles.figure1);
 delete(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = errorValues_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in acceptButton.
function acceptButton_Callback(hObject, eventdata, handles)
% hObject    handle to acceptButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.output = 'OK';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    %set(handles.textERROR, 'String', 'hola');
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function textERROR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textERROR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%set(handles.textERROR, 'String', 'hola');
