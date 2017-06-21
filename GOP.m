
init_gop;

gop_mex( 'setDetector', 'MultiScaleStructuredForest("GoPCode/lib/gop_1.3/data/sf.dat")' );

% Setup the proposal pipeline (baseline)
p = Proposal('max_iou', 0.8,...
             'unary', 130, 5, 'seedUnary()', 'backgroundUnary({0,15})',...
             'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ...
             );
% Setup the proposal pipeline (learned)
% p = Proposal('max_iou', 0.8,...
%              'seed', '../data/seed_final.dat',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_0_fg.dat")', 'binaryLearnedUnary("../data/masks_final_0_bg.dat"',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_1_fg.dat")', 'binaryLearnedUnary("../data/masks_final_1_bg.dat"',...
%              'unary', 140, 4, 'binaryLearnedUnary("../data/masks_final_2_fg.dat")', 'binaryLearnedUnary("../data/masks_final_2_bg.dat"',...
%              'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ...
%              );

% Load in image


 %   I = imread(images{it});
    
    % Create an over-segmentation
    tic();
    I = option.im;
    os = OverSegmentation( option.im );
    t1 = toc();

    % Generate proposals
    tic();
    props = p.propose( os );
    t2 = toc();
    
    fprintf( ' %d proposals generated. OverSeg %0.3fs, Proposals %0.3fs. Image size %d x %d.\n', size(props,1), t1, t2, size(I,1), size(I,2) );
    
    % If you just want boxes
    boxes = os.maskToBox( props );
    figure(3)
    for i=1:30
        mask = props(i,:);
        m = uint8(mask( os.s()+1 ));
        % Visualize the mask
        subplot(5,6,i)
        II = 1*I;
        II(:,:,1) = II(:,:,1) .* (1-m) + m*255;
        II(:,:,2) = II(:,:,2) .* (1-m);
        II(:,:,3) = II(:,:,3) .* (1-m);
        imagesc( II );
        rectangle( 'Position', [boxes(i,1),boxes(i,2),boxes(i,3)-boxes(i,1)+1,boxes(i,4)-boxes(i,2)+1], 'LineWidth',2, 'EdgeColor',[0,1,0] );
    end

