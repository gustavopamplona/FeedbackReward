clear
list=[];

data=xlsread('C:\Gustavo\Dropbox\Postdoc\Project7 - Feedback Appraisal\Feedback_values_Jana.xlsx',1);

crossover_vec=data(:,1);
fbvalues_mat=round(data(:,2:end));

n_subj=length(crossover_vec);
n_trials=size(fbvalues_mat,2);

day_val=[ones(n_trials/2,1);2*ones(n_trials/2,1)];
run_val=[repelem((1:4)',9);repelem((1:4)',9)];

for subj=1:n_subj
    
    subj_val=[];
    fb_val=[];
    mode_val=[];
        
    subj_val=subj*ones(n_trials,1);
    fb_val=fbvalues_mat(subj,:)';
    
    if crossover_vec(subj)==1
        mode_val=repelem({'left';'right'},n_trials/2);
    else crossover_vec(subj)==-1
        mode_val=repelem({'right';'left'},n_trials/2);
    end

    [censored_vals]=remove_excessive_count_keller2021(fb_val);
    
    array=[];
    
    array=[num2cell(subj_val) num2cell(day_val) num2cell(run_val) mode_val num2cell(fb_val) censored_vals];
    list=[list;array];
end

names={'subj' 'day' 'run' 'mode' 'fb' 'censored_trials'};

table2write=[names;list];

xlswrite('D:\Feedback_appraisal\Analysis\Distribution\Dist_Keller2021\fbvalues_Keller2021.xlsx',table2write)