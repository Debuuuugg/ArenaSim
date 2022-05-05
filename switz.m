clc;clear ;
win_score = 3;
lose_score = 0;
num = 16;%队伍数
%weight = 0.1;
ability=randn(num,1)/6+0.5;
ability(ability<0|ability>1)=0.5;
%ability = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
%hist(ability,30);


for i = 1:num
    team(i).num = i;
    team(i).ability = ability(i);
    team(i).score = 0;
    team(i).last_rival = 0;
    team(i).relative_win_rate = 0;
    team(i).win = 0;
    team(i).lose = 0;
    team(i).rival_score = 0;
    team(i).star = 1;
    team(i).rival_ability = 0;
end

pair = randperm(fix(num/2));
pair = pair + num/2;
pair = pair';

%初始轮，随机打
for i = 1:fix(num/2)
    team(i).relative_win_rate = team(i).ability/(team(i).ability + team(pair(i)).ability);
    team(i).rival_ability = team(pair(i)).ability + team(i).rival_ability;
    team(pair(i)).rival_ability = team(i).ability + team(pair(i)).rival_ability;
    team(pair(i)).relative_win_rate = 1 - team(i).relative_win_rate;
    seed = rand;
    if team(i).relative_win_rate > seed%team(i).ability > team(pair(i)).ability
        %team(i).star = team(i).star + team(pair(i)).star;%获取对方全部星星
        %team(pair(i)).star = 0;%失去全部星星
        team(i).star = team(i).star + team(pair(i)).star/2;%获取对方一半星星
        team(pair(i)).star = team(pair(i)).star*(1/2);%失去一半星星
        team(i).score = team(i).score + win_score;%胜者加分数
        team(pair(i)).score = team(pair(i)).score + lose_score;%败者加分数
        team(i).win = team(i).win + 1;%加胜场数
        team(pair(i)).lose = team(pair(i)).lose + 1;%加败场数
    else
        %team(pair(i)).star = team(pair(i)).star + team(i).star;%获取对方全部星星
        %team(i).star = 0;%失去全部星星
        team(pair(i)).star = team(pair(i)).star + team(i).star/2;%获取对方一半星星
        team(i).star = team(i).star*(1/2);%失去一半
        team(i).score = team(i).score + lose_score;%败者加分数
        team(pair(i)).score = team(pair(i)).score + win_score;%胜者加分数
        team(i).lose = team(i).lose + 1;%加败场数
        team(pair(i)).win = team(pair(i)).win + 1;%加胜场数
    end   
    team(i).last_rival = team(pair(i)).num;
    team(pair(i)).last_rival = team(i).num;
    team(i).star = team(i).star + 1;
    team(pair(i)).star = team(pair(i)).star + 1;
%     if team(i).ability > team(pair(i)).ability
%         team(i).score = team(i).score + win_score;
%         team(pair(i)).score = team(pair(i)).score + lose_score;
%     else
%         team(i).score = team(i).score + win_score;
%         team(pair(i)).score = team(pair(i)).score + lose_score;
%     end
end

%评估后续轮次
if num <= 2
    loop = 1;
elseif (num > 2)&&(num <= 4)
    loop = 2;
elseif (num > 4)&&(num <= 8)
    loop = 3;
elseif (num > 8)&&(num <= 16)
    loop = 4;
elseif (num > 16)&&(num <= 32)
    loop = 5;
elseif (num > 32)&&(num <= 64)
    loop = 6;
end
    
[temp_score, pos] = sort([team.score], 'descend');
for i = 1:num
   temp = team(i);
   sorted_team(i) = team(pos(i));
   team(pos(i)) = temp;
end

%轮次开始
for j = 1:loop
%     plot([sorted_team.rival_ability]);
    win_score = win_score + 0.1;
    for i = 1:2:num
        sorted_team(i).rival_ability = sorted_team(i + 1).ability + sorted_team(i).rival_ability;
        sorted_team(i + 1).rival_ability = sorted_team(i).ability + sorted_team(i + 1).rival_ability;
        sorted_team(i).relative_win_rate = sorted_team(i).ability/(sorted_team(i).ability + sorted_team(i + 1).ability);
        sorted_team(i + 1).relative_win_rate = 1 - sorted_team(i).relative_win_rate;
        seed = rand;
        
        sorted_team(i).rival_score = sorted_team(i).rival_score + sorted_team(i + 1).score;
        sorted_team(i + 1).rival_score = sorted_team(i + 1).rival_score + sorted_team(i).score;
        
       if sorted_team(i).ability > sorted_team(i + 1).ability%sorted_team(i).relative_win_rate > seed
           %sorted_team(i).star = sorted_team(i).star + sorted_team(i + 1).star;
           %sorted_team(i + 1).star = 0;
           sorted_team(i).star = sorted_team(i).star + sorted_team(i + 1).star/2;
           sorted_team(i + 1).star = sorted_team(i + 1).star*(1/2);
           sorted_team(i).score = sorted_team(i).score + win_score;
           sorted_team(i+1).score = sorted_team(i+1).score + lose_score;
           sorted_team(i).win = sorted_team(i).win + 1;
           sorted_team(i+1).lose = sorted_team(i+1).lose + 1;
       else
           %sorted_team(i + 1).star = sorted_team(i + 1).star + sorted_team(i).star;
           %sorted_team(i).star = 0;
           sorted_team(i + 1).star = sorted_team(i + 1).star + sorted_team(i).star/2;
           sorted_team(i).star = sorted_team(i).star/2;
           sorted_team(i).score = sorted_team(i).score + lose_score;
           sorted_team(i+1).score = sorted_team(i+1).score + win_score;
           sorted_team(i).lose = sorted_team(i).lose + 1;
           sorted_team(i+1).win = sorted_team(i+1).win + 1;
       end
           sorted_team(i).last_rival = sorted_team(i+1).num;
           sorted_team(i+1).last_rival = sorted_team(i).num;
    end
    
    team = sorted_team;
    
    [temp_score, pos] = sort([team.score], 'descend');
    for i = 1:num
       temp = team(i);
       sorted_team(i) = team(pos(i));
       team(pos(i)) = temp;
    end
    
    if j~=loop
        for i = 1:2:num
            sorted_team(i).star = sorted_team(i).star + 1;
            sorted_team(i + 1).star = sorted_team(i + 1).star + 1;
        end
    end
end
% figure(1);%对手水平
% plot([sorted_team.rival_ability]);
% figure(2);%队伍水平
% plot([sorted_team.ability]);
% cov([sorted_team.rival_ability])%对手水平方差
%histogram([sorted_team.rival_ability]);