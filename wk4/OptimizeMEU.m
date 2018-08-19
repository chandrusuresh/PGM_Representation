% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    OptimalDecisionRule = I.DecisionFactors;
    OptimalDecisionRule.val = zeros(size(OptimalDecisionRule.val),'int8');  
  
    EUF = CalculateExpectedUtilityFactor(I);
    total_assgn = prod(EUF.card(2:end));
    start_ind = 1;
    MEU = 0.0;
    for i = 1:EUF.card(1)
        EUF_val = EUF.val(start_ind:start_ind+total_assgn-1);
        ind = start_ind - 1 + find(EUF_val == max(EUF_val));
        start_ind = start_ind + total_assgn;
        OptimalDecisionRule.val(ind) = 1.0;
        MEU = MEU + EUF.val(ind);
        if length(EUF.var) == 1
            break;
        end
    end
end
