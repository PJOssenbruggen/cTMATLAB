function Plot3(XY)
Labels();
load('cT_Setup.mat')
scale = 20;
figure
plot(XY(:,4)/scale,XY(:,5)/scale,'r-','LineWidth',1)
hold on
plot(XY(:,6)/scale,XY(:,7)/scale,'b-','LineWidth',1)
axis([-100  1900 -700 700]/scale)
hold on
plot(500/scale,500/scale,'r-o');
hold on
plot(570/scale,500/scale,'b-o')
hold on
plot(1280/scale,492/scale,'r-o');
hold on
plot(1280/scale,508/scale,'b-o')
hold on
xx = [-100/scale 1900/scale];
yy = [0 0];
plot(xx,yy,'k:')
hold on
xx = [0,0];
yy = [-800/scale 800/scale];
plot(xx,yy,'k:')
hold on
xx = [500/scale,500/scale];
yy = [-800/scale 800/scale];
plot(xx,yy,'k:')
hold on
xx = [1277/scale, 1277/scale];
yy = [-800/scale 800/scale];
plot(xx,yy,'k:')
str = {'Car-following', 'Criuse Zone 1'};
text(70/scale, 70/scale, str)
text(750/scale, 600/scale, 'Merge Zone')
str = {'Two-lane', 'Criuse Zone 2'};
text(1400/scale, 70/scale, str)
text(1277/scale, 550/scale, '\leftarrow Vehicles Side-by-side')
text(500/scale, 450/scale, '\leftarrow t = 0 s')
text(500/scale, -450/scale, '\leftarrow t ~ 20 s')
text(1050/scale, -450/scale, 't ~ 30 s \rightarrow')
text(1050/scale, 450/scale, 't ~ 50 s \rightarrow')
text(707/scale, -600/scale, 'Diverge Zone')
legend('Vehicle 1','Vehicle 2','Location','southeast')
xlabel(str28,'Interpreter','latex')
ylabel(str29,'Interpreter','latex')
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