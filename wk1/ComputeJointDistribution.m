%ComputeJointDistribution Computes the joint distribution defined by a set
% of given factors
%
%   Joint = ComputeJointDistribution(F) computes the joint distribution
%   defined by a set of given factors
%
%   Joint is a factor that encapsulates the joint distribution given by F
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%

function Joint = ComputeJointDistribution(F)

  % Check for empty factor list
  if (numel(F) == 0)
      warning('Error: empty factor list');
      Joint = struct('var', [], 'card', [], 'val', []);      
      return;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% Compute the joint distribution defined by F
% You may assume that you are given legal CPDs so no input checking is required.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Joint = struct('var', [], 'card', [], 'val', []); % Returns empty factor. Change this.
Joint.map = {}
for i = 1:length(F)
    for j = 1:length(F(i).var)
        ind = find(Joint.var == F(i).var(j));
        if isempty(ind)
            Joint.var = [Joint.var,F(i).var(j)];
            Joint.card = [Joint.card,F(i).card(j)];
        end
    end
end

assignments = IndexToAssignment(1:prod(Joint.card),Joint.card);

for i = 1:size(assignments,1)
    jt_prob = 1.0;
    for j = 1:size(assignments,2)
        if isempty(Joint.map{j})
            prob = F(Joint.map{j}[1]).val(assignments(i,j));
        else
            %% Get Evidence matrix
            for k = 1:length(F(Joint.map{j}[1]).var)
                E(k,:) = [F(Joint.map{j}[1]).var(k),assignments(i,F(Joint.map{j}[1]).var(k))];
            end
            E = sortrows(E,1);
            newF = ObserveEvidence(F(Joint.map{j}[1]), E);
            prob = newF.val(find(newF.val > 0));
        end
        jt_prob = jt_prob*prob;
    end
    Joint.val(i) = jt_prob;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

