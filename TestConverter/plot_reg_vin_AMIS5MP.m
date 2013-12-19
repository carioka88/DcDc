 function [V_mon I_mon V_out I_out] = plot_reg_vin_AMIS5MP( V_in, I_load, fname , handles)

    
    
    % close all;

    [V_mon I_mon V_out I_out] = reg_vin_AMIS5MP(V_in,I_load, handles);

    %  Create plots here
    
    Pout = V_out.*I_out;
    Pin = V_mon.*I_mon;
%     Eff = Pout./Pin;
    Eff = abs(Pout./Pin);

    scrsz = get(0,'ScreenSize');
    %figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2])
    figure1 = figure('Position',[scrsz(1) scrsz(2) scrsz(3)-1 scrsz(4)-2]);

    subplot(2,2,1, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),Eff(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end

    legend(lgd, 'Location', 'SouthWest');

    %axis([min(I_load) max(I_load) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Load Current(A)');
    ylabel('Efficiency (%)');
    grid on;
    title('Efficiency vs load Current');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic2);
    %cla;
    subplot(2,2,3, 'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),V_out(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

   % axis([min(V_in) max(V_in) 2 3]);
   if(min(I_load) == 0)
       axis([min(V_in) max(V_in) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   else
       axis([min(V_in) max(V_in) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
   end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Output voltage (V)');
    grid on;
    title('Input voltage regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %axes(handles.Graphic3);
    %cla;
    subplot(2,2,4, 'Parent', figure1);
    lgd = cell(1,numel(V_in));
    for i=1:1:numel(V_in);
        plot(I_out(i,:),V_out(i,:),'-o');
        lgd{i} = sprintf('Vin = %g', V_in(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthWest');    

    %axis([min(I_load) max(I_load) 2 3]);
    if(min(I_load) == 0)
        axis([min(I_load) max(I_load) (min(V_out(:,1))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    else
        axis([min(I_load) max(I_load) (min(V_out(:,min(I_load)))- 0.5) (max(V_out(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Output current (A)');
    ylabel('Output voltage (V)');
    grid on;
    title('Load regulation');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %axes(handles.Graphic4);
    %cla;
    subplot(2,2,2,'Parent', figure1);
    lgd = cell(1,numel(I_load));
    for i=1:1:numel(I_load);
        plot(V_mon(:,i),Eff(:,i),'-o');
        lgd{i} = sprintf('Iload = %g', I_load(i));
        hold all;
    end       
    legend(lgd, 'Location', 'SouthEast');    

    %axis([min(V_in) max(V_in) 0.5 1]);
    if(min(I_load) == 0)
        axis([min(V_in) max(V_in) (min(Eff(:,1))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    else
        axis([min(V_in) max(V_in) (min(Eff(:,min(I_load)))- 0.5) (max(Eff(:,max(I_load))) + 0.5)]);
    end
    
    %axis equal;
    xlabel('Input voltage (V)');
    ylabel('Efficiency');
    grid on;
    title('Efficiency vs input voltage');
    
    % annotation
    
    % tbox = annotation('textbox', [0.1 0.9 0.8 0.1], 'Interpreter', 'none', 'FontWeight','bold', 'LineStyle','none','HorizontalAlignment','center','String', [fname, ' - ', onewirenumber]);
    
    % Print resuts on console window
    
    leg_vin = [0, V_in]';
    eff_table = [I_load; Eff];
    eff_table = [leg_vin, eff_table];
    
    vout_table = [I_load; V_out];
    vout_table = [leg_vin, vout_table];
    
    disp ('Efficiency data function of Vin and Iout:');
    eff_table
    
    disp ('Output voltage data function of Vin and Iout:');
    vout_table
    
    % save the figure and the results
    
    %saveas(gcf, fname, 'fig');
    cd('../Results');
    saveas(gcf, str2mat(fname{1}), 'fig');
    % save the mat file
    
    %save (fname);
    save(str2mat(fname{1}));
    cd('../TestConverter');
    
end
