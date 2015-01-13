clear all;close all;clc;
addpath('../voicebox');
modeldir = 'voice_models/';

modelName = input('Name of the model:','s');
load([modeldir,modelName,'.mat']);

asr_fis = readfis('asr_fis');

numWords = numel(model.words);
numSamples = size(model.words(1).mfcc_matrix,2);
numComps = size(model.words(1).mfcc_matrix,3);
dist_matrix = zeros(numSamples,numWords);
for idx = 1:numWords
    for idy = 1:numSamples
        mfcc_dist = 0;
        for idz = 1:numComps
            mfcc_dist = mfcc_dist + ... 
                dtw(model.words(idx).centroid_mfcc(:,1,idz)',model.words(idx).mfcc_matrix(:,idy,idz)');
        end
        yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',model.words(idx).yule_matrix(:,idy)')));
        %yule_dist = dtw(model.words(idx).centroid_yule',model.words(idx).yule_matrix(:,idy)');
        
        fisinput = [mfcc_dist, yule_dist];
        dist_matrix(idy, idx) = evalfis(fisinput,asr_fis);
    end
end
disp('auto_test');
datasetsimplefis = dataset({dist_matrix,model.words(:).name})

%%
chunks = 100;
input('Press enter to test new word','s');
recordAnother = 'y';
while(~strcmp(recordAnother,'n'))
    dist_matrix = zeros(1,numWords);
    [audioData,fs] = voiceRecorder(model.name,'test',false);
    
    [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
        = genWordModel({audioData},[fs],chunks);
    %figure;plot(test_yule_matrix(:,1))
    for idx = 1:numWords
        mfcc_dist = 0;
        for idz = 1:numComps
            mfcc_dist = mfcc_dist + ... 
                dtw(model.words(idx).centroid_mfcc(:,1,idz)',test_mfcc_matrix(:,1,idz)');
        end
        yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',test_yule_matrix(:,1)')));
        %yule_dist = dtw(model.words(idx).centroid_yule',test_yule_matrix(:,1)');

        fisinput = [mfcc_dist, yule_dist];
        dist_matrix(1, idx) = evalfis(fisinput,asr_fis);
    end
    dist_matrix
    [min_dist, min_idx] = min(dist_matrix,[],2);
    disp(['Predicted word: ', model.words(min_idx).name]);
    disp(['Distance: ', num2str(min_dist)]);
    recordAnother = input('test another word? (y/n)','s');
end
