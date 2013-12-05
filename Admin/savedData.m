function varargout = savedData(varargin)
% SAVEDDATA MATLAB code for savedData.fig
%      SAVEDDATA, by itself, creates a new SAVEDDATA or raises the existing
%      singleton*.
%
%      H = SAVEDDATA returns the handle to a new SAVEDDATA or the handle to
%      the existing singleton*.
%
%      SAVEDDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVEDDATA.M with the given input arguments.
%
%      SAVEDDATA('Property','Value',...) creates a new SAVEDDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before savedData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to savedData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help savedData

% Last Modified by GUIDE v2.5 04-Dec-2013 10:31:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @savedData_OpeningFcn, ...
                   'gui_OutputFcn',  @savedData_OutputFcn, ...
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


% --- Executes just before savedData is made visible.
function savedData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to savedData (see VARARGIN)

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes savedData wait for user response (see UIRESUME)
 uiwait(handles.figure1);
 delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = savedData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = 'OK';

% Update handles structure
guidata(hObject, handles);

uiresume(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume(handles.figure1);
