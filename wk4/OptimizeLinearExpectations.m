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
%     OptimalDecisionRule.var = [];
%     OptimalDecisionRule.card = [];
%     OptimalDecisionRule.val = [];

    EUF = [];
    I1 = struct();
    I1.RandomFactors = I.RandomFactors;
    I1.DecisionFactors = I.DecisionFactors;
    vars = [];
    len = [];
    for i = 1:length(I.UtilityFactors)
        I1.UtilityFactors = I.UtilityFactors(i);
        euf = CalculateExpectedUtilityFactor(I1);
        EUF = [EUF,euf];
        if i == 1
            vars = euf.var;
            card = euf.card;
            len = [len, length(vars)];
        else
            [vars,ia] = unique([vars, euf.var(2:end)]);
            card1 = [card, euf.card(2:end)];
            card = card1(ia);
            len = [len, length(vars)-len(end)];
        end
    end
    OptimalDecisionRule = struct();
    [unique_vars,ia] = unique(vars);
    OptimalDecisionRule.var = unique_vars;
    OptimalDecisionRule.card = card(ia);
    assgn = IndexToAssignment(1:prod(OptimalDecisionRule.card),OptimalDecisionRule.card);
    EU_val = zeros(size(assgn,1),1);
    for i = 1:size(assgn,1)
        EUval = [];
        for j = 1:length(len)
            if j==1
                rng = 1:len(j);
            else
                rng = [1,len(j-1)+1:len(j-1)+len(j)];
            end
            EUval = [EUval,EUF(j).val(AssignmentToIndex(assgn(i,rng),EUF(j).card))];
        end
        EU_val(i) = sum(EUval);
    end
    total_assgn = prod(OptimalDecisionRule.card(2:end));
    MEU = 0.0;
    start_ind = 1;
    OptimalDecisionRule.val = zeros(1,size(assgn,1));
% %     MEU = -1E10;
% %     for i = 1:total_assgn
% %         EUval = EU_val(i);
% %         if length(OptimalDecisionRule.var) > 1
% %             EUval = EUval + EU_val(size(assgn,1)-i+1);
% %         end
% %         if MEU < EUval
% %             MEU = EUval;
% %             ind = [i];
% %             if length(OptimalDecisionRule.var) > 1
% %                 ind = [ind,size(assgn,1)-i+1];
% %             end
% %         end
% %     end
% %     OptimalDecisionRule.val(ind) = 1.0;
%     for i = 1:total_assgn
%         ind1 = [(i-1)*2+1,i*2];
    for i = 1:OptimalDecisionRule.card(1)
        ind1 = find(assgn(:,1) == i);
        val = EU_val(ind1);
        ind = ind1(find(val == max(val)));
        if length(ind) == 1
            OptimalDecisionRule.val(ind) = 1.0;
        else
            if OptimalDecisionRule.val(max(1,ind(1)-1)) == 1.0
                OptimalDecisionRule.val(ind(end)) = 1.0;
            else
                OptimalDecisionRule.val(ind(1)) = 1.0;
            end
        end
        if length(OptimalDecisionRule.var) == 1
            break;
        end
    end
    MEU = EU_val(find(OptimalDecisionRule.val) == 1.0);
end
