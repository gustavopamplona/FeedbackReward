% fMRI preprocessing of Feedback Reward Study - Scheinost data

% Gustavo Pamplona, 26.07.2022

clear

data_folder='D:\Feedback_reward\Data\Data_Scheinost\MRI';

n_sess=1;
n_runs=3;

subject_folder=dir(data_folder);
subject_folder(1:2)=[];
n_subj=length(subject_folder);
first_subj=3;

for subj=19
    
    for sess=1:n_sess
        
        for run=2
            
            subject_folder(subj).name
            sess
            run
            
            anat_source=[data_folder filesep subject_folder(subj).name filesep 'anat'];
            func_source=[data_folder filesep subject_folder(subj).name filesep 'func\Run' num2str(run)];
            
            func_path{1,:}=func_source;
            
            %anat
            anat_files=dir(anat_source);
            anatName=[anat_source '\' anat_files(3).name];
            anat_cell{1,1}=char(anatName);
            
            %func
            if exist(char(func_path))
                funcFiles=dir(char(func_path));
                funcfile=funcFiles(3).name;
                funcName=[func_source '\' funcfile];
                
                for j=1:length(spm_vol(funcName))
                    func_cell{1,1}{j,1}=char([funcName ',' num2str(j)]);
                end
                
                load('D:\Feedback_reward\Analysis\Analysis_Scheinost\batch_preprocessing_FbReward_Scheinost.mat')
                
                % batch
                matlabbatch{1,1}.spm.temporal.st.scans{1,1}=func_cell{1,1};
                matlabbatch{1,3}.spm.spatial.coreg.estimate.source=anat_cell;
                
                spm_jobman('run',matlabbatch);
                
                clear func_cell
            end
        end
    end
end