% Finds all rs values at a specified depth and puts them in a matrix
function residualStress = find_stresses_at_depth_one_sample(samplePath,reportedDepth)
    data = load(fullfile(samplePath, 'results', 'strung_data-combined.mat'));
    
    depth = data.strungData.allDepths;
    stress = data.strungData.allStresses;

    [~, closestIndex] = min(abs(depth - reportedDepth));
    residualStress = stress(closestIndex);
end