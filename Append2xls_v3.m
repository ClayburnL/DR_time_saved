% Append2xls_v3.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Write results to .xls
% Some bold font might be nice?

% Matlab 2019a does not support append to excel spreadsheet
% read and write seems a bit complex, due to the format
% recommend moving to simple format and using read and write if 2019a req.

function [] = Append2xls_v3(scanner, protocol, seq_name, seq_time, DR_seq, original_seq, DR_seq_time, original_seq_time, protocol_original, protocol_original_time)

    cd('C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings');

    % if file doesn't exist, create it and add heading
    if ~isfile(strcat(scanner,'.xls'))
        %% Sheet 1
        heading=cell(1,2);
        heading{1,1}='Sequence name';
        heading{1,2}='Sequence time [s]';
        heading2=cell(1,5);
        for i=1:2
            heading2{1,i}='--';
        end
        writecell(heading,strcat(scanner,'.xls'),'Sheet',1);
        writecell(heading2,strcat(scanner,'.xls'),'Sheet', 1, 'WriteMode','append');
        %% Sheet 2
        heading=cell(1,7);
        heading{1,1}='Protocol';
        heading{1,2}='Original sequence name';
        heading{1,3}='Deep Resolve sequence name';
        heading{1,4}='Original sequence time [s]';
        heading{1,5}='Deep resolve sequence time [s]';
        heading{1,6}='Time saving [s]';
        heading{1,7}='Time saving [%]';
        heading2=cell(1,7);
        for i=1:7
            heading2{1,i}='--';
        end
        writecell(heading,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');
        writecell(heading2,strcat(scanner,'.xls'),'Sheet', 2, 'WriteMode','append');
    end

    %% Sheet 1
    % Add protocol name and today's date
    date_cell=cell(1,1);
    date_cell{1}=date;
    writecell(date_cell,strcat(scanner,'.xls'),'Sheet',1, 'WriteMode','append');
    writecell(protocol,strcat(scanner,'.xls'),'Sheet',1, 'WriteMode','append');

    % Add sequence names and times
    result=cell(length(seq_name),2);
    result(:,1)=seq_name;
    result(:,2)=seq_time;
    writecell(result,strcat(scanner,'.xls'),'Sheet',1, 'WriteMode','append');
    heading=cell(1,1);
    heading{1,1}='--';
    writecell(heading,strcat(scanner,'.xls'),'Sheet',1, 'WriteMode','append');

    %% Sheet 2
    % Add protocol name and today's date
    date_cell=cell(1,1);
    date_cell{1}=date;
    writecell(date_cell,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');
    writecell(protocol,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');

    % Add sequence names and times
    result=cell(length(DR_seq),7);
    result(:,2)=original_seq;
    result(:,3)=DR_seq;
    result(:,4)=original_seq_time;
    result(:,5)=DR_seq_time;
    time_saving=cell(length(DR_seq_time),1);
    time_saving_percent=cell(length(DR_seq_time),1);
    time_saving_sum=0; % initialise
    % Calculate time savings
    for i=1:length(time_saving)
        time_saving{i,1}=original_seq_time{i,1}-DR_seq_time{i,1};
        time_saving_percent{i,1}=100*time_saving{i,1}/original_seq_time{i,1};
        protocol_time_saving=time_saving_sum+time_saving{i,1};
    end
    protocol_original_time_sum=0; % intialise
    % Calculate protocol original time total
    for i=1:length(protocol_original_time)
        if ~isempty(protocol_original_time{i,1})
        protocol_original_time_sum=protocol_original_time_sum+protocol_original_time{i,1};
        end
    end
    protocol_time_saving_percent=100*protocol_time_saving/protocol_original_time_sum;
    result(:,6)=time_saving;
    result(:,7)=time_saving_percent;

    writecell(result,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');

    heading=cell(1,2);
    heading{1,1}='Protocol time saving [s]';
    heading{1,2}='Protocol time saving [%]';
    writecell(heading,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');
    heading=cell(1,2);
    heading{1,1}=protocol_time_saving;
    heading{1,2}=protocol_time_saving_percent;
    writecell(heading,strcat(scanner,'.xls'),'Sheet',2, 'WriteMode','append');
end
