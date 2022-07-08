%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Growth and Etching of one-dimensional graphene nanoribbons
%% level-set method, reaction-diffusion equation
%% Wanzhen He, May, 2019, Tsinghua Univerisity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;
clc;
format long

%% Input      
xi_eq = 5.0e-1;
xig   = 2.0e-4;    %graphene
D     = 10.0;    %diffusion coefficient
F     = 0.01;    %Flux
m     = 1e-5;    %evaporation rate
er    = 1.0e-4;    %ething
lx    = 10.0;    
dx    = 0.05;
dt    = 1.0e-4; 
ra0   = 8.0;   % initial interface 
T     = 10;    %The time of evolution
nt    = round(T/dt);
gra   = xi_eq*(1-0.05);
L     = 1.0e-1; 

%% Parameters
nx        = lx/dx;
xi_inf    = xi_eq*3.0;

%% Model establishment
% field parameters
xi(nx,nt) = 0;
lap_xi(nx,nt) = 0;
phi(nx,nt) = 0; % level set
ra(nt) = 0;
vd(nt) = 0;
% IC
xi(:,1) = xi_inf;
for i=1:nx
    phi(i,1) = i*dx - ra0;
end
for i=1:nx
    if(phi(i,1)<0)
        xi(i,1) = xi_inf;
    else
        xi(i,1) = xi_eq;
    end
end
xi(50,1) = 2*xi_eq;

%% Start simulation
    for s=1:nt-1
        for i=2:nx
           if(phi(i,s)<0)
               if(i==nx)
                   v=0;
                   flag=1;
                   break;
               end
               lap_xi(i,s) = (xi(i-1,s)+xi(i+1,s)-2*xi(i,s))/dx/dx;
               xi(i,s+1)=xi(i,s)+(D*lap_xi(i,s)+F-m*xi(i,s))*dt;
           elseif(phi(i,s)>=0)
               if(i==nx)
                   v=0;
                   flag=1;
                   break;
               end
               v=(xi(i-1,s)-xi(i+1,s))/dx*D/L;
               vd(s)=v;
               dphi=(phi(i,s)-phi(i-1,s))/dx;
               xi(i,s+1)=xi(i,s)+(D*lap_xi(i,s)+F)*dt;
               temp=i;   
               break;
           end
        end
        for i=(temp+0):nx-1
            lap_xi(i,s) = (xi(i-1,s)+xi(i+1,s)-2*xi(i,s))/dx/dx;
            xi(i,s+1)=xi(i,s)+(D*lap_xi(i,s)-m*xi(i,s))*dt;
        end
        xi(1,s+1)=xi(2,s+1); % BC: symmetric
        xi(nx,s+1)=xi(nx-1,s+1);
        vd(s)= dt*v*dphi;
        for i=1:nx
            phi(i,s+1)=phi(i,s)+dt*v*dphi-er;
        end
        for i=1:nx
            if(phi(1,s)>0.1)
                ra(s)=0;
                break;
            end
            if(phi(nx,s)<0.1)
                ra(s)=lx;
                break;
            end
            if(phi(i,s)>=0)
                ra(s)=(i-phi(i,s)/(phi(i,s)-phi(i-1,s)))*dx;
                break;
            end
        end
    end
    
%% Output
figure(1)
hold on
t=1:nt;
t=t*dt;
ra=ra*2;
plot(t,ra)
xlabel('Growth time (min)')
ylabel('Gap between nanoribbons (A)')
set(gca,'FontSize',20);
set(gca,'PlotBoxAspectRatio',[1 0.8 1]);
lh = legend('{\itm} = 1.0e^-^5','{\itm} = 1.0e^-^4','{\itm} = 1.0e^-^3','{\itm} = 1.0e^-^2','{\itm} = 1.0e^-^1','{\itm} = 1.0e^-^0');
set(lh,'box','off')

figure(2)
plot(vd)
figure(3)
for temp=4:nt/10000
    ii=1:250;
    ii=ii';
    axis([0,25,0,1])
    plot(ii*0.1,xi(:,temp*10000))
    hold on
    plot(ra(temp*10000-1),xi(round(ra(temp*10000-1)/dx),temp*10000),'o')
    pause(1)
end
xlabel('Coordination')
ylabel('Carbon concentration')