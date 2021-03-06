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

  UF = I.UtilityFactors(1);
  for i = 2:length(I.UtilityFactors)
    UF = FactorSum(UF,I.UtilityFactors(i));
  end
  
  I.UtilityFactors = UF;
  
  EUF = CalculateExpectedUtilityFactor( I );
  ed_ind = 0;
  OptimalDecisionRule = EUF;
  OptimalDecisionRule.val = zeros(size(EUF.val));
  nDecisions = prod(I.DecisionFactors.card(2:end));
  MEU = 0;
  for i = 1:nDecisions
    st_ind = (i-1)*nDecisions + 1;
    ed_ind = st_ind - 1 + I.DecisionFactors.card(1);
    val = EUF.val(st_ind:ed_ind);
    ind = st_ind - 1 + find(val == max(val));
    MEU = MEU + max(val);
    OptimalDecisionRule.val(ind(1)) = 1;
  end  
end