function [x y] = RetinoModel(varargin)
% [x y] = RetinoModel(u,v,param)
% param = [ A, Bx, By, Angle, U0, V0 ]
% 
% This function converts visual coordinates (u,v) to retinotopic 
% coordinates (x,y) based on a model with parameters param
% (All coordinates are cartesian)
%
% u : 3D matrix of X visual coordinates in cortical space (x,y,X)
% v : 3D matrix of Y visual coordinates in cortical space (x,y,Y)
% A : Shift in the mapping function in deg
% Bx: magnification along x axes
% By: magnification along y axes
%
% x : X cortical position
% y : Y cortical position
%
%-------------------------------------------
% by Giacomo Benvenuti & Wahiba Taouali
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

u = varargin{1} ;
v = varargin{2} ;
param = varargin{3} ;

[rho theta] = cartesian_to_polar(u,v); 
[x,y] = polarVisual_to_cortical(rho,theta,param);

% Scaling - Find a better way?
x = x/param(2);
y = y/param(2);

% Display
if  nargin >3
    disp(u,v,x,y)
end
end

function [rho theta]= cartesian_to_polar(u,v)
rho = sqrt(u.^2+v.^2);
theta = atan2(v,u).*180./pi;

end

function [x1 y1] = polarVisual_to_cortical(rho,theta,param)
A = param(1);
Bx = param(3);
By = param(4);
Angle = param(5);
U0 = param(6);
V0 = param(7);

hemi = ones(size(theta));
hemi( mod(theta,360)>90 & mod(theta,360)<270 ) = -1 ;

thetaR = theta.*pi./180;
x =  Bx*log(sqrt(rho.*rho+2.*A.*rho.*abs(cos(thetaR))+A.*A)/A);

y =  -By*atan(rho.*sin(thetaR)./(rho.*abs(cos(thetaR))+A));
%y =  By*atan(rho.*sin(thetaR)./(rho.*abs(cos(thetaR))+A)); % Compansate for data inversion


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
n = size(u,2);
col = jet(n);
for i = 1:n
    subplot(221)
    plot(u(i,:),v(i,:),'-','Color',col(i,:),'LineWidth',2);
    
    
    if i == 1
        axis square; box off
        hold on; scatter(0,0,60,'+')
        xlabel('dva'); ylabel('dva')
        title('Visual Space'); ylim([-10 10]); xlim([-10 10])
    end
    
    subplot(222)
    hold on
    in1 = find(x(i,:)<0);
    in2 = find(x(i,:)>0);
    plot(x(i,in1),y(i,in1),'-','Color',col(i,:),'LineWidth',2); hold on
    plot(x(i,in2),y(i,in2),'-','Color',col(i,:),'LineWidth',2);
    
    
    if i ==1
        axis square; box off
        xlabel('pixels'); ylabel('pixels')
        title('Retinotopic Space')
       ylim([min(y(:))-1,max(y(:))+1])
        line([0 0], [min(y(:)),max(y(:))],'Color','k','LineWidth',2)
    end
    
    
    subplot(223)
    plot(u(:,i),v(:,i),'-','Color',col(i,:),'LineWidth',2);
    
    if i == 1
        axis square; box off
        hold on; scatter(0,0,60,'+')
        xlabel('dva'); ylabel('dva')
        title('Visual Space'); ylim([-10 10]); xlim([-10 10])
    end
    
    subplot(224)
    hold on
    plot(x(:,i),y(:,i),'-','Color',col(i,:),'LineWidth',2);
    
    
    
    if i ==1
        axis square; box off
        xlabel('pixels'); ylabel('pixels')
        title('Retinotopic Space')
        ylim([min(y(:))-1,max(y(:))+1])
        line([0 0], [min(y(:)),max(y(:))],'Color','k','LineWidth',2)
    end
    
    
    
    
    
end

set(gcf,'color','w')
end


