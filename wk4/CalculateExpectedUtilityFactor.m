% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  Fnew = I.RandomFactors;
  vars = I.RandomFactors(1).var;
  for i = 1:length(I.RandomFactors)
    vars = unique([vars,I.RandomFactors(i).var]);
  end

  totalUtility = I.UtilityFactors(1);
%  for i = 2:length(I.UtilityFactors)
%    totalUtility = FactorSum(totalUtility,I.UtilityFactors(i));
%  end
  Fnew(end+1) = totalUtility;
  vars = unique([vars,totalUtility.var]);

  varsToEliminate = setdiff(vars,I.DecisionFactors.var);
  EUF = VariableElimination(Fnew,varsToEliminate);
  newEUF = EUF(1);
  if length(EUF) > 1
    for k = 2:length(EUF)
      newEUF = FactorProduct(newEUF,EUF(k));
    end
    EUF = newEUF;
  end  
end