% DR_time_savings_main_v10.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

%% Plot bar charts showing time saved due to application of Deep Resolve
% Comment/uncomment anatomy as appropriate throughout code before running 

% Before running this file:
% 1 Export protocols as .xml file from scanner
% 2 Point Produce_xls_main.m at directory containing .xmls and run to produce .xls with list of sequence names and times
% 3 Manually append anatomy of interest to .xls filename
% 4 Edit .xls to produce 4 columns: - original sequence name, time, DR sequence name, time
% 5 Create new sections for anatomay of interest in this file, and copy times from spreadsheet into array

% v10 - inc. prostate and ocular protocols
% Corrected a bug in graph plotting
% Added instructions and comments

% Note that one sequence was missed for prostate when .xls was produced - t1 vibe dyn - added into analysis manually
% On inspection, this sequence is in the TOC of the .xml, but not listed in the main body! Need to code a check for other such errors and run other anatomies again

%-------------------------------------------------------------------------

%% Specify .xml filepath

% Brain - Additional and Meningioma were absent from my list as no Deep Resolve sequences - careful with labelling
% path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Brain_minus_Additional_and_Meningioma\';

% IAM - misleading to say no time saving on two files (original sequences deleted from scanner) - so not shown in plots
% path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Copy_of_IAMs';

% Spine - only those protocols with DR implemented - I think that there may be some missing...
% path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Spine';

% Prostate
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Prostate';

% Orbits
% path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Orbits';

cd(path)
files=dir('*.*');

%% Specify original and DR times

% Brain
% original=[505 514 1708 1498 1849 879 1456 446 939 1061 1035 514 1642 994 905 1224 947 1675 1551 1218];
% DR=[410 419 1056 1263 994 780 1004 375 370 468 835 383 1253 671 565 932 580 1310 1435 731];

% IAM
% original=[1383 1283 283 748];
% DR=[1163 747 283 748];

% Spine
% original=[2436 860 1460 1116 1578];
% DR=[1651 653 736 652 1014];

% Prostate
original=[1294];
DR=[1064];

% Orbits
% original=[2537];
% DR=[1212];

difference=original-DR;

% convert to mins
original=original/60;
DR=DR/60;
difference=difference/60;

%% Specify bar chart parameters

% Brain
% for i=3:length(files)-1
%     dummy=strrep(files(i).name, 'Brain -', '');
%     dummy=strrep(dummy, 'Brain ', '');
%     dummy=strrep(dummy, '_', '');
%     dummy=strrep(dummy, 'Brain-', '');
%     x{i-2,1}=strrep(dummy,'.xml', ''); % get string
%     y(i-2,:)=[DR(i-2), difference(i-2)];
% end

% IAMS
% for i=3:length(files)-3 % misleading to say no time saving on last two files => no plot
%     dummy=strrep(files(i).name,'.xml', ''); % get string
%     x{i-2,1}=strrep(dummy,'IAM - ', ''); % get string
%     y(i-2,:)=[DR(i-2), difference(i-2)];
% end

% % Spine
% for i=3:length(files)-1
%     x{i-2,1}=strrep(files(i).name,'.xml', ''); % get string
%     y(i-2,:)=[DR(i-2), difference(i-2)];
% end

% % Prostate
for i=3:length(files)
    x{i-2,1}=strrep(files(i).name,'.xml', ''); % get string
    y(i-2,:)=[DR(i-2), difference(i-2)];
end

% Orbits
% for i=3:length(files)
%     x{i-2,1}=strrep(files(i).name,'.xml', ''); % get string
%     % y(i-2,:)=[original(i-2), difference(i-2)];
%     y(i-2,:)=[DR(i-2), difference(i-2)];
% end

%% Plot bar charts
figure()
    hold on;
    % b=bar(y, 'stacked', 'FaceColor','flat'); % MATLAB 2006+
    b=bar(x, y, 'stacked', 'FaceColor','flat'); % MATLAB 2023b+
    b(1).CData = [41 118 145]/255;
    b(2).CData = [248 177 51]/255;

    % xtips1 = b(1).XEndPoints;
    % ytips1 = b(1).YEndPoints;
    % labels1 = string(b(1).YData);
    % text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    %     'VerticalAlignment','bottom')

    xtips2 = b(2).XEndPoints;
    ytips2= b(2).YEndPoints;
    label_data= round(b(2).YData,2); % round to 2 d.p
    labels2 = string(label_data);
    text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')

    % grid on;
    title('HM4 time savings');
    % xlabel('Brain protocol');
    % xlabel('IAM protocol');
    % xlabel('Spine protocol');
    xlabel('Prostate protocol');
    % xlabel('Orbits protocol');
    ylabel('Time [m]');
    legend('Deep Resolve','Original')
    set(gcf,'color','w');
    set(gca,'fontsize',20);
