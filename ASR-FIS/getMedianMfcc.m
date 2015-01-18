function [median_mfcc] = getMedianMfcc(mfcc_matrix)
    numSamples = size(mfcc_matrix,1);
    numComps = size(mfcc_matrix,2);
    
    for idz = 1:numComps
        median_mfcc{idz} = mfcc_matrix{1,idz};
    end
    current_dist = realmax;
    for idx = 1:numSamples
        mfcc_dist = 0;
        for idy = 1:numSamples
            for idz = 1:numComps
                mfcc_dist =  mfcc_dist + dtw(mfcc_matrix{idx,idz}',mfcc_matrix{idy,idz}');
            end
        end
        
        if mfcc_dist < current_dist
           current_dist =  mfcc_dist;
           for idz = 1:numComps
             median_mfcc{idz} = mfcc_matrix{idx,idz};
           end
        end
    end

end