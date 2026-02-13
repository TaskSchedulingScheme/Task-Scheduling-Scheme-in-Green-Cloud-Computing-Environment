function [Male_Jackal_score,Convergence_curve, Male_Jackal_pos, ct]=GJO(Positions,fobj,lb,ub,Max_iter)
[SearchAgents_no, dim] = size(Positions);
%% initialize Golden jackal pair
Male_Jackal_pos=zeros(1,dim);
fitness=zeros(1,SearchAgents_no);
Male_Jackal_score=inf;
Female_Jackal_pos=zeros(1,dim);
Female_Jackal_score=inf;
%% Initialize the positions of search agents
% Positions=initialization(SearchAgents_no,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);
ct = tic();
l=0;% Loop counter
% Main loop
while l<Max_iter
    for i=1:size(Positions,1)
        % boundary checking
        Flag4ub=Positions(i,:)>ub(i,:);
        Flag4lb=Positions(i,:)<lb(i,:);
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub(i,:).*Flag4ub+lb(i,:).*Flag4lb;
        % Calculate objective function for each search agent
        fitness(1, i)=feval(fobj,Positions(i,:));
        % Update Male Jackal
        if fitness(1, i)<Male_Jackal_score
            Male_Jackal_score=fitness(1, i);
            Male_Jackal_pos=Positions(i,:);
        end
        if fitness(1, i)>Male_Jackal_score && fitness(1, i)<Female_Jackal_score
            Female_Jackal_score=fitness(1, i);
            Female_Jackal_pos=Positions(i,:);
        end
    end
    
    
    
    E1=1.5*(1-(l/Max_iter));
    RL=0.05*levy(SearchAgents_no,dim,1.5);
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            
            r1=rand(); % r1 is a random number in [0,1]
            E0=2*r1-1;
            E=E1*E0; % Evading energy
            
            
            if abs(E)<1
                %% EXPLOITATION
                D_male_jackal=abs((RL(i,j)*Male_Jackal_pos(j)-Positions(i,j)));
                Male_Positions(i,j)=Male_Jackal_pos(j)-E*D_male_jackal;
                D_female_jackal=abs((RL(i,j)*Female_Jackal_pos(j)-Positions(i,j)));
                Female_Positions(i,j)=Female_Jackal_pos(j)-E*D_female_jackal;
                
            else
                %% EXPLORATION
                D_male_jackal=abs( (Male_Jackal_pos(j)- RL(i,j)*Positions(i,j)));
                Male_Positions(i,j)=Male_Jackal_pos(j)-E*D_male_jackal;
                D_female_jackal=abs( (Female_Jackal_pos(j)- RL(i,j)*Positions(i,j)));
                Female_Positions(i,j)=Female_Jackal_pos(j)-E*D_female_jackal;
            end
            Positions(i,j)=(Male_Positions(i,j)+Female_Positions(i,j))/2;
            
        end
    end
    l=l+1;
    
    Convergence_curve(l)=Male_Jackal_score;
end
runtime = toc(ct);
end


function [z] = levy(n,m,beta)
num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator

den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator
sigma_u = (num/den)^(1/beta);% Standard deviation
u = random('Normal',0,sigma_u,n,m);

v = random('Normal',0,1,n,m);
z =u./(abs(v).^(1/beta));
end

