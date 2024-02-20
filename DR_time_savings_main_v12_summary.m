% DR_time_savings_main_v12_summary.m--
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

% v11_summary: produce .xls summary file
% v12: add more spines

% Note that one sequence was missed for prostate when .xls was produced - t1 vibe dyn - added into analysis manually
% On inspection, this sequence is in the TOC of the .xml, but not listed in the main body! Need to code a check for other such errors and run other anatomies again

%-------------------------------------------------------------------------

%% Specify original and DR times

% Brain
original=[505 514 1708 1498 1849 879 1456 446 939 1061 1035 514 1642 994 905 1224 947 1675 1551 1218]';
DR=[410 419 1056 1263 994 780 1004 375 370 468 835 383 1253 671 565 932 580 1310 1435 731]';

% IAM
original=cat(1, original, [1383 1283]');
DR=cat(1, DR, [1163 747]');

% Spine
original=cat(1, original, [2436 860 1338 325 1460 886 1116 821 742 1578 769]');
DR=cat(1, DR, [1651 653 630 224 736 625 652 605 397 1014 526 ]');

% Prostate
original=cat(1, original, [1294]');
DR=cat(1, DR, [1064]');

% Orbits
original=cat(1, original, [2537]');
DR=cat(1, DR, [1212]');

% Neck
original=cat(1, original, [1123 1106 2119 858]');
DR=cat(1, DR, [862 328 1624 741]');

% Brain and spine
original=cat(1, original, [2876 2370]');
DR=cat(1, DR, [2055 1478]');

% Head
original=cat(1, original, [799]');
DR=cat(1, DR, [458]');

difference=original-DR;

% convert to mins
original=original/60;
DR=DR/60;
difference=difference/60;

%% Get protocol names
% Brain - Additional and Meningioma were absent from my list as no Deep Resolve sequences - careful with labelling
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Brain_minus_Additional_and_Meningioma\'; % Specify .xml filepath
cd(path)
files=dir('*.*');
j=1; % initialise protocol counter
for i=3:length(files)-1
    dummy=strrep(files(i).name, 'Brain -', '');
    dummy=strrep(dummy, 'Brain ', '');
    dummy=strrep(dummy, '_', '');
    dummy=strrep(dummy, 'Brain-', '');
    protocol{j,1}=strrep(dummy,'.xml', ''); % get string
    anatomy{j,1}='Brain';
    j=j+1;
end

% IAM - misleading to say no time saving on two files (original sequences deleted from scanner) - so not shown in plots
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Copy_of_IAMs';
cd(path)
files=dir('*.*');
for i=3:length(files)-3 % misleading to say no time saving on last two files => no plot
    dummy=strrep(files(i).name,'.xml', ''); % get string
    protocol{j,1}=strrep(dummy,'IAM - ', ''); % get string
    anatomy{j,1}='IAM';
    j=j+1;
end

% Spine - only those protocols with DR implemented
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Spine';
cd(path)
files=dir('*.*');
for i=3:length(files)
    protocol{j,1}=strrep(files(i).name,'.xml', ''); % get string
    anatomy{j,1}='Spine';
    j=j+1;
end

% Prostate
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Prostate';
cd(path)
files=dir('*.*');
for i=3:length(files)
    protocol{j,1}=strrep(files(i).name,'.xml', ''); % get string
    anatomy{j,1}='Prostate';
    j=j+1;
end

% Orbits
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Orbits';
cd(path)
files=dir('*.*');
for i=3:length(files)
    protocol{j,1}=strrep(files(i).name,'.xml', ''); % get string
    anatomy{j,1}='Orbits';
    j=j+1;
end

% Neck
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Neck';
cd(path)
files=dir('*.*');
for i=3:length(files)
    dummy=strrep(files(i).name, 'Neck - ', '');
    dummy=strrep(dummy, 'neck -', '');
    protocol{j,1}=strrep(dummy,'.xml', ''); % get string
    anatomy{j,1}='Neck';
    j=j+1;
end

% Brain and spine - one sequence in original set replaced w DR
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Brain and Spine';
cd(path)
files=dir('*.*');
for i=3:length(files)
    protocol{j,1}=strrep(files(i).name,'.xml', ''); % get string
    anatomy{j,1}='Brain & Spine';
    j=j+1;
end

% Head
path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Head';
cd(path)
files=dir('*.*');
for i=3:length(files)
    protocol{j,1}=strrep(files(i).name,'.xml', ''); % get string
    anatomy{j,1}='Head';
    j=j+1;
end

%% Plot bar charts
x=1:length(protocol);
for j=1:length(protocol)
    y(j,:)=[DR(j), difference(j)];
end

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
    xlabel('Protocol #');
    ylabel('Time [m]');
    legend('Deep Resolve','Original')
    set(gcf,'color','w');
    set(gca,'fontsize',20);
