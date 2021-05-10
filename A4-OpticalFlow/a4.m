% Andy Lee
% Assignment 4
% 500163559

% Note: sometimes running a4runimage get stuck in busy. If this happens,
% ctrl-c the program and rerun it.

%% Q1-Q3 Corridor
clear;
impath1 = "Sequences\corridor\bt_0.png";
impath2 = "Sequences\corridor\bt_1.png";
% winLen = 11;
% eigThres = 0.001;
% reduceFactor = 4;
winLen = 5;
eigThres = 0.00001;
reduceFactor = 12;
a4runimage;
%% Q2. Explain what effects this parameter has on the result.
fprintf("If window size is too small, the colours are very patchy.\n");
fprintf("If window size is too large, the colours are very blocky\n" ...
    + "with many regions overlapping; making\n");
fprintf("it difficult to distinguish optical flow.\n");
fprintf("Window size also affects whether corners or edges are detected.\n");

%% Q1-Q3 Sphere
impath1 = "Sequences\sphere\sphere_0.png";
impath2 = "Sequences\sphere\sphere_1.png";
winLen = 11;
eigThres = 0.0001;
reduceFactor = 1;
a4runimage;

%% Q1-Q3 Synth
impath1 = "Sequences\synth\synth_0.png";
impath2 = "Sequences\synth\synth_1.png";
winLen = 5;
eigThres = 0.0001;
reduceFactor = 2;
a4runimage;

%% Q4
% Close any opened Figure window to remove subplot.

clear;
klt;