function [best_fitness, Convergence_curve, best_pos, time] = RPO(piranhas_positions,objective_function,lower_bound,upper_bound,num_iterations)
   
    [num_piranhas,dimension] = size(piranhas_positions);
    % Initialize the best position and fitness
    best_position = [];
    best_fitness = Inf;
    
    Convergence_curve = zeros(1,num_iterations);
    t=0;
    tic; 
    for iteration = 1:num_iterations
        % Evaluate fitness for each piranha
        fitness_values = feval(objective_function,piranhas_positions); %objective_function(piranhas_positions);
        
        % Find the best piranha
        [min_fitness, min_index] = min(fitness_values);
        if min_fitness < best_fitness
            best_fitness = min_fitness;
            best_position = piranhas_positions(min_index, :);
        end
        
            % Update piranhas' positions
            for i = 1:num_piranhas
                for j = 1:dimension
                    if rand() < 0.5
                        % Move towards the best piranha
                        piranhas_positions(i, :) = piranhas_positions(i, j) + rand() * (best_position(j) - piranhas_positions(i, j));
                    else
                        % Move randomly
                        piranhas_positions = rand() * (upper_bound - lower_bound) + lower_bound;
                    end

                    % Check and correct boundary violations
                    piranhas_positions = max(min(piranhas_positions(i, :), upper_bound), lower_bound);
                end
            end
            
           
        t=t+1;
    Convergence_curve(1, t)=best_fitness;
    end
time = toc;
best_fitness = Convergence_curve(1, end);
best_pos = best_position;
end


