function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J= (-y'*log(sigmoid(X*theta))-(ones(size(y))-y)'*log(ones(size(X*theta))-sigmoid(X*theta)))/m+(lambda/(2*m))*(theta'*theta - theta(1)*theta(1));
grad = (X'*(sigmoid(X*theta)-y))/m+(lambda/m)*(theta-theta(1)*eye(size(theta)));
end
