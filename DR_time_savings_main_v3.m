% DR_time_savings_main.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Read scanner, protocol name, sequence names & durations from .xml file directory
% Find Deep Resolve and original sequences and compare run times
% Append to .xls

% v3 in Read_xml_fn_v3.m try matching first three strings (underscore separated), instead of first 10 characters

% To do:

% Note that sequences should be more easily differentiable for future robustness of code

% Some errors in spreadsheet
% clean up code a bit - especially in Append2xls_v3.m
% Bar charts

% Test files - 10 brain protocols
% Results from DR_time_savings_main_v2.m
% 3 ok
% 4 ok
% 5 ok
% 6 ok
% 7 error due to first 10 char approach to sequence matching
% 8 ok
% 9 ok
% 10 error due to first 10 char approach to sequence matching
% 11 ok
% 12 ok

path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\XML files\';
cd(path)
files=dir('*.*');

for i=3:length(files)
    cd(path)
    Read_xml_fn_v3(files(i).name)
end


