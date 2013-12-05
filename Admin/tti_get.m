function [V,I] = tti_get( address )
% Gets the TTI TSX-P power supply: [V,I}=tti_get( address )
%   address = GPIB primary address (default = 2)
%   Output Voltage
%   Output Current

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

sV = query(obj1, 'V?');
sI = query(obj1,'IO?');

% Extract numeric values only

V = sscanf(sV, 'V %f');
I = sscanf(sI, ' %fA');

% Close instrument
fclose (obj1);

end

