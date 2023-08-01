

%% load cell array that contains time series from REM states (these cell arrays are called "REM_single")

%% Organize single time series into epoched arrays each epoch lasting 30 sec (15000 samples)

% take REM series out of the cell array T7:

for i = 1:length(REM_single.REM_T7)
        REM_T7 (i) = REM_single.REM_T7(i,1);
end

% organize single arrays into a matrix with 30 sec multiple trials 

for i = 1: length(REM_T7) 
      irange = 1:15000:length(REM_T7{1,i})-15000;
         for j=1:length(irange)
             m = irange(j);
        REM_T7m {1,i}(j,:)  = REM_T7{1,i}(m:(m+14999));
         end
     
end
   
% Put all 30 sec REM series together

REM_T7m = vertcat(REM_T7m{:});

%%%%%%%%%%%%%%%%%%

% take REM series out of the cell array T8:

for i = 1:length(REM_single.REM_T8)
        REM_T8 (i) = REM_single.REM_T8(i,1);
end

% organize single arrays into a matrix with 30 sec multiple trials 

for i = 1: length(REM_T8) 
      irange = 1:15000:length(REM_T8{1,i})-15000;
         for j=1:length(irange)
             m = irange(j);
        REM_T8m {1,i}(j,:)  = REM_T8{1,i}(m:(m+14999));
         end
     
end

% Put all 30 sec REM series together

REM_T8m = vertcat(REM_T8m{:});



%% Output
output.REM_T7 = REM_T7m;
output.REM_T8 = REM_T8m;
REM_multiple = output; 

clearvars -except REM_multiple

% save REM_multiple structure array for the next step

%% end 



    
    