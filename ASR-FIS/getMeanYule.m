function [mean_yule] = getMeanYule(yule_matrix)
    mean_yule = mean(yule_matrix, 2);
end