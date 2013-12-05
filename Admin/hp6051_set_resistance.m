function status = hp6051_set_resistance( address, V, I, R)
% Set the HP60501 Load Current
%   address = GPIB primary address (default = 1)
%   I = Max current
%   V = max voltage
%   R = load resistance

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

% Set DC voltage 
fprintf(obj1, ['VOLTAGE:LEVEL:IMMEDIATE ' num2str(V) ] );

% Set DC Current
fprintf(obj1, ['CURRENT:LEVEL:IMMEDIATE ' num2str(I) ] );

% Set DC Current
fprintf(obj1, ['RESISTANCE:LEVEL:IMMEDIATE ' num2str(R) ] );

% Set mode
fprintf(obj1, 'MODE:RESISTANCE' );


% Close instrument
fclose (obj1);

end

