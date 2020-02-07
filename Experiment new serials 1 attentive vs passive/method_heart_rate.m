function [HRV_blvg, data_original, pks, locs, all_channel_HRV] = method_heart_rate(dod_raw, s_task, t, window_t, window_size)

% only refrence channels
channels = [18, 4, 19, 10];

% select only the task portion
first_index = min(find(s_task==1));
last_index = max(find(s_task==1));

start_index = first_index - 50*5;
end_index = last_index + 50*45;

% HbO more susceptable to systemic changes, use HbO data to calcualte heart
% rate; calcualte HbO concetration first and use Referece channel only
load('SD.mat');
dc = hmrOD2Conc(dod_raw, SD, [6  6]);

% dc_Hb = dc([start_index:end_index],number,RC);
% dod_raw = median(dc(:,1,:), 3);
% dc_Hb = dod_raw([start_index:end_index],1);

% do this for each channel
all_channel_HRV = [];
for ii = 1: length(channels)

    dc_Hb = dc([start_index:end_index],1,channels(ii));
    % dc_Hb = dod_raw([start_index:end_index], channels(ii));
    disp(length(dc_Hb))
    %Call the Butter IIR LPF fc=4Hz
    Hd = fnirLPFilt(4);
    %filtfilt(SOS,G,x) G is between 1 and L+1, L = 2
    dod_filt = filtfilt(Hd.sosMatrix,1,dc_Hb);
    % data_original2 = dod_filt;
    % tx = t(start_index : end_index);
    %data_original = resample(dod_filt,tx,100);
    data_original = dod_filt;
    
    % Peaks in the HbO signal were found using the FINDPEAKS routine in the
    % MATLAB signal processing toolbox, with a minimum spacing equivalent to
    % 200 BPM
    [pks,locs] = findpeaks(data_original,'MinPeakDistance',0.5*50); %, 'MinPeakProminence', 7);
    
    %% Heart Rate Calculation
    %Find Sample Interval between peaks
    RR_SampleDiff = zeros(1,size(locs,2)-1);
    for i = 1:length(locs)-1
        RR_SampleDiff(i) = locs(i+1) - locs(i);
    end
    %Find Time Interval using Sample Intervals
    RR_TimeDiff = RR_SampleDiff./50;
    
    %Dropped Beats
    %Intervals Longer than the mean + three standard deviations are assumed to
    %be dropped beats and the intervals are divided in half
    averageTimeDiff = mean(RR_TimeDiff);
    threeDev = std(RR_TimeDiff)*3;
    maxInterval = averageTimeDiff + threeDev;
    for checkInt = 1:size(RR_TimeDiff,2)
        if RR_TimeDiff(checkInt) > maxInterval
            RR_TimeDiff(checkInt) = RR_TimeDiff(checkInt)/2;
        end
    end
    
    % %Divide Blocks into time blocks.
    % totalSamples = length(data_original); %totalSecs = totalSamples/100; %100Hz at resampled rate
    % %Divide into 10 second blocks: 1000 samples per block at 100Hz
    % %Find which peaks belong in which block. Check if sample is less than 1k, 2k, ... to 589k
    % samplesPerBlock = 50 * window_size;
    % numBlocks = ceil(totalSamples/samplesPerBlock);
    % sampleCheckPrev = 0;
    % index = cell([1,numBlocks]); Block = cell([1,numBlocks]);
    % instantHR = zeros(1,length(Block));
    %
    % for i = 1:numBlocks
    %     sampleCheck = i*samplesPerBlock;
    %     index{1,i} = find(locs < sampleCheck & locs > sampleCheckPrev); %gives index of locs_corr
    %
    %     if isempty(index{1,i}) %if there are no samples that match, replace with NaN
    %         index{1,i} = NaN;
    %     else
    %         if index{1,i}(end) >= size(RR_TimeDiff,2) %Avoid error when index is larger than size
    %             index{1,i}(end) = size(RR_TimeDiff,2);
    %         end
    %         Block{1,i} = RR_TimeDiff(index{1,i}(1):index{1,i}(end)); %Cell filled with Time Intervals
    %         % instantHR(i) = (nanmean(1./Block{1,i})); %Take average of inverse of time intevals
    %         instantHR(i) = std(Block{1,i});
    %     end
    %     sampleCheckPrev = sampleCheck;
    % end
    
    % for i = 1:length(Block)
    %     numincell(i) = length(Block{1,i});
    % end
    
    to_inter = 1./RR_TimeDiff;
    x2 = locs(1:end-1);
    xq2 =  1: size(dc_Hb,1);
    HRV = interp1(x2, to_inter, xq2, 'spline');

    all_channel_HRV = cat(1, all_channel_HRV, HRV);
    
end

% select median at each time point
HRV = median(all_channel_HRV, 1);

%Call the Butter IIR LPF fc=0.3Hz
Hd = fnirLPFilt(0.03);
%filtfilt(SOS,G,x) G is between 1 and L+1, L = 2
HRV = filtfilt(Hd.sosMatrix,1,HRV);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% new block average for each task onset
all_block_HRV = [];
task_index = find(s_task==1);
for ii = 1 :  length(task_index)
    
    pre_stim_HRV = HRV(task_index(ii) - 4 * 50 : task_index(ii) - 2 * 50);
    block_HRV = HRV(task_index(ii) - 5 * 50 : task_index(ii) + 40 * 50);
    block_HRV = block_HRV - median(pre_stim_HRV);
    
    all_block_HRV = cat(2, all_block_HRV, block_HRV');
    
end

% calculate block average of HRV
% HRV_blvg = hmrBlockAvg(HRV', s_task, t, window_t);
HRV_blvg = mean(all_block_HRV, 2);
end