% modelInit
addpath(genpath('../HMMall'));

%% Kmeans for the MFCC model
k = 15;
mfccComps = 12;

dim = ndims(model.words(1).mfcc_matrix);
trnData = [];
for idx = 1:numWords
    for idy = 1:numSamples
        M = cat(dim,model.words(idx).mfcc_matrix{idy,:});
        trnData = [trnData; M(:,1:mfccComps)];
    end
end
[~,centroids] = kmeans(trnData,k);
asr_hmm.kmeans_matrix = centroids;

%% Training HMM per Word
% http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm_usage.html
O = k; % observations = k
Q = 3; % states

% prior1 = normalise(rand(Q,1));
transmat1 = diag(repmat(0.8,1,Q))+repmat(0.1,Q,Q);
%obsmat1 = repmat(1/Q,Q,O);

asr_hmm.hmm_matrix = cell(numWords,1);
dim = ndims(model.words(1).mfcc_matrix);
for idx = 1:numWords
    trnData = [];
    for idy = 1:numSamples
        mfcc_sample = cat(dim,model.words(idx).mfcc_matrix{idy,:});
        trnData = [ trnData ; kEncodeSample(mfcc_sample, asr_hmm.kmeans_matrix)];
    end
    
    prior1 = normalise(rand(Q,1));
%     transmat1 = mk_stochastic(rand(Q,Q));
    obsmat1 = mk_stochastic(rand(Q,O));
    
    [LL, prior2, transmat2, obsmat2] = ...
        dhmm_em(trnData, prior1, transmat1, obsmat1, 'max_iter', 5);
    
    asr_hmm.hmm_matrix{idx}.prior = prior2;
    asr_hmm.hmm_matrix{idx}.transmat = transmat2;
    asr_hmm.hmm_matrix{idx}.obsmat = obsmat2;
end

save('asr_hmm.mat','asr_hmm');
