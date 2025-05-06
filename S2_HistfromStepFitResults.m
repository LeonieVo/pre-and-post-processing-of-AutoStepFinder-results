% This code makes bleaching step histograms from StepFinder results
clear all
close all
twoColours =0 % put 1 if protein is labelled with two colors
ifastxt = 0 % Change to 1, if you accidently saved the AutoStepfinder results as .txt instead of .m
%% import data
%put in Folder, where results from AutoStepfinder are stored:
folderName='Z:\_personalDATA\JS+LV_4F-TIRF\003_project_ArlJ\240806_PfArlI+AfArlJ_rep2\240806_Ana2_PfArlI+AfArlJ+ATP+Mg2+_BleachingSteps_individualtraces\StepFit_Result';
header='06.08.24 AfArlJ + ATP + Mg2+ (200 nM PfArlI)'; % give a name
%% get results from _properties.mat files
filePattern = fullfile(folderName, '*properties*.mat'); % Change to whatever pattern you need.
%filePattern = fullfile(folderName, '*properties*.txt'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
cd(folderName)
StepFit_Results=[];
for k = 1 : length(theFiles)
    A=load(theFiles(k).name);
    A.name=theFiles(k).name;
    StepFit_Results=[StepFit_Results,A];
end
%% import txt
% This code part is for when the _properties files are saved as .txt instead of .m
if ifastxt
    filePattern = fullfile(folderName, '*properties*.txt'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    cd(folderName)
    % StepFit_Results=[];
    
    % Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 8);
    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    % Specify column names and types
    opts.VariableNames = ["IndexStep", "TimeStep", "LevelBefore", "LevelAfter", "StepSize", "DwellTimeStepBefore", "DwellTimeStepAfter", "StepError"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double"];
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    % Import the data
    % ggx64y65M1properties = readtable("Z:\_personalDATA\JS+LV_4F-TIRF\ArlJ_Moritz\220826_1st_ArlJ_analysis\220826_1st_ArlJ_traces_individualtraces\StepFit_Result\15_g_g_x64_y65_M1_properties.txt", opts);
    for k = 1 : length(theFiles)
        A=readtable(theFiles(k).name, opts);
        B=table2struct(A,"ToScalar",true);
        B.name=theFiles(k).name;
        StepFit_Results=[StepFit_Results,B];
    end
    %Clear temporary variables
    clear opts
end
%% extract dwell times
Dwelltime_pos=[];
for k = 1: length(StepFit_Results)
    StepFit_Results(k).NumSteps=length(StepFit_Results(k).DwellTimeStepBefore); %count steps
    
    b=[StepFit_Results(k).DwellTimeStepBefore];
    b= b(:)';
    Dwelltime_pos=[Dwelltime_pos,b];
end
%% convert dwell times from position to seconds
% time for g_g
%time=[1.05:2.1:418.95]; % time exp =1000ms
%time=[0.25:0.5:199.75]; % time exp =200ms
%time=[0.55:1.1:219.45]; % time exp =500ms
%time for r_r
%time=[1.05:2.1:418.95]; % time exp =1000ms XXXXXX
time=[0.5:0.5:400]; % time exp =200ms
%time=[0.55:1.1:219.45]; % time exp =500msXXXXXXXXX
Dwelltime_s=[];
for k =1:length(Dwelltime_pos)
    Dwelltime_s(k)=time(Dwelltime_pos(k));
end
%% extract only traces which fullfil our dwell time condition
DwellTimeCond=2; %in frames not seconds. you can set the condition here
DwellTimeCond_s=time(DwellTimeCond);
howmanydel=[];
for k = 1: length(StepFit_Results)
    % if shortest step is shorter than condition, this step is omitted
    if min(StepFit_Results(k).DwellTimeStepBefore)<DwellTimeCond %DwellTimeCond
        StepFit_Results(k).NumSteps= StepFit_Results(k).NumSteps-1;
        howmanydel=[howmanydel,k];
    end
end
%% If proteins are labelled with two colours sum steps from r_r and g_g
if twoColours
    for k = 1: length(StepFit_Results)
        if mod(k,2)>0
            StepFit_Results(k).NumStepsSum=StepFit_Results(k).NumSteps+StepFit_Results(k+1).NumSteps;
        end
    end
end
%% plot histogram over bleaching steps
figure('Name','bleach')
h=histogram([StepFit_Results.NumSteps]);
if twoColours
    h=histogram([StepFit_Results.NumStepsSum]);
end
h.BinEdges=[0.5:6.5];
ylabel('Frequency')
xlabel('bleaching steps')
title(header)
histBleach=zeros(1,7);
histBleach(2:7)=h.Values;
histBleachpercent=histBleach/sum(histBleach);
%% histogram over dwell times
figure
h2=histogram(Dwelltime_s);
% h2.BinEdges=time;
h2.BinWidth=0.5;
hold on;
line([DwellTimeCond_s, DwellTimeCond_s], ylim, 'LineWidth', 2, 'Color', 'r');
ylabel('Frequency')
xlabel('plateau length [s]')
legend('plateau lengths',strcat('cutoff'," ",num2str(DwellTimeCond_s),' s'))
title(header)
%% saving
cd(folderName)%go to path where used data comes from
mydir  = pwd;
idcs   = strfind(mydir,filesep);
newdir = mydir(1:idcs(end)-1);
cd(newdir)% go one folder up
SaveFolder  = 'Histograms';        %Make new folder to save results
if ~exist(SaveFolder, 'dir')       %Check if folder already exists
    mkdir(SaveFolder);             %If not create new folder
end
cd(strcat(newdir,'\',SaveFolder))
SaveName=mydir(idcs(end-1)+1:idcs(end)-1)    ;
save([SaveName,'_histBleach'],'histBleach','histBleachpercent');
save([SaveName,'_histBleachpercent'],'histBleachpercent');
%% save figure as png
saveas(h,[SaveName,'bleachingSteps_absolut.png'])
% saveas(h2,[SaveName,'plateaulengths.png'])