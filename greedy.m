#Get N,M,B,R
Parameters = csvread('parameters.csv');
Output = [];
Parameters(1,:);

function res = get_lowest_processing(t,w,processing_over,i,M)
  val = inf;
  for j = 1:M
    if(processing_over(j)!=1 && val > t(i,j)/w(i,j))
      val = t(i,j)/w(i,j);
      res = j;
    endif
  endfor
endfunction

size(Parameters)(1)
for iter = 1:size(Parameters)(1)
  iter
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

  #coef = X(:);
  #coef = coef';

  #coef;
  #
  W;

#{
  All tasks are sorted in the non-decreasing
  order of weighted local processing time tj/wj
  for all j, and each task is scheduled in this 
  order onto the processor where it meets its 
  user’s budget and has the fastest processing time.
  
#}

  completion_time = 0;
  for i = 1:N
    curr_budget = 0;
    max_budget = B(i);
    processing_over = zeros(1,M);
    al = alpha(i,:);
    [b I] = sort(al,'ascend');
    for var = 1:M
      #get the unfinished task with the lowest processing time - j
      j = get_lowest_processing(t,W,processing_over,i,M);
      #schedule it such that it has fastest processing time and budget is not violated
      for r = 1:R
        if(beta(I(r))*alpha(I(r))*t(i,j) + curr_budget <= max_budget)
          curr_budget += beta(I(r))*t(i,j)*alpha(I(r));
          completion_time += alpha(I(r))*W(i,j)*t(i,j);
          i
          j
          I(r)
          break;
        endif
      endfor
      processing_over(j) = 1;
    endfor
  endfor
  Output(iter) = completion_time;
endfor
Output = Output'
csvwrite('Outputgreedy.csv',Output);