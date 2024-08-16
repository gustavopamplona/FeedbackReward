clear
list=[];
censored_all=[];

for subj=2:11
    
    all_fb_vals=[];
    
    for sess=1:3
        
        if length(num2str(subj))==1
            fb_folder = ['D:\Feedback_reward\Data\Data_Krause\sub-00' num2str(subj) '\ses-mri0' num2str(sess) '\feedback'];
        else
            fb_folder = ['D:\Feedback_reward\Data\Data_Krause\sub-0' num2str(subj) '\ses-mri0' num2str(sess) '\feedback'];
        end
        
        fb_val=[];
        subj_val=[];
        day_val=[];
        run_val=[];
        mode_val=[];
        array=[];
        censored_vals=[];
        for run=1:length(dir(fb_folder))-2
            
            load([fb_folder filesep 'feedback' num2str(run) '.mat'])
            
            fb_val=feedback;
            subj_val=subj*ones(length(feedback),1);
            day_val=sess*ones(length(feedback),1);
            run_val=run*ones(length(feedback),1);
            
            if sess == 1 && run == 1
                mode_val=repmat({'up'}, [length(feedback),1]);
            elseif sess == 1 && run == 2
                mode_val=repmat({'down'}, [length(feedback),1]);
            else
                mode_val=repmat({'up';'down'}, [8,1]);
            end
            
            array=[num2cell(subj_val) num2cell(day_val) num2cell(run_val) mode_val num2cell(fb_val)];
            list=[list;array(1:15,:)];
            
            all_fb_vals=[all_fb_vals;fb_val(1:15)];
            
        end
    end
    
    [censored_vals]=remove_excessive_count_Krause(all_fb_vals);
    censored_all=[censored_all;censored_vals];
    
end

complete_list=[list censored_all];

names={'subj' 'day' 'run' 'mode' 'fb' 'censored_trials'};

table2write=[names;complete_list];

xlswrite('D:\Feedback_reward\Analysis\Analysis_Krause\fbvalues_krause.xlsx',table2write)