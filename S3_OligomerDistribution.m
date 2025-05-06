% This code takes the bleaching step histograms and the Degree of Labelling
% to calculate Oligomer size distributions using biomial distributions. The
% code is currently written to work for monomers up to hexamers.
% Input:
% 1. Histogram of bleaching steps (histBleachpercent)
% 2. Degree of protein Labeling including standard deviation
% Output:
% Oligomersize hisogram with confidence intervals
close all
clear all
%% load histBleachpercent
% put in folder where Histograms are saved
folder='Z:\_personalDATA\JS+LV_4F-TIRF\003_project_ArlJ\240806_PfArlI+AfArlJ_rep2\240806_Ana2_PfArlI+AfArlJ+ATP+Mg2+_BleachingSteps_individualtraces\Histograms';
cd(folder)
a=dir('*_histBleachpercent.mat');%dir('*individualtraces_histBleachpercent.mat');
load(a.name)
% go back to folder where function sum6ar is:
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
% OR like this:
% cd('C:\PutPathHere\GitHub\pre-and-post-processing-of-AutoStepFinder-results')
%% Labelling Efficiency
DOL=0.968; %put in labelling efficiency
DOLstd=0.015; %put in standard deviation of labelling efficiency from measuring several times with the NanoDrop
ex=histBleachpercent;
%header='FlaI incubated with ATP @ 50°C 10 min';
header='06.08.24 AfArlJ + Mg2+ (200 nM PfArlI)'; % put in header name
%header='30.09.20 no ATP (ana7)';

%% fit data to BINOMIAL mixture with 6 oligomersizes
% works
ft6 = fittype( 'sum6ar(x,a,b,c,d,e,g,parsum,DOL)' );
paramSum=1; % sum of all oligomer kinds should always be 1
x=[0:10];
exlonger=cat(2,histBleachpercent,zeros(1,length(x)-length(histBleachpercent))); %because fit needs more datapoints
[f6A,gof6A] = fit(x',exlonger', ft6, 'StartPoint', [DOL 0.6 0.4 0.12 0.4 0.08 0.2 paramSum],...
    'Lower',[DOL 0 0 0 0 0 0 paramSum],... % the parameters are [DOL monomers dimers trimers tetramers pentamers hexamers paramSum]
    'Upper',[DOL 1 1 1 1 1 0 paramSum] )
summeBino= f6A.a +f6A.b+f6A.c+f6A.d+f6A.e+f6A.g % to check if sum of all factors gives 1
%% fit with lower DOL
DOLlow=DOL-DOLstd;
ft6 = fittype( 'sum6ar(x,a,b,c,d,e,g,parsum,DOL)' );
paramSum=1;
x=[0:10];
exlonger=cat(2,histBleachpercent,zeros(1,length(x)-length(histBleachpercent))); %because fit needs more datapoints
[f6DOLlow,gofDOLlow] = fit(x',exlonger', ft6, 'StartPoint', [DOLlow 0.6 0.4 0.07 0.07 0.08 0.2 paramSum],...
    'Lower',[DOLlow 0 0 0 0 0 0 paramSum],...
    'Upper',[DOLlow 1 1 1 1 1 0 paramSum] )
summeBino= f6DOLlow.a +f6DOLlow.b+f6DOLlow.c+f6DOLlow.d+f6DOLlow.e+f6DOLlow.g % to check if sum of all factors gives 1
%% fit with upper DOL
DOLup=DOL+DOLstd;
ft6 = fittype( 'sum6ar(x,a,b,c,d,e,g,parsum,DOL)' );
paramSum=1;
x=[0:10];
exlonger=cat(2,histBleachpercent,zeros(1,length(x)-length(histBleachpercent))); %because fit needs more datapoints
[f6DOLup,gofDOLup] = fit(x',exlonger', ft6, 'StartPoint', [DOLup 0.6 0.4 0.07 0.07 0.08 0.2 paramSum],...
    'Lower',[DOLup 0 0 0 0 0 0 paramSum],...
    'Upper',[DOLup 1 1 1 1 1 0 paramSum] )
summeBino= f6DOLup.a +f6DOLup.b+f6DOLup.c+f6DOLup.d+f6DOLup.e+f6DOLup.g % to check if sum of all factors gives 1
%% saving Autostepfinder fitresults
fitresuA=[f6A.DOL,f6A.a,f6A.b,f6A.c,f6A.d,f6A.e,f6A.g,f6A.parsum];
CI_f6A=confint(f6A,0.95); %CIs from fit
fitresuDOLlow=[f6DOLlow.DOL,f6DOLlow.a,f6DOLlow.b,f6DOLlow.c,f6DOLlow.d,f6DOLlow.e,f6DOLlow.g,f6DOLlow.parsum];
fitresuDOLup=[f6DOLup.DOL,f6DOLup.a,f6DOLup.b,f6DOLup.c,f6DOLup.d,f6DOLup.e,f6DOLup.g,f6DOLup.parsum];
CI_DOL=zeros(2,8);
CI_DOL(CI_DOL==0)=NaN;
CI_DOL(1,2:7)=fitresuDOLlow(2:7);
CI_DOL(2,2:7)=fitresuDOLup(2:7);
CI_DOL=sort(CI_DOL,1); % damit obere und untere Grenzen passend
cd(folder)
head=header(find(~isspace(header)));
SaveName=strcat(head,'_Stepfinder');
save([SaveName,'_fitresu.mat'],'fitresuA'); 
% save([SaveName,'_CI_f6.mat'],'CI_f6A'); 
save([SaveName,'_CI_DOL.mat'],'CI_DOL'); 
% go back to folder where function sum6ar is:
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot experiment and fits

