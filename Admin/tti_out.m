function status = tti_out( address, out )
% Sets the TTI TSX-P power supply: tti_out( address, out )
%   address = GPIB primary address (default = 2)
%   out = 0 : Output is off
%   out = 1:  Output is on

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
s = ['OP ' num2str(out)];
fprintf(obj1, s);

% Close instrument
fclose (obj1);

end

