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
  D = I.DecisionFactors(1);
  U = I.UtilityFactors(1);
  EUF = struct();
  EUF.var = I.DecisionFactors.var;
  EUF.card = I.DecisionFactors.card;
  EUF.val = zeros(1,prod(EUF.card));
  
  F1 = I.RandomFactors;
    
  varsNeeded = [];
  for i = 1:length(D)
      varsNeeded = [varsNeeded,D(i).var];
  end
  for i = 1:length(U)
      varsNeeded = [varsNeeded,U(i).var];
  end
  varsNeeded = unique(varsNeeded);
  varsToEliminate = [];
  for i = 1:length(F1)
      vars = F1(i).var;
      for j = 1:length(vars)
          ind = find(varsNeeded == vars(j));
          if isempty(ind)
              varsToEliminate = [varsToEliminate,vars(j)];
          end
      end
  end
  varsToEliminate = unique(varsToEliminate);
  Fnew = VariableElimination(F1, varsToEliminate);

  if length(Fnew) > 1
      %%%%% Independent factors
      Fn = Fnew(1);
      for i = 2:length(Fnew)
          Fn = FactorProduct(Fn, Fnew(i));
      end
      Fnew = Fn;
%       Fnew = NormalizeFactorValues(Fnew);
  end    
  
  if length(Fnew.var) ~= length(varsNeeded)
      %%%%% Decision node has no parents
      D.val = ones(size(D.val));
      Fnew = FactorProduct(Fnew, D);
      varsToEliminate = [];
      for i = 1:length(Fnew.var)
          ind = find(U.var == Fnew.var(i));
          if isempty(ind)
              varsToEliminate = [varsToEliminate,Fnew.var(i)];
          end
      end
      Fnew = VariableElimination(Fnew, varsToEliminate);
  end
  ind = find(I.UtilityFactors.var == I.DecisionFactors.var(1));
  EUF1 = FactorProduct(Fnew,U);
  varsToRemove = [];
  if isempty(ind)
      vars = [I.DecisionFactors.var(1),I.UtilityFactors.var];
      for i = 1:length(I.DecisionFactors.var)
          ind1 = find(vars == I.DecisionFactors.var(i));
          if isempty(ind1)
              varsToRemove = [varsToRemove,I.DecisionFactors.var(i)];
          end
      end
%       EUF = FactorProduct(Fnew,U);
  else
      for i = 1:length(Fnew.var)
          ind = find(D.var == Fnew.var(i));
          if isempty(ind)
              varsToRemove = [varsToRemove,Fnew.var(i)];
          end
      end
  end
  EUF = FactorMarginalization(EUF1,varsToRemove);