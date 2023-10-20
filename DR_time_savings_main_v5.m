% DR_time_savings_main_v5.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Read scanner, protocol name, sequence names & durations from .xml file directory
% Find Deep Resolve and original sequences and compare run times
% Append to .xls
% Tested on 10 brain protocols

% v3 in Read_xml_fn_v3.m try matching first three strings (underscore separated), instead of first 10 characters
% v4 plot bar charts
% v5 catch case where no Deep Resolve sequences exist -  plotting not working...
% wondering if this because of versions?

% To do:
% Note that sequences should be more easily differentiable for future robustness of code
% Break summary figures into batches of 10 protocols?

path='\\imagestore3\rps$\MRI\Scan_protocols\seq_development_docs\Deep Resolve\HM4 XML Files\Brain\';
cd(path)
files=dir('*.*');

% Initialise
protocol=cell(length(files), 1);
protocol_original_time_sum=cell(length(files), 1);
protocol_time_saving=cell(length(files), 1);

for i=8:8% length(files)-1 % -1 to ignore .xsl file
    cd(path)
    [protocol{i-2,1}, protocol_original_time_sum{i-2,1}, protocol_time_saving{i-2,1}] = Read_xml_fn_v5(files(i).name);
end

for i=6:6% length(files)-2
    dummy=strsplit(protocol{i,1}{1,1}, '\');
    x{i,1}=dummy{1,5}; % get string
    y(i,:)=[protocol_original_time_sum{i,1}, protocol_time_saving{i,1}];
end
y=y/60; % convert to minutes

figure()
    hold on;
    b=bar(x, y, 'stacked', 'FaceColor','flat');
    b(1).CData = [41 118 145]/255;
    b(2).CData = [248 177 51]/255;
    
    % xtips1 = b(1).XEndPoints;
    % ytips1 = b(1).YEndPoints;
    % labels1 = string(b(1).YData);
    % text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    %     'VerticalAlignment','bottom')

    xtips2 = b(2).XEndPoints;
    ytips2= b(2).YEndPoints;
    labels2 = string(b(2).YData);
    text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

    % grid on;

    % didn't work as intended...
    dummy=strsplit(protocol{1,1}{1,1}, '\');
    header=strcat(dummy{1,2},' ');
    header=strcat(header,dummy{1,3});
    header=strcat(header,' ');
    header=strcat(header, dummy{1,4});

    title(header);
    xlabel('Protocol');
    ylabel('Time [m]');
    legend('Deep Resolve','Original')
    set(gcf,'color','w');
    set(gca,'fontsize',20);

