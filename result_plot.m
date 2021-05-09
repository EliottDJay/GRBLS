function result_plot(result,file_name)

fig1=figure;
set(fig1,'visible','off');
set(0, 'currentFigure', fig1);

plot(result(:,1),result(:,2),'-vr');
hold on;
plot(result(:,1),result(:,3),'-^b');
legend('training_sample', 'testing_sample' );
xlabel('\itenhancement nodes','FontSize',12);ylabel('\itrate','FontSize',12);
frame = getframe(fig1);
im = frame2im(frame);
pic_name=fullfile(file_name,['rate_comparion','.png']);
imwrite(im,pic_name);
close all;

fig2=figure;
set(fig2,'visible','off');
set(0, 'currentFigure', fig2);

plot(result(:,1),result(:,2),'-vr');
hold on;
plot(result(:,1),result(:,4),'-^b');
legend('not_contaminated', 'contaminated' );
xlabel('\itenhancement nodes','FontSize',12);ylabel('\itrate','FontSize',12);
frame = getframe(fig2);
im = frame2im(frame);
pic_name=fullfile(file_name,['train_rate_comparion','.png']);
imwrite(im,pic_name);
close all

fig3=figure;
set(fig3,'visible','off');
set(0, 'currentFigure', fig3);

plot(result(:,1),result(:,3),'-vr');
hold on;
plot(result(:,1),result(:,4),'-^b');
legend('testing_sample', 'contaminated_sample' );
xlabel('\itenhancement nodes','FontSize',12);ylabel('\itrate','FontSize',12);
frame = getframe(fig3);
im = frame2im(frame);
pic_name=fullfile(file_name,['con_rate_comparion','.png']);
imwrite(im,pic_name);
close all;

end