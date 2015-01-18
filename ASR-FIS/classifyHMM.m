function [pred_class, max_llike, ll_matrix] = classifyHMM(asr_hmm, test_mfcc_matrix)
    
    numWords = size(asr_hmm.hmm_matrix,1);
    dim = ndims(test_mfcc_matrix);

    ll_matrix = zeros(1,numWords);

    mfcc_sample = cat(dim,test_mfcc_matrix{1,:});
    enc_sample = kEncodeSample(mfcc_sample, asr_hmm.kmeans_matrix);

    for idx = 1:numWords
        
        ll_matrix(1, idx) = ...
            dhmm_logprob( ...
                enc_sample, ... 
                asr_hmm.hmm_matrix{idx}.prior, ...
                asr_hmm.hmm_matrix{idx}.transmat, ...
                asr_hmm.hmm_matrix{idx}.obsmat);
    end
    ll_matrix;
    [max_llike, pred_class] = max(ll_matrix,[],2);
    if max_llike == -Inf;
        pred_class = 0;
    end
end