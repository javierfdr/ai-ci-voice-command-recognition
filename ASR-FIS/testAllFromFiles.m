clear all;close all;clc;

modelInit
testdir = ['audio_files/',model.name,'/test/'];
test_files = dir(fullfile([testdir,'*.wav']));

load('asr_hmm.mat');
addpath(genpath('../HMMall'));

asr_anfis = readfis('asr_anfis');
asr_fis = readfis('asr_fis');


pred_matrix = zeros(2,3,numel(test_files));
for idf = 1:numel(test_files)
    
    [audioData,fs] = audioread([testdir,test_files(idf).name]);

    [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
        = getWordModel({audioData},fs,chunks);
    
    % Simple FIS classifier
    [pred_class, min_dist, ~] = ...
            classifyFIS(asr_fis,model,test_mfcc_matrix,test_yule_matrix);
    pred_matrix(:,1,idf) = [pred_class; min_dist];
        
    % ANFIS classifier
    [pred_class, min_dist, ~] = ...
            classifyFIS(asr_anfis,model,test_mfcc_matrix,test_yule_matrix);
    
    pred_matrix(:,2,idf) = [pred_class; min_dist];
    
    % HMM Classifier
    [pred_class, max_llike, ~] = classifyHMM(asr_hmm, test_mfcc_matrix);
    
    pred_matrix(:,3,idf) = [pred_class; max_llike];
    
end

for idf = 1:numel(test_files)
    dataset([pred_matrix(:,:,idf),{'FIS' 'ANFIS' 'HMM'}])
end
