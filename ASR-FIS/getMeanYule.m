function [mean_yule] = getMeanYule(yule_matrix)
    dim = ndims(yule_matrix{1});
    M = cat(dim+1,yule_matrix{:});
    mean_yule = mean(M,dim+1);
end