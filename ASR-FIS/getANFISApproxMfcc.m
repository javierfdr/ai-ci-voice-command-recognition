function [anfis_mfcc] = getANFISApproxMfcc(mfcc_matrix)

    numSamples = size(mfcc_matrix,1);
    numComps = size(mfcc_matrix,2);

    anfis_mfcc{:} = mfcc_matrix{1,:};
    
    trnData = [];
    chkData = [];

    numMFs = 4;
    inmftype = 'gbellmf';
    outmftype = 'linear';

    trnOpt = [20, 0, 0.02, 0.8, 1.2];
    dispOpt = [1,1,1,1];
    optMethod = 1;


    for idz = 1:numComps
        trnData = [];
        minSampleSize = realmax;
        for idy = 1:numSamples
            sampleSize = size(mfcc_matrix{idy,idz},1);
            if(sampleSize < minSampleSize)
                minSampleSize = sampleSize;
            end
            trnData = [trnData; (1:sampleSize)', mfcc_matrix{idy,idz}];
        end

        initFis = genfis1(trnData,numMFs,inmftype,outmftype);

        [fis,error,stepsize,chkFis,chkErr] = ...
            anfis(trnData,initFis,trnOpt,dispOpt,chkData,optMethod);

        anfis_mfcc{idz} = evalfis((1:minSampleSize)',fis);
    end
end