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
% %         [i,j]
%         if i == 33 && j == 12
%             keyboard
%         end
        map = 0;
        for k = 1:length(F)
            if F(k).var(1) == Joint.var(j)
                map = k;
                asgn = zeros(length(F(k).var),1);
                for k1 = 1:length(F(k).var)
                    ind1 = find(Joint.var == F(k).var(k1));
                    asgn(k1) = assignments(i,ind1);
                end
                Ev = [F(k).var', asgn];
                break;
            end
        end
        if map == 0
            keyboard
        end
        newF = ObserveEvidence(F(map), Ev);
        ind_nonZeroProb = find(newF.val > 0);
        if ~isempty(ind_nonZeroProb)
            prob = newF.val(ind_nonZeroProb);
        else
            prob = 0;
        end
        jt_prob = jt_prob*prob;
    end
    Joint.val(i) = jt_prob;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

