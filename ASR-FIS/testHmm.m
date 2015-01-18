clear all;close all;clc;

trainHMM

modelInit
load('asr_hmm.mat');
% addpath(genpath('../HMMall'));
autoTestHMM

input('Press enter to test new word','s');
recordAnother = 'y';
while(~strcmp(recordAnother,'n'))
    [audioData,fs] = voiceRecorder(model.name,'test',false);

    [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
        = getWordModel({audioData},fs,chunks);

    [pred_class, max_llike, ~] = classifyHMM(asr_hmm, test_mfcc_matrix);
    if(pred_class == 0)
        disp('Predicted word: UNKNOWN');
    else
        disp(['Predicted word: ', model.words(pred_class).name]);
    end
    disp(['Distance: ', num2str(max_llike)]);
    recordAnother = input('test another word? (y/n)','s');

end