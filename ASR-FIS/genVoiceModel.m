clear all;close all;clc;
addpath('../voicebox');
modeldir = 'voice_models/';
mkdir(modeldir);

model.name = input('Name of the model:','s');
numSamples = input('Samples per word:');
recordAnother = 'y';
model.words = [];
chunks = 100;
while(~strcmp(recordAnother,'n'))
    word.name = input('Word to record:','s');
    audios = [];
    fss = [];
    for idw = 1:numSamples
        [audioData,fs] = voiceRecorder(model.name,[word.name,'-',num2str(idw)],true);
        audios{idw} = audioData;
        fss = [fss,fs];
    end
    [word.mfcc_matrix, word.yule_matrix, word.centroid_mfcc, word.centroid_yule] ...
        = genWordModel(audios,fss,chunks);
    
    model.words = [model.words, word];
    recordAnother = input('record another word? (y/n)','s');
end

save([modeldir,model.name,'.mat'],'model');