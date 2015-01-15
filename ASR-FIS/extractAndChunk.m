function [mSeq] = extractAndChunk(AUDIO, FS, CHUNKS)
    % Cleaning non speech
    [y,z]  = vadsohn(AUDIO,FS);    
    seq = AUDIO(logical(y));
    
    % Computing MFCC
    [mSeq, ct] = melcepst(seq,FS);
    

    % Chunking
    cSeq = zeros(CHUNKS,size(mSeq,2));
    chunkstep = floor(size(mSeq,1)/CHUNKS);
    for i=0:CHUNKS-1
        cSeq(i+1,:) = mean(mSeq(((chunkstep*i)+1:chunkstep*(i+1)),:));
    end
    mSeq = cSeq;

end