clear
list=[];

data=xlsread('C:\Gustavo\Dropbox\Postdoc\Project7 - Feedback Appraisal\Feedback_values_Jana.xlsx',3);

crossover_vec=data(:,1);
fbvalues_mat=round(data(:,2:end));

n_subj=length(crossover_vec);
n_trials=size(fbvalues_mat,2);
% n_trials=64;

day_val=[ones(n_trials/2,1);2*ones(n_trials/2,1)];
run_val=[repelem((1:4)',9);repelem((1:4)',9)];
% run_val=[repelem((1:4)',8);repelem((1:4)',8)];

for subj=1:n_subj
    
    subj_val=[];
    fb_val=[];
    mode_val=[];
        
    subj_val=subj*ones(n_trials,1);
    fb_val=fbvalues_mat(subj,:)';
%     fb_val(9:9:end)=[];
    
    if crossover_vec(subj)==1
        mode_val=repelem({'up';'down'},n_trials/2);
    else
        mode_val=repelem({'down';'up'},n_trials/2);
    end

    if subj ~= 33
        [censored_vals]=remove_excessive_count_zweerings2019(fb_val);
    end
    
    array=[];
    
    array=[num2cell(subj_val) num2cell(day_val) num2cell(run_val) mode_val num2cell(fb_val) censored_vals];
    list=[list;array];
end

names={'subj' 'day' 'run' 'mode' 'fb' 'censored_trials'};

table2write=[names;list];

xlswrite('D:\Feedback_reward\Analysis\Analysis_Zweerings2019\Dist_Zweerings2019\fbvalues_zweerings2019.xlsx',table2write)