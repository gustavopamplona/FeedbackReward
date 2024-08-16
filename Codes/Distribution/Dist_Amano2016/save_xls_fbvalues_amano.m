clear
list=[];
censored_all=[];

n_subj=12;
n_sess=3;
n_trials=15;

for subj=1:n_subj
    
    if length(num2str(subj))==1
        fb_folder = ['D:\Feedback_appraisal\Data_Amano\data\sub-0' num2str(subj)];
        filename_sess1 = ['D:\Feedback_appraisal\Data_Amano\data\sub-0' num2str(subj) '\pattern\in_score_d1.csv'];
        filename_sess2 = ['D:\Feedback_appraisal\Data_Amano\data\sub-0' num2str(subj) '\pattern\in_score_d2.csv'];
        filename_sess3 = ['D:\Feedback_appraisal\Data_Amano\data\sub-0' num2str(subj) '\pattern\in_score_d3.csv'];
    else
        fb_folder = ['D:\Feedback_appraisal\Data_Amano\data\sub-' num2str(subj)];
        filename_sess1 = ['D:\Feedback_appraisal\Data_Amano\data\sub-' num2str(subj) '\pattern\in_score_d1.csv'];
        filename_sess2 = ['D:\Feedback_appraisal\Data_Amano\data\sub-' num2str(subj) '\pattern\in_score_d2.csv'];
        filename_sess3 = ['D:\Feedback_appraisal\Data_Amano\data\sub-' num2str(subj) '\pattern\in_score_d3.csv'];
    end
    
    load(filename_sess1)
    load(filename_sess2)
    load(filename_sess3)
    
    subj_val=[];
    day_val=[];
    run_val=[];
    fb_val=[];
    fb_vec=[];
    array=[];
    censored_vals=[];
    
    k=1;
    
    for sess = 1:n_sess
        
        if sess == 1
            fb_val=in_score_d1;
            day=1;
        elseif sess == 2
            fb_val=in_score_d2;
            day=2;
        else
            fb_val=in_score_d3;
            day=3;
        end
        
        n_runs=length(fb_val)/n_trials;
%         vec_runs = repelem(1:n_runs,n_trials-1);
        vec_runs = repelem(1:n_runs,n_trials);
%         fb_val(n_trials:n_trials:length(fb_val))=[]; % removing the last feedback trial in each run
        
        for trial=1:length(fb_val)
            
            subj_val(k,1)=subj;
            day_val(k,1)=day;
            run_val(k,1)=vec_runs(trial);
            fb_vec(k,1)=fb_val(trial,1);
            
            k=k+1; % rows in the excel file to be saved

        end
    end
    
%     if subj == 10 && sess == 3
%         1
%     end
    
    [censored_vals]=remove_excessive_count_amano(fb_vec);
    censored_all=[censored_all;censored_vals];
    
    array=[subj_val day_val run_val fb_vec];
    list=[list;array];
end

names={'subj' 'day' 'run' 'fb' 'censored_trials'};

list_cell=[num2cell(list) censored_all];

table2write=[names;list_cell];

xlswrite('D:\Feedback_appraisal\Analysis\Distribution\Dist_Amano2016\fbvalues_amano.xlsx',table2write)