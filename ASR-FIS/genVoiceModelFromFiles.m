clear all;close all;clc;
addpath('../voicebox');
modeldir = 'voice_models/';
audiodir = 'audio_files/';
mkdir(modeldir);

model.name = input('Name of the model:','s');
audiodir = [audiodir,model.name,'/'];
audio_files = dir(fullfile([audiodir,'*.wav']));

filesNums = [];
for idf = 1:numel(audio_files)
    filename = audio_files(idf).name;
    dashpos = regexpi(filename,'-');
    filesNums = [filesNums; filename(dashpos+1:end-4)];    
end
numSamples = length(unique(filesNums));

model.words = [];
chunks = 20;
anfaprox = true;
for idf = 1:numel(audio_files)
    filename = audio_files(idf).name;
    dashpos = regexpi(filename,'-');
    word.name = filename(1:dashpos-1);
    numSample = eval(filename(dashpos+1:end-4));
    
    if numSample == 1
        audios = [];
        fss = []; 
    end
    
    [audioData, fs] = audioread([audiodir,audio_files(idf).name]);
    audios{numSample} = audioData;
    fss = [fss,fs];
    
    if numSample == numSamples
        [word.mfcc_matrix, word.yule_matrix, word.centroid_mfcc, word.centroid_yule] ...
            = getWordModel(audios,fss,chunks,anfaprox);
    
        model.words = [model.words, word];
    end
    
end

save([modeldir,model.name,'.mat'],'model');