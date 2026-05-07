%这个函数用于求解方程组的雅可比矩阵和一个例子
f={'tanh(x)','y^z*cos(x)','x^z*sin(y)','x^(y^z)'};%方程组
varargin = [pi,1,2];
[J,Jf,var] = Jacobi_solve(f,varargin);
J
result = Jx(J,var,varargin);
result
function varargout=Jacobi_solve(f,varargin)
% 求函数表达式雅可比矩阵 J
% 输入：
%       输入f：方程组向量
%       输入varargin：可代入求解雅可比矩阵的向量
% 输出：
%       输出J：符号表达式
%       输出Jf：句柄函数
%       输出var：变量
%       输出varargin：若输入点x0, 输出带入点后的值

    [x,f]=fx(f);
    n=nargin(f); % 找到输入参数个数
    df=[];        
    for i =1:n
        df1 = diff(f,x(i));
        df = [df,df1];
    end
  
    varargout{1}=df;                       % 输出为符号表达式
    varargout{2}=matlabFunction(df);       % 输出为句柄函数
    for i=1:length(x)
            s{i}=char(x(i));
    end
    varargout{3}=s;                        % 输出变量
    if ~isempty(varargin)
        varargout{4}=Jx(df,s,varargin{1}); % 输出代入点后的值 
    end
end

function [x,f]=fx(f)
% 将用字符串写的函数表达式转化为句柄函数    
    if  ~isa(f,'sym')            % 判断f是否为符号函数格式。
        if iscolumn(f)
            f=str2sym(f);
        else
            f=str2sym(f');
        end                 
    end 
    x=symvar(f);             % 搜寻函数中的符号变量
    f=matlabFunction(f);
end

function Jk=Jx(J,x,x0)
% 将点 x0 代入雅可比矩阵 J 中求值
% 输出格式为：矩阵值
    n=nargin(matlabFunction(J));
    if n==0
        Jk=double(J);
    else
        a=symvar(J);  % 找雅可比矩阵中的符号变量
        for i=1:length(a)
            s=char(a(i));
            idx(i) = find(strcmp(x,s));
        end
        Jk = subs(J,a,x0(idx));
        Jk = double(Jk);
    end   
end
