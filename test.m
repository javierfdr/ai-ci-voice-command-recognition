% http://en.wikipedia.org/wiki/Speech_corpus
% http://www.cnel.ufl.edu/~yadu/report1.html

clear all;close all;clc;
addpath('./voicebox');
%  specandcep('audiofiles/abrete.wav');
%  specandcep('audiofiles/abrete-alejandro.wav');
% 
% specandcep('audiofiles/cierrate.wav');
% specandcep('audiofiles/cierrate-alejandro.wav');
% 
% specandcep('audiofiles/abrete-sub.wav');
% 
specandcep('audiofiles/1-1.wav');
specandcep('audiofiles/1-2.wav');

% [TRANS_EST, EMIS_EST] = hmmestimate(chunkmeans, states)

% specandcep('audiofiles/1-3.wav');

specandcep('audiofiles/2-1.wav');
specandcep('audiofiles/2-2.wav');
% specandcep('audiofiles/2-3.wav');

% specandcep('audiofiles/abrete-alejandro.wav');
% specandcep('audiofiles/alcohol-1.wav');
% specandcep('audiofiles/alcohol-2.wav');