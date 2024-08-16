clear
list=[];

data=xlsread('C:\Gustavo\Dropbox\Postdoc\Project7 - Feedback Appraisal\Feedback_values_Jana.xlsx',2);

fbvalues_mat=round(data);

n_subj=size(data,1);
n_trials=size(fbvalues_mat,2);

run_val=[repelem((1:2)',9)];

for subj=1:n_subj
    
    subj_val=[];
    fb_val=[];
    mode_val=[];
        
    subj_val=subj*ones(n_trials,1);
    fb_val=fbvalues_mat(subj,:)';

    [censored_vals]=remove_excessive_count_zweerings2020(fb_val);

    array=[];
    
    array=[num2cell(subj_val) num2cell(run_val) num2cell(fb_val) censored_vals];
    list=[list;array];
end

names={'subj' 'run' 'fb' 'censored_trials'};

table2write=[names;list];

xlswrite('D:\Feedback_appraisal\Analysis\Distribution\Dist_Zweerings2020\fbvalues_zweerings2020.xlsx',table2write)