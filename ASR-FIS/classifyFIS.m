function [pred_class, min_dist, dist_matrix] = classifyFIS(fis,model,test_mfcc_matrix,test_yule_matrix)
   
    numWords = numel(model.words);
    numComps = size(model.words(1).mfcc_matrix,2);
    
    dist_matrix = zeros(1,numWords);

    for idx = 1:numWords
        mfcc_dist = 0;
        for idz = 1:numComps
             mfcc_dist = mfcc_dist + ... 
                    dtw(model.words(idx).centroid_mfcc{idz}',test_mfcc_matrix{1,idz}');
        end
        yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',test_yule_matrix{1}')));
%         yule_dist = dtw(model.words(idx).centroid_yule',test_yule_matrix{1}');

        fisinput = [mfcc_dist, yule_dist]
        dist_matrix(1, idx) = evalfis(fisinput,fis);
    end
    dist_matrix;
    [min_dist, pred_class] = min(dist_matrix,[],2);

end