function varargout = confirmationWindows(varargin)
% CONFIRMATIONWINDOWS MATLAB code for confirmationWindows.fig
%      CONFIRMATIONWINDOWS, by itself, creates a new CONFIRMATIONWINDOWS or raises the existing
%      singleton*.
%
%      H = CONFIRMATIONWINDOWS returns the handle to a new CONFIRMATIONWINDOWS or the handle to
%      the existing singleton*.
%
%      CONFIRMATIONWINDOWS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIRMATIONWINDOWS.M with the given input arguments.
%
%      CONFIRMATIONWINDOWS('Property','Value',...) creates a new CONFIRMATIONWINDOWS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before confirmationWindows_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to confirmationWindows_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help confirmationWindows

% Last Modified by GUIDE v2.5 04-Dec-2013 10:20:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @confirmationWindows_OpeningFcn, ...
                   'gui_OutputFcn',  @confirmationWindows_OutputFcn, ...
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


% --- Executes just before confirmationWindows is made visible.
function confirmationWindows_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to confirmationWindows (see VARARGIN)

% Choose default command line output for confirmationWindows
handles.output = 'NO';

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes confirmationWindows wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = confirmationWindows_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(size(handles)~= [0 0])
    varargout{1} = handles.output;
    delete(handles.figure1);
else
    handles.output = 'NO';
end

% --- Executes on button press in pushAccept.
function pushAccept_Callback(hObject, eventdata, handles)
% hObject    handle to pushAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.output = 'YES';
    % Update handles structure
    guidata(hObject, handles);

    % Use UIRESUME instead of delete because the OutputFcn needs
    % to get the updated handles structure.
    uiresume(handles.figure1); 

% --- Executes on button press in pushCancel.
function pushCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = 'NO';
guidata(hObject, handles);
uiresume(handles.figure1);
