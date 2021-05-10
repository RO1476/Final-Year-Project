  #IN Xijrl, r includes cloud+local so keep index 0 or last for representing local
#Get N,M,B,R
Parameters = csvread('parameters.csv');
Output = [];
Parameters(1,:);
size(Parameters)(1)
for iter = 1:size(Parameters)(1)
  iter
  if(iter==15 || iter==14 || (iter >= 6 && iter <=11))
    continue;
  endif
  #Parameters(1,:)(4)
  #disp('check');
  N = Parameters(iter,:)(1); 
  M = Parameters(iter,:)(2);
  #disp('check');
  B = Parameters(iter,:)(3);
  R = Parameters(iter,:)(4);
  #disp('check');
  data = load('-ascii','D_c-hilop.txt');
  size(data);
  int64(data(1))
  t = zeros(N,M);
  #task_ind = int64(myrand1(1,size(data)(1), N*M))
  cnt = 1;
  for i = 1:N
    for j = 1:M
      t(i,j) = data(cnt)/max(data(1:N*M))*10;
      cnt += 1;
    endfor
  endfor
  t;

  data = load('-ascii','VM_c-hilop.txt');
  size(data)
  int64(data(1));
  alpha = zeros(N,R-1);
  #proc_ind = int64(myrand1(1,size(data)(1), N*(R-1)))
  cnt = 1;
  max(data)
  iter
  N
  R
  for i = 1:N
    for j = 1:R-1
      max(data)
      #data(proc_ind(cnt))
      alpha(i,j) = data(mod(cnt,size(data)(1)-1)+1)/max(data);
      cnt += 1;
    endfor
  endfor
  alpha;
  local_ps = ones(N,1);
  alpha = horzcat(alpha,local_ps);



  #^^speed-up factor alpha
  #alpha = randi([5,15],N,R-1);
  #can uncomment for random dataset
  %{
  alpha = myrand2(0,1,N,R-1);
  local_ps = ones(N,1);
  alpha = horzcat(alpha,local_ps)
  %}
  #Here R=>Cloud Processors only(no local)

  #utilization cost beta
  #beta = randi([1,2],1,R-1);
  beta = myrand1(1,2,R-1);
  beta(R) = 0;#local_cost
  beta
  #Here R=>Cloud Processors only(no local)

  #t - local processing time of task 
  #t = randi([3,7],N,M)
  #t = myrand2(1,5,N,M)#can uncomment for random dataset

  sum(sum(t))
  L = getL(t)

  #Budget of each User
  #B = randi([1,60],1,N)
  #B = myrand1(1,10,N)#recently commented
  B = B*ones(N)
  
  #xav = reshape(C1_l,1,N*M*N*M*R*L)


  #weights
  #W = randi([1,2],N,M);#Uncomment below and comment this!
  W = myrand2(1,1,N,M);
  W
  iter
  #data = load('-ascii','D_c-hilo.txt');


  #varibles
  #X = zeros(N,M,R,L);
  X = zeros(1,L*R*M*N);#new change
  
  
  #MEMORY REQUIREMENTS of A TASK
  m_req = myrand2(100,400,N,M)
  #MEMORY CAPACITY of A PROCESSOR
  M_Capacity = myrand1(500,1000,R)

  cnt = 0;
  for i = 1:N
    for j = 1:M
      for r = 1:R
        for l = 1:L
          cnt += 1;
          #X(i,j,r,l) = Tau(l-1) * W(i,j);
          X(cnt) = Tau(l-1) * W(i,j);
        endfor
      endfor
    endfor
  endfor



  #Constraint 1 aka equation 2

  
  temp = [];
  CNT = 0;
  for I = 1:N#2
    for J = 1:M #2
      CNT += 1;
      C1_l = zeros(1,L*R*M*N);
      cnt = 0;
      for i = 1:N
        for j = 1:M
          for r = 1:R
            for l = 1:L
              cnt += 1;
              if(I == i && J==j)
                C1_l(cnt) = 1;
              endif
            endfor
          endfor
        endfor
      endfor
      #Y = horzcat(Y,C1_l)
      temp(CNT,:) = C1_l;
    endfor
  endfor
  C1_l = temp;
  C1_l(3,:);

  C1_r = ones(N*M,1);
  C1_m = getconcat("S", N*M);





  #Constraint 2 aka equation 3

  temp = [];


  #R=>Cloud+local
  #make C2_l double also others like alpha as well
  cnt1 = 0;
  for r_ = 1:R
    for l_ = 1:L    
      C2_l = zeros(1,N*M*R*L);
      cnt2 = 0;
      for i = 1:N
        for j = 1:M
          for r = 1:R
            for l = 1:L
              cnt2 += 1;
              if(r_ == r && l_ == l)
                C2_l(cnt2) = alpha(i,r)*t(i,j);
              endif
            endfor
          endfor
        endfor
      endfor
      cnt1 += 1; 
      temp(cnt1,:) = C2_l;
    endfor
  endfor
  C2_l = temp;
  C2_l(11,:);
  #reshape C2-l
  cnt1 = 0;
  C2_r = ones(R*L,1);
  for r = 1: R
    for l = 1:L
      cnt1 += 1;
      C2_r(cnt1) = Tau(l);
    endfor
  endfor
  #also create <= sign array for constraint 2 and 3
  C2_r; #= reshape(C2_r,R*L,1)
  #Check c2r
  C2_m = getconcat("U",R*L);





  #Constraint 3 -- equation 4
  #C3_l = zeros(N,N,M,R,L);
  temp = [];
  cnt1 = 0;
  for I = 1:N
    C3_l = zeros(1,N*M*R*L);
    cnt2 = 0;
    for i = 1:N
      for j = 1:M
        for r = 1:R
          for l = 1:L
            cnt2 += 1;
            if(I == i)
              C3_l(cnt2) = beta(r)*alpha(i,r)*t(i,j);
            endif
          endfor
        endfor
      endfor
    endfor
    cnt1 += 1;
    temp(cnt1,:) = C3_l;
  endfor
  #reshape C3_l
  C3_l = temp;
  C3_r = ones(N,1);
  for i = 1:N
    C3_r(i) = B(i);
  endfor
  C3_l(2,:);
  C3_r;

  C3_m = getconcat("U",N);

  #reshape C3_r?




  #Equation 5 + 6
  #C4_l = zeros(N,M,R,L,N,M,R,L);
  #^** Here R stands for cloud+local
  temp = [];
  cnt1 = 0;
  for i_ = 1:N
    for j_ = 1:M
      for r_ = 1:R# R=>C
        for l_ = 1:L
          C4_l = zeros(1,N*M*R*L);
          cnt2 = 0;
          for i = 1:N
            for j = 1:M
              for r = 1:R
                for l = 1:L
                  cnt2 += 1;
                  if(i_ == i && j_== j && r_ == r && l_ == l && Tau(l) < alpha(i,r)*t(i,j))
                    C4_l(cnt2) = 1;
                  endif
                endfor
              endfor
            endfor
          endfor
          cnt1 += 1;
          temp(cnt1,:) = C4_l;
        endfor
      endfor
    endfor
  endfor
  #reshape C4_l
  C4_l = temp;
  C4_l(11,:);

  C4_r = zeros(N*M*R*L,1);
  #C4_r = reshape(C4_r,N,M,R,L,N*M*R*L);
  size(C4_r);

  C4_m = getconcat("S",N*M*R*L);

  #Equation 7

  temp = [];
  cnt1 = 0;
  for i_ = 1:N
    for j_ = 1:M
      for r_ = 1:R# R=>C
        for l_ = 1:L
          C5_l = zeros(1,N*M*R*L);
          cnt2 = 0;
          for i = 1:N
            for j = 1:M
              for r = 1:R
                for l = 1:L
                  cnt2 += 1;
                  if(i_ == i && j_== j && r_ == r && l_ == l && B(i) < beta(r)*alpha(i,r)*t(i,j))
                    C5_l(cnt2) = 1;
                  endif
                endfor
              endfor
            endfor
          endfor
          cnt1 += 1;
          temp(cnt1,:) = C5_l;
        endfor
      endfor
    endfor
  endfor

  C5_l = temp;
  C5_l(7:11,:);
  C5_l(11,:);

  C5_r = zeros(N*M*R*L,1);
  C5_r;
  size(C5_r);
  C5_m = getconcat("S",N*M*R*L);


  #MEMORY CONSTRAINTS
  #Memory requirements of each task



  temp = [];


  #R=>Cloud+local
  #make C2_l double also others like alpha as well
  cnt1 = 0;
  for r_ = 1:R
    for l_ = 1:L    
      C6_l = zeros(1,N*M*R*L);
      cnt2 = 0;
      for i = 1:N
        for j = 1:M
          for r = 1:R
            for l = 1:L
              cnt2 += 1;
              if(r_ == r && l_ == l)
                C6_l(cnt2) = m_req(i,j);
              endif
            endfor
          endfor
        endfor
      endfor
      cnt1 += 1; 
      temp(cnt1,:) = C6_l;
    endfor
  endfor
  C6_l = temp;
  C6_l(1,:)
  C6_l(3,:);
  cnt1 = 0;
  C6_r = ones(R*L,1);
  for r = 1:R
    for l = 1:L
      cnt1 += 1;
      C6_r(cnt1) = M_Capacity(r);
    endfor
  endfor
  size(C6_r);
  #also create <= sign array for constraint 2 and 3
  C6_r; #= reshape(C2_r,R*L,1)
  #Check c2r
  C6_m = getconcat("U",R*L);

  size(C6_m);

  #individual task memory constraint

  temp = [];
  cnt1 = 0;
  for i_ = 1:N
    for j_ = 1:M
      for r_ = 1:R# R=>C
        for l_ = 1:L
          C7_l = zeros(1,N*M*R*L);
          cnt2 = 0;
          for i = 1:N
            for j = 1:M
              for r = 1:R
                for l = 1:L
                  cnt2 += 1;
                  if(i_ == i && j_== j && r_ == r && l_ == l && M_Capacity(r) < m_req(i,j))
                    C7_l(cnt2) = 1;
                  endif
                endfor
              endfor
            endfor
          endfor
          cnt1 += 1;
          temp(cnt1,:) = C7_l;
        endfor
      endfor
    endfor
  endfor
  #reshape C7_l
  C7_l = temp;
  size(C7_l);
  C7_r = zeros(N*M*R*L,1);


  size(C7_r);

  C7_m = getconcat("S",N*M*R*L);



  #Equation 8

  lower_bound = zeros(N*M*R*L,1);
  upper_bound = ones(N*M*R*L,1);
  size(lower_bound);
  size(upper_bound);

  #Combining C1-C5;
  size(C1_l);
  size(C2_l);
  size(C3_l);
  size(C4_l);
  size(C5_l);
  size(C6_l);
  A = [C1_l;C2_l;C3_l;C4_l;C5_l;C6_l;C7_l];
  b = [C1_r;C2_r;C3_r;C4_r;C5_r;C6_r;C7_r];
  #([size(C1_l),size(C2_l),size(C3_l),size(C4_l),size(C5_l)])
  ctype = strcat(C1_m,C2_m,C3_m,C4_m,C5_m,C6_m,C7_m);
  ctype;
  #vartype = getconcat("I",(size(ctype))(2));#integer or continuos
  vartype = getconcat("I",N*M*R*L);
  s = 1;#minimization
  param.msglev = 3;
  param.itlim = 10000;
  [xmin, fmin, status, extra] = glpk (X, A, b, lower_bound, upper_bound, ctype, vartype, s, param);

  xmin
  fmin
  Output(iter) = fmin;
  cnt = 0;
  for i = 1:N
    for j = 1:M
      for r = 1:R
        for l = 1:L
          cnt += 1;
          if(xmin(cnt) != 0)
            i
            j
            r
            l
            xmin(cnt)
          endif;
        endfor
      endfor
    endfor
  endfor


  iter
endfor
Output = Output';
csvwrite('BasicILPm.csv',Output);
