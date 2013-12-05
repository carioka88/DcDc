function status = tti_set( address, V, I )
% Sets the TTI TSX-P power supply: tti_set( address, V, I )
%   address = GPIB primary address (default = 2)
%   Output Voltage
%   Current Limit

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

% Set parameters
s = ['V ' num2str(V)];
fprintf(obj1, s);

s = ['I ' num2str(I)];
fprintf(obj1, s);

% Close instrument
fclose (obj1);

end

