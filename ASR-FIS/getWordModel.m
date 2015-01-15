function [mfcc_matrix, yule_matrix, centroid_mfcc, centroid_yule] = genWordModel(AUDIOS,FSS,CHUNKS,ANFAPROX)
    
    numSamples = size(AUDIOS,2);
    order = 12;
    nfft = 512;
    mfcc_comps = 12;
%     mfcc_matrix = zeros(CHUNKS,numSamples,mfcc_comps);
%     yule_matrix = zeros((nfft/2+1),numSamples);
    % pxx has length (nfft/2+1) if nfft is even, and (nfft+1)/2 if nfft is odd
    
    mfcc_matrix = cell(numSamples,mfcc_comps);
    yule_matrix = cell(numSamples);
    
    
    for idx = 1:numSamples
        mfcc = extractAndChunk(AUDIOS{idx}, FSS(idx), CHUNKS);
        pxx = pyulear(AUDIOS{idx},order,nfft,FSS(idx));
        for idy = 1:mfcc_comps
            mfcc_matrix{idx,idy} = mfcc(:,idy);
        end
        yule_matrix{idx} = log(pxx);

    end

    if(nargin > 3 && ANFAPROX)
        centroid_mfcc = getANFISApproxMfcc(mfcc_matrix);
    else
        centroid_mfcc = getMedianMfcc(mfcc_matrix);
    end
    
    centroid_yule = getMeanYule(yule_matrix);
%     centroid_yule = getMedianYule(yule_matrix);
    
%     figure();
%     plot((1:CHUNKS)',anfis_mfcc,'rx');hold on;
%     plot((1:CHUNKS)',centroid_mfcc(:,1),'go');

end