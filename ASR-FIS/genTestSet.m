clear all;close all;clc;

modelInit
testdir = ['audio_files/',model.name,'/test'];
mkdir(testdir);

wordsIdx = dataset({1:numWords,model.words(:).name});

input('Press enter to record new test word','s');
recordAnother = 'y';
saveSample = true;
numSample = 0;
while(~strcmp(recordAnother,'n'))
    pred_matrix = zeros(2,3);
    wordsIdx
    testIdx = input('Index of word to test?');
    testName = model.words(testIdx).name;
    numSample = numSample +1;
    [audioData,fs] = ... 
        voiceRecorder(model.name,['/test/',testName,'-',num2str(numSample)],saveSample);

    recordAnother = input('record another word? (y/n)','s');

end