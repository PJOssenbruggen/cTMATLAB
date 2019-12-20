function Plot4(Zl, Zf)
Labels();
load('cT_Setup.mat')
scale = 20;
tl  = size(Zl);
tl  = tl(1)+2;

figure
subplot(2,1,1)
plot(Zl(:,1),Zl(:,2)/scale,Zl(:,1),Zl(:,5)/scale,Zl(:,1),Zl(:,8)/scale,Zl(:,1),Zl(:,11)/scale,Zl(:,1),Zl(:,14)/scale,Zf(:,1),Zf(:,2)/scale,Zf(:,1),Zf(:,5)/scale,Zf(:,1),Zf(:,8)/scale,Zf(:,1),Zf(:,11)/scale,Zf(:,1),Zf(:,14)/scale,'LineWidth',1 )
hold on
axis([-2 tl  68/scale 85/scale])
xx = [0, 0];
yy = [68/scale, 85/scale];
plot(xx,yy,'k:')
hold on
xx = [20, 20];
yy = [68/scale, 85/scale];
plot(xx,yy,'k:')
hold on
xx = [30, 30];
yy = [68/scale, 85/scale];
plot(xx,yy,'k:')
hold on
xx = [50, 50];
yy = [68/scale, 85/scale];
plot(xx,yy,'k:')
hold on
xx = [60, 60];
yy = [68/scale, 85/scale];
plot(xx,yy,'k:')
hold on
xlabel(str1,'Interpreter','latex')
ylabel(str30,'Interpreter','latex')
text(50, 69/scale, 'Merge Zone')
text(19.5, 69/scale, 'Diverge Zone')
text(4, 69/scale, 'Cruise Zone 1')
text(34, 69/scale, 'Cruise Zone 2')
text(60.5, 69/scale, 'Cruise Zone 1')
title('Driver Assistance')
str = {'Vehicle 1 \downarrow'}
text(45, 83/scale, str)
str = {'\uparrow Vehicle 10'}
text(62, 72/scale, str)
text(34, 79.5/scale, str)

subplot(2,1,2)
xmin = -1000/scale;
xmax = 6000/scale;
plot(Zl(:,1),Zl(:,3)/scale,Zl(:,1),Zl(:,6)/scale,Zl(:,1),Zl(:,9)/scale,Zl(:,1),Zl(:,12)/scale,Zl(:,1),Zl(:,15)/scale,Zf(:,1),Zf(:,3)/scale,Zf(:,1),Zf(:,6)/scale,Zf(:,1),Zf(:,9)/scale,Zf(:,1),Zf(:,12)/scale,Zf(:,1),Zf(:,15)/scale,'LineWidth',1 )
hold on
axis([-2  tl xmin xmax])
title('Safe Headways')
xx = [0, 0];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xx = [20, 20];
yy = [xmin, xmax];
plot(xx,yy,'k:')
xx = [30, 30];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xx = [50, 50];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xx = [60, 60];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xlabel(str27,'Interpreter','latex')
ylabel(str28,'Interpreter','latex')
str = {'Safe Headways in', 'Cruise Zone 1'};
text(3, 1600/scale, str)
str = {'Safe Headways in', 'Right and Left', 'Cruise Zone 2', 'Lanes'};
text(32, 3900/scale, str)
str = {'Safe Headways in', 'Cruise Zone 1 \rightarrow'};
text(47.5, 5050/scale, str)
str = {'Vehicle 1 \downarrow'}
text(20, 2500/scale, str)
str = {'\uparrow Vehicle 10'}
text(22, 900/scale, str)

label = 'Figure2.pdf';
x00=10;
y00=10;
width=550;
height=700;
set(gcf,'position',[x00,y00,width,height])
saveas(gcf,label)  
end