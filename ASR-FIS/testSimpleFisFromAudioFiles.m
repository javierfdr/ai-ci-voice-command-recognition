clear all;close all;clc;
addpath('./voicebox');
audiodir = 'audio_files/prueba/';
audio_files = dir(fullfile([audiodir,'*.wav']));

order = 12;
nfft = 512;

chunks = 15;
mfcc_comps = 12;
mfcc_matrix = zeros(chunks,size(audio_files,1),mfcc_comps);
yule_matrix = [];
for idx = 1:numel(audio_files)
    [audio, fs] = audioread([audiodir,audio_files(idx).name]);
    mfcc = extractAndChunk(audio, fs, chunks);
    figure;plot(mfcc(:,1));
    [pxx,freq, ~] = pyulear(audio,order,nfft,fs);
%     figure;plot(freq,log(pxx));
    for idy = 1:mfcc_comps
        mfcc_matrix(:,idx,idy) = mfcc(:,idy);
    end
    yule_matrix = [yule_matrix, log(pxx)];
    
end

fismat = readfis('asr_fis');

dist_matrix = zeros(size(audio_files,1));
for idx = 1:numel(audio_files)
    for idy = 1:numel(audio_files)
        mfcc_dist = 0;
        for idz = 1:mfcc_comps
            mfcc_dist = mfcc_dist + dtw(mfcc_matrix(:,idx,idz)',mfcc_matrix(:,idy,idz)');
        end
        yule_dist = sum(diag(pdist2(yule_matrix(:,idx)',yule_matrix(:,idy)')));
   
        fisinput = [mfcc_dist, yule_dist]
        dist_matrix(idx, idy) = evalfis(fisinput,fismat);
    end
end
%dataset({dist_matrix.*(dist_matrix<5),audio_files(:).name})
dataset({dist_matrix,audio_files(:).name})