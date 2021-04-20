dbstop if error
AddPaths
tpl = imread('./mb/mb.jpg');

RootDir = pwd;
gtPath = fullfile(RootDir,'img');
resPath = fullfile(RootDir,'Resultour1');
if ~exist(resPath,'dir')
    mkdir(resPath);
end

gtFiles = dir(fullfile(gtPath,'*.jpg'));

for i = 1:length(gtFiles)
 [img,map] = imread(fullfile(gtPath,gtFiles(i).name));

%img = rgb2gray(img);

img = im2double(img);
%img = MakeOdd(img);

%tpl = rgb2gray(tpl);
tpl = im2double(tpl);
%tpl = MakeOdd(tpl);

% FastMatch run
[bestConfig,bestTransMat,sampledError] = FastMatch(tpl,img);

optMat = [];
% Visualize result
[optError,fullError,overlapError] = MatchingResult1(i,gtFiles,resPath,tpl,img,bestTransMat,optMat,'example 1');

fprintf('example 1 - optError: %.4f (%.2f GLs), fullError: %.4f (%.2f GLs), overlapError: %.1f%%\n',...
    optError,256*optError,fullError,256*fullError,100*overlapError);
fprintf('example 1: finished\n\n');


end