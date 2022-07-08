%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Etching Density of MoSe2
%% Deattchment-limited, discrete or channel
%% Wanzhen He, Mar, 2021, Tsinghua Univerisity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
clf;
format long

%% Initial hexagon
% hexagon mode
polygon(0,0,3,3,pi/6,[0 0.45 0.74]) 
hold on
polygon(0,0,3,3,7/6*pi,[0 0.45 0.74])
% channel mode
% polygon(0,0,3,3,pi/6,[0.75 0 0.75]) 
% hold on
% polygon(0,0,3,3,7/6*pi,[0.75 0 0.75])
box on
xlabel('X')
ylabel('Y')
set(gca,'FontSize',20);
set(gca,'PlotBoxAspectRatio',[1 0.8 1]);
backColor = [0.83 0.82 0.78];
set(gca, 'color', backColor);
axis equal %axis square
axis([-4 4 -3.5 3.5])

%% Initial conditions
n = 100; % etching points
T = 0.008; % etching coverage from single point 
D0 = 3;
d = D0*sqrt(T); % etching length
nx = 10;
dx = 2*D0/nx;

%% Etching
% random seeding mode
% i = 0;
% while i < n
%     x = 2*D0*rand(1,2)-1*D0;
%     if ((abs(x(1)) + abs(x(2))/sqrt(3))  <= D0 && abs(x(2)) <= D0*sqrt(3)/2)
%         i = i+1;
%         angle = rand(1)*pi;
%         hold on
%         polygon(x(1),x(2),6,d,angle,[0.83 0.82 0.78]) 
%     end
% end
% hold off
% uniform seeding mode
for i = 1:(nx+1)
    for j = 1:(nx+1)
        x = -D0+dx*(i-1) + (2*rand-1)*dx/8; %*3
        y = -D0+dx*(j-1) + (2*rand-1)*dx/8; %*3
        angle = rand(1)*pi;
        hold on
        polygon(x,y,6,d,angle,[0.83 0.82 0.78]) 
        % flattened hexagon
        hold on
        alpha = rand*dx/2;
        x1 = x + alpha*sin(angle);
        y1 = y + alpha*cos(angle);
        polygon(x1,y1,6,d,angle,[0.83 0.82 0.78]) 
    end
end
hold off











