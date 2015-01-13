function [median_mfcc] = getMedianMfcc(mfcc_matrix)
    numSamples = size(mfcc_matrix,2);
    numComps = size(mfcc_matrix,3);

    median_mfcc = mfcc_matrix(:,1,:);
    current_dist = realmax;
    for idx = 1:numSamples
        mfcc_dist = 0;
        for idy = 1:numSamples
            for idz = 1:numComps
                mfcc_dist =  mfcc_dist + dtw(mfcc_matrix(:,idx,idz)',mfcc_matrix(:,idy,idz)');
            end
        end
        
        if mfcc_dist < current_dist
           current_dist =  mfcc_dist;
           median_mfcc = mfcc_matrix(:,idx,:);
        end
    end

end