clear all;close all;clc;

modelInit
testdir = ['audio_files/',model.name,'/test'];
mkdir(testdir);

recordAnother = 'y';
saveSample = true;
for idw = 1:numWords
    input(['Press enter to record test set for: ',model.words(idw).name] ,'s');
    testName = model.words(idw).name;
    
    for ids = 1:numSamples
    [audioData,fs] = ... 
        voiceRecorder(model.name,['/test/',testName,'-',num2str(ids)],saveSample);

    end
end