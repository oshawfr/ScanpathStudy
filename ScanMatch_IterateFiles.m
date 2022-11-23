% ScanPath Analysis 4 Part2
% Calcul score for the same tasks for each couple of participants
% tutor: Ms SHARAFI Zohreh
% student: Mr SHAW Oscar

% Clear command Window and Workspace
clear all; 
clc;

% Folder from which we extract our files and extension considered
FOLDER_PATH = './data_files';
EXT = '.csv';


filelist = dir([FOLDER_PATH,'/*',EXT]);

% Creation of the GUI 
% To change the hyperparameters, it's easier to do so direct on the definition of the struct
ScanMatchInfo = ScanMatch_Struct(); 

scoreTable = table(); % Table which contains the scores
couple = zeros(1,2); % Array to check select only couples for same tasks
for i = 1:length(filelist)-1
    file_i = csvread([FOLDER_PATH,'/',filelist(i).name;]); % Get data from csv 
    seq_i = ScanMatch_FixationToSequence(file_i, ScanMatchInfo); % Build string sequence from data
    for j = i+1:length(filelist)
        file_j = csvread([FOLDER_PATH,'/',filelist(j).name;]); % Get data from csv 
        couple(1) = filelist(i).name(6); couple(2) = filelist(j).name(6); couple = char(couple); % Only Keep the num of the task to compare it
        if couple(1) == couple(2) % Check wether it's the same task (by comparing the num of task)
            seq_j = ScanMatch_FixationToSequence(file_j, ScanMatchInfo); % Build string sequence from data
            exp = 'P+[0-9]*+_+[1-3]'; % Expr pattern to extract name
            pattern = regexpPattern(exp); % Expr to RegExp
            New(1,1).File_I = extract(filelist(i).name,pattern); New(1,1).File_J = extract(filelist(j).name,pattern); New(1,1).Score = ScanMatch(seq_i, seq_j, ScanMatchInfo); % Build new row
            scoreTable = [scoreTable;struct2table(New)]; % Append new row to table
        end
    end
end
writetable(scoreTable,'outputScanMatch.csv','WriteRowNames',true,'Delimiter',',','Encoding','UTF-8','QuoteStrings',true) % Extract data to csv in the current folder


