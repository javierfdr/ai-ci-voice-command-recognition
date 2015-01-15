function testFIS(fis)
    modelInit

    dist_matrix = zeros(numSamples,numWords,numWords);
    for idx = 1:numWords
        for idx2 = 1:numWords
            for idy = 1:numSamples
                mfcc_dist = 0;
                if(idx == idx2)
                figure();
                plot(model.words(idx).mfcc_matrix{idy,1}','rx'); hold on;
                plot(model.words(idx2).centroid_mfcc{1},'go');
                end
                for idz = 1:numComps
                    mfcc_dist = mfcc_dist + ... 
                            dtw(model.words(idx2).centroid_mfcc{idz}',model.words(idx).mfcc_matrix{idy,idz}');
                end
                yule_dist = sum(diag(pdist2(model.words(idx2).centroid_yule',model.words(idx).yule_matrix{idy}')));
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

    %%
    input('Press enter to test new word','s');
    recordAnother = 'y';
    while(~strcmp(recordAnother,'n'))
        dist_matrix = zeros(1,numWords);
        [audioData,fs] = voiceRecorder(model.name,'test',false);

        [test_mfcc_matrix, test_yule_matrix, test_centroid_mfcc, test_centroid_yule] ...
            = getWordModel({audioData},[fs],chunks);

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
        dist_matrix
        [min_dist, min_idx] = min(dist_matrix,[],2);
        disp(['Predicted word: ', model.words(min_idx).name]);
        disp(['Distance: ', num2str(min_dist)]);
        recordAnother = input('test another word? (y/n)','s');

    end
end