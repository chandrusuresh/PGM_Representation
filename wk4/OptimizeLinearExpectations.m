% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%     MEU = [];
%     OptimalDecisionRule = struct();
%     OptimalDecisionRule.var = [1];
%     OptimalDecisionRule.card = [2];
%     OptimalDecisionRule.val = [1,0];

  EUF = [];
  for i = 1:length(I.UtilityFactors)
    newI = I;
    newI.UtilityFactors = I.UtilityFactors(i);
    EUF = [EUF,CalculateExpectedUtilityFactor( newI )];
  end

  OptimalDecisionRule = struct();
  OptimalDecisionRule.var = EUF(1).var;
  OptimalDecisionRule.card = EUF(1).card;
  OptimalDecisionRule.val = zeros(1,length(EUF(1).val));
  
  val = EUF(1).val;
  for j = 2:length(EUF)
    val = val + EUF(j).val;
  end

  MEU = 0;
  nDecisions = prod(OptimalDecisionRule.card(2:end));
  for i = 1:nDecisions
    st = (i-1)*OptimalDecisionRule.card(1) + 1;
    ed = i*OptimalDecisionRule.card(1);
    max_val = max(val(st:ed));
    idx = st - 1 + find(val(st:ed) == max_val);
    MEU = MEU + max_val;
    OptimalDecisionRule.val(idx) = 1;
  end