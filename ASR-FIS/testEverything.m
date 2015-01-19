clear all;close all;clc;

addpath('../voicebox');
modeldir = 'voice_models/';

models = dir(fullfile([modeldir,'*.mat']));

for idm = 1:numel(models)
    modelName = models(idm).name;
    modelName = modelName(1:end-4);

    load([modeldir,modelName,'.mat']);

    numWords = numel(model.words);
    chunks = size(model.words(1).mfcc_matrix{1,1},1);
    numSamples = size(model.words(1).mfcc_matrix,1);
    numComps = size(model.words(1).mfcc_matrix,2);
    
    testAllFromFiles

end