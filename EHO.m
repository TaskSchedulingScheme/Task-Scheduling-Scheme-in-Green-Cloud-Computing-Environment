function [Leader_score,Convergence_curve,Leader_pos,ct]=EHO(Positions,fobj,VRmin,VRmax,Max_iter)
[N,dim] = size(Positions);
lb = VRmin(1,:);
ub = VRmax(1,:);

Wind_angle = 2*pi*rand;     % Wind direction
pos_angle = Wind_angle+pi;    % Diection of positions

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems

% initialize position vector and score for the leader
sc_pos=zeros(1,dim);
sc_score=-inf; %change this to inf for maximization problems

%Initialize the positions of search agents
% Positions=randi(node_count, N, dim);

Convergence_curve=zeros(1,Max_iter);

t=0;% Loop counter
tic;
% Main loop
while t<Max_iter
    for i=1:size(Positions,1)
        
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Calculate objective function for each search agent
        fitness=feval(fobj,Positions(i,:));
        
        % Update the leader
        if fitness<Leader_score % Change this to > for maximization problem
            Leader_score=fitness; % Update alpha
            Leader_pos=Positions(i,:);
        end
        
        if fitness>Leader_score && fitness<sc_score% Change this to < for maximization problem
            sc_score=fitness; % Update alpha
            sc_pos =Positions(i,:);
        end
        
    end
    

    % Update the Position of search agents 
    for i=1:size(Positions,1)
        r = (pi/8)*rand;
        v = Wind_angle-r;
        A = pos_angle + v;
        m1 = 0; m2 = 2; 
        p = (m2-m1).*rand + m1;
        a = -1; b = 1;      
        for j=1:size(Positions,2)  
            r1= a + (b-a).*rand(); % r1 is a random number in [-1,1]
            r2=rand(); % r2 is a random number in [0,1]
            if p<1                
                A1=(1/4)*log(t+(1/Max_iter))*r1; 
                C1=2*r2;                 
                if abs(C1)>=1
                  alp = abs((C1*Leader_pos(j))-Positions(i,j));
                  Positions(i,j) = Leader_pos(j)-A1*p*alp; 
                else
                  alp = abs((C1*sc_pos(j))-Positions(i,j));
                  Positions(i,j) = sc_pos(j)-A1*p*alp;   
                end
            else                 
                  alp = abs((cos(A)*Leader_pos(j))-Positions(i,j));
                  Positions(i,j) = Leader_pos(j)-r1*p*alp;                
            end            
        end
    end
    t=t+1;
    Convergence_curve(t)=Leader_score;
end
Leader_score = Convergence_curve(end);
ct = toc;
end

