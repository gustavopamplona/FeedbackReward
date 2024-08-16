clear

data_folder='D:\Feedback_reward\Data\Data_Amano';
roi_folder = 'D:\Feedback_reward\Analysis\ROI_analysis\ROIs';

listROIs=dir([roi_folder filesep '*.mat']);

n_rois=16;
n_models = 4;
n_studies = 1;
first_subj=1;

labels={'subj' 'contrast' 'tValue' 'study'};
study_str = 'Amano';

for model = 4
    
    for roi = 1:n_rois
        
        Z=[];
        
        subject_folder=dir(data_folder);
        subject_folder(1:2)=[];
        n_subj=length(subject_folder);
        
        roi_file=[roi_folder filesep listROIs(roi).name];
        R  = maroi(roi_file); % Make marsbar ROI object
        
%         if length(num2str(roi))==1
%             roiName = ['roi0' num2str(roi)];
%         else
%             roiName = ['roi' num2str(roi)];
%         end
        
        for subj=1:n_subj
            
            disp(['Running ROI analysis for Model ' num2str(model) ', ROI ' num2str(roi) ' and Subject ' num2str(subj)]);
            
            if model == 1
                folderModel = '1stLevel_1';
            elseif model == 2
                folderModel = '1stLevel_1\PPI';
            elseif model == 3
                folderModel = '1stLevel_2';
            elseif model == 4
                folderModel = '1stLevel_2\PPI';
            end
                
            spmFile=[data_folder filesep subject_folder(subj).name filesep folderModel filesep 'SPM.mat'];
            
            D  = mardo(spmFile); % Make marsbar design object
            D = autocorr(D, 'fmristat', 1); % https://marsbar-toolbox.github.io/faq.html#i-get-errors-using-the-spm-reml-estimation-for-fmri-designs-can-i-try-something-else
            Y  = get_marsy(R, D, 'mean'); % Fetch data into marsbar data object
            xCon = get_contrasts(D); % Get contrasts from original design
            E = estimate(D, Y); % Estimate design on ROI data
            E = set_contrasts(E, xCon); % Put contrasts from original design back into design object
            b = betas(E); % get design betas
            marsS = compute_contrasts(E, 1); % get stats and stuff for all contrasts into statistics structure
            
            X=[num2cell(subj) num2cell(marsS.con) num2cell(marsS.stat) cellstr(study_str)];
            Z=[Z;X];
            
            clear X b E D Y
            
        end
        
        Z=[labels;Z];
        xlswrite(['D:\Feedback_reward\Analysis\ROI_analysis\tables\table_model' num2str(model) '_roi' num2str(roi) '_Amano.xlsx'],Z);
        
    end
    
    clear Z

end