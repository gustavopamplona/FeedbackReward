clear

folderName='D:\Feedback_reward\Data\Data_Amano';

nsubjs=12;
nsess=3;
nruns_max=12;

for subj = 6
    if length(num2str(subj))==1
        subjFolder=[folderName filesep 'sub-0' num2str(subj)];
    else
        subjFolder=[folderName filesep 'sub-' num2str(subj)];
    end
    
    cumul_x=[];
    n_run=0;
    
    for sess = 1:nsess
        for run = 1:nruns_max
            if length(num2str(subj))==1
                rpFile=[subjFolder filesep 'func' filesep 'ses-' num2str(sess) filesep 'sub-0' num2str(subj) '_task-nfb_bold_run-' num2str(run) '.nii'  filesep 'rp_aday' num2str(sess) '-run' num2str(run) '.txt'];
            else
                rpFile=[subjFolder filesep 'func' filesep 'ses-' num2str(sess) filesep 'sub-' num2str(subj) '_task-nfb_bold_run-' num2str(run) '.nii'  filesep 'rp_aday' num2str(sess) '-run' num2str(run) '.txt'];
            end
            
            if exist(rpFile, 'file') == 2
                n_run=n_run+1;
                fid = fopen(rpFile);
                c=cell2mat(textscan(fid,'%f%f%f%f%f%f'));
                fclose(fid);
                cumul_x=[cumul_x;c];
            end
        end
    end
    
    final_mat=cumul_x;
    
    if length(num2str(subj))==1
        filename=['mult_reg_subj0' num2str(subj)];
    else
        filename=['mult_reg_subj' num2str(subj)];
    end
    
    dlmwrite([subjFolder filesep filename '.txt'],final_mat,'delimiter','\t','precision','%.10f')
    
    clear cumul_x intercept final_mat valid_run
end