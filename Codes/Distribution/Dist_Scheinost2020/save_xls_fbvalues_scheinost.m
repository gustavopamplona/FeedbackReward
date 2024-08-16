clear
list=[];
censored_vals=[];

n_subj=20;
n_sess=1;
n_runs=3;
n_trials=4;

sham_val0=repmat({'yes'}, [n_runs*n_trials,1]);
sham_val1=repmat({'no'}, [n_runs*n_trials,1]);

file_folder='D:\Feedback_appraisal\Data_Dustin\behav\';

for subj=1:n_subj
    
    fb_val=[];
    subj_val=[];
    run_val=[];
    
    for run=1:n_runs
        
        if rem(subj,2)
            sham_idx='1';
            sham_cell=sham_val1;
        else
            sham_idx='0';
            sham_cell=sham_val0;
        end
        
        fb_file = [file_folder 'RealTime' sham_idx '_BehavData_Sub' num2str(subj) '_Run' num2str(run) '_share.mat'];
        
        load(fb_file)
        
        fb_val=[fb_val; network_strength_rank];
        run_val=[run_val;run*ones(n_trials,1)];
        
    end
    
    subj_val=subj*ones(length(fb_val),1);
    
    array=[];
        
    [censored_vals]=remove_excessive_count_scheinost(fb_val);
    
    array=[num2cell(subj_val) num2cell(run_val) sham_cell num2cell(fb_val) censored_vals];
    list=[list;array];
    
end

names={'subj' 'run' 'sham' 'fb' 'censored_trials'};

table2write=[names;list];

xlswrite('D:\Feedback_appraisal\Analysis\Distribution\Dist_Scheinost2020\fbvalues_scheinost.xlsx',table2write)