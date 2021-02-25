% Sets the processed training-data directory
work_dir = '../training/8000_perf_noisy_ex/';

for j=1:10    
    
    % Loads files concerning right target states
    load(strcat(work_dir,'X_right_',int2str(j),'.mat'))
    load(strcat(work_dir,'y_cont_right_',int2str(j),'.mat'))
    X_good=X;
    y_good=y_cont;
    
    % Loads files concerning wrong target states
    load(strcat(work_dir,'X_wrong_',int2str(j),'.mat'))
    load(strcat(work_dir,'y_cont_wrong_',int2str(j),'.mat'))
    X_bad=X;
    y_bad=y_cont;
    
    % Combines both sets of files
    X=[X_good;X_bad];
    y=[y_good;y_bad];
   
    % Saves results
    save(strcat(work_dir,'X_',int2str(j),'.mat'),'X')
    save(strcat(work_dir,'y_',int2str(j),'.mat'),'y')
    
end