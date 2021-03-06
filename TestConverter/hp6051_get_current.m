function [I] = hp6051_get_current( address )
% Gets the HP6051 2001 voltage
%   address = GPIB primary address (default = 1)
%   I = Read Voltage

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

% Get parameters

sI = query(obj1, 'MEASURE:CURRENT?');

% Extract numeric values only

I = sscanf(sI, '%f');

% Close instrument
fclose (obj1);

end

