clear all; close all; clc;

load fuzex1trnData.dat
%load fuzex2trnData.dat
load fuzex1chkData.dat
%load fuzex2chkData.dat

% initFis = genfis1(data,numMFs,inmftype,outmftype) 
% [fis,error,stepsize,chkFis,chkErr] = ...
%  anfis(trnData,initFis,trnOpt,dispOpt,chkData,optMethod)

numMFs = 4;
inmftype = 'gbellmf';
outmftype = 'linear';
initFis = genfis1(fuzex1trnData,numMFs,inmftype,outmftype);
trnOpt = [40, 0, 0.02, 0.8, 1.2];
dispOpt = [1,1,1,1];
optMethod = 1;
[fis,error,stepsize,chkFis,chkErr] = ...
 anfis(fuzex1trnData,initFis,trnOpt,dispOpt,fuzex1chkData,optMethod);

figure();
plot(fuzex1chkData(:,1),evalfis(fuzex1chkData(:,1),fis),'rx');hold on;
plot(fuzex1chkData(:,1),fuzex1chkData(:,2),'go');