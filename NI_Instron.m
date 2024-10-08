% Written by Dr. Nathan Patterson
close all; clear all; clc;

sampleRate = 10000; % Sample rate - can't go above 10k for 2 channels or more
timeWindow = 2; % Creates a moving window with the plotted data to always look at the last few seconds of info
capDataLengthInSeconds = 10; % Caps length of data array to not make computer melt down
maxVoltage = 5; % Choose 1, 5, 10, 20 - Can't do 20 for single ended terminals

% Don't change anything after this
dlist = daqlist("ni");
daqObj = daq("ni");
daqObj.Rate = sampleRate;
devId = dlist.DeviceID(1);

ch1 = daqObj.addinput(devId, "ai0", "Voltage");
ch1.Range = [-maxVoltage maxVoltage];
ch1.TerminalConfig = "SingleEnded";

ch2 = daqObj.addinput(devId, "ai1", "Voltage");
ch2.Range = [-maxVoltage maxVoltage];
ch2.TerminalConfig = "SingleEnded";

daqObj.start("continuous")
pause(1)

f = figure;
allData = []; allTime = [];
while true
    [data, time] = daqObj.read("all", "OutputFormat","Matrix");
    allData = [allData; data];
    allTime = [allTime; time];
    index = max(1, length(allData) - timeWindow * sampleRate);
    plot(allTime(index:end), allData(index:end,1), allTime(index:end), allData(index:end,2))
    ylim([0 maxVoltage])
    if length(allData) > capDataLengthInSeconds * sampleRate
        allData([1:end-capDataLengthInSeconds * sampleRate],:) = [];
        allTime([1:end-capDataLengthInSeconds * sampleRate],:) = [];
    end
    pause(0.1)
end