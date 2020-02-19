% Side-by-side U and X
clc
close all
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%% Side by Side Merge %%%%%%%%%%%%%%%%%%%%%%%%%%%
nr       = Step14(2, 0);
tstart   = 29;
load('cT_Setup.mat')
tpre     = 26:0.1:tstart;
tpre     = tpre';
tpost    = 42:0.1:46;
tpost    = tpost';
dim1     = size(tpre);
dim2     = size(tpost);
u0init   = u0*ones(dim1);
u0post   = u0*ones(dim2);
xled     = zeros(dim1);
xflw     = zeros(dim1);
xpost    = zeros(dim2);
for i = 1:dim1
    xled(i)  = u0 * (tpre(i) - 26);
end   
Zpre     = [tpre, u0init, xled];
% Leader Stage 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tstart   = tstart;
Tend     = 42;
Ustart   = u0;
Uend     = u0;
Xstart   = 0;
Xend     = (42 - tstart)*u0 + 0.5 * u0;  % length of merge zone 
ab       = Step64(Tstart,Tend,Ustart,Uend,Xstart,Xend)
a        = ab(1);
b        = ab(2);
Xstart   = xled(dim1(1));
Z0       = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Xstart);
Z1       = [Zpre; Z0];
dimp     = size(Z1);
for i = 1:dim2
    xpost(i)  = Z1(dimp(1),3) + u0 * (tpost(i) - 42);
end
Zpost     = [tpost, u0post, xpost];
Z1        = [Z1; Zpost];
%plot(Z1(:,1),Z1(:,2))
%plot(Z1(:,1),Z1(:,3))
% Follower Prestage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tstart   = 30;     % t2 = tstart
load('cT_Setup.mat')
tpre     = 26:0.1:tstart;
tpre     = tpre';
dim1     = size(tpre);
for i = 1:dim1
    xfol(i)  = u0 * (tpre(i) - 26);
end   
u0init   = u0*ones(dim1);
Zpre     = [tpre, u0init, xfol'];
% Follower Stage 2
Tstart   = tstart;
Tend     = 42;
Ustart   = u0;
Uend     = u0;
Xstart   = 0;
Xend     = 11.5*u0;  % length of merge zone 
ab       = Step64(Tstart,Tend,Ustart,Uend,Xstart,Xend)
a        = ab(1);
b        = ab(2);
Xstart   = xfol(dim1(1));
Z2       = Speed_Location(a,b,Ts,Tstart,Tend,Ustart,Xstart);
Z2       = [Zpre; Z2];
dimp     = size(Z2);
for i = 1:dim2
    xpost(i)  = Z2(dimp(1),3) + u0 * (tpost(i) - 42);
end
Zpost     = [tpost, u0post, xpost];
Z2        = [Z2; Zpost];
Z         = [Z1, Z2];
Z(:,[1,2,5,3,6]);
%plot(Z2(:,1),Z2(:,2))
%plot(Z2(:,1),Z2(:,3))
max(0.3084*Z(:,2))
min(0.3084*Z(:,5))
figure
subplot(2,2,2)
plot(Z(:,1),0.3084*Z(:,2))
hold on
plot(Z(:,1),0.3084*Z(:,5))
hold on
axis([26 46 20 29]);
hold on
x = [30;30];
y = [20;30];
plot(x,y,':k')
hold on
x = [42;42];
y = [20;30];
plot(x,y,':k')
hold on
legend(str37,str38,'Interpreter','latex','Location','northeast')
xlabel(str1,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
title('Side-by-Side')

subplot(2,2,4)
plot(Z(:,1),0.3084*Z(:,3))
hold on
plot(Z(:,1),0.3084*Z(:,6))
axis([26 46 -50 550]);
hold on
x = [30;30];
y = [-60;600];
plot(x,y,':k')
hold on
x = [42;42];
y = [-60;600];
plot(x,y,':k')
hold on
text(30,520,str27,'Interpreter','latex');
hold on
text(42,520,str28,'Interpreter','latex');
hold on
x = [26;46];
y = [0;0];
plot(x,y,'-k')
hold on
y = [Z(161,3)*0.3084;Z(161,3)*0.3084;];
plot(x,y,':k')
y = [Z(41,3)*0.3084;Z(41,3)*0.3084;];
plot(x,y,':k')
text(27,110,str40,'Interpreter','latex');
hold on;
text(27,410,str41,'Interpreter','latex');
hold on;
xlabel(str1,'Interpreter','latex')
ylabel(str2,'Interpreter','latex')
title('Safe Merge')

%%%%%%%%%%%%%%%%%%%%%%%%%%% Zipper Merge %%%%%%%%%%%%%%%%%%%%%%%%%%%
t     = 26:0.1:46;
t     = t';
dim   = length(t);
U0    = u0*ones(dim,1);
xled  = zeros(dim,1);
xfol  = zeros(dim,1);

for i = 1:dim
    xled(i) = u0*(t(i) - 26);
    xfol(i) = -s + u0*(t(i) - 26);
end
Z    = [t, U0, xled, t, U0, xfol];


subplot(2,2,1)
plot(Z(:,1),0.3084*Z(:,2))
hold on
plot(Z(:,1),0.3084*Z(:,5))
hold on
axis([26 46 20 29]);
hold on
x = [30;30];
y = [20;30];
plot(x,y,':k')
hold on
x = [42;42];
y = [20;30];
plot(x,y,':k')
hold on
legend(str37,str38,'Interpreter','latex','Location','northeast')
xlabel(str1,'Interpreter','latex')
ylabel(str18,'Interpreter','latex')
title('Zipper')

subplot(2,2,3)
plot(Z(:,1),0.3084*Z(:,3))
hold on
plot(Z(:,1),0.3084*Z(:,6))
axis([26 46 -50 550]);
hold on
x = [30;30];
y = [-60;600];
plot(x,y,':k')
hold on
x = [42;42];
y = [-60;600];
plot(x,y,':k')
hold on
y = [Z(161,3)*0.3084;Z(161,3)*0.3084];
plot(x,y,':k')
x = [26;46];
y = [Z(41,3)*0.3084;Z(41,3)*0.3084;];
plot(x,y,':k')
hold on
y = [Z(161,3)*0.3084;Z(161,3)*0.3084];
plot(x,y,':k')
hold on
text(30,520,str27,'Interpreter','latex');
hold on
text(42,520,str28,'Interpreter','latex');
hold on
y = [0;0];
plot(x,y,'-k')
hold on
text(27,110,str40,'Interpreter','latex');
hold on;
text(27,400,str41,'Interpreter','latex');
hold on;
xlabel(str1,'Interpreter','latex')
ylabel(str2,'Interpreter','latex')
title('Safe Merge')

x0=10;
y0=10;
width=550;
height=700;
set(gcf,'position',[x0,y0,width,height])
label = 'Figure11.pdf';
saveas(gcf,label) 
