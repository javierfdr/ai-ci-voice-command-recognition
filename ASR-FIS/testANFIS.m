%clear all;close all;clc;
addpath('../voicebox');
modeldir = 'voice_models/';
mkdir(modeldir);

clear all;close all;clc;
addpath('../voicebox');
modeldir = 'voice_models/';

modelName = input('Name of the model:','s');
load([modeldir,modelName,'.mat']);

numWords = numel(model.words);
chunks = size(model.words(1).mfcc_matrix,1);
numSamples = size(model.words(1).mfcc_matrix,2);
numComps = size(model.words(1).mfcc_matrix,3);

%% training anfis

trnData = [];
for idx = 1:numWords
    for idx2 = idx:numWords
        for idy = 1:numSamples
            mfcc_dist = 0;
            for idz = 1:numComps
                mfcc_dist = mfcc_dist + ... 
                        dtw(model.words(idx2).centroid_mfcc(:,:,idz)',model.words(idx).mfcc_matrix(:,idy,idz)');
            end
            yule_dist = sum(diag(pdist2(model.words(idx2).centroid_yule',model.words(idx).centroid_yule')));

            trnData = [trnData; mfcc_dist, yule_dist, ((idx ~= idx2)*1000)];
        end
    end
end

chkData = [];

numMFs = 2;
inmftype = 'gbellmf';
outmftype = 'linear';

trnOpt = [50, 0, 0.02, 0.8, 1.2];
dispOpt = [1,1,1,1];
optMethod = 1;

initFis = genfis1(trnData,numMFs,inmftype,outmftype);

[asr_anfis,error,stepsize,chkFis,chkErr] = ...
            anfis(trnData,initFis,trnOpt,dispOpt,chkData,optMethod);
        
writefis(asr_anfis,'asr_anfis');

%%
% asr_anfis = readfis('asr_anfis');

dist_matrix = zeros(numSamples,numWords);
for idx = 1:numWords
    for idx2 = 1:numWords
        for idy = 1:numSamples
            mfcc_dist = 0;
            for idz = 1:numComps
                mfcc_dist = mfcc_dist + ... 
                        dtw(model.words(idx2).centroid_mfcc(:,:,idz)',model.words(idx).mfcc_matrix(:,idy,idz)');
            end
            yule_dist = sum(diag(pdist2(model.words(idx2).centroid_yule',model.words(idx).yule_matrix(:,idy)')));
    %         yule_dist = dtw(model.words(idx).centroid_yule',model.words(idx).yule_matrix(:,idy)');

            fisinput = [mfcc_dist, yule_dist];
            dist_matrix(idy, idx, idx2) = evalfis(fisinput,asr_anfis);
        end
    end
end
disp('auto_test');
for idx = 1:numWords
    dataset({dist_matrix(:,:,idx),model.words(:).name})
end

%%
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
                    dtw(model.words(idx).centroid_mfcc(:,:,idz)',test_mfcc_matrix(:,1,idz)');
        end
        yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',test_yule_matrix(:,1)')));
%         yule_dist = dtw(model.words(idx).centroid_yule',test_yule_matrix(:,1)');

        fisinput = [mfcc_dist, yule_dist]
        dist_matrix(1, idx) = evalfis(fisinput,asr_anfis);
    end
    dist_matrix
    [min_dist, min_idx] = min(dist_matrix,[],2);
    disp(['Predicted word: ', model.words(min_idx).name]);
    disp(['Distance: ', num2str(min_dist)]);
    recordAnother = input('test another word? (y/n)','s');
end