figure
hold on
%bar(0:6,ex,'FaceColor',[0 0.6 1],'EdgeColor',[0 0 0],'LineWidth',0.5,'BarWidth', 1) %experiment
bar(0:6,histBleachpercent,'FaceColor',[0 0.6 1],'EdgeColor',[0 0 0],'LineWidth',0.5,'BarWidth', 1) %experiment
% %plot(k,sum6ar(k,f6.a,f6.b,f6.c,f6.d,f6.e,f6.g,paramSum,DOL),'.-r','DisplayName','fit n=4 fixed to 10%','MarkerSize',11) %fit of sum of up to 6 oligomersizes
% plot(k,sum6ar(k,f6A.a,f6A.b,f6A.c,f6A.d,f6A.e,f6A.g,paramSum,DOL),'.-m','DisplayName','fit n=4 fixed to 10%','MarkerSize',11) %fit of sum of up to 6 oligomersizes
% %plot(k,Gaus1(k,fGaus.n,fGaus.DOL),'.-','Color','magenta','DisplayName','fit','MarkerSize',11)
% % plot(k,Gaus6(k,fGaus6.a,fGaus6.b,fGaus6.c,fGaus6.d,fGaus6.e,fGaus6.g,fGaus6.parsum,fGaus6.DOL),'.-','Color',[102/255 0 255/255],'DisplayName','fit','MarkerSize',11)
% plot(0:6,catdata([6 7],:)','.-','MarkerSize',11)%plot thoretical distributions
xlim([0 6.5])
ylim([0 1])
xlabel('bleaching steps')
ylabel('probability')
box on
legend(strcat('experiment with DOL='," ",num2str(DOL*100),'%'),...
    'binomfit mixture of oligomersizes from n=1 to n=6',...
    'theoretical binom distribution for n=5','theoretical binom distribution for n=6',...
    'Box','off','Color','none','Location','northeast')
title(header)
%% save as png
cd(folder)
saveas(gcf,[SaveName,'_bleachingsteps_relative.png'])
% go back to folder where function sum6ar is:
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% plot oligomersizes
% Sometimes the renaming of the x axis labels has to be done by runing the code line
% by line. No idea why, but it does not work otherwise.
figure
hold on
h=bar(fitresuA(2:6));
% Get group centers
xCnt = get(h(1),'XData');% + cell2mat(get(h,'XOffset')); % XOffset is undocumented!
% get rid of old labels
xLab=[];
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
% Create Tick Labels
xLab={repmat({''},1,floor(size(fitresuA',2)/2)),'monomers',repmat({''},1,size(fitresuA',2)-1),'dimers',repmat({''},1,size(fitresuA',2)-1),'trimers',repmat({''},1,size(fitresuA',2)-1),'tetramers'};
xLab={repmat({''},1,floor(size(fitresuA',2)/2)),'monomers',repmat({''},1,size(fitresuA',2)-1),'dimers',repmat({''},1,size(fitresuA',2)-1),'trimers',repmat({''},1,size(fitresuA',2)-1),'tetramers',repmat({''},1,size(fitresuA',2)-1),'pentamers'};
%xLab = {''','',','','','','','dimers','','','','','trimers','','','','','tetramers','','','','','','pentamers','','','','','hexamers','',''}; 
xLab=cat(2,xLab{:});
%errorbar(xCnt,fitresuA(2:5),fitresuA(2:5)-CI_f6A(1,2:5),CI_f6A(2,2:5)-fitresuA(2:5),'k','LineStyle','none') % errorbars drom fit
errorbar(xCnt,fitresuA(2:6),fitresuA(2:6)-CI_DOL(1,2:6),CI_DOL(2,2:6)-fitresuA(2:6),'k','LineStyle','none') % errorbars from uncertain DOL
% Set individual ticks
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
xlim([0.5 5.5])
ylabel('frequency')
% set(gcf, 'units','centimeters','position',[4 4 17 12])
title(header)
ylim([0 1])
box on
%% save as png
cd(folder)
saveas(gcf,[SaveName,'_OligomerSizes_relative.png'])
% go back to folder where function sum6ar is:
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
