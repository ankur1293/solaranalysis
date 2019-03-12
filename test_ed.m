clc
clear
close all


%Loading s4
x=load('01Jan14.dat');




%%%Comvert decimal time in actual time
% f=z(:,3);
% integ=fix(z(:,3));
% decim=z(:,3)-integ;
% decim=decim.*0.6;
% z(:,3)=integ+decim;







%Loading IonPrf
myRootDir ='F:\TUB\GFZ\ele_dens\01';
% Get a list of all files in the folder with the desired file name pattern.
myfilePattern = fullfile(myRootDir, '*.dat'); % Change to whatever pattern you need.
theFiles = dir(myfilePattern);

% for i=1:4%length(theFiles)
 for i=274:274
 fileName = theFiles(i).name;  
 fullFileName = fullfile(myRootDir, fileName);

 file_data = fopen(fullFileName);
 formatSpec='%f %f %f %f %f %f %f ';
 C_temp = textscan(file_data,formatSpec);
 C=cell2mat(C_temp);
 fclose( file_data);
 
 doy=str2double(fileName(18:20)); 
 sat_id=str2double(fileName(9:11));
 gps_id=str2double(fileName(29:30));
 UT=str2double(fileName(22:23))+(str2double(fileName(25:26))/100);



 
%%%%%%%%%%%%%%%% Condition for COSMIC sat %%%%%%%%%%%%%%
% Find min distance =0
distances = pdist2( x(:,9), sat_id);
index=find(distances==0);
[minVRow, ~] = ind2sub(size(distances), index);

%New file 
x1=x(minVRow,:); 



% %%%%%% COnditions for GPS satellite  %%%%%%%%%%%%
% 
% 
% distances = pdist2(x1(:,10), gps_id);
% index=find(distances<0.05);
% [minVRow, ~] = ind2sub(size(distances), index);
% 
% %New file 
% x1=x1(minVRow,:); 


%%%%%% COnditions for UT   %%%%%%%%%%%%


distances = pdist2(x1(:,3), UT);
index=find(distances<0.05);
[minVRow, ~] = ind2sub(size(distances), index);

%New file 
x1=x1(minVRow,:); 


%%%%%%Conditions for Latitude 

distances = pdist2(x1(:,5), C(:,4));
index=find(distances<0.5);
[minVRow, ~] = ind2sub(size(distances), index);

%New file 
x1=x1(minVRow,:); 
x1=unique(x1,'rows');

    if size(x1,1)>=1

    fid = fopen('ListofIonPrf.txt','a+');
    fprintf(fid, '%s\n', fileName);
    fclose(fid);
    
    
    save('ListofIonPhs.dat','x1','-ascii','-tabs')
        
        
    end


 
 
 
 
 
 
end
