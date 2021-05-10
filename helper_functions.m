function helper_functions
  #returns uniformly distributed random 2d array(n,m) between A and B
  function x = myrand2(A, B, n, m)
    x = A + (B - A)*rand(n,m);
  endfunction

  #returns uniformly distributed random 1d array(n) between A and B
  function x = myrand1(A, B, n)
    x = A + (B - A)*rand(1,n);
  endfunction


  #returns L-value based on the processing time-t
  function l = getL(t)
    l = 1;
    t = sum(sum(t));
    while pow2(l) < t
      l += 1;
    endwhile
  endfunction
endfunction