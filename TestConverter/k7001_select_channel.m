function k7001_select_channel(address, channel)
% Select a channel on multiplexing card
%   address = GPIB primary address (default = 7)
%   channel = select channel (1 to 40)
% All channels are disconnected before a new one is selected!

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

% disconnect all channels
fprintf(obj1, ':OPEN ALL' );


% connect channel
fprintf(obj1, [':CLOSE (@1!' num2str(channel) ')'] );


% Close instrument
fclose (obj1);

end

