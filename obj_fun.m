function[Fitn] = obj_fun(soln)
global Info
for i = 1:size(soln,1)  % for each solution
    sol = round(soln(i,:));
    for j = 1:length(sol)
        ind{j} = find(Info.VM_id == sol(j));
        Id(j) = unique(Info.VM_id(ind{j}));
        E_texe(j) = Id(j) * sum(Info.CPU_util(ind{j}))* sum(Info.S_wt(ind{j}));
        E_tt(j) = (sum(Info.TT(ind{j}))/sum(Info.BW(ind{j}))) * sum(Info.CPU_util(ind{j}));
        E_active = E_texe(j) * E_tt(j);
        E_idle = (2/3)*(sum(Info.CPU_util(ind{j})));
        E_cons = E_active + E_idle;
        RT= sum(Info.RT(ind{j}));

        lambda_tn = mean(Info.TT(ind{j}));
        lambda_tm = mean(Info.TT(ind{j}))+0.2;
        V_star = E_texe(j);
        t = reshape(Info.RT', 1, []);
    end
    E_cons = sum(E_cons);
    Timespan = sum(RT);
    
    term1 = (lambda_tn + lambda_tm) * V_star;
    term2 = lambda_tn * expected_remaining_completion_time(lambda_tn, V_star, t);
    term3 = lambda_tm * expected_remaining_completion_time(lambda_tm, V_star, t);

    % Evaluate the equation
    Equation = 1 + term1 + term2 + term3; % equation 15 in ref 3
    
    Fitn(i) = E_cons + Timespan; % Minimize
    
end
end


function expected_time = expected_remaining_completion_time(lambda, V_star, t)
    % Helper function to calculate the expected remaining completion time
    % Inputs:
    % lambda: Experimentally distributed time for a task
    % V_star: Expected value of remaining completion time when no task has been completed
    % t: Set of time quantities {t1, t2, ..., tn}
    % Calculate the expected time
    expected_time = integral(@(tau) tau .* probability_density_function(lambda, tau, t), 0, V_star);
end


function pdf_value = probability_density_function(lambda, tau, t)
    % Helper function to calculate the probability density function
    % Inputs:
    % lambda: Experimentally distributed time for a task
    % tau: Time variable
    % t: Set of time quantities {t1, t2, ..., tn}

    % Assume a simple probability density function, you may need to replace this
    % with the actual distribution function based on your experimental data
    % Example: Exponential distribution
    pdf_value = lambda * exp(-lambda * tau);

end

