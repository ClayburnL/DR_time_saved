% Read_xml_fn_v3.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Reads MRI protocol from .xml - tested on SIEMENS MAGNETOM 1.5T XQ Numaris_X VA51A_0349
% v2 ignore sequences with work in progress (WIP) in name
% v3 try matching first three strings (underscore separated), instead of first 10 characters

% Unused
% file=xmlread('Brain - _Mets.xml');
% type('Brain - _Mets.xml')

function [] = Read_xml_fn_v3(XMLfile)
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
    % Find original sequences (original_seq if first 10 characters of seq match that of DR)
    % Create original protocol protocol_original (cell array of sequences with DR sequences removed)
    
    % Initialise
    j=1;
    protocol_original=seq_name;
    protocol_original_time=seq_time;
    
    for i=1:length(seq_name)
        % get Deep Resolve sequence names - watch out for DRIVE sequences & 'work in progress'
        if contains(seq_name{i,1},'DR') && ~contains(seq_name{i,1},'DRIVE') && ~contains(seq_name{i,1},'WIP')
            DR_seq{j,1}=seq_name{i,1};
            DR_seq_time{j,1}=seq_time{i,1};
            protocol_original{i,1}=[];
            protocol_original_time{i,1}=[];
            for k=1:length(seq_name)
                if k~=i
                    dummy1=strsplit(DR_seq{j,1},'_');
                    dummy2=strsplit(seq_name{k,1},'_');
                    % if first three underscore delimited strings match and DR is not found, you have the original sequence 
                    if strcmp(dummy1{1,1},dummy2{1,1}) && strcmp(dummy1{1,2},dummy2{1,2}) && strcmp(dummy1{1,3},dummy2{1,3}) && ~contains(seq_name{k,1},'DR') 
                        original_seq{j,1}=seq_name{k,1};
                        original_seq_time{j,1}=seq_time{k,1};
                    end
                end
            end
            j=j+1;
        end
    end
    
    %% Write to .xls
    Append2xls_v3(scanner, protocol, seq_name, seq_time, DR_seq, original_seq, DR_seq_time, original_seq_time, protocol_original, protocol_original_time);
end