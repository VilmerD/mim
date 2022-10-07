classdef LinearOperator < handle
    properties
        dim;
        opfun;
        opfun_t
    end
    
    methods
        function obj = LinearOperator(dim, opfun, opfun_t)
            obj.dim = dim;
            obj.opfun = opfun;
            
            if nargin < 3
                obj.opfun_t = opfun;
            else
                obj.opfun_t = opfun_t;
            end
        end
        
        function y = mtimes(lhs, rhs)
            if isa(lhs, 'LinearOperator') && isa(rhs, 'LinearOperator')
                % Check that they match
                if lhs.dim(2) ~= rhs.dim(1)
                    errorstruct.message = 'Error when combining to linear operators';
                    error(errorstruct);
                end
                A = lhs; B = rhs;
                newdim = [A.dim(1) B.dim(2)];
                newop = @(x) A*(B*x);
                newop_t = @(x) (x*A)*B;
                y = LinearOperator(newdim, newop, newop_t);
                return;
                
            elseif isa(lhs, 'LinearOperator')
                A = lhs; x = rhs;
                if size(x, 1) == A.dim(2)
                	y = A.opfun(x);
                    return;
                end
            else
                A = rhs; x = lhs;
                if size(x, 2) == A.dim(1)
                    y = A.opfun_t(x);
                    return
                end
            end
            
            % If the code reached this point there was some error
            errorstruct.message = sprintf('Incorrect use of mtimes');
            error(errorstruct);
        end
    end
end