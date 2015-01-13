
clear all;close all;clc;

[audio, fs] = audioread('audiofiles/2-1.wav');
qSeq = extractAndQuantize(audio, fs);
order = 12;
nfft = 512;
[pxx,freq, ~] = pyulear(audio,order,nfft,fs);
% plot(freq./1000,log(pxx));

% states = 1:size(qSeq,1);
% [~, ~, rSeq] = unique(qSeq(:,1));


[audio, fs] = audioread('audiofiles/2-3.wav');
qSeq2 = extractAndQuantize(audio, fs);

[pxx2,freq2, ~] = pyulear(audio,order,nfft,fs);

yule_dist = sum(diag(pdist2(log(pxx),log(pxx2))))

% [~, ~, rSeq2] = unique(qSeq2(:,1));
% rSeq = [rSeq; rSeq2];
% states = [states,states];

mfcc_dist = dtw(qSeq(:,1)',qSeq2(:,1)')

TRANS_GUESS = [.9 .1 0 0 0;
               .05 .9 .05 0 0;
               0 .05 .9 .05 0;
               0 0 .05 .9 .05
               0 0 0 .1 .9];
EMIS_GUESS = [1     2     3;
              8    15    12;
              10    11    14;
              13     9     7;
              6     5     4];

% [TRANS_EST, EMIS_EST] = hmmtrain(rSeq, TRANS_GUESS, EMIS_GUESS)


% [audio, fs] = audioread('audiofiles/1-3.wav');
% qSeq = extractAndQuantize(audio, fs);
% [~, ~, rSeq] = unique(qSeq(:,1));

% [PSTATES,logpseq] = hmmdecode(rSeq,TRANS_EST,EMIS_EST)
