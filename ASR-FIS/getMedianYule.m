function [median_yule] = getMedianYule(yule_matrix)
    numSamples = size(yule_matrix,1);
    
    median_yule = yule_matrix{1};
    current_dist = realmax;
    for idx = 1:numSamples
        yule_dist = 0;
        for idy = 1:numSamples
            yule_dist =  yule_dist + dtw(yule_matrix{idx}',yule_matrix{idy}');
        end
        
        if yule_dist < current_dist
           current_dist =  yule_dist;
           median_yule = yule_matrix{idx};
        end
    end

end