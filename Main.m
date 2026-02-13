function [] = Main_27_01_2024()
close all;
clear all;
clc;

global Info

%% Data-collection %%
an = 0;
if an == 1
    No_of_VM = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    VC_limit = [1 98]; % CPU - (capacity)
    VM_limit = [0 80]; % GB Ram (Memory)
    CT_limit = [200 1400]; % completion time limit(sec)
    U_limit = [20, 99]; % Utilization limit in (%)
    R_limit = [0, 2]; % Response time limit(sec)
    size=10000;
    for i = 1 : length(No_of_VM)
        VC = randi([VC_limit(1) VC_limit(2)], 1, size);  % VM - CPU
        VM = randi([VM_limit(1) VM_limit(2)], 1, size);  % VM - Memory
        BW = randi([5 50], 1, size);  % Bandwidth
        CT = randi([CT_limit(1) CT_limit(2)], 1, size);  % Completion Time
        UT = randi([U_limit(1) U_limit(2)], 1, size); % Maximum Utilization time
        RT = randi([R_limit(1) R_limit(2)], 1, size); % Response time
        T = rand(1, size); % performance
        Data{i} = [VC; VM; BW; CT; UT; RT; T]';
        Target{i} = T;
    end
    save Data Data
    save Target Target
end

%% Data initialization
an = 0;
if an == 1
    No_of_VM = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    No_of_Server = [100, 120, 140, 160, 180, 200, 220, 240, 260, 280];
    size = 10000;
    load Data
    for i = 1 : length(No_of_VM)
        Var(i).BW = Data{i}(:, 3); % Bandwidth
        Var(i).VM_id = randi([1 No_of_VM(i)], 1, size);  % Virtual machines
        Var(i).S_wt = rand(1, size); % Weight of The Server
        Var(i).TT = rand(1, size); % Task Transfer between two VM's x and y
        Var(i).RT = Data{i}(:, 6); % Response Time
        Var(i).SS = No_of_Server(i); % Number of Servers
        Var(i).CPU_util = rand(1, size); % CPU Utilization
        Var(i).Init_Energy = 0.05; % Initial Energy 
        Var(i).Energy = 0.0001 + (0.0099-0.0001).*rand(1); % Consumed Energy
    end
    save Var Var 
end

%% Optimization for Task Sheduling
an = 0;
if an == 1
    load Var
    load Target
    VM = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    no_of_tasks = [50, 100, 150, 200] ;
    bestsolution = {};
    Fitness = {};
    for i = 1:length(VM)
        best_sol_task = {};
        Fitness_task = {};
        for j =1:length(no_of_tasks)
            Info = Var(i);
            Targ = Target{i};
            Npop = 10;
            Ch_len = no_of_tasks(j);  % No of tasks 
            xmin = ones(Npop,Ch_len);
            xmax = VM(i).*ones(Npop, Ch_len);
            initsol = unifrnd(xmin,xmax);
            itermax = 250;    % iteration value
            fname = 'obj_fun';

            disp('GRO')
            [bestfit,fitness,bestsol,time] = GRO(initsol,fname,xmin,xmax,itermax);  % GRO
            Gro(i, j).bf = bestfit; Gro(i, j).fit = fitness; Gro(i,j).bs = bestsol; Gro(i,j).ct = time;
            save Gro Gro

            disp('GJO')
            [bestfit,fitness,bestsol,time] = GJO(initsol,fname,xmin,xmax,itermax);  % JAYA
            Gjo(i,j).bf = bestfit; Gjo(i,j).fit = fitness; Gjo(i,j).bs = bestsol; Gjo(i,j).ct = time;
            save Gjo Gjo

            disp('EHA')
            [bestfit,fitness,bestsol,time] = EHO(initsol,fname,xmin,xmax,itermax);  % MRA
            Eho(i,j).bf = bestfit; Eho(i,j).fit = fitness; Eho(i,j).bs = bestsol; Eho(i,j).ct = time;
            save Eho Eho

            disp('RPO')
            [bestfit,fitness,bestsol,time] = RPO(initsol,fname,xmin,xmax,itermax);  % RPO
            Rpo(i,j).bf = bestfit; Rpo(i,j).fit = fitness; Rpo(i,j).bs = bestsol; Rpo(i,j).ct = time;
            save Rpo Rpo

            disp('PROPOSED')
            [bestfit,fitness,bestsol,time] = PROPOSED(initsol,fname,xmin,xmax,itermax);  % EHA+RPO
            Prop(i,j).bf = bestfit; Prop(i,j).fit = fitness; Prop(i,j).bs = bestsol; Prop(i,j).ct = time;
            save Prop Prop
            
            best_sol = [Gro(i, j).bs; Gjo(i, j).bs; Eho(i, j).bs; Rpo(i, j).bs; Prop(i, j).bs];
            best_Fit = [Gro(i, j).fit; Gjo(i, j).fit; Eho(i, j).fit; Rpo(i, j).fit; Prop(i, j).fit];
            
            best_sol_task = [best_sol_task, best_sol];
            Fitness_task = [Fitness_task, best_Fit];
        end
        Fitness = [Fitness, Fitness_task];
        bestsolution = [bestsolution, best_sol_task];
    end
    save bestsolution bestsolution; 
    save Fitness Fitness;
end

Plot_results();
end
