%http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm_usage.html
clear all;close all;clc;
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


trnData = [];
for idx = 1:numWords
    for idx2 = idx:numWords
        for idy = 1:numSamples
            mfcc_dist = 0;
            for idz = 1:numComps
                trnData = [trnData; model.words(idx).mfcc_matrix(:,idy,idz)'];
            end
        end
    end
end

idx = kmeans(trnData,10)