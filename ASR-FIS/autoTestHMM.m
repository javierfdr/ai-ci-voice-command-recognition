% clear all;close all;clc;
% 
% modelInit
% load('asr_hmm.mat');

ll_matrix = zeros(numSamples,numWords);
dim = ndims(model.words(1).mfcc_matrix);

for idx = 1:numWords
    for idx2 = 1:numWords
        for idy = 1:numSamples
            mfcc_sample = cat(dim,model.words(idx).mfcc_matrix{idy,:});
            enc_sample = kEncodeSample(mfcc_sample, asr_hmm.kmeans_matrix);
            ll_matrix(idy, idx, idx2) = ...
                dhmm_logprob( ...
                    enc_sample, ... 
                    asr_hmm.hmm_matrix{idx2}.prior, ...
                    asr_hmm.hmm_matrix{idx2}.transmat, ...
                    asr_hmm.hmm_matrix{idx2}.obsmat);
        end
    end
end

disp('HMM auto_test');
for idx = 1:numWords
    dataset({ll_matrix(:,:,idx),model.words(:).name})
end