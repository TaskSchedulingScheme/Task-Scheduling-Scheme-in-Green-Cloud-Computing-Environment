function [best_fitness, Convergence_curve, best_pos, time] = PROPOSED(positions,objective_function,lower_bound,upper_bound,num_iterations)

Wind_angle = 2*pi*rand;     % Wind direction
pos_angle = Wind_angle+pi;    % Diection of positions

Leader_score=inf; %change this to -inf for maximization problems

[num_piranhas,dimension] = size(positions);
% Initialize the best position and fitness
sc_pos=zeros(1,dimension);
sc_score=-inf;
best_position = [];
best_fitness = Inf;
Convergence_curve = zeros(1, num_iterations);
t=0;
tic;
for iteration = 1:num_iterations
    piranhas_positions = positions;
    % Evaluate fitness for each piranha
    fitness_values = feval(objective_function,piranhas_positions); %objective_function(piranhas_positions);
    
    % Find the best piranha
    [min_fitness, min_index] = min(fitness_values);
    if min_fitness < best_fitness
        best_fitness = min_fitness;
        best_position = piranhas_positions(min_index, :);
    end
    if iteration < num_iterations / 2
        % Update positions using EHO
        for i=1:size(piranhas_positions,1)
            r = (pi/8)*rand;
            v = Wind_angle-r;
            A = pos_angle + v;
            m1 = 0; m2 = 2;
            p = (m2-m1).*rand + m1;
            a = -1; b = 1;
            
            
        if best_fitness>Leader_score && best_fitness<sc_score% Change this to < for maximization problem
            sc_score=best_fitness; % Update alpha
            sc_pos =piranhas_positions(i,:);
        end
            
            for j=1:size(piranhas_positions,2)
                r1= a + (b-a).*rand(); % r1 is a random number in [-1,1]
                r2=rand(); % r2 is a random number in [0,1]
                if p<1
                    A1=(1/4)*log(t+(1/num_iterations))*r1;
                    C1=2*r2;
                    if abs(C1)>=1
                        alp = abs((C1*best_position(j))-piranhas_positions(i,j));
                        piranhas_positions(i,j) = best_position(j)-A1*p*alp;
                    else
                        alp = abs((C1*sc_pos(j))-piranhas_positions(i,j));
                        piranhas_positions(i,j) = sc_pos(j)-A1*p*alp;
                    end
                else
                    alp = abs((cos(A)*best_position(j))-piranhas_positions(i,j));
                    piranhas_positions(i,j) = best_position(j)-r1*p*alp;
                end
            end
        end
       
    else
        % Update positions using RPO
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
    end
    t=t+1;
    Convergence_curve(1, t)=best_fitness;
end
time = toc;
best_fitness = Convergence_curve(1, end);
best_pos = best_position;
end


