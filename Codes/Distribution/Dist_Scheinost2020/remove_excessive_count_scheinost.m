function [censored_vals]=remove_excessive_count_scheinost(fb_val)

temp_fb_val=fb_val;
censored_vals=repelem({'no'},length(fb_val))';

max_fb_val=max(fb_val);
min_fb_val=min(fb_val);
h=(max_fb_val-min_fb_val)/(100-1); % number of bins in the histogram

binc = min_fb_val:h:max_fb_val;

while 1
    
    counts = hist(temp_fb_val,binc);
    val_count = [binc; counts];
    
    val_count(2,val_count(2,:)==0) = NaN;
    
    excess_vec=val_count>nanmean(val_count(2,:))+2*nanstd(val_count(2,:)); % multiplying factor is only 2 for Amano because of the logistic distribution of feedback values
    
    if nnz(excess_vec(2,:))
        
        excess_fb_val=find(val_count(2,:)==max(val_count(2,:))); % looks for the bins where fb values are excessive
        shuffle_excess_fb_val=excess_fb_val(randperm(length(excess_fb_val))); % shuffles the vector of bins of excessive values
        excess_where=find(temp_fb_val>=val_count(1,shuffle_excess_fb_val(1))-h/2 & temp_fb_val<val_count(1,shuffle_excess_fb_val(1))+h/2); % looks for which trials the excessive values were shown
        shuffle_excess_where=excess_where(randperm(length(excess_where))); % shuffles the vector of trial indexes of excessive values
        temp_fb_val(shuffle_excess_where(1))=nan; % replaces the vector of fb vals with a nan in the first value of shuffle_excess_where
        censored_vals(shuffle_excess_where(1))={'censor'};
        
    else
        break
    end
end



return