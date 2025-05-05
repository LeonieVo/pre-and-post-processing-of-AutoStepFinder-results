% This code exists to cut a .txt-file with many traces into many individual .txt-files
% before using this codes, export traces from Igor like this:
% 1. Click on saved traces graph
% 2. then put the following one after another in the command line
% string list = tracenamelist("", ";", 1)          //get list of traces plotted on y-axis of top-most graph
% save/B/G/W list as "OutputFile.txt"           // with /W for names of traces
% 3. You get one txt file with all traces. The associated waves ore packs of three in the order g_g r_g r_r
%% go to folder with your big txt-file and put its name here:
%  cd Z:\_personalDATA\JS+LV_4F-TIRF\ArlJ_Moritz\220930_2nd_ArlJ_measurement
 cd Z:\_personalDATA\JS+LV_4F-TIRF\ZZZ_Data\2024\240806_PfArlI+AfArlJ_Bleaching+Rotation
filename = '240806_Ana2_PfArlI+AfArlJ+ATP+Mg2+_BleachingSteps_alltraces.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
%% select colors, only run the code lines you need
% for all traces, meaning g_g r_g r_r run these lines
Data=A.data(:,1:end); 
colorsselected=3;
% for g_g and r_r run lines above and these line
Data(:,2:3:end)=[]; 
colorsselected=2;
% for only g_g :
Data=A.data(:,1:3:end); 
colorsselected=1;
% for only r_g:
Data=A.data(:,2:3:end); 
colorsselected=1;
%for only r_r:
Data=A.data(:,3:3:end); 
colorsselected=1;

% select correct trace names
tracenames=A.textdata(1,1:end);% for all traces, meaning g_g r_g r_r
tracenames(:,2:3:end)=[]; % for g_g and r_r run line above and this line
tracenames=A.textdata(1,1:3:end);% only g_g 
tracenames=A.textdata(1,2:3:end);% only r_g 
tracenames=A.textdata(1,3:3:end);% only r_r 

%% save to
% think of a name for the folder where your traces are saved to
saveto= strcat(filename(1:end-4),'_individualtraces');
mkdir(saveto)

%% now saving the traces
% run a loop to save each column into text file
 k=reshape( repmat( [1:size(Data,2)/colorsselected], colorsselected,1 ), 1, [] ); % to get 1 1 1 2 2 2 ....
for i = 1:size(Data,2); 
   
    filenamearray = strcat(num2str(k(i)),'_',tracenames(i),'.txt') ; % filename of saved trace
    filename=cat(2,filenamearray{:});
    data_col = Data(:,i) ; %select data of trace
    save(strcat(saveto,'/',filename),'data_col','-ascii') ;
end
%% to plot a trace just for visialisation/checking if everthing's alright
for i=1%:5% i-th trace from Data
    trace=Data(:,i);
    trace = trace - mean(trace(end-20:end)); % set background/end to zero
    trace= trace/mean(trace(1:10)); %normalized
    % smoothing:
    smoGA= smoothdata(trace,'gaussian',15);
    %% plotting:
    figure
    hold on
    plot(trace)
    plot(smoGA,'r')
    axis([0 length(trace) -1 5])
    title(tracenames(i))
end



