clear all;close all;clc;

modelInit
load('asr_hmm.mat');
addpath(genpath('../HMMall'));

asr_anfis = readfis('asr_anfis');
asr_fis = readfis('asr_fis');


input('Press enter to test new word','s');
recordAnother = 'y';
while(~strcmp(recordAnother,'n'))
    pred_matrix = zeros(2,3);
    
    [audioData,fs] = voiceRecorder(model.name,'_test',false);

    [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
        = getWordModel({audioData},fs,chunks);
    
    % Simple FIS classifier
    [pred_class, min_dist, ~] = ...
            classifyFIS(asr_fis,model,test_mfcc_matrix,test_yule_matrix);
    pred_matrix(:,1) = [pred_class; min_dist];
        
    % ANFIS classifier
    [pred_class, min_dist, ~] = ...
            classifyFIS(asr_anfis,model,test_mfcc_matrix,test_yule_matrix);
    
    pred_matrix(:,2) = [pred_class; min_dist];
    
    % HMM Classifier
    [pred_class, max_llike, ~] = classifyHMM(asr_hmm, test_mfcc_matrix);
    
    pred_matrix(:,3) = [pred_class; max_llike];
    
    dataset([pred_matrix,{'FIS' 'ANFIS' 'HMM'}])
    
    recordAnother = input('test another word? (y/n)','s');

end