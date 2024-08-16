clear
list=[];
censored_vals=[];

n_subj=18;
n_sess=1;
n_runs=3;
n_trials=4;

run_val = repelem((1:n_runs)',2*n_trials);
mode_val=repmat({'happy';'count'}, [n_runs*n_trials,1]);

for subj=1:n_subj
    
    if subj ~= 5 && subj ~= 7
        
        if length(num2str(subj))==1
            fb_folder = ['D:\Feedback_reward\Data\Data_Hellrung\s0' num2str(subj) '\1stLevel_1'];
        else
            fb_folder = ['D:\Feedback_reward\Data\Data_Hellrung\s' num2str(subj) '\1stLevel_1'];
        end
        
        load([fb_folder '\SPM.mat'])
        
        subj_val=[];
        array=[];
        
        subj_val=subj*ones(2*n_runs*n_trials,1);
        fb_val=SPM.Sess.U.P.P;
        
%         if subj == 6
%             1
%         end
        [censored_vals]=remove_excessive_count_hellrung(fb_val);
        
        array=[num2cell(subj_val) num2cell(run_val) mode_val num2cell(fb_val) censored_vals];
        list=[list;array];
        
    end
end

names={'subj' 'run' 'mode' 'fb' 'censored_trials'};

table2write=[names;list];

xlswrite('D:\Feedback_appraisal\Analysis\Distribution\Dist_Hellrung2018\fbvalues_hellrung.xlsx',table2write)