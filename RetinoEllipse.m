classdef RetinoEllipse < handle ;
    % ------------------------------------------------
    %  by Giacomo Benvenuti & Wahiba Taouli 
    % ------------------------------------------------
    properties
        u = [5 20 30 40]  ;% linspace(0,5,5) % (dva) x in visual space
        v = linspace(-20,20,5) ; % (dva) y in visual space
        A  = 3 ; % Scaling factor //Shift in the mapping function in deg
        Bx = 1.4 ;% magnification along x axe in mm/deg
        By = 1.8 ;% magnification along y axe in mm/rad
        
        rho = []; %  polar coordinates in visual space in deg
        theta = []; % polar coordinates in visual space in deg
        U = [] ; % Grid visual space
        V = []; % Grid visual space
        x = []; 
        y = [];
    end
    
    methods
        function obj = RetinoEllipse(varargin)
            %RetinoEllipse (u,v,A,Bx,By)
            [U,V] = meshgrid(obj.u,obj.v);
            obj.U = U; obj.V = V;
            obj.cartesianVisual_to_cortical;
        end
        
        function obj = cartesianVisual_to_cortical(obj)
            % Polar to logpolar coordinates.
            % rho,theta : polar coordinates in visual space in deg
            % A :Shift in the SC mapping function in deg
            % Bx:Collicular magnification along x axe in mm/deg
            % By:Collicular magnification along y axe in mm/rad
            % xlims,ylims : cortical space extremities
            % P.S. the default values are those used for
            % biologically plausible model of the superior colliculus
            [U,V] = meshgrid(obj.u,obj.v);
            obj.U = U; obj.V = V;
            obj.cartesian_to_polar % calculate rho and theta
            obj.polarVisual_to_cortical %
        end
        
        function obj= cartesian_to_polar(obj)
            obj.rho = sqrt(obj.U.^2+obj.V.^2);
            obj.theta = atan2(obj.V,obj.U).*180./pi;
        end
        
        function obj = polarVisual_to_cortical(obj)
            % Polar to logpolar coordinates.
            % rho,theta : polar coordinates in visual space in deg
            % A :Shift in the SC mapping function in deg
            % Bx:Collicular magnification along x axe in mm/deg
            % By:Collicular magnification along y axe in mm/rad
            % xlims,ylims : cortical space extremities
            % P.S. the default values are those used for
            % biologically plausible model of the superior colliculus
            
            hemi = ones(size(obj.theta));
            hemi( mod(obj.theta,360)>90 & mod(obj.theta,360)<270 ) = -1 ;
            
            thetaR = obj.theta.*pi./180;
            x = obj.Bx*log(sqrt(obj.rho.*obj.rho+2.*obj.A.*obj.rho.*abs(cos(thetaR))+obj.A.*obj.A)/obj.A);
            y = obj.By*atan(obj.rho.*sin(thetaR)./(obj.rho.*abs(cos(thetaR))+obj.A));
            obj.y = y.*-1;
            obj.x = x.*hemi; 
            %obj.x = (obj.x -min(obj.x(:)))./max(obj.x(:) -min(obj.x(:)));
            %obj.y = (obj.y -min(obj.y(:)))./max(obj.y(:) -min(obj.y(:)));
        end
        
        function obj = disp(obj)
            % Disp
            col = parula(size(obj.U,2));
            for i = 1:size(obj.U,2)
                hold on
                subplot(1,2,1)
                plot(obj.U(:,i),obj.V(:,i),'Color',col(i,:)); axis square; box off
                hold on; scatter(0,0,60,'+')
                title('Visual Space (dva)'); ylim([-10 10]); xlim([-10 10])
                
                subplot(1,2,2)
                plot(obj.x(:,i),obj.y(:,i),'Color',col(i,:)); axis square; box off
                title('Retinotopic Space (mm)')
            end
            
            set(gcf,'color','w')
        end
    end
    
end

