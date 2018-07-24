% ObserveEvidence Modify a vector of factors given some evidence.
%   F = ObserveEvidence(F, E) sets all entries in the vector of factors, F,
%   that are not consistent with the evidence, E, to zero. F is a vector of
%   factors, each a data structure with the following fields:
%     .var    Vector of variables in the factor, e.g. [1 2 3]
%     .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%     .val    Value table of size prod(.card)
%   E is an N-by-2 matrix, where each row consists of a variable/value pair. 
%     Variables are in the first column and values are in the second column.

function F = ObserveEvidence(F, E)

% Iterate through all evidence

for i = 1:size(E, 1),
    v = E(i, 1); % variable
    x = E(i, 2); % value

    % Check validity of evidence
    if (x == 0),
        warning(['Evidence not set for variable ', int2str(v)]);
        continue;
    end;

    for j = 1:length(F),
		  % Does factor contain variable?
        indx = find(F(j).var == v);

        if (~isempty(indx)),
        
		  	   % Check validity of evidence
            if (x > F(j).card(indx) || x < 0 ),
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Fj_val = zeros(size(F(j).val));
            map = [];
            for k = 1:length(F(j).var),
                tmp = find(E(:,1) == F(j).var(k));
                if isempty(tmp)
                    tmp = (1:F(j).card(k))';
                    if isempty(map)
                        map = tmp;
                    else
                        if size(map,1) >= length(tmp)
                            map1 = cell(size(tmp));
                            map2 = [];
                            for ii = 1:length(tmp)
                                map1{ii} = [map,repmat(tmp(ii),[size(map,1),1])];
                                map2 = [map2;map1{ii}];
                            end
                            map = map2;
                        else
                            map = [repmat(map,size(tmp)),tmp];
                        end                        
                    end
                else
                    if size(map,1) > length(tmp)
                        if length(tmp) == 1
                            map = [map,E(tmp,2)*ones(size(map,1),1)];
                        end
                    else
                        map = [map,E(tmp,2)];
                    end
                end
            end;
%            assignment = [];
%            for k = 1:size(map,1)
%                assignment(k,:) = E(map(k,:),2);
%            end
            assignment = map;
            indices = AssignmentToIndex(assignment,F(j).card);
            Fj_val(indices) = F(j).val(indices);
            F(j).val = Fj_val;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0)),
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;

        end;
    end;
end;

end
