%ComputeMarginal Computes the marginal over a set of given variables
%   M = ComputeMarginal(V, F, E) computes the marginal over variables V
%   in the distribution induced by the set of factors F, given evidence E
%
%   M is a factor containing the marginal over variables V
%   V is a vector containing the variables in the marginal e.g. [1 2 3] for
%     X_1, X_2 and X_3.
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%   E is an N-by-2 matrix, each row being a variable/value pair. 
%     Variables are in the first column and values are in the second column.
%     If there is no evidence, pass in the empty matrix [] for E.


function M = ComputeMarginal(V, F, E)

% Check for empty factor list
if (numel(F) == 0)
      warning('Warning: empty factor list');
      M = struct('var', [], 'card', [], 'val', []);      
      return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% M should be a factor
% Remember to renormalize the entries of M!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = struct('var', [], 'card', [], 'val', []); % Returns empty factor. Change this.
% M.var = V;
% 
Jt = ComputeJointDistribution(F);

if isempty(E)
    M = Jt;
    return;
end

assignments = IndexToAssignment(1:prod(Jt.card),Jt.card);
el_cols = [];
rowNum = [];
for i = 1:size(E,1)
    colNum = find(Jt.var == E(i,1));
    el_cols(i) = colNum;
    if isempty(rowNum)
        rowNum = find(assignments(:,colNum) == E(i,2));
    else
        rowNum = intersect(rowNum,find(assignments(:,colNum) == E(i,2)));
    end
end

M.val = Jt.val(rowNum);
M.var = Jt.var;
M.var(el_cols) = [];
for i = 1:length(M.var)
    ind = find(Jt.var == M.var(i));
    M.card(i) = Jt.card(ind);
end
M.val = M.val/sum(M.val);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
