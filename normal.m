function x=normal(mu,Q, varargin)

if length(varargin)==1
    N=varargin{1};
else
    N=1;
end;

R=chol(Q);
x= repmat(mu,1,N) + (randn(N,length(mu))*R)';