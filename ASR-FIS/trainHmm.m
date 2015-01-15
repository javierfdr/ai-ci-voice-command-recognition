modelInit
addpath(genpath('../HMMall'));

%% Segmental Kmeans for the MFCC model
segments = 5;
k = 10;

asr_hmm.kmeans_matrix = cell(segments,1);
dim = ndims(model.words(1).mfcc_matrix);
for c = 0:segments-1
    trnData = [];
    for idx = 1:numWords
        for idy = 1:numSamples
            M = cat(dim,model.words(idx).mfcc_matrix{idy,:});
            chunkstep = floor(size(model.words(idx).mfcc_matrix{idy},1)/segments);
            trnData = [trnData; M(((chunkstep*c)+1:chunkstep*(c+1)),:)];
        end
    end
    [~,centroids] = kmeans(trnData,k);
    asr_hmm.kmeans_matrix{c+1} = centroids;
end

%% Training HMM per Word
% http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm_usage.html
O = k; % observations as k
Q = segments; % states as segments

prior1 = normalise(rand(Q,1));
transmat1 = mk_stochastic(rand(Q,Q));
obsmat1 = mk_stochastic(rand(Q,O));

asr_hmm.hmm_matrix = cell(numWords,1);
dim = ndims(model.words(1).mfcc_matrix);
for idx = 1:numWords
    trnData = [];
    for idy = 1:numSamples
        mfcc_sample = cat(dim,model.words(idx).mfcc_matrix{idy,:});
        trnData = [ trnData ; encodeSample(mfcc_sample, asr_hmm.kmeans_matrix)];
    end    
    [LL, prior2, transmat2, obsmat2] = ...
        dhmm_em(trnData, prior1, transmat1, obsmat1, 'max_iter', 20);
    
    asr_hmm.hmm_matrix{idx}.prior = prior2;
    asr_hmm.hmm_matrix{idx}.transmat = transmat2;
    asr_hmm.hmm_matrix{idx}.obsmat = obsmat2;
end

% save('asr_hmm','asr_hmm');
