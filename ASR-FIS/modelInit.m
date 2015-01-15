addpath('../voicebox');
modeldir = 'voice_models/';

modelName = input('Name of the model:','s');
load([modeldir,modelName,'.mat']);

numWords = numel(model.words);
chunks = size(model.words(1).mfcc_matrix{1,1},1);
numSamples = size(model.words(1).mfcc_matrix,1);
numComps = size(model.words(1).mfcc_matrix,2);