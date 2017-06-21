function [ output_args ] = figure2file( im,out ,box,cl)
fig = gcf;
figure();
imagesc(im);axis image;
if nargin>2
      rectangle( 'Position', [box(1),box(2),box(3)-box(1)+1,box(4)-box(2)+1], 'LineWidth',3, 'EdgeColor',cl);
end


h=gca;
            set(gca, 'XTick', [],'YTick',[]);
            F=getframe(h);
            im=F.cdata;
            imshow(im); truesize;
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            fig_pos = fig.PaperPosition;
            fig.PaperSize = [fig_pos(3) fig_pos(4)];
            print(fig,out,'-dpng');
            figure(fig);
end

