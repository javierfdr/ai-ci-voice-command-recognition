function [enc_mfcc] = kEncodeSample(mfcc_sample,kmeans_matrix)
    
    mfccComps = 1:size(kmeans_matrix,2);
    enc_mfcc = [];        
    for s = 1:size(mfcc_sample,1);        
        enc_idx =  knnsearch(kmeans_matrix,mfcc_sample(s,mfccComps));
        enc_mfcc = [enc_mfcc,enc_idx];
    end

end