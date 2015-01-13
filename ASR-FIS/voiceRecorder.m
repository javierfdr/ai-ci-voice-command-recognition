function [audioData,fs] = voiceRecorder(MODELNAME, WORDNAME, SAVE)
    audiodir = 'audio_files/';
    mkdir(audiodir);
    mkdir(audiodir,MODELNAME);
    fs = 8000;
    Nbit = 16;
    Nchan = 1;
    
    recObj = audiorecorder(fs, Nbit, Nchan);

    % Define callbacks to show when
    % recording starts and completes.
    recObj.StartFcn = 'disp(''Start speaking.'')';
    recObj.StopFcn = 'disp(''End of recording.'')';

    record(recObj);
    %To listen to the recording, call the play method:
    input('press enter to stop','s');
    stop(recObj);
    audioData = getaudiodata(recObj);
    if(SAVE)
        audiowrite([audiodir,MODELNAME,'/',WORDNAME,'.wav'],audioData,fs,'BitsPerSample',Nbit);
    end
    
end