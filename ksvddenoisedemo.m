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

%disp('  Available test images:');
%disp(' ');
%for k = 1:length(imglist)
%  printf('  %d. %s', k, imglist(k).name);
%end
%disp(' ');

imnum = 0;
%while (~isnumeric(imnum) || ~iswhole(imnum) || imnum<1 || imnum>length(imglist))
%  imnum = input(sprintf('  Image to denoise (%d-%d): ', 1, length(imglist)), 's');
%  imnum = sscanf(imnum, '%d');
%end

for imnum =1:2
    imgname = fullfile(pathstr, 'images', imglist(imnum).name);



    %% generate noisy image %%

    sigma = 20;
    for sigma = [20, 80]
        disp(' ');
        disp('Generating noisy image...');

        im = imread(imgname);
        im = double(im);

        n = randn(size(im)) * sigma;
        imnoise = im + n;



        %% set parameters %%

        params.x = imnoise;
        params.blocksize = 8;
        params.dictsize = 256;
        params.sigma = sigma;
        params.maxval = 255;
        params.trainnum = 2000;%40000
        params.iternum = 2;
        params.memusage = 'high';



        % denoise!
        disp('Performing K-SVD denoising...');
        [imout, dict] = ksvddenoise(params);



        % show results %

        dictimg = showdict(dict,[1 1]*params.blocksize,round(sqrt(params.dictsize)),round(sqrt(params.dictsize)),'lines','highcontrast');
        figure('visible','off'); imshow(imresize(dictimg,2,'nearest'));
        title('Trained dictionary');
        saveas(gcf(), strcat('trainedDict-','Image-',num2str(imnum),'-Sigma-',num2str(sigma),'.png'), 'png');

        figure('visible','off'); imshow(im/params.maxval);
        title('Original image');
        saveas(gcf(), strcat('Original-','Image-',num2str(imnum),'-Sigma-',num2str(sigma),'.png'), 'png');

        figure('visible', 'off'); imshow(imnoise/params.maxval); 
        title(sprintf('Noisy image, PSNR = %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imnoise(:))) ));
        saveas(gcf(), strcat('NoisyImage-','Image-',num2str(imnum),'-Sigma-',num2str(sigma),'.png'), 'png');

        figure('visible', 'off'); imshow(imout/params.maxval);
        title(sprintf('Denoised image, PSNR: %.2fdB', 20*log10(params.maxval * sqrt(numel(im)) / norm(im(:)-imout(:))) ));
        saveas(gcf(), strcat('DenoisedImage-','Image-',num2str(imnum),'-Sigma-',num2str(sigma),'.png'), 'png');
    end
end
exit;
