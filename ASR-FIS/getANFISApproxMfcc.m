function [anfis_mfcc] = getANFISApproxMfcc(mfcc_matrix)
    chunks = size(mfcc_matrix,1);
    numSamples = size(mfcc_matrix,2);
    numComps = size(mfcc_matrix,3);

    anfis_mfcc(:,1,:) = mfcc_matrix(:,1,:);
    
    trnData = [];
    chkData = [];

    numMFs = 4;
    inmftype = 'gbellmf';
    outmftype = 'linear';

    trnOpt = [10, 0, 0.02, 0.8, 1.2];
    dispOpt = [1,1,1,1];
    optMethod = 1;


    for idz = 1:numComps
        trnData = zeros(numSamples*chunks,2);
        for idy = 1:numSamples
            trnData(idy:idy+chunks-1,:) = [(1:chunks)', mfcc_matrix(:,idy,idz)];
        end

        initFis = genfis1(trnData,numMFs,inmftype,outmftype);

        [fis,error,stepsize,chkFis,chkErr] = ...
            anfis(trnData,initFis,trnOpt,dispOpt,chkData,optMethod);

        anfis_mfcc(:,1,idz) = evalfis((1:chunks)',fis);
    end
end