function [R] = k2000_get_res( address )
% Gets the Keithley 2001 resistance: [V}=k2000_get_res( address )
%   address = GPIB primary address (default = 1)
%   R = Read resistance

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', address, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, address);
else
    fclose(obj1);
    obj1 = obj1(1);
end
set(obj1, 'Name', ['GPIB0-' address]);
set(obj1, 'PrimaryAddress', address);

% Connect to instrument object, obj1.
fopen(obj1);

% Set DC voltage measurement mode
fprintf(obj1, ':SENSE:FUNCTION ''RESISTANCE''');
fprintf(obj1, ':SENSE:RESISTANCE:AVERAGE:TCONTROL MOVING');
fprintf(obj1, ':SENSE:RESISTANCE:AVERAGE:COUNT 100');

% Get parameters

sR = query(obj1, ':SENSE:DATA:FRESH?');

% Extract numeric values only

R = sscanf(sR, '%f');

% Close instrument
fclose (obj1);

end

