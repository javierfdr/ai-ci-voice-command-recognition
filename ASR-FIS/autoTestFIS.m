% clear all;close all;clc;
% 
% modelInit
% fis = readfis('asr_anfis');

dist_matrix = zeros(numSamples,numWords,numWords);
for idx = 1:numWords
    for idx2 = 1:numWords
        for idy = 1:numSamples
            mfcc_dist = 0;

            for idz = 1:numComps
                mfcc_dist = mfcc_dist + ... 
                        dtw(model.words(idx).centroid_mfcc{idz}',model.words(idx2).mfcc_matrix{idy,idz}');
            end
            yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',model.words(idx2).yule_matrix{idy}')));
    %         yule_dist = dtw(model.words(idx).centroid_yule',model.words(idx).yule_matrix{idy}');

            fisinput = [mfcc_dist, yule_dist];
            dist_matrix(idy, idx, idx2) = evalfis(fisinput,fis);
        end
    end
end
disp('auto_test');
for idx = 1:numWords
    dataset({dist_matrix(:,:,idx),model.words(:).name})
end