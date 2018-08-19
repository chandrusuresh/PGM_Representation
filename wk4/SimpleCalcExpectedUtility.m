% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  F1 = I.RandomFactors;
  for i = 1:length(I.DecisionFactors)
      newF = I.DecisionFactors(i);
      F1 = [F1,newF];
  end
  
  varsToEliminate = [];
  for i = 1:length(F1)
      vars = F1(i).var;
      for j = 1:length(vars)
          ind = find(U.var == vars(j));
          if isempty(ind)
              varsToEliminate = [varsToEliminate,vars(j)];
          end
      end
  end
  varsToEliminate = unique(varsToEliminate);
  Fnew = VariableElimination(F1, varsToEliminate);

  if length(Fnew) > 1
      %%%%% Decision node has no parents
      Fn = Fnew(1);
      for i = 2:length(Fnew)
          Fn = FactorProduct(Fn, Fnew(i));
      end
      Fnew = Fn;
  end  
  % % % Variable mapping from Fnew to U
  A_Fnew = IndexToAssignment(1:prod(Fnew.card), Fnew.card);
  A_U = IndexToAssignment(1:prod(U.card), U.card);
  
  colMapping = [];
  for i = 1:length(U.var)
      ind = find(Fnew.var == U.var(i));
      if isempty(ind)
          keyboard
      else
          colMapping = [colMapping,ind];
      end
  end
  
  AFnew_mapped = A_Fnew(:,colMapping);  
  
  EU = 0.0;
  for i = 1:size(AFnew_mapped,1)
      sum_diff = sum(abs(A_U-repmat(AFnew_mapped(i,:),[size(AFnew_mapped,1),1])),2);
      ind = find(sum_diff == 0);
      EU = EU + ...
          Fnew.val(i)*U.val(ind);
  end
end
