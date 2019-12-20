function Plot1(XY)
Labels();
load('cT_Setup.mat')

figure
plot(XY(:,4),XY(:,5),'r-','LineWidth',1)
hold on
plot(XY(:,6),XY(:,7),'b-','LineWidth',1)
axis([-100  1900 -700 700])
hold on
plot(500,500,'r-o');
hold on
plot(570,500,'b-o')
hold on
plot(1280,492,'r-o');
hold on
plot(1280,508,'b-o')
hold on
xx = [-100 1900];
yy = [0 0];
plot(xx,yy,'k:')
hold on
xx = [0,0];
yy = [-800 800];
plot(xx,yy,'k:')
hold on
xx = [500,500];
yy = [-800 800];
plot(xx,yy,'k:')
hold on
xx = [1277, 1277];
yy = [-800 800];
plot(xx,yy,'k:')
str = {'Car-following', 'Criuse Zone 1'};
text(70, 70, str)
text(750, 650, 'Merge Zone')
str = {'Two-lane', 'Criuse Zone 2'};
text(1400, 70, str)
text(1277, 550, '\leftarrow Vehicles Side-by-side')
text(500, 450, '\leftarrow t = 0 s')
text(500, -450, '\leftarrow t ~ 20 s')
text(1050, -450, 't ~ 30 s \rightarrow')
text(1050, 450, 't ~ 50 s \rightarrow')
text(707, -650, 'Diverge Zone')
legend('Vehicle 1','Vehicle 2','Location','southeast')
xlabel(str17,'Interpreter','latex')
ylabel(str27,'Interpreter','latex')
title('Track Geometry')
axis equal

label = 'Figure1.pdf';
x00=10;
y00=10;
width=550;
height=700;
set(gcf,'position',[x00,y00,width,height])
saveas(gcf,label) 
load('cT_Setup.mat')

end