% Produce_xls_main.m--
% Developed in Matlab 23.2.0.2365128 (R2023b) on PCWIN64
% Copyright Sheffield Teaching Hospitals NHS Foundation Trust 17-10-2023.
% Lloyd Clayburn (lloyd.clayburn@nhs.net), 
%-------------------------------------------------------------------------

% Inputs: path to directory of protocols in .xml form
% Outpus: .xls with sequence names and times from protocol - note that .xml file doesn't break out into strategies - it just gives a list of sequences
% Rename .xls after each use, or you'll be appending to same one

% Previous code DR_time_savings_main_v6_produce_xls.m tried to match
% original and DR sequences and calculate time savings, however this needs
% to be done manually to get accurate results really

% Read scanner, protocol name, sequence names & durations from .xml file directory
% Find Deep Resolve and original sequences and compare run times
% Append to .xls
% Tested on 10 brain protocols

path='C:\Users\clayb\OneDrive\Documents\STP\MRI\Y3\Deep Resolve time savings\HM4 XML Files\Prostate\';
cd(path)
files=dir('*.*');

for i=3:length(files) % -1 if you want to ignore .xsl file
    cd(path)
    Read_xml_fn_v7(files(i).name);
    disp(i-2);
end
