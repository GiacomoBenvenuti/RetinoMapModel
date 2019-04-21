function [Uq Vq] = RetinoModel_INV(varargin)
% [u v] = RetinoModel_INV(X,Y,param)
% param = [ A, Bx, By, Angle, U0, V0 ]
% 
% This function converts cortical coordinates (X,Y) to visual 
% coordinates (u,v) based on a model with parameters param
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
%  Since we cannot analytically formulate the inverse function of our model,
% we have to use a work around. This approach consists 
% in converting a large grid in the visual space to the 
% cortical space and interpolating. 
%
%-------------------------------------------
% by Giacomo Benvenuti & Wahiba Taouali
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------
Xq = varargin{1} ;
Yq = varargin{2} ;
param = varargin{3} ;

% Generate grid in visual space
[U, V] = meshgrid( -10:.5:10 ,  -10:.5:10 );
% Estimate correspondent cortical location
[x2 y2] = RetinoModel(U,V,param);

% Cortical coordinates that we want to estimate (in pxl)
%[Xq, Yq ]= meshgrid( 1:size(X,1) , 1:size(X,2) );

% Interpolation 
Uq = griddata(x2,y2,U,Xq,Yq);
Vq = griddata(x2,y2,V,Xq,Yq);

end