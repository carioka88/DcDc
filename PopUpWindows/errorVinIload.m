function varargout = errorVinIload(varargin)
% ERRORVINILOAD MATLAB code for errorVinIload.fig
%      ERRORVINILOAD, by itself, creates a new ERRORVINILOAD or raises the existing
%      singleton*.
%
%      H = ERRORVINILOAD returns the handle to a new ERRORVINILOAD or the handle to
%      the existing singleton*.
%
%      ERRORVINILOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORVINILOAD.M with the given input arguments.
%
%      ERRORVINILOAD('Property','Value',...) creates a new ERRORVINILOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorVinIload_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorVinIload_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorVinIload

% Last Modified by GUIDE v2.5 22-Oct-2013 17:07:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorVinIload_OpeningFcn, ...
                   'gui_OutputFcn',  @errorVinIload_OutputFcn, ...
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


% --- Executes just before errorVinIload is made visible.
function errorVinIload_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorVinIload (see VARARGIN)

% UIWAIT makes errorVinIload wait for user response (see UIRESUME)
 uiwait(handles.figure1);
 delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = errorVinIload_OutputFcn(hObject, eventdata, handles) 
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
