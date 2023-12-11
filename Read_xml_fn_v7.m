% Read_xml_fn_v7.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Reads MRI protocol from .xml - tested on SIEMENS MAGNETOM 1.5T XQ Numaris_X VA51A_0349
% Only write to .xls if DR sequences present
% v7 - Do not try to compare original and DR sequences in code or spreadsheet - revert to manual analysis

function [] = Read_xml_fn_v7(XMLfile)
    ml_struct = parseXML(XMLfile);
    
    % initalise
    seq_name=cell((length(ml_struct(2).Children)-3)/2,1);
    seq_time=seq_name;
    
    % get scanner model
    scanner=ml_struct(2).Children(2).Children(2).Children(2).Children.Data;
    % for every sequence in protocol
    for i=4:2:length(ml_struct(2).Children)
        j=(i-2)/2;
        % Get sequence path
        seq_name{j}=ml_struct(2).Children(i).Children(2).Children(4).Children(2).Children(2).Children.Data;
        % and line containing TA
        seq_time{j}=ml_struct(2).Children(i).Children(2).Children(4).Children(2).Children(4).Children.Data;
    end
    
    %% Reformat data
    % reformat scanner string
    scanner=strrep(scanner,'/','_');
    scanner=strrep(scanner,'-','_');
    
    % get protocol path and sequence name
    for i=1:length(seq_name)
        dummy=seq_name{i,1};
        dummy2=strsplit(seq_name{i,1},'\');
        seq_name{i}=dummy2(end);
    end
    protocol=strrep(dummy,seq_name{i,1},'');
    % convert cell to string
    for i=1:length(seq_name)
        dummy=seq_name{i,1};
        seq_name{i,1}=dummy{1,1};
    end
    
    % get sequence time
    for i=1:length(seq_time)
        if contains(seq_time{i,1},'min') % if time is formatted as [ m:ss] or [mm:ss]
            seq_time{i,1}=seq_time{i,1}(4:8);
            % convert to [s]
            dummy=strsplit(seq_time{i,1},':');
            seq_time{i,1}=str2num(dummy{1,1})*60+str2num(dummy{1,2});
        else % if time is formatted as ss 'sec'
            seq_time{i,1}=seq_time{i,1}(5:6);
            seq_time{i,1}=str2num(seq_time{i,1});
        end
    end
    
    % Find Deep Resolve sequences (if name contains DR and not DRIVE)
    j=1; % Initialise DR sequence counter
    for i=1:length(seq_name)
        % get Deep Resolve sequence names - watch out for DRIVE sequences & 'work in progress'
        if contains(seq_name{i,1},'DR') && ~contains(seq_name{i,1},'DRIVE') && ~contains(seq_name{i,1},'WIP')
            DR_seq{j,1}=seq_name{i,1};
            j=j+1;
        end
    end
    if exist('DR_seq', 'var')
        %% Write to .xls
        Append2xls_v6(scanner, protocol, seq_name, seq_time);
    end
end
