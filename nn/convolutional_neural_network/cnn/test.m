close('all');
clear();
clc();

% Test Suite
% import('matlab.unittest.TestSuite');
% run(TestSuite.fromFolder('tests'));

%% DagNNTrainer
suite = testsuite('./tests/TestDagNNTrainer.m');
suite.run();

%% DagNNTrainer
suite = testsuite('./tests/TestDagNNViz.m');
suite.run();
