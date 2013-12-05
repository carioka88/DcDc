function [I] = k2000_get_current( address )
% Gets the Keithley 2001 Current: [V}=k2000_get_current( address )
%   address = GPIB primary address (default = 1)
%   I = Read current

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
fprintf(obj1, ':SENSE:FUNCTION ''CURRENT:DC''');
fprintf(obj1, ':SENSE:CURRENT:DC:AVERAGE:TCONTROL MOVING');
fprintf(obj1, ':SENSE:CURRENT:DC:AVERAGE:COUNT 100');

% Get parameters

sI = query(obj1, ':SENSE:DATA:FRESH?');

% Extract numeric values only

I = sscanf(sI, '%f');

% Close instrument
fclose (obj1);

end

