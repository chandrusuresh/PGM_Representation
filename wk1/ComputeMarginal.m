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

if isempty(E) && isempty(V)
    M = Jt;
    return;
end

assignments = IndexToAssignment(1:prod(Jt.card),Jt.card);
el_cols = [];
for i = 1:length(V)
    colNum = find(Jt.var == V(i));
    el_cols(i) = colNum;
end
M.var = Jt.var(el_cols);
M.card = Jt.card(el_cols);

rowNum = [];
for i = 1:size(E,1)
    colNum = find(Jt.var == E(i,1));
    if isempty(rowNum)
        rowNum = find(assignments(:,colNum) == E(i,2));
    else
        rowNum = intersect(rowNum,find(assignments(:,colNum) == E(i,2)));
    end
end
if isempty(rowNum)
    rowNum = 1:size(assignments,1);
end
final_assgn = IndexToAssignment(1:prod(M.card),M.card);
final_rows = [];
for i = 1:size(final_assgn,1)
    for j = 1:size(final_assgn,2)
        r = rowNum(find(assignments(rowNum,el_cols(j)) == final_assgn(i,j)));
        if j == 1
            rows = r;
        else
            rows = intersect(rows,r);
        end
    end
    rows = reshape(rows,[1,length(rows)]);
    if isempty(rows)
        rows = zeros(1,size(final_rows,2));
    end
    final_rows = [final_rows;rows];
end

for i = 1:size(final_rows,1)
    if sum(final_rows(i,:)) == 0
        M.val(i) = 0.0;
    else
        M.val(i) = sum(Jt.val(final_rows(i,:)));
    end
end
M.val = M.val/sum(M.val);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
