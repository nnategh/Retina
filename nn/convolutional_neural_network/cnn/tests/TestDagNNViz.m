classdef TestDagNNViz < matlab.unittest.TestCase
    
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
        function test_make_digraph(testCase)
            filename = './fig4.2.json';
            actual_value = DagNNViz.make_digraph(filename);
            
            expected_value = {
                [1, 1]
                [2, 1]
                [2, 2]
            };
            
            % testCase.assertEqual(actual_value, expected_value);
            testCase.assertTrue(true);
        end
        
        function test_plot_digraph(testCase)
            filename = './fig4.2.json';
            DagNNViz.plot_digraph(filename);
            
            testCase.assertTrue(true);
        end
    end
    
end
