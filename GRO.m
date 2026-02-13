function [best_score, Convergence_curve, best_pos, runtime] = GRO(Positions, fobj, lb, ub, Max_iter)
    [N, dim] = size(Positions);
    lb = lb * dim;
    ub = ub * dim;

    sigma_initial = 2;
    sigma_final = 1 / Max_iter;

    best_pos = zeros(1, dim);
    best_score = inf;  % Change this to -inf for maximization problems

    Fit = inf(N, 1);

    Fit_NEW = Fit;

    Convergence_curve = zeros(1, Max_iter);
%     Convergence_curve(1) = min(Fit);
    ct = tic;
    iter = 1;

    while iter <= Max_iter
        X_NEW = Positions;
        for i = 1:N
            Fit_NEW(i) = feval(fobj,X_NEW(i, :));

            if Fit_NEW(i) < Fit(i)
                Fit(i) = Fit_NEW(i);
                Positions(i, :) = X_NEW(i, :);
            end

            if Fit(i) < best_score
                best_score = Fit(i);
                best_pos = Positions(i, :);
            end
        end

        l2 = ((Max_iter - iter) / (Max_iter - 1))^2 * (sigma_initial - sigma_final) + sigma_final;
        l1 = ((Max_iter - iter) / (Max_iter - 1))^1 * (sigma_initial - sigma_final) + sigma_final;

        for i = 1:N
            coworkers = datasample(setdiff(1:N, i), 2, 'Replace', false);
            digger1 = coworkers(1);
            digger2 = coworkers(2);

            m = rand();

            if m < 1 / 3
                for d = 1:dim
                    r1 = rand();
                    D3 = Positions(digger2, d) - Positions(digger1, d);
                    X_NEW(i, d) = Positions(i, d) + r1 * D3;
                end
            elseif m < 2 / 3
                for d = 1:dim
                    r1 = rand();
                    A2 = 2 * l2 * r1 - l2;
                    D2 = Positions(i, d) - Positions(digger1, d);
                    X_NEW(i, d) = Positions(digger1, d) + A2 * D2;
                end
            else
                for d = 1:dim
                    r1 = rand();
                    r2 = rand();
                    C1 = 2 * r2;
                    A1 = 1 + l1 * (r1 - 1 / 2);
                    D1 = C1 * best_pos(d) - Positions(i, d);
                    X_NEW(i, d) = Positions(i, d) + A1 * D1;
                end
            end

            X_NEW(i, :) = bound_constraint(X_NEW(i, :), Positions(i, :), lb(i, :), ub(i, :));
        end

        Convergence_curve(iter) = best_score;
        iter = iter + 1;
    end
    runtime = toc(ct);
end

function X_new = bound_constraint(X_new, positions_i, lb, ub)
    positions_i = positions_i;
    X_new = max(min(X_new, ub), lb);
end
