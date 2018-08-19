% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeWithJointUtility( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
    
  % This is similar to OptimizeMEU except that we must find a way to 
  % combine the multiple utility factors.  Note: This can be done with very
  % little code.
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  UF = struct();
  UF.var = [];
  UF.card = [];
  for i = 1:length(I.UtilityFactors)
      UF.var = [UF.var,I.UtilityFactors(i).var];
      UF.card = [UF.card,I.UtilityFactors(i).card];
  end
  [UF.var,ia] = unique(UF.var);
  UF.card = UF.card(ia);
  UF.val = zeros(1,prod(UF.card));
  A_UF = IndexToAssignment(1:prod(UF.card),UF.card);
  for i = 1:length(I.UtilityFactors)
      cols = [];
      for j = 1:length(I.UtilityFactors(i).var)
          ind = find(UF.var == I.UtilityFactors(i).var(j));
          cols = [cols,ind];
      end
      newA = A_UF(:,cols);
      indices = AssignmentToIndex(newA,I.UtilityFactors(i).card);
      UF.val = UF.val + I.UtilityFactors(i).val(indices);
  end
%   
  I2 = I;
  I2.UtilityFactors = UF;
  [MEU,OptimalDecisionRule] = OptimizeMEU(I2);
end
