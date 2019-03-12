clc
close all

%Last Modified 26/12

format short g;
myRootDir = '/dsk/cha101/COSMIC/Ion_Phs/2009/';
%myRootDir = 'F:\TUB\GFZ\Testv.1';
% fname = 'C:\Users\Ankur\Desktop\January'; 
mySubDirPattern = '*';
myFilePattern = '*.dat';

mySubDirs = dir(fullfile(myRootDir, mySubDirPattern));
numSubDirs = length(mySubDirs);
tic
%Initialization for storing values
% lai=[];
% rri=[];
% adji=[];
% lgi=[];
% lti=[];
% UTi=[];
% namep=[];
% pak=[];
% flg=[];

%Calculating the number of 
FilesNum=[];





%recurse sub-directories
% FileID = fopen('file2712.dat', 'a');
% if FileID==-1
%   error('Cannot open file for writing: %s', file);
%   exit();
% end

% h=['DayofYear','Year','UT','LocalTime','Latitude','Longitude','SNR_{std-max}','Altitude'];
% fprintf(FileID,'%9s %4s %4s %13s %10s %12s %13s %8s %6s\n','DayofYear','Year','UT','LocalTime','Latitude','Longitude','SNR_{std-max}','Altitude','Flag');

% fprintf(FileID,'%4d \t %4d \t %2d \t %02.3g \t % .3f \t %.3f \t %2.4f \t %5g \t %1g\n',M.');



for i = 1:numSubDirs
    %for i = 123:numSubDirs
    

     if(mySubDirs(i).isdir == 1) %myRootDir might have files as well

            currentSubDir = fullfile(myRootDir, mySubDirs(i).name);

            %get all filenames that match myFilePattern
            myFiles = dir(fullfile(currentSubDir, myFilePattern));

            numFiles = length(myFiles);
            
            FilesNum(i)=numFiles;
%            

           %read all files in sub directory
            for k = 1:numFiles
                  fileName = myFiles(k).name;
                  fullFileName = strcat(fullfile(currentSubDir, fileName));
%                   fullFileName=strcat(fileName);
                  file_data = fopen(fullFileName);
                  formatSpec='%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
                  C_temp = textscan(file_data,formatSpec,'headerlines', 1);
    %3d array .. 3rd index for each file.. change accordingly
    try
    C=cell2mat(C_temp);
    catch exception
        continue
    end

                   fclose(file_data);
  
 %For scatter plot
ak=C(:,6);
bk=C(:,7);
ck=bk/15;

    
     
% dat = load('ionPhs_C001.2013.001.16.22.G29_2013.3520.dat');
    C=C(C(:, 5)< 600,:);    %Filter above 600km altitude
    C=C(C(:, 5)> 150,:);
% dat=[];
     if (C(:,5)<600)

        %Defining Arrays

         alt=C(:,5);
         %  alti=dat(:,5);
         %  indices = find(abs(alt)>600);
         %  alt(indices) = NaN;
  
          lat=C(:,6);
          lon=C(:,7); 
          t=lon/15;
% if (t<0);
%     t=t+24;
% else(t>0);
%     t=t;
% end;
 
           UT_time=C(:,1);
           SP=C(1,1);
           %Calculation of Max Dev.
           snr=C(:,16);
           q=mean(snr);           %Mean of SNR
           r=snr/q;               %Normalized SNR
           z=mean(r);
           dev=r-z;
           [~,ii]=max(abs(dev));
           snr_max = dev(ii)  ; 
           xxv=length(alt);
  
                  if xxv>10  
                  
                 
                


%%%%%%%%%%%%%%% Condition for Step Size 0f 10 %%%%%%%%%%%%%%%%%%%%%

                %For Normalised SNR
                vec_len = length(r) - rem(length(r),10);        % Trim To Have Length = Integer Multiple Of 3
                r_new = reshape(r(1:vec_len), 10, []); 
                sd=std(r_new)';
                
                %For Altitude
                vec_len1 = length(alt) - rem(length(alt),10);   % Trim To Have Length = Integer Multiple Of 3
                r_alt = reshape(alt(1:vec_len1), 10, []); 
                alti=mean(r_alt)';
                
                %For Latitude
                vec_len2 = length(lat) - rem(length(lat),10);  
                r_lat = reshape(lat(1:vec_len2), 10, []); 
                lati=mean(r_lat)';

                %For Longitude
                vec_len3 = length(lon) - rem(length(lon),10);  
                r_lon = reshape(lon(1: vec_len3), 10, []); 
                loni=mean(r_lon)';
                
                %For UT_Time
                vec_len4 = length(UT_time) - rem(length(UT_time),10);  
                r_UT_time = reshape(UT_time(1: vec_len4), 10, []); 
                UT_timei=mean(r_UT_time)';
                
                %For Time
                vec_len5 = length(t) - rem(length(t),10);  
                r_t = reshape(t(1: vec_len5), 10, []); 
                ti=mean(r_t)';
                
                if (ti<0);             %For -ve time to +ve
                 ti=ti+24;
                else(ti>0);
                 ti=ti;
                end;

                
                
                rr=max(sd);


%%%%%%%%%%%% Result for above condition  %%%%%%%%%%%%%%%%%%%%%%%%%
                index1 = find(sd == rr);
                
                    try
                      op = [[], index1(1)];
                    catch exception
                        continue
                    end
                
                 
                  %Max Altitude
                  adj = [[], alti(op)];
                
                  %Max Local Time
                  lt = [[], ti(op)];
                  
                  %Max Latitude 
                  la = [[], lati(op)];
               
                  %Max Longitude
                  lg = [[], loni(op)];

                  %Max UT
                  UT = [[], UT_timei(op)];
                  
               nam=str2double(fileName(13:16));
               pk=str2double(fileName(18:20));


% UTi=[UTi,UT];
% lti=[lti,lt];
% lai=[lai,la];
% lgi=[lgi,lg];
% rri=[rri,rr];
% adji=[adji,adj];
% namep=[namep,nam];
% pak=[pak,pk];



%%%%%%%%%%%%%%%%%%%%  Conditions for Plotting %%%%%%%%%%%%%%%%%%%%%%
%         futu= sd(sd(:)>0.09 & sd(:)<0.5);
%      S_4 = [];
index2 = find(sd(:)>0.06 & sd(:)<0.5);
% S_4 = [[], index(1)]

  height = [[], alti(index2)];             %Height corresponding to sd condition 
   
    
     yyy=length(find(sd > 0.006 & sd < 0.5)); %Length of sd with condition

                  if  sd(sd > 0.1 & sd < 0.5) 
           
                      if height(height > 200 & height < 400)
               
                         if yyy(yyy > 14 & yyy < 22)
                             
                             
%                       nam=str2double(fileName(13:16));
%                       pk=str2double(fileName(18:20));
% 
% 
% 
% UTi=[UTi,UT];
% lti=[lti,lt];
% lai=[lai,la];
% lgi=[lgi,lg];
% rri=[rri,rr];
% adji=[adji,adj];
% namep=[namep,nam];
% pak=[pak,pk];








% jpgname = strrep(fileName, '.', '_');
% saveas(gcf, fullfile(fname, jpgname), 'jpeg');
% save('file.dat','M','-ascii','-tabs')
                         T_m=true;
                         else
%                           T_m=false
                         end    

                        

                      else
                      end
                      

                  else 
                     T_m=false;
                  end
       
%                   flg=[flg,km];
                        try
                          M=[pk;nam;UT; lt; la ;lg; rr; adj; T_m];
                        catch exception
                           continue
                        end
                  M=M';
                  save('new_2009.dat','M','-append','-ascii','-tabs')
%                   fprintf(FileID,'%4d \t %4d \t %2d \t %02.3g \t % .3f \t %.3f \t %2.4f \t %5g \t %1g\n',M.');
                  
                  else
                  end
% 
     else
     end
    


 clear C_temp C snr fileName q r z fullFileName file_data alt UT_time SP snr_max dev
 fclose('all');
            end

%            

    end
i
clearvars -except myRootDir mySubDirPattern myFilePattern numSubDirs mySubDirs FileID FilesNum tic toc M
end

% M=[pak;namep;UTi; lti; lai ;lgi; rri; adji; flg];
% M=M';

%To check if the file is open
% FileID = fopen('file2.dat', 'w');
% if FileID==-1
%   error('Cannot open file for writing: %s', file);
%   exit();
% end
% 
% h=['DayofYear','Year','UT','LocalTime','Latitude','Longitude','SNR_{std-max}','Altitude'];
% fprintf(FileID,'%9s %4s %4s %13s %10s %12s %13s %8s %6s\n','DayofYear','Year','UT','LocalTime','Latitude','Longitude','SNR_{std-max}','Altitude','Flag');
% 
% fprintf(FileID,'%4d \t %4d \t %2d \t %02.3g \t % .3f \t %.3f \t %2.4f \t %5g \t %1g\n',M.');

% fclose(FileID);
FilesNum=sum(FilesNum)-1;
toc
