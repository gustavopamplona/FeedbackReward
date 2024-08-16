% Convert con files to normalized feedback scores - Krause's dataset

% Gustavo Pamplona, 15.03.21

clear

data_folder = 'D:\Feedback_reward\Data\Data_Krause';

subject_folder=dir(data_folder);
subject_folder(1:2)=[];
first_subj=1;

n_subjs = length(subject_folder);

for subj=first_subj:n_subjs
    
    for mode = 1:2
        
        folderName = [data_folder '\' subject_folder(subj).name '\1stLevel_' num2str(mode)];
        folderRenamed = [data_folder '\' subject_folder(subj).name '\1stLevel_' num2str(mode) '_old'];
                
        movefile(folderName,folderRenamed,'f')
        
        newFolder1 = [data_folder '\' subject_folder(subj).name '\1stLevel_' num2str(mode)];
        
        mkdir(newFolder1)
        
        load('D:\Feedback_reward\Analysis\Analysis_Krause\batch_convert_contrast.mat')
        
        matlabbatch{1,1}.spm.util.imcalc.input=[];
        matlabbatch{1,1}.spm.util.imcalc.input=cellstr([folderRenamed '\con_0001.nii']);
        matlabbatch{1,1}.spm.util.imcalc.output = 'con_0001';
        matlabbatch{1,1}.spm.util.imcalc.outdir = cellstr(newFolder1);
        matlabbatch{1,1}.spm.util.imcalc.expression = 'i1/50';
        
        spm_jobman('run',matlabbatch);
        
    end
end