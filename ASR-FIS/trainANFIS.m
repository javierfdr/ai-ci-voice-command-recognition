modelInit;

trnData = [];
for idx = 1:numWords
    for idx2 = 1:numWords
        for idy = 1:numSamples
            mfcc_dist = 0;
            for idz = 1:numComps
                mfcc_dist = mfcc_dist + ... 
                        dtw(model.words(idx).centroid_mfcc{idz}',model.words(idx2).mfcc_matrix{idy,idz}');
            end
            yule_dist = sum(diag(pdist2(model.words(idx).centroid_yule',model.words(idx2).yule_matrix{idy}')));

            trnData = [trnData; mfcc_dist, yule_dist, (idx ~= idx2)*1000];
        end
    end
end

chkData = [];

numMFs = 2;
inmftype = 'gbellmf';
outmftype = 'linear';

trnOpt = [20, 0, 0.02, 0.8, 1.2];
dispOpt = [1,1,1,1];
optMethod = 1;

initFis = genfis1(trnData,numMFs,inmftype,outmftype);

[asr_anfis,error,stepsize,chkFis,chkErr] = ...
            anfis(trnData,initFis,trnOpt,dispOpt,chkData,optMethod);
        
writefis(asr_anfis,'asr_anfis');