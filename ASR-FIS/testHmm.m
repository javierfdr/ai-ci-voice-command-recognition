clear all;close all;clc;

trainHmm

% asr_hmm = load('asr_hmm.mat');

ll_matrix = zeros(numSamples,numWords);
dim = ndims(model.words(1).mfcc_matrix);
for idx = 1:numWords
    for idx2 = 1:numWords
        for idy = 1:numSamples
            mfcc_sample = cat(dim,model.words(idx).mfcc_matrix{idy,:});

            ll_matrix(idy, idx, idx2) = ...
                dhmm_logprob( ...
                    encodeSample(mfcc_sample, asr_hmm.kmeans_matrix), ... 
                    asr_hmm.hmm_matrix{idx2}.prior, ...
                    asr_hmm.hmm_matrix{idx2}.transmat, ...
                    asr_hmm.hmm_matrix{idx2}.obsmat);
        end
    end
end

disp('auto_test');
for idx = 1:numWords
    dataset({ll_matrix(:,:,idx),model.words(:).name})
end

%%

    input('Press enter to test new word','s');
    recordAnother = 'y';
    while(~strcmp(recordAnother,'n'))
        ll_matrix = zeros(1,numWords);
        [audioData,fs] = voiceRecorder(model.name,'test',false);

        [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
            = getWordModel({audioData},fs,chunks);

        for idx = 1:numWords
            mfcc_sample = cat(dim,test_mfcc_matrix{1,:});

            ll_matrix(1, idx) = ...
                dhmm_logprob( ...
                    encodeSample(mfcc_sample, asr_hmm.kmeans_matrix), ... 
                    asr_hmm.hmm_matrix{idx}.prior, ...
                    asr_hmm.hmm_matrix{idx}.transmat, ...
                    asr_hmm.hmm_matrix{idx}.obsmat);
        end
        ll_matrix
        [min_dist, max_idx] = max(ll_matrix,[],2);
        disp(['Predicted word: ', model.words(max_idx).name]);
        disp(['Distance: ', num2str(min_dist)]);
        recordAnother = input('test another word? (y/n)','s');

    end