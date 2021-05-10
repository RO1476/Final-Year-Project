#run('equation.m');
#arr = [4 5 6];
#status = xlswrite('test4.xls', 'arr', 'Third_sheet', 'C3:AB40');
%{
fd = fopen('somefile.txt','r');
for i = 1:6
  fscanf(fd,'%d ',[arr i]);
  fprintf(fd, '\n');
endfor
fclose(fd);


%}

Params = zeros(15, 4);
#check budget effect
cnt = 1;
for i = 1:5
  Params(cnt,:) = [3,5,i,3];
  cnt += 1;
endfor
for i = 5:15
  if(mod(i,2)==1) 
    Params(cnt,:) = [3,i,10,3];
    cnt += 1;
  endif;
endfor
for i = 2:5
  Params(cnt,:) = [i,5,10,3];
  cnt += 1;
endfor  
csvwrite('parameters.csv',Params);
ddata = csvread('parameters.csv');
size(ddata)