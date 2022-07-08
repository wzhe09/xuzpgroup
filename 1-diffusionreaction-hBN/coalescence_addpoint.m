%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% coalescence processes of adlayer hBN islands
%% reaction-diffusion equation
%% Wanzhen He, Feb, 2021, Tsinghua Univerisity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
format long;

%% geometry
R = 50; % size of box
num = 500; % number of initial points
addn = 5;
is = 0.1; % initial size of graphene island
isd = 1; % initial size of DLA nucleation
D = 6; % diffusion constant
T = 1;
dt = 0.001;

kbt = 8.617333262e-5*1000; % eV, T = 1000 K
cA  = 0.0862; % coefficient before size, so initial chance: 0.3679, 10 size chance: 0.9048
nt = T/dt;
dl = sqrt(2*D*dt);

%% IC
% boundary
theta = 0:0.1:360;
circle1 = R.*cos(theta);
circle2 = R.*sin(theta);
Fig = figure(1);
gifname = 'evolution.gif';
plot(circle1,circle2,'-k','LineWidth',1.0)
axis([-R R -R R])
daspect([1 1 1]); % axis equal

% add points
r = R.*sqrt(rand(1,num));
seta = 2*pi.*rand(1,num);
x = r.*cos(seta);
y = r.*sin(seta);
for i = 1:num
    hold on
    plottriangle(x(i),y(i),is)
end
xlabel('{\it x}')
ylabel('{\it y}')
set(gca,'FontSize',20);
drawnow
frame = getframe(Fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,gifname,'gif','WriteMode','overwrite', 'Loopcount',inf);

% ceate nodes and list
my_list = list();
for i = 1:num
    n(i) = node(is,x(i),y(i),0); % initial dla = 0
    my_list.insertbeforehead(n(i));
end
% DLA nucleation
n(num+1)=node(isd,0,0,1);
my_list.insertbeforehead(n(num+1));
% my_list.backdisplay();


%% evolution
for i = 1:nt
    ptemp1 = my_list.head;
    % add point
    r = R.*sqrt(rand(1,addn));
    seta = 2*pi.*rand(1,addn);
    x = r.*cos(seta);
    y = r.*sin(seta);
    for ini = 1:addn
        index = num+ini+(i-1)*addn;
        n(index) = node(is,x(ini),y(ini),0);
        my_list.insertbeforehead(n(index));
    end
%     my_list.size
    while ( ~isempty(ptemp1) && strcmp(class(ptemp1),'node') )
        ptemp2 = ptemp1.Next;
        while ( ~isempty(ptemp2) && strcmp(class(ptemp2),'node') )
            point1 = [ptemp1.Cx,ptemp1.Cy];
            point2 = [ptemp2.Cx,ptemp2.Cy];
            dl1 = sqrt(2*D*exp(-ptemp1.Num/is/5)*dt);
            dl2 = sqrt(2*D*exp(-ptemp2.Num/is/5)*dt);
            if( norm(point1-point2) < (dl1+dl2)*i ) % (dl1+dl2)*i
                % DLA attachment
                if (ptemp1.DLA == 1 || ptemp2.DLA == 1)
                    ptemp1.DLA = 1;
                    ptemp2.DLA = 1;
                    dl1 = 0;
                    dl2 = 0;
                else
                    % chance to coalescence
                    if ( ptemp2.Num > ptemp1.Num )
                        probability = exp(-cA*ptemp2.Num/kbt);
                        if ( rand(1) < probability )
                            % node1 + node2 = node1
                            ptemp1.Num = ptemp2.Num + ptemp1.Num;
                            ptemp1.Cx  = ptemp1.Cx+(ptemp2.Cx-ptemp1.Cx)*dl1/(dl1+dl2);
                            ptemp1.Cy  = ptemp1.Cy+(ptemp2.Cy-ptemp1.Cy)*dl1/(dl1+dl2);
                            % delete node ptemp2
                            if ~isempty(ptemp2.Prev) 
                                ptemp2.Prev.Next=ptemp2.Next;
                                ptemp2.Next.Prev=ptemp2.Prev;
                                my_list.size=my_list.size-1;
                            else
                                my_list.head=ptemp2.Next;
                                my_list.head.Prev=[];
                                my_list.size=my_list.size-1;
                            end
                            ptemp2=ptemp2.Next;
                        else
                            ptemp2=ptemp2.Next;
                            ptemp1.Cx=ptemp1.Cx+dl1*cos(2*pi.*rand(1));
                            ptemp1.Cy=ptemp1.Cy+dl1*sin(2*pi.*rand(1));
                        end
                    else
                        probability = exp(-cA*ptemp1.Num/kbt);
                        if ( rand(1) < probability )
                            % node1 + node2 = node1
                            ptemp1.Num = ptemp2.Num + ptemp1.Num; % may add diffusion
                            ptemp1.Cx  = ptemp1.Cx+(ptemp2.Cx-ptemp1.Cx)*dl1/(dl1+dl2);
                            ptemp1.Cy  = ptemp1.Cy+(ptemp2.Cy-ptemp1.Cy)*dl1/(dl1+dl2);
                            % delete node ptemp2
                            if ~isempty(ptemp2.Prev) 
                                ptemp2.Prev.Next=ptemp2.Next;
                                ptemp2.Next.Prev=ptemp2.Prev;
                                my_list.size=my_list.size-1;
                            else
                                my_list.head=ptemp2.Next;
                                my_list.head.Prev=[];
                                my_list.size=my_list.size-1;
                            end
                            ptemp2=ptemp2.Next;
                        else
                            ptemp2=ptemp2.Next;
                            ptemp1.Cx=ptemp1.Cx+dl1*cos(2*pi.*rand(1));
                            ptemp1.Cy=ptemp1.Cy+dl1*sin(2*pi.*rand(1));
                        end
                    end
                end
            else
                ptemp2=ptemp2.Next;
                if (ptemp1.DLA == 0)
                    ptemp1.Cx=ptemp1.Cx+dl1*cos(2*pi.*rand(1));
                    ptemp1.Cy=ptemp1.Cy+dl1*sin(2*pi.*rand(1));
                end
            end
        end
        ptemp1 = ptemp1.Next;
    end
    % save data and plot movie
    if (mod(i,10) == 0)
        filename = strcat('mylist',num2str(i),'.dat');
        save(filename,'my_list')
        hold off
        plot(circle1,circle2,'-k','LineWidth',1.0)
        axis([-R R -R R])
        daspect([1 1 1]);
        ptemp=my_list.head;
        test = 0;
        while (test < my_list.size)
            hold on
            plottriangle(ptemp.Cx,ptemp.Cy,ptemp.Num)
            ptemp=ptemp.Next;
            test = test +1;
        end
        xlabel('{\it x}')
        ylabel('{\it y}')
        set(gca,'FontSize',20);
        filename = strcat('time-',num2str(i));
        saveas(gcf,filename,'eps')
        drawnow
        frame = getframe(Fig);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        imwrite(imind,cm,gifname,'gif','WriteMode','append','DelayTime',0.1);
    end
end