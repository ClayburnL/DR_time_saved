% DR_time_savings_main_v7.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% v7 semi-manual boi - protocols checked on scanner

% Brain - Additional and Meningioma were absent from my list as no time
% saving - careful with labelling
path='\\imagestore3\rps$\MRI\Scan_protocols\seq_development_docs\Deep Resolve\HM4 XML Files\Brain\';

% IAMS
% path='\\imagestore3\rps$\MRI\Scan_protocols\seq_development_docs\Deep Resolve\HM4 XML Files\IAMs';

cd(path)
files=dir('*.*');

% Brain
original=[505 514 1708 1498 1849 879 1456 446 939 1061 1035 514 1642 994 905 1224 947 1675 1551 1218];
DR=[410 419 1056 1263 994 780 1004 375 370 468 835 383 1253 671 565 932 580 1310 1435 731];

% IAMS
% original=[1383 1283 283 748];
% DR=[1163 747 283 748];

difference=original-DR;

% convert to mins
original=original/60;
DR=DR/60;
difference=difference/60;

% y=cell((length(files)-5),1);

% Brain
for i=3:length(files)-1
    dummy=strrep(files(i).name, 'Brain -', '');
    dummy=strrep(dummy, 'Brain ', '');
    x{i-2,1}=strrep(dummy,'.xml', ''); % get string
    y(i-2,:)=[original(i-2), difference(i-2)];
end

% IAMS
% for i=3:length(files)-1
%     x{i-2,1}=strrep(files(i).name,'.xml', ''); % get string
%     y(i-2,:)=[original(i-2), difference(i-2)];
% end

%% Plot bar charts
figure()
    hold on;
    b=bar(y, 'stacked', 'FaceColor','flat'); % MATLAB 2006+
%     b=bar(x, y, 'stacked', 'FaceColor','flat'); % MATLAB 2023b+
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
    title('HM4');
    xlabel('Brain');
%     xlabel('IAMS');
    ylabel('Time [m]');
    legend('Deep Resolve','Original')
    set(gcf,'color','w');
    set(gca,'fontsize',20);

