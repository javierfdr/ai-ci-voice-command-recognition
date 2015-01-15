function [enc_mfcc] = encodeSample(mfcc_sample,kmeans_matrix)
    
    enc_mfcc = [];
    chunks = size(kmeans_matrix,1);
    chunkstep = floor(size(mfcc_sample,1)/chunks);
    for c = 0:chunks-1;
        sample_chunk = mfcc_sample(((chunkstep*c)+1:chunkstep*(c+1)),:);
        centroids = kmeans_matrix{c+1};
        
        for s = 1:size(sample_chunk,1);
            min_dist = realmax;
            enc_idx = 0;
            for cent = 1:size(centroids,1)
               point_dist = pdist([sample_chunk(s);centroids(cent)]);
               if(point_dist < min_dist)
                   min_dist = point_dist;
                   enc_idx = cent;
               end
            end
            enc_mfcc = [enc_mfcc,enc_idx];
        end
    end

end