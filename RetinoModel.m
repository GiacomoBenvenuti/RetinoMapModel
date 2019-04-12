function [x y] = RetinoModel(varargin)
% param = [ A, Bx, By, Angle, U0, V0 ]
% Polar to logpolar coordinates.
% rho,theta : polar coordinates in visual space in deg
% A :Shift in the SC mapping function in deg
% Bx:Collicular magnification along x axe in mm/deg
% By:Collicular magnification along y axe in mm/rad

u = varargin{1} ;
v = varargin{2} ;
param = varargin{3} ;
if nargin >3
    disp_flag = 1;
else
    disp_flag = 0;
end

[rho theta] = cartesian_to_polar(u,v); % calculate rho and theta
[x,y] = polarVisual_to_cortical(rho,theta,param);
if   disp_flag
    disp(u,v,x,y)
end
end

function [rho theta]= cartesian_to_polar(u,v)
rho = sqrt(u.^2+v.^2);
theta = atan2(v,u).*180./pi;

end

function [x1 y1] = polarVisual_to_cortical(rho,theta,param)
A = param(1);
Bx = param(2);
By = param(3);
Angle = param(4);
U0 = param(5);
V0 = param(6);

hemi = ones(size(theta));
hemi( mod(theta,360)>90 & mod(theta,360)<270 ) = -1 ;

thetaR = theta.*pi./180;
x =  Bx*log(sqrt(rho.*rho+2.*A.*rho.*abs(cos(thetaR))+A.*A)/A);
y =  -By*atan(rho.*sin(thetaR)./(rho.*abs(cos(thetaR))+A));
x = x.*hemi;

% Translation
x = x+U0;
y = y+V0;

% Rotation
Angle = Angle*pi/180;
x1 = cos(Angle).*x - sin(Angle).*y ;
y1 = sin(Angle).*x + cos(Angle).*y ;

end



function disp(u,v,x,y)

if size(u,2) == 1
    n = size(u,1);
    d = 1;
else
    n = size(u,2);
    d =2;
end

col = parula(n);
for i = 1:n
    
    subplot(2,2,1)
    hold on
    if d ==1
        plot(u(i),v(i),'.','Color',col(i,:));
    else
        plot(u(:,i),v(:,i),'.','Color',col(i,:));
        %  plot(u(i,:),v(i,:),'.','Color',col(i,:));
    end
    
    if i == 1
        axis square; box off
        hold on; scatter(0,0,60,'+')
        xlabel('dva'); ylabel('dva')
        title('Visual Space (dva)'); ylim([-10 10]); xlim([-10 10])
    end
    
    subplot(1,2,2)
    hold on
    if d == 1
        plot(x(i),y(i),'.','Color',col(i,:));
    else
        plot(x(:,i),y(:,i),'.','Color',col(i,:));
        %plot(x(i,:),y(i,:),'.','Color',col(i,:));
    end
    
    if i ==1
        axis square; box off
        xlabel('pixels'); ylabel('pixels')
        title('Retinotopic Space (mm)')
        yl = ylim;
    end
    
    
end
line([0 0], yl,'Color','k','LineWidth',2)
set(gcf,'color','w')
end


function disp2(u,v,x,y)
n = size(u,2);

col = parula(n);
for i = 1:n
    
    subplot(223)
    plot(u(:,i),v(:,i),'.','Color',col(i,:));
    %  plot(u(i,:),v(i,:),'.','Color',col(i,:));
    
    
    if i == 1
        axis square; box off
        hold on; scatter(0,0,60,'+')
        xlabel('dva'); ylabel('dva')
        title('Visual Space (dva)'); ylim([-10 10]); xlim([-10 10])
    end
    
    subplot(224)
    hold on
    plot(x(:,i),y(:,i),'.','Color',col(i,:));
    %plot(x(i,:),y(i,:),'.','Color',col(i,:));
    
    
    if i ==1
        axis square; box off
        xlabel('pixels'); ylabel('pixels')
        title('Retinotopic Space (mm)')
        yl = ylim;
    end
    
    
    subplot(221)
    %  plot(u(:,i),v(:,i),'.','Color',col(i,:));
    plot(u(i,:),v(i,:),'.','Color',col(i,:));
    
    
    if i == 1
        axis square; box off
        hold on; scatter(0,0,60,'+')
        xlabel('dva'); ylabel('dva')
        title('Visual Space (dva)'); ylim([-10 10]); xlim([-10 10])
    end
    
    subplot(222)
    hold on
    plot(x(i,:),y(i,:),'.','Color',col(i,:));
    
    
    if i ==1
        axis square; box off
        xlabel('pixels'); ylabel('pixels')
        title('Retinotopic Space (mm)')
        yl = ylim;
    end
    
    
end
line([0 0], yl,'Color','k','LineWidth',2)
set(gcf,'color','w')
end


