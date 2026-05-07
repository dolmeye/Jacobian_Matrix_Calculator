% This function is used to solve the Jacobian matrix of the system of equations with an example
f={'tanh(x)','y^z*cos(x)','x^z*sin(y)','x^(y^z)'}; % System of equations
varargin = [pi,1,2];
[J,Jf,var] = Jacobi_solve(f,varargin);
J
result = Jx(J,var,varargin);
result

function varargout=Jacobi_solve(f,varargin)
% Solve the symbolic Jacobian matrix of the function
% Input:
%       f     : Function vector of the equation system
%       varargin : The point coordinate for substituting into Jacobian matrix
% Output:
%       J     : Symbolic expression of Jacobian matrix
%       Jf    : Function handle of Jacobian matrix
%       var   : List of symbolic variables
%       varargin : Numerical value after substituting the given point x0

    [x,f]=fx(f);
    n=nargin(f); % Get the number of input arguments
    df=[];        
    for i =1:n
        df1 = diff(f,x(i));
        df = [df,df1];
    end
  
    varargout{1}=df;                       % Output symbolic expression
    varargout{2}=matlabFunction(df);       % Output function handle
    for i=1:length(x)
            s{i}=char(x(i));
    end
    varargout{3}=s;                        % Output variable list
    if ~isempty(varargin)
        varargout{4}=Jx(df,s,varargin{1}); % Output Jacobian value at given point
    end
end

function [x,f]=fx(f)
% Convert function expression written in string format to function handle    
    if  ~isa(f,'sym')            % Check if f is symbolic format
        if iscolumn(f)
            f=str2sym(f);
        else
            f=str2sym(f');
        end                 
    end 
    x=symvar(f);             % Extract symbolic variables from function
    f=matlabFunction(f);
end

function Jk=Jx(J,x,x0)
% Substitute point x0 into Jacobian matrix J for numerical evaluation
% Output format : Numerical matrix
    n=nargin(matlabFunction(J));
    if n==0
        Jk=double(J);
    else
        a=symvar(J);  % Find symbolic variables in Jacobian matrix
        for i=1:length(a)
            s=char(a(i));
            idx(i) = find(strcmp(x,s));
        end
        Jk = subs(J,a,x0(idx));
        Jk = double(Jk);
    end   
end