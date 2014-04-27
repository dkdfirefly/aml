function ksvddenoisedemo
%KSVDDENOISEDEMO K-SVD denoising demonstration.
%  KSVDDENISEDEMO reads an image, adds random white noise and denoises it
%  using K-SVD denoising. The input and output PSNR are compared, and the
%  trained dictionary is displayed.
%
%  To run the demo, type KSVDDENISEDEMO from the Matlab prompt.
%
%  See also KSVDDEMO.


%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs
%
%  August 2009


%disp(' ');
%disp('  **********  K-SVD Denoising Demo  **********');
%disp(' ');
%disp('  This demo reads an image, adds random Gaussian noise, and denoises the image');
%disp('  using K-SVD denoising. The function displays the original, noisy, and denoised');
%disp('  images, and shows the resulting trained dictionary.');
%disp(' ');

addpath('./l1Solvers')
%% prompt user for image %%

pathstr = fileparts(which('ksvddenoisedemo'));
dirname = fullfile(pathstr, 'images', '*.png');
imglist = dir(dirname);

imnum = 0;

%% set parameters %%

params.maxval = 255;
params.trainnum = 8192;%40000
params.iternum = 8;
params.memusage = 'high';
params.blocksize = 8;
params.method = 'OMP';%CHANGE-HERE AND IN KSVD
params.dirName = strcat('results', params.method, '/');
params.resultsFile = strcat(params.dirName, 'results-', params.method, '.csv');

mkdir(params.dirName)
f = fopen(params.resultsFile, 'w');
fprintf(f, 'ImageNum, Sigma, DictSize, Iter, PSNR(db), Time, Method\n');
fclose(f);



for imnum =1:2
    imgname = fullfile(pathstr, 'images', imglist(imnum).name);
    im = imread(imgname);
    im = double(im);

    %% set parameters %%

    params.imnum = imnum;
    params.im = im;

    figure('visible','off'); imshow(im/params.maxval);
    title('Original image');
    saveas(gcf(), strcat(params.dirName,'Image-',num2str(imnum),'-Original','.png'), 'png');

    for sigma = [10, 20, 50]
        % generate noisy image %
        disp(' ');
        disp('Generating noisy image...');

        n = randn(size(im)) * sigma;
        imnoise = im + n;

        %% set parameters %%

        params.x = imnoise;
        params.sigma = sigma;
        
        figure('visible', 'off'); imshow(imnoise/params.maxval); 
        NoisyPSNR = 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:)));
        title(sprintf('Noisy image, PSNR = %.2fdB', NoisyPSNR ));
        saveas(gcf(), strcat(params.dirName,'Image-',num2str(imnum),'-Sigma-',num2str(sigma),'-NoisyImage','.png'), 'png');

        % denoise!
        
        params.NoisyPSNR = NoisyPSNR;
        
        for dictSize =[64 128 256]
            
            %% set parameters %%
            params.dictsize = dictSize;
            
            disp('Performing K-SVD denoising...');
            [imout, dict] = ksvddenoise(params);

            close all;
        end
    end
end
exit;
