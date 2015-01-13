function [chunkmeans] = specandcep(filename)

    [audio, Fs] = audioread(filename);

    [c, ct] = melcepst(audio,Fs);

    order = 12;
    nfft = 512;
    figure();
    pyulear(audio,order,nfft,Fs);
    
%     figure();
%     plot(c(:,1));
    plot(c);
   
    
    chunks = 10;
    chunkmeans = zeros(chunks,size(c,2));
    chunkstep = floor(size(c,1)/chunks);
    for i=0:chunks-1
        chunkmeans(i+1,:) = mean(c(((chunkstep*i)+1:chunkstep*(i+1)),:));
    end

%    cut head and tail

%     for i=1:size(chunkmeans)
%         if(chunkmeans(i,1)> -2)
%             chunkmeans = chunkmeans(i:end,:);
%             break;
%         end
%     end
%     
%     for i=size(chunkmeans):1
%         if(chunkmeans(i,1)> -2)
%             chunkmeans = chunkmeans(1:i,:);
%             break;
%         end
%     end

    figure();
    plot(chunkmeans); xlabel('chunks');
    
    
%     dt = 1/Fs;
%     I0 = round(0.1/dt);
%     Iend = round(0.25/dt);
%     x = audio(I0:Iend);
%     c  = cceps(x);
%     t = 0:dt:length(x)*dt-dt;
%     figure();
%     plot(t(15:75).*1e3,c(15:75)); xlabel('msec');
%     [~,I] = max(c(15:55));
%     fprintf('Complex cepstrum F0 estimate is %3.2f Hz.\n', 1/(t(I+15)));
end