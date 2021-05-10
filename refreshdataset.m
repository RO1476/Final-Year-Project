
d = dlmread('D_c-hilo.txt');
ind = randperm(numel(d));
dpermuted = d(ind);
dlmwrite('D_c-hilop.txt',dpermuted);  


d = dlmread('VM_c-hilo.txt');
ind =  randperm(numel(d));
dpermuted = d(ind);
dlmwrite('VM_c-hilop.txt',dpermuted);
data = load('-ascii','D_c-hilop.txt');
max(data(1:3*5))
for i =1:numel(data)
  i;
  data(i);
endfor