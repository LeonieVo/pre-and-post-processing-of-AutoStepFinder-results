% This code summarizes the results from several repetions of the same
% experiments to create overview plots.
% It is best run section by section.
% Input: Oligomer size Hisograms from several independet experiments
% Output: Plots to compare several independet experiments
clear all
close all
%% find all saved fitting results and CIs
% put in the "parent folder" with all your experiments
myFolder='Z:\_personalDATA\JS+LV_4F-TIRF\ArlJ_Moritz+Marie\**\';
% myFolder='Z:\_personalDATA\JS+LV_4F-TIRF\ArlJ_Moritz+Marie\240603_ArlJ_Marie_AfvsPf\**\';

% get results from your saved fit results from the
% Oligomers_distributionsAsBars.m code
filePattern = fullfile(myFolder, '*ArlJ*Stepfinder*fitresu*.mat');
theFiles = dir(filePattern);

%CIs
filePatternCI = fullfile(myFolder, '*ArlJ*Stepfinder*CI*.mat');
theCIs = dir(filePatternCI);

%filePatternhistBleach = fullfile(myFolder, '*noATP*histBleach.mat'); % Change to whatever pattern you need.
filePatternhistBleach = fullfile(myFolder, '*ArlJ*histBleach.mat');
thehistBleachs = dir(filePatternhistBleach);

% If you cant to delete some data (for example if you only want to plot 
% selected experiments), best do it now in all acoording lists.
% theCIs(10) = [];
% theCIs(8) = [];
%% Load data
% all fitresuls will be saven in "alle"
for k =1 : length(theFiles)
    %load fitresu
    file=load(fullfile(theFiles(k).folder,theFiles(k).name));
    A(k).name=theFiles(k).name;
    if isfield(file,'fitresu')
        A(k).fitresu=file.fitresu;
    else
        A(k).fitresu=file.fitresuA; % historically there were some called this way
    end
    % load CIs
    CI=load(fullfile(theCIs(k).folder,theCIs(k).name));
    if isfield(CI,'CI_f6A')
        A(k).CI=CI.CI_f6A;
    else
        A(k).CI=CI.CI_DOL;
    end
    A(k).CIname=theCIs(k).name;
    %get name and date
    A(k).date=A(k).name(1:10);%A(k).date=A(k).name(1:10);
    A(k).DOL=A(k).fitresu(1);
    % load histbleach absolut to get Oligomer numbers
    histBleach=load(fullfile(thehistBleachs(k).folder,thehistBleachs(k).name));
    A(k).histBleach=histBleach.histBleach;
    A(k).OligomerNumber=sum(A(k).histBleach);
end

for k=1:length(A);
    % Now concatenate
    this_t = A(k).fitresu;
    alle(:, k) = this_t(:);
    
    this_date=A(k).date;
    dates(k,:)=this_date(:);
    
    this_CI=A(k).CI(1,:);
    CIdown(:,k)=this_t(:)-this_CI(:);
    
    this_CI=A(k).CI(2,:);
    CIup(:,k)=this_CI(:)-this_t(:);
end
%% you can also deleate some now
%remove 2.7. wegen riesigen CIs
% for example:
alle(:,2)=[];
CIdown(:,2)=[];
CIup(:,2)=[];
dates(2,:)=[];

%%  plot all or some of your experimes
% select the ones you want to plot:
alle = alle(:,1:9); %
CIdown=CIdown(:,1:9);
CIup=CIup(:,1:9);
% mean_alle=mean(alle,2);
% std_alle=std(alle,0,2);
figure
hold on
h=bar(alle(2:7,:))

% writing monomers, dimers,.. and so on on the x-Axis. Wierdly this code
% only works properly when run line by line:
% Get group centers
xCnt = get(h(1),'XData') + cell2mat(get(h,'XOffset')); % XOffset is undocumented!
% get rid of old labels
xLab=[]
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
% Create Tick Labels
xLab={repmat({''},1,floor(size(alle,2)/2)),'monomers',repmat({''},1,size(alle,2)-1),'dimers',repmat({''},1,size(alle,2)-1),'trimers',repmat({''},1,size(alle,2)-1),'tetramers',repmat({''},1,size(alle,2)-1),'pentamers',repmat({''},1,size(alle,2)-1),'hexamers'};
% xLab = {'monomers','','dimers','','trimers','','tetramers','','pentamers','','hexamers','',''};
xLab=cat(2,xLab{:});
% Set individual ticks
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)

% plot means
% scatter(mean(xCnt),mean_alle(2:7)','kx')
% errorbar(mean(xCnt),mean_alle(2:7)',std_alle(2:7)','k','LineStyle','none')

% plot errorbars:
vecxCnt=sort(xCnt);
vecxCnt=vecxCnt(:);
vecalle=alle(2:7,:)';%' ist wichtig!!
vecalle=vecalle(:);
vecCIdown=CIdown(2:7,:)';%' ist wichtig!!
vecCIdown=vecCIdown(:);
vecCIdown(isnan(vecCIdown))=0;
vecCIup=CIup(2:7,:)';%' ist wichtig!!
vecCIup=vecCIup(:);
vecCIup(isnan(vecCIup))=0;

errorbar(vecxCnt,vecalle,vecCIdown,vecCIup,'k','LineStyle','none')
ylabel('frequency')
%l={cellstr(dates),{'mean'},{'std'}}%legend if means and std
% dates legend
l={cellstr(dates),{'95% CI'},}
g=cat(1,l{:})
legend(g)
% repetiopn legend
l={'exp #1','exp #2',{'95% CI'},}%,'exp #3','exp #4','exp #5','exp #6'
l={'26.08.22 10 nM ArlI','30.09.22 200 nM ArlI','30.09.22 200 nM + 200 nM free ArlI','30.09.22 10 nM ArlI','02.12.22 200 nM ArlI','02.12.22 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP','26.05.23 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP','26.05.23 200 nM ArlI',{'95 % CI'},}
l={'03.11.23 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP','03.11.23 200 nM ArlI #1','03.11.23 200 nM ArlI #2',{'uncertainty from uncertainty of DOL'}};
l={'AfArlJ on 200 nM AfArlI','AfArlJ on 200 nM AfArlI + 5 mM MgCl_2 + 1 mM ATP','AfArlJ on 200 nM PfArlI','AfArlJ on 200 nM PfArlI + 5 mM MgCl_2 + 1 mM ATP',{'uncertainty from uncertainty of DOL'}};
l={'03.11.23 200 nM AfArlI + 5 mM MgCl_2 + 1 mM ATP','03.11.23 200 nM AfArlI #1','03.11.23 200 nM AfArlI #2','AfArlJ on 200 nM AfArlI','AfArlJ on 200 nM AfArlI + 5 mM MgCl_2 + 1 mM ATP','AfArlJ on 200 nM PfArlI','AfArlJ on 200 nM PfArlI + 5 mM MgCl_2 + 1 mM ATP',{'uncertainty from uncertainty of DOL'}};
l={'03.11.23 AfArlJ on AfArlI + 5 mM MgCl_2 + 1 mM ATP',...
    '03.11.23 AfArlJ on AfArlI #1',...
    '03.11.23 AfArlJ on AfArlI #2',...
    '28.05.24 AfArlJ on AfArlI',...
    '28.05.24 AfArlJ on AfArlI + 1 mM MgCl_2 + 1 mM ATP',...
    '28.05.24 AfArlJ on PfArlI',...
    '28.05.24 AfArlJ on PfArlI + 1 mM MgCl_2 + 1 mM ATP',...
    '06.08.24 AfArlJ on PfArlI',...
    '06.08.24 AfArlJ on PfArlI + 1 mM MgCl_2 + 1 mM ATP',...
    {'uncertainty from uncertainty of DOL'}};
g=cat(1,l{:})
legend(g)
legend('boxoff')
title('ArlH no ATP')
title('ArlH phosphorylated')
title('ArlI')
title('ArlH non-phosphorylating ATP-buffer')
title('28.05.24')
ylim([0 1])
ylim([0 1.3])
xlim([0.5 5.5])
% colors für no ATP
Farbreihe=[[148/255,0/255,65/255];[237/255,107/255,63/255];[246/255,172/255,92/255];...
    [231/255,245/255,161/255];[175/255,220/255,170/255];...
    [114/255,194/255,163/255];[65/255,138/255,191/255];[99/255,83/255,165/255];[166/255,0,125/255];[1, 217/255, 102/255];[96/255, 148/255,60/255]];
colorsnoATP=[[0,0,255/255];[0,0.447,0.741];[0.85,0.325,0.098];[0.466,0.674,0.188];[0,0.512,0];[0.635,0.078,0.184]];
colorsnoATP=[Farbreihe(1,:);Farbreihe(2,:);Farbreihe(3,:);Farbreihe(8,:);Farbreihe(7,:);Farbreihe(11,:);Farbreihe(4,:);Farbreihe(6,:);Farbreihe(5,:)];
%für plot ohne manche
colorsnoATP(7,:)=[];
colorsnoATP(5,:)=[];
colorsnoATP(2,:)=[];
%
for c=1: length(colorsnoATP)
    h(c).FaceColor=colorsnoATP(c,:);
end

% same colors in both plots
colorsphos= [[0,0.447000000000000,0.741000000000000];[0.850000000000000,0.325000000000000,0.0980000000000000];[0.929000000000000,0.694000000000000,0.125000000000000];[0.494000000000000,0.184000000000000,0.556000000000000];[0.466000000000000,0.674000000000000,0.188000000000000];[0.301000000000000,0.745000000000000,0.933000000000000];[0.635000000000000,0.0780000000000000,0.184000000000000]];
colorsphos=[Farbreihe(2,:);Farbreihe(3,:);Farbreihe(4,:);Farbreihe(5,:);Farbreihe(6,:);Farbreihe(8,:);Farbreihe(9,:)];
colorsphos=[Farbreihe(1,:);Farbreihe(2,:);Farbreihe(3,:);Farbreihe(6,:);Farbreihe(7,:);Farbreihe(9,:)]
%für plot nur manche
colorsphos(3,:)=[];
colorsphos(1,:)=[];
for c=1:length(colorsphos)
    h(c).FaceColor=colorsphos(c,:);
end
% ****************** stating here: old polts ***********************
% ****************** see below: statistical testing ****************
%% neu sortiert: '10 nM ArlI','10 nM ArlI','200 nM ArlI','200 nM ArlI','200 nM ArlI + ATP'
alleneu(:,1)=alle(:,1); %'26.08.22 10 nM ArlI',
alleneu(:,3)=alle(:,2);%'30.09.22 200 nM ArlI',
%'30.09.22 200 nM + 200 nM free ArlI',
alleneu(:,2)=alle(:,4);%'30.09.22 10 nM ArlI',
alleneu(:,4)=alle(:,5);%'02.12.22 200 nM ArlI',
alleneu(:,5)=alle(:,6);%'02.12.22 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP'
alleneu(:,7)=alle(:,7);%'26.05.23 ArlJ(200nMArlI)+MgCl_2+ATP
alleneu(:,6)=alle(:,8);%'26.05.23 ArlJ(200nMArlI)
alleneu(:,8)=alle(:,9);%'20.07.23 ArlJ(200nMArlI)
alleneu(:,9)=alle(:,10);%'20.07.23 ArlJ(200nMArlI)+MgCl_2+ATP


CIdownneu(:,1)=CIdown(:,1); %'26.08.22 10 nM ArlI',
CIdownneu(:,3)=CIdown(:,2);%'30.09.22 200 nM ArlI',
%'30.09.22 200 nM + 200 nM free ArlI',
CIdownneu(:,2)=CIdown(:,4);%'30.09.22 10 nM ArlI',
CIdownneu(:,4)=CIdown(:,5);%'02.12.22 200 nM ArlI',
CIdownneu(:,5)=CIdown(:,6);%'02.12.22 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP'
CIdownneu(:,7)=CIdown(:,7);%'26.05.23 ArlJ(200nMArlI)+MgCl_2+ATP
CIdownneu(:,6)=CIdown(:,8);%'26.05.23 ArlJ(200nMArlI)
CIdownneu(:,8)=CIdown(:,9);%'20.07.23 ArlJ(200nMArlI)
CIdownneu(:,9)=CIdown(:,10);%'20.07.23 ArlJ(200nMArlI)+MgCl_2+ATP

CIupneu(:,1)=CIup(:,1); %'26.08.22 10 nM ArlI',
CIupneu(:,3)=CIup(:,2);%'30.09.22 200 nM ArlI',
%'30.09.22 200 nM + 200 nM free ArlI',
CIupneu(:,2)=CIup(:,4);%'30.09.22 10 nM ArlI',
CIupneu(:,4)=CIup(:,5);%'02.12.22 200 nM ArlI',
CIupneu(:,5)=CIup(:,6);%'02.12.22 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP'
CIupneu(:,7)=CIup(:,7);%'26.05.23 ArlJ(200nMArlI)+MgCl_2+ATP
CIupneu(:,6)=CIup(:,8);%'26.05.23 ArlJ(200nMArlI)
CIupneu(:,8)=CIup(:,9);%'20.07.23 ArlJ(200nMArlI)
CIupneu(:,9)=CIup(:,10);%'20.07.23 ArlJ(200nMArlI)+MgCl_2+ATP

alle=alleneu;
CIup=CIupneu;
CIdown=CIdownneu;

% alle=alle(:,1:2);
% CIdown=CIdown(:,1:2);
% CIup=CIup(:,1:2);

figure
hold on
h=bar(alle(2:7,:))% bar(alle(2:7,:))
% Get group centers
xCnt = get(h(1),'XData') + cell2mat(get(h,'XOffset')); % XOffset is undocumented!
% get rid of old labels
xLab=[]
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
% Create Tick Labels
xLab={repmat({''},1,floor(size(alle,2)/2)),'monomers',repmat({''},1,size(alle,2)-1),'dimers',repmat({''},1,size(alle,2)-1),'trimers',repmat({''},1,size(alle,2)-1),'tetramers',repmat({''},1,size(alle,2)-1),'pentamers',repmat({''},1,size(alle,2)-1),'hexamers'};
%xLab = {'monomers','','dimers','','trimers','','tetramers','','pentamers','','hexamers','',''};
xLab=cat(2,xLab{:});
% Set individual ticks
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
%Y=h.CData(:,:,8)=[1 1 1]

% plot means
% scatter(mean(xCnt),mean_alle(2:7)','kx')
% errorbar(mean(xCnt),mean_alle(2:7)',std_alle(2:7)','k','LineStyle','none')
vecxCnt=sort(xCnt);
vecxCnt=vecxCnt(:);
vecalle=alle(2:7,:)';%' ist wichtig!!
vecalle=vecalle(:);
vecCIdown=CIdown(2:7,:)';%' ist wichtig!!
vecCIdown=vecCIdown(:);
vecCIdown(isnan(vecCIdown))=0;
vecCIup=CIup(2:7,:)';%' ist wichtig!!
vecCIup=vecCIup(:);
vecCIup(isnan(vecCIup))=0;
errorbar(vecxCnt,vecalle,vecCIdown,vecCIup,'k','LineStyle','none')
ylabel('frequency')
%l={cellstr(dates),{'mean'},{'std'}}%legend if means and std
% repetiopn legend
datesstr=cellstr(dates);
l={datesstr{1},datesstr{3},datesstr{2},datesstr{4},datesstr{5},datesstr{7},datesstr{6},{'95 % CI'}}

l={'10 nM ArlI','10 nM ArlI','200 nM ArlI','200 nM ArlI','200 nM ArlI + ATP',{'95 % CI'},}
l={'10 nM ArlI #1','10 nM ArlI #2',{'95 % CI'},}
l={'26.08.22 10 nM ArlI','30.09.22 10 nM ArlI','30.09.22 200 nM ArlI','02.12.22 200 nM ArlI','02.12.22 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP',...
    '26.05.23 200 nM ArlI','26.05.23 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP',...
    '20.07.23 200 nM ArlI','20.07.23 200 nM ArlI + 5 mM MgCl_2 + 1 mM ATP',{'uncertainty from uncertainty of DOL'}}
g=cat(1,l{:})
legend(g)
legend('boxoff')
ylim([0 1])
xlim([0.5 4.5])
set(gca,'fontname','Helvetica')
set(gca,'FontSize',10)
title('ArlJ oligomers')

Farbreihe=[[148/255,0/255,65/255];[237/255,107/255,63/255];[246/255,172/255,92/255];...
    [231/255,245/255,161/255];[175/255,220/255,170/255];...
    [114/255,194/255,163/255];[65/255,138/255,191/255];[99/255,83/255,165/255];[166/255,0,125/255];[1, 217/255, 102/255];[96/255, 148/255,60/255]];
colorsnoATP=[[0,0,255/255];[0,0.447,0.741];[0.85,0.325,0.098];[0.466,0.674,0.188];[0,0.512,0];[0.635,0.078,0.184]];
colorsnoATP=[Farbreihe(1,:);Farbreihe(9,:);Farbreihe(3,:);Farbreihe(10,:);Farbreihe(6,:)];
colorsnoATP=[Farbreihe(1,:);Farbreihe(3,:);Farbreihe(10,:);Farbreihe(6,:)];
for c=1: length(colorsnoATP)
    h(c).FaceColor=colorsnoATP(c,:);
end


%% Preparations for statistical testing
% 1. You need to have all experiments of one condition in "alle"
% 2. They are calculated back to absolute numbers to weigh each oligomer
% equally
% 3. They are summed up according to oligomer size
% 4. They are saved for later
for k=1:length(A)
    alle_abs(:,k)=alle(2:7,k)*A(k).OligomerNumber; %calculated back to absolute numbers
end
sum_alle_abs=sum(alle_abs,1);%control to get OligomerNumber again
sum_Oligomerkinds=sum(alle_abs,2); % summed up according to oligomer size
% save table of Oligomerkinds
cd('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno') % go to folder where you want to save
save('sum_Oligomerkinds_phos_ohn2jul3sep.mat','sum_Oligomerkinds')
save('sum_Oligomerkinds_noATP_with10feb.mat','sum_Oligomerkinds')
save('sum_Oligomerkinds_ATP-buffer_with10feb.mat','sum_Oligomerkinds')
save('sum_Oligomerkinds_ArlI.mat','sum_Oligomerkinds')
%% to calculate weighted CIs
% same procedure as above for the oligomers
for k=1:length(A)
    %replace NaNs by 0
    CIdown(isnan(CIdown))=0;
    CIup(isnan(CIup))=0;
    %
    CIdown_abs(:,k)=CIdown(2:7,k)*A(k).OligomerNumber;
    CIup_abs(:,k)=CIup(2:7,k)*A(k).OligomerNumber;
end
CIdown_abs_sum=sum(CIdown_abs,2);
CIdown_rel_sum=CIdown_abs_sum/sum([A.OligomerNumber]);
CIup_abs_sum=sum(CIup_abs,2);
CIup_rel_sum=CIup_abs_sum/sum([A.OligomerNumber]);
% save table of CIs
cd('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno')
save('weighed_CIs_ArlI.mat','CIdown_rel_sum')
save('weighed_CIs_noATP_with10feb.mat','CIdown_rel_sum')
save('weighed_CIs_phos.mat','CIdown_rel_sum')
save('weighed_CIs_buffer_with10feb.mat','CIdown_rel_sum')
%% ohne 2.7.2020, da riesiege CIs
for k=1:length(A)
    alle_abs(:,k)=alle(2:7,k)*A(k).OligomerNumber;
end
% delete 2.7.
% case= no ATP (2,7. = 2.eintrag
alle_abs(:,2)=[];
% cas =phos (2.7= 1.eintrag)
alle_abs(:,1)=[];
%delete 3.9.
alle_abs(:,1)
%
sum_alle_abs=sum(alle_abs,1);%test to get OligomerNumber again
sum_Oligomerkinds=sum(alle_abs,2);
% table_Oligomerkinds=
cd('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno')
save('sum_Oligomerkinds_phos_ohne2ndjuly.mat','sum_Oligomerkinds')
save('sum_Oligomerkinds_noATP_ohne2ndjuly.mat','sum_Oligomerkinds')
%% plot in absolute oligomer numbers 
phos=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_phos_ohn2jul3sep.mat');
noATP=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_noATP_with10feb.mat');
% no ATP vs ATP binding
%noATP=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_noATP_ohne2jul30sepII3decII.mat');
buffer=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_ATP-buffer_with10feb.mat');
ArlI=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_ArlI.mat');

phos=phos.sum_Oligomerkinds;
noATP=noATP.sum_Oligomerkinds;
buffer=buffer.sum_Oligomerkinds;
ArlI=ArlI.sum_Oligomerkinds;
%phos
monomers=ones(1,round(phos(1)));
dimers=ones(1,round(phos(2)))*2;
trimers=ones(1,round(phos(3)))*3;
tetramers=ones(1,round(phos(4)))*4;
pentamers=ones(1,round(phos(5)))*5;
hexamers=ones(1,round(phos(6)))*6;
monotohex=cat(2,monomers,dimers,trimers,tetramers,pentamers,hexamers);
% no ATP
monomersnoATP=ones(1,round(noATP(1)));
dimersnoATP=ones(1,round(noATP(2)))*2;
trimersnoATP=ones(1,round(noATP(3)))*3;
tetramersnoATP=ones(1,round(noATP(4)))*4;
pentamersnoATP=ones(1,round(noATP(5)))*5;
hexamersnoATP=ones(1,round(noATP(6)))*6;
monotohexnoATP=cat(2,monomersnoATP,dimersnoATP,trimersnoATP,tetramersnoATP,pentamersnoATP,hexamersnoATP);
% ATP buffer
monomersbuffer=ones(1,round(buffer(1)));
dimersbuffer=ones(1,round(buffer(2)))*2;
trimersbuffer=ones(1,round(buffer(3)))*3;
tetramersbuffer=ones(1,round(buffer(4)))*4;
pentamersbuffer=ones(1,round(buffer(5)))*5;
hexamersbuffer=ones(1,round(buffer(6)))*6;
monotohexbuffer=cat(2,monomersbuffer,dimersbuffer,trimersbuffer,tetramersbuffer,pentamersbuffer,hexamersbuffer);
% ArlI
monomersI=ones(1,round(ArlI(1)));
dimersI=ones(1,round(ArlI(2)))*2;
trimersI=ones(1,round(ArlI(3)))*3;
tetramersI=ones(1,round(ArlI(4)))*4;
pentamersI=ones(1,round(ArlI(5)))*5;
hexamersI=ones(1,round(ArlI(6)))*6;
monotohexI=cat(2,monomersI,dimersI,trimersI,tetramersI,pentamersI,hexamersI);
% what do you wanna plot?
cat2plot=cat(2,noATP,phos);
cat2plot=cat(2,noATP,buffer);
cat2plot=cat(2,noATP,phos,buffer);
cat2plot=cat(2,noATP,phos,buffer,ArlI);

cat2plot=ArlI;
figure
hold on
h=bar(cat2plot);
h(1).FaceColor=[248/255,196/255,65/255]; %no ATP orange
h(2).FaceColor=[170/255,23/255,43/255]; %phos red
h(3).FaceColor=[0.3882,    0.3255,    0.6471];% ATP buffer lila
h(1).FaceColor=[ 0.4471,    0.7608,    0.6392];% ArlI
% h=plot(phos,'x');
% plot(noATP,'o')
ylabel('frequency')
%legend('ArlH no ATP','ArlH-phos')
%legend('ArlH no ATP','ArlH ATP buffer')
legend('ArlH no ATP','ArlH-phos','ArlH ATP buffer')
legend('ArlH no ATP','ArlH-phos','ArlH ATP buffer','ArlI')
title('absolute oligomer numbers')
xCnt = get(h(1),'XData') + cell2mat(get(h,'XOffset')); % XOffset is undocumented!
% get rid of old labels
xLab=[]
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
xLab={repmat({''},1,floor(size(cat2plot,2)/2)),'monomers',repmat({''},1,size(cat2plot,2)-1),'dimers',repmat({''},1,size(cat2plot,2)-1),'trimers',repmat({''},1,size(cat2plot,2)-1),'tetramers',repmat({''},1,size(cat2plot,2)-1),'pentamers',repmat({''},1,size(cat2plot,2)-1),'hexamers'};
xLab=cat(2,xLab{:});
xLab={'','monomers','','dimers','','trimers','','tetramers','','pentamers','','hexamers',''};%for 2 different bars
xLab={'','monomers','','','dimers','','','trimers','','','tetramers','','','pentamers','','','hexamers',''};% for 3 different bars
% Set individual ticks
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
xlim([0.5 6.5])
ylim([0 1400])
%% back to relative: plot different conditions in relative numbers again
%load the stuff you saved before
phos=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_phos_ohn2jul3sep.mat');
noATP=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_noATP_with10feb.mat');
% no ATP vs ATP binding
%noATP=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_noATP_ohne2jul30sepII3decII.mat');
buffer=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_ATP-buffer_with10feb.mat');
ArlI=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\sum_Oligomerkinds_ArlI.mat');
%load CIs
CI_ArlI=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\weighed_CIs_ArlI.mat');
CI_noATP=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\weighed_CIs_noATP_with10feb.mat');
CI_phos=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\weighed_CIs_phos.mat');
CI_buffer=load('Z:\_personalDATA\JS+LV_4F-TIRF\Measurements_for_Nuno\Figures_Nuno\weighed_CIs_buffer_with10feb.mat');


phos=phos.sum_Oligomerkinds;
noATP=noATP.sum_Oligomerkinds;
buffer=buffer.sum_Oligomerkinds;
ArlI=ArlI.sum_Oligomerkinds;
%
CI_ArlI=CI_ArlI.CIdown_rel_sum;
CI_noATP=CI_noATP.CIdown_rel_sum;
CI_phos=CI_phos.CIdown_rel_sum;
CI_buffer=CI_buffer.CIdown_rel_sum;
% calulate relative
noATPrel=noATP/sum(noATP);
phosrel=phos/sum(phos);
bufferrel=buffer/sum(buffer);
ArlIrel=ArlI/sum(ArlI);
% select to plot
cat2plot=cat(2,noATPrel,bufferrel);
catCI=cat(2,CI_noATP,CI_buffer);
cat2plot=cat(2,noATPrel,phosrel);
catCI=cat(2,CI_noATP,CI_phos);
cat2plot=cat(2,phosrel,noATPrel,bufferrel);
catCI=cat(2,CI_phos,CI_noATP,CI_buffer);
cat2plot=cat(2,noATPrel,phosrel,bufferrel, ArlIrel);
cat2plot=ArlIrel
catCI=CI_ArlI
cat2plot=cat(2,ArlIrel,noATPrel);
catCI=cat(2,CI_ArlI,CI_noATP);
figure
hold on
h=bar(cat2plot,0.4);
h(2).FaceColor=[248/255,196/255,65/255]; %no ATP orange
h(1).FaceColor=[170/255,23/255,43/255]; %phos red
h(3).FaceColor=[0.3882,    0.3255,    0.6471];% ATP buffer lila
h(1).FaceColor=[ 0.4471,    0.7608,    0.6392];% ArlI
%h.EdgeColor=[0, 0, 0];
ylabel('frequency')
ylabel('relative frequency')
%legend('ArlH no ATP','ArlH-phos')
%legend('ArlH no ATP','ArlH ATP buffer')
%legend('ArlH no ATP','ArlH-phos','ArlH ATP buffer')
legend('ArlH no ATP','ArlH-phos','ArlH ATP buffer','ArlI')
legend('ArlI','weighted 95% CI')
legend boxoff
title('relative oligomer numbers')
title('')
xCnt = get(h(1),'XData') + cell2mat(get(h,'XOffset')); % XOffset is undocumented!
xCnt = get(h,'XData'); % für nur ArlI
% get rid of old labels
xLab=[]
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
xLab={repmat({''},1,floor(size(cat2plot,2)/2)),'monomers',repmat({''},1,size(cat2plot,2)-1),'dimers',repmat({''},1,size(cat2plot,2)-1),'trimers',repmat({''},1,size(cat2plot,2)-1),'tetramers',repmat({''},1,size(cat2plot,2)-1),'pentamers',repmat({''},1,size(cat2plot,2)-1),'hexamers'};
xLab=cat(2,xLab{:});
%xLab={'','monomers','','dimers','','trimers','','tetramers','','pentamers','','hexamers',''};
xLab={'','','monomers','','','','dimers','','','','trimers','','','','tetramers','','','','pentamers','','','','hexamers',''};% for 3 different bars

% Set individual ticks
set(gca, 'XTick', sort(xCnt(:)), 'XTickLabel', xLab)
xlim([0.5 6.5])
ylim([0 0.7])
% include weighed CIs
vecxCnt=sort(xCnt);
vecxCnt=vecxCnt(:);
vecalle=cat2plot';%' ist wichtig!!
vecalle=vecalle(:);
vecCIdown=catCI';%' ist wichtig!!
vecCIdown=vecCIdown(:);
vecCIdown(isnan(vecCIdown))=0;
vecCIup=catCI';%' ist wichtig!!
vecCIup=vecCIup(:);
vecCIup(isnan(vecCIup))=0;
errorbar(vecxCnt,vecalle,vecCIdown,vecCIup,'k','LineStyle','none')
legend('ArlH no ATP','ArlH phos','weighted 95% CI')
legend('ArlH phos','ArlH no ATP','ArlH non-phosphorylating ATP-buffer','weighted 95% CI')
legend('ArlI','ArlH no ATP','weighted 95% CI')
legend boxoff
%% rank sum test
[p,h,stats]=ranksum(monotohex,monotohexnoATP)
[p,h,stats]=ranksum(monotohexbuffer,monotohexnoATP)
[p,h,stats]=ranksum(monotohexI,monotohexnoATP)
% ttest
[h,p,ci,stats] = ttest2(monotohex,monotohexnoATP)
[h,p,ci,stats] = ttest2(monotohex,monotohexbuffer)
[h,p,ci,stats] = ttest2(monotohexbuffer,monotohexnoATP)
[h,p,ci,stats] = ttest2(monotohexnoATP,monotohexI)
