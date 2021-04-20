% Demo script
% Uncomment each case to see the results

%I = (imread('imgs/Bishapur_zan.jpg'));
%I = (imread('imgs/rm.jpg'));

RootDir = pwd;
gtPath = fullfile(RootDir,'img');
resPath = fullfile(RootDir,'Resultour');
if ~exist(resPath,'dir')
    mkdir(resPath);
end

gtFiles = dir(fullfile(gtPath,'*.jpg'));

for i = 1:length(gtFiles)
 [I0,map] = imread(fullfile(gtPath,gtFiles(i).name));
%I = (imread('imgs/330.jpg'));
I = rgb2gray(I0);


%I=(imread('imgs/vessel.bmp'));
S = tsmooth(I,0.015,3);
 figure, imshow(S);
%imwrite(S,'imgs/qwl330.jpg')
%resName = sprintf([gtFiles(i).name(1:end-4) '_%.4f_'   '.jpg']);
resName = sprintf('%d.jpg',i);
 imwrite(S,fullfile(resPath,resName));
end
% I = (imread('imgs/graffiti.jpg'));
% S = tsmooth(I,0.015,3);
% figure, imshow(I), figure, imshow(S);

% I = (imread('imgs/crossstitch.jpg'));
% S = tsmooth(I,0.015,3);
% figure, imshow(I), figure, imshow(S);


% I = (imread('imgs/mosaicfloor.jpg'));
% S = tsmooth(I, 0.01, 3, 0.02, 5);
% figure, imshow(I), figure, imshow(S);






