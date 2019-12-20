function Plot2(Zl, Zf)
Labels();
load('cT_Setup.mat')
tl  = size(Zl);
tl  = tl(1)+2;

figure
subplot(2,1,1)
plot(Zl(:,1),Zl(:,2),Zl(:,1),Zl(:,5),Zl(:,1),Zl(:,8),Zl(:,1),Zl(:,11),Zl(:,1),Zl(:,14),Zf(:,1),Zf(:,2),Zf(:,1),Zf(:,5),Zf(:,1),Zf(:,8),Zf(:,1),Zf(:,11),Zf(:,1),Zf(:,14),'LineWidth',1 )
hold on
axis([-2 tl  68 85])
xx = [0, 0];
yy = [68, 85];
plot(xx,yy,'k:')
hold on
xx = [20, 20];
yy = [68, 85];
plot(xx,yy,'k:')
hold on
xx = [30, 30];
yy = [68, 85];
plot(xx,yy,'k:')
hold on
xx = [50, 50];
yy = [68, 85];
plot(xx,yy,'k:')
hold on
xx = [60, 60];
yy = [68, 85];
plot(xx,yy,'k:')
hold on
xlabel(str1,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
text(50, 69, 'Merge Zone')
text(19.5, 69, 'Diverge Zone')
text(4, 69, 'Cruise Zone 1')
text(34, 69, 'Cruise Zone 2')
text(60.5, 69, 'Cruise Zone 1')
title('Driver Assistance')
str = {'Vehicle 1 \downarrow'}
text(45, 83, str)
str = {'\uparrow Vehicle 10'}
text(62, 72, str)
text(34, 79.5, str)

subplot(2,1,2)
xmin = -1000;
xmax = 6000;
plot(Zl(:,1),Zl(:,3),Zl(:,1),Zl(:,6),Zl(:,1),Zl(:,9),Zl(:,1),Zl(:,12),Zl(:,1),Zl(:,15),Zf(:,1),Zf(:,3),Zf(:,1),Zf(:,6),Zf(:,1),Zf(:,9),Zf(:,1),Zf(:,12),Zf(:,1),Zf(:,15),'LineWidth',1 )
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
hold on
xx = [50, 50];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xx = [60, 60];
yy = [xmin, xmax];
plot(xx,yy,'k:')
hold on
xlabel(str1,'Interpreter','latex')
ylabel(str17,'Interpreter','latex')
str = {'Safe Headways in', 'Cruise Zone 1'};
text(3, 1600, str)
str = {'Safe Headways in', 'Right and Left', 'Cruise Zone 2', 'Lanes'};
text(32, 3900, str)
str = {'Safe Headways in', 'Cruise Zone 1 \rightarrow'};
text(47.5, 5050, str)
str = {'Vehicle 1 \downarrow'}
text(20, 2500, str)
str = {'\uparrow Vehicle 10'}
text(22, 900, str)

label = 'Figure2.pdf';
x00=10;
y00=10;
width=550;
height=700;
set(gcf,'position',[x00,y00,width,height])
saveas(gcf,label)  
end