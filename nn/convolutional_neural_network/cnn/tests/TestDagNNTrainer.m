classdef TestDagNNTrainer < matlab.unittest.TestCase
    
    properties
        originalPath
    end
    
    methods (TestMethodSetup)
        function addToPath(testCase)
            % Add `parent` of current directory to the `path` of matlab
            
            % save original path
            testCase.originalPath = path;
            
            % add `..` to the path
            [parentFolder, ~, ~] = fileparts(pwd);
            addpath(parentFolder);
        end
    end
    
    methods (TestMethodTeardown)
        function restorePath(testCase)
            % Restore original path
            path(testCase.originalPath);
        end
    end
    
    methods (Test)
    end
    
end
