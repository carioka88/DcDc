function varargout = errorNameExist(varargin)
% ERRORNAMEEXIST MATLAB code for errorNameExist.fig
%      ERRORNAMEEXIST, by itself, creates a new ERRORNAMEEXIST or raises the existing
%      singleton*.
%
%      H = ERRORNAMEEXIST returns the handle to a new ERRORNAMEEXIST or the handle to
%      the existing singleton*.
%
%      ERRORNAMEEXIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORNAMEEXIST.M with the given input arguments.
%
%      ERRORNAMEEXIST('Property','Value',...) creates a new ERRORNAMEEXIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorNameExist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorNameExist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorNameExist

% Last Modified by GUIDE v2.5 02-Dec-2013 15:07:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorNameExist_OpeningFcn, ...
                   'gui_OutputFcn',  @errorNameExist_OutputFcn, ...
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


% --- Executes just before errorNameExist is made visible.
function errorNameExist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorNameExist (see VARARGIN)

% Update handles structure
guidata(hObject, handles);

set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes success wait for user response (see UIRESUME)
 uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = errorNameExist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(size(handles)~= [0 0])
    varargout{1} = handles.output;
    delete(handles.figure1);
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);
