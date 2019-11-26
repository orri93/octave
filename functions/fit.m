function [linx, liny] = fit(time, temperature)

  # Initialize time vectors
  time_squared = [];
  time_cube = [];
  time_fourth = [];
  time_fifth = [];
  time_sixth = [];
  
  time_reduced = [];
  temperature_reduced = [];
  
  count = min(length(time), length(temperature));
  
  for i = 1:count
    temperature_reduced(i) = temperature(i);
    time_reduced(i) = time(i);
    time_squared(i) = time_reduced(i)**2;
    time_cube(i) = time_reduced(i)**3;
    time_fourth(i) = time_squared(i)**2;
    time_fifth(i) = time_squared(i) * time_cube(i);
    time_sixth(i) = time_cube(i)**2;
  endfor
  
  # Get the sum of the filled vectors above and put it in the time_vector
  time_vector = [];
  time_vector(end+1) = sum(time_reduced);
  time_vector(end+1) = sum(time_squared);
  time_vector(end+1) = sum(time_cube); 
  time_vector(end+1) = sum(time_fourth);
  time_vector(end+1) = sum(time_fifth);
  time_vector(end+1) = sum(time_sixth);

  # Initialize the matrix A
  A = zeros(4,4);
  
  # Build the A matrix using the time_vector (Note: Ax = b)
  A(1,1) = length(time_reduced);
  A(1,2:end) = time_vector(1:3);
  A(2,1:end) = time_vector(1:4);
  A(3,1:end) = time_vector(2:5);
  A(4,1:end) = time_vector(3:6);

  # Build the b matrix 
  b = [];
  b(end+1) = sum(temperature_reduced);
  b(end+1) = sum(time_reduced(1:end) .* temperature_reduced(1:end));
  b(end+1) = sum(time_squared(1:end) .* temperature_reduced(1:end));
  b(end+1) = sum(time_cube(1:end) .* temperature_reduced(1:end));
  b = b.';
  
  # Use Cholesky Decomposition to get a0, a1, a2, a3
  # Get L and D in the LDL'   
  # reference: mathworks.com/matlabcentral/fileexchange/47-ldlt?focused=5033716&tab=function
  n = size(A,1);
  L = zeros(n,n);
  for j=1:n,
    if (j > 1),
      v(1:j-1) = L(j,1:j-1).*d(1:j-1);
      v(j) = A(j,j)-L(j,1:j-1)*v(1:j-1)';
      d(j) = v(j);
      if (j < n),
        L(j+1:n,j) = (A(j+1:n,j)-L(j+1:n,1:j-1)*v(1:j-1)')/v(j);
      endif
    else
      v(1) = A(1,1);
      d(1) = v(1);
      L(2:n,1) = A(2:n,1) / v(1);    
    endif
  endfor
  
  D=diag(d);
  L=L+eye(n);
  
  # Ly = b
  # Solve for y
  y = L\(b);
  
  # DL.'x = y
  # Solve for x
  x = (D*L.')\(y);
  
  # Flip the x polynomial produced to fit the polynomial format
  poly = flip(x);
  
  L_transpose = L.'
  
  # Get first derivative of polynomial generated
  first_derivative = polyder(poly.');
  
  # Get second derivative of the polynomial generated
  second_derivative = polyder(first_derivative);
  
  % The following lines are responsible for the plotting of graphs
  # Create list of x coordinates
  linx = linspace(min(time_reduced), max(time_reduced));
  
  # Evaluate the polynomial with the created list of x coordinates
  liny = evalpoly(poly, linx(:));
  
endfunction
