% Append2xls_v6.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Write results to .xls

% v6 - Do not try to compare original and DR sequences in code or spreadsheet - revert to manual analysis

% Some bold font might be nice?

% Matlab 2019a does not support append to excel spreadsheet
% read and write seems a bit complex, due to the format
% recommend moving to simple format and using read and write if 2019a req.

function [] = Append2xls_v6(scanner, protocol, seq_name, seq_time)

    cd('C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings');

    % if file doesn't exist, create it and add heading
    filename=strcat(scanner,'.xls');
    if ~isfile(filename)
        heading=cell(1,2);
        heading{1,1}='Sequence name';
        heading{1,2}='Sequence time [s]';
        heading2=cell(1,5);
        for i=1:2
            heading2{1,i}='--';
        end
        writecell(heading,filename,'Sheet',1);
        writecell(heading2,filename,'Sheet', 1, 'WriteMode','append');
    end
    % Add protocol name and today's date
    date_cell=cell(1,1);
    date_cell{1}=date;
    writecell(date_cell,filename,'Sheet',1, 'WriteMode','append');
    writecell(protocol,filename,'Sheet',1, 'WriteMode','append');

    % Add sequence names and times
    result=cell(length(seq_name),2);
    result(:,1)=seq_name;
    result(:,2)=seq_time;
    writecell(result,filename,'Sheet',1, 'WriteMode','append');
    heading=cell(1,1);
    heading{1,1}='--';
    writecell(heading,filename,'Sheet',1, 'WriteMode','append');
end
