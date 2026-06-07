function [physicalDOE, codedDOE, response] = generateMyDOE(nbDepthLevels,lowDepth,highDepth)
    % This script creates a full factorial design of experiments.
    % Author: Kento Takahashi
    % Date of last modification: 22/04/2026

    rootDir = fullfile(mfilename("fullpath"),'..','..','data');

    depthLevels = lowDepth:(highDepth-lowDepth)/(nbDepthLevels-1):highDepth;
    
    timeLevels = [2; 20]; % min
    diamondLevels = [1; 9]; % μm
    speedLevels = [50; 150]; % rpm
    loadLevels = [10; 20]; % N
    
    nbTimeLevels = numel(timeLevels);
    nbDiamondLevels = numel(diamondLevels);
    nbSpeedLevels = numel(speedLevels);
    nbLoadLevels = numel(loadLevels);
    
    factorNames = ["Depth","Time","Abrasive particle size","Disk rotation speed","Load"];
    nbLevelsFactor = [nbDepthLevels,nbTimeLevels,nbDiamondLevels,nbSpeedLevels,nbLoadLevels];
    
    physicalDOE = fullFactorialDOE(depthLevels', timeLevels, diamondLevels, speedLevels, loadLevels, FactorNames=factorNames);
    codedDOE = fullfact(nbLevelsFactor);
    
    response = table(zeros(size(physicalDOE.Design,1),1),VariableNames={'Residual stress'});
    
    for combinationIndex = 1:size(physicalDOE.Design,1)
        responseDepth = physicalDOE.Design.Depth(combinationIndex);
        time = physicalDOE.Design.Time(combinationIndex);
        abrasiveParticleSize = physicalDOE.Design.("Abrasive particle size")(combinationIndex);
        diskRotationSpeed = physicalDOE.Design.("Disk rotation speed")(combinationIndex);
        load = physicalDOE.Design.Load(combinationIndex);
        if abrasiveParticleSize == 1 && load == 20
            response{combinationIndex,1} = NaN;
        else
            sampleDir = fullfile(rootDir,sprintf('t%d-P%d-v%d-D%d',time,load,diskRotationSpeed,abrasiveParticleSize));
            response{combinationIndex,1} = find_stresses_at_depth_one_sample(sampleDir,responseDepth);
        end
    end
end