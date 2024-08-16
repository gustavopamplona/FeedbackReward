clear 

folderName='D:\Feedback_appraisal\Data';

nsubjs=15;
nruns=10;

% set up the 'waitbar'
h = waitbar(0,sprintf('running %d subjects',nsubjs));

for subj = 1:nsubjs
    if length(num2str(subj))==1
        subjFolder=[folderName filesep 'A0' num2str(subj)];
    else
        subjFolder=[folderName filesep 'A' num2str(subj)];
    end
    
    cumul_c=[];
    for run = 1:nruns
        if length(num2str(run))==1
            rpFile=[subjFolder filesep 'Run0' num2str(run) filesep 'rp_Func.txt'];
        else
            rpFile=[subjFolder filesep 'Run' num2str(run) filesep 'rp_Func.txt'];
        end
        
        fid = fopen(rpFile);
        c=cell2mat(textscan(fid,'%f%f%f%f%f%f'));
        fclose(fid);
        
%         intercept=zeros(size(c,1),nruns-1);
%         if run ~= 1
%             intercept(:,run-1)=1;
%         end
        
%         x=[c intercept];
        cumul_c=[cumul_c;c];
        
        clear c
    end
    
    if length(num2str(subj))==1
        filename=['mult_reg_subj0' num2str(subj) '_2'];
    else
        filename=['mult_reg_subj' num2str(subj) '_2'];
    end
    
    dlmwrite([subjFolder filesep filename '.txt'],cumul_c,'delimiter','\t','precision','%.10f')
    
    waitbar(subj/nsubjs,h)
end

delete(h)