function testFIS(fis)
    modelInit

    autoTestFIS

    input('Press enter to test new word','s');
    recordAnother = 'y';
    while(~strcmp(recordAnother,'n'))
        [audioData,fs] = voiceRecorder(model.name,'test',false);

        [test_mfcc_matrix, test_yule_matrix, ~, ~] ...
            = getWordModel({audioData},[fs],chunks);

        [pred_class, min_dist, ~] = ...
            classifyFIS(fis,model,test_mfcc_matrix,test_yule_matrix);
        
        disp(['Predicted word: ', model.words(pred_class).name]);
        disp(['Distance: ', num2str(min_dist)]);
        recordAnother = input('test another word? (y/n)','s');

    end
end