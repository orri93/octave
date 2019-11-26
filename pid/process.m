#
# A tutorial on how to curve/data fit a set of data points using
# Least Squares Fitting in GNU Octave
#
# https://medium.com/@richdayandnight/a-tutorial-on-how-to-curve-data-fit-a-set-of-data-points-using-least-squares-fitting-in-gnu-octave-3a6d36dc360c
# https://github.com/richdayandnight/Tutorial_CurveFitting


data = csvread("C:/temp/pid/november/latest.csv");

count = rows(data);

half = count / 2;

range = 1:half;

#plot(data(range,2), data(range,3), data(range,4));

manual = [];
temperature = [];

# Initialize time vectors
time = [];
time_squared = [];
time_cube = [];
time_fourth = [];
time_fifth = [];
time_sixth = [];

# Output matrix
output = zeros(half,4);

start = data(1,1);
for i = range
  time(i) = (data(i,1) - start) / 1000;
  manual(i) = data(i,3);
  temperature(i) = data(i,4);
  output(i,1) = time(i);
  output(i,2) = manual(i);
  output(i,3) = temperature(i);

  time_squared(i) = time(i)**2;
  time_cube(i) = time(i)**3;
  time_fourth(i) = time_squared(i)**2;
  time_fifth(i) = time_squared(i) * time_cube(i);
  time_sixth(i) = time_cube(i)**2;
endfor

# Get the sum of the filled vectors above and put it in the year_vector
time_vector = [];
time_vector(end+1) = sum(time);
time_vector(end+1) = sum(time_squared);
time_vector(end+1) = sum(time_cube); 
time_vector(end+1) = sum(time_fourth);
time_vector(end+1) = sum(time_fifth);
time_vector(end+1) = sum(time_sixth);

# Initialize the matrix A
A = zeros(4,4);

# Build the A matrix using the year_vector (Note: Ax = b)
A(1,1) = length(time);
A(1,2:end) = time_vector(1:3);
A(2,1:end) = time_vector(1:4);
A(3,1:end) = time_vector(2:5);
A(4,1:end) = time_vector(3:6);

# Build the b matrix 
b = [];
b(end+1) = sum(temperature);
b(end+1) = sum(time(1:end) .* temperature(1:end));
b(end+1) = sum(time_squared(1:end) .* temperature(1:end));
b(end+1) = sum(time_cube(1:end) .* temperature(1:end));
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

#printf("\nCurve Fitting\n1.) Matrices formed in least-squares polynomial curve fitting\nA matrix:\n");
#A
#printf("\nb matrix:\n");
#b

# Flip the x polynomial produced to fit the polynomial format
poly = flip(x);
#printf("\n======================================================================\n");
#printf("\n2.)The following cubic polynomial interpolates the data points: \n")
#polyout(poly, 'x');
#printf("where:\n    a_0 = %f\n     a_1 = %f\n     a_2 = %f\n     a_3 = %f\n", poly(1), poly(2), poly(3), poly(4));
#printf("SOLUTION: Cholesky LDLt\n");
#L
#D

L_transpose = L.';
#printf("Ly = b // below is the solved y\n");
#y
#printf("D(Lt)x = y  // below is the solved x\n");
#x
#printf("\n See the first graph containing the cubic polynomial which fits the data points")

#printf("\n======================================================================\n");
#complete_year = [0,5,10,15,20,25,30,35,40];
#complete_population = [35.80, 41.29, 47.40, 54.32, 61.95, 69.83, 77.99, 86.27, 93.73];
#printf("3.) Interpolation the population in years(5,15,25,35) using the model VS real value:\n")
#interpolated_values = evalpoly(poly,[5,15,25,35])
#real_value = [complete_population(2:2:end)]

#interpolated_temperature = evalpoly(poly, time);
#real_temperature = [(2:2:end)];

# Get first derivative of polynomial generated
first_derivative = polyder(poly.');

# Get second derivative of the polynomial generated
second_derivative = polyder(first_derivative);

#printf("\n See the second graph containing the cubic polynomial interpolating the data points")
#printf("\n======================================================================\n");
#printf("\n4.) The following first derivative of the polynomial generated:\n");
#polyout(first_derivative, 'x');

#printf("\n======================================================================\n");
#printf("\n5.) See the third subplot for the gradient of the first graph\n");

% The following lines are responsible for the plotting of graphs
# Create list of x coordinates
linx = linspace(min(time), max(time));
# Evaluate the polynomial with the created list of x coordinates
liny = evalpoly(poly, linx(:));

# FIRST GRAPH
# Plot the Model --Year vs Population graph--
# AND Plot the given data points
#subplot(3,1,1)
hold on;
plot(linx(:), liny(:), "b-");
plot(time(:), temperature(:));
title("Time vs temperature graph");
ylabel("temperature (°C)");
xlabel("time (s)");
legend("pop(year)", "Data point");
hold off;


# SECOND GRAPH
# Plot the Model --Year vs Population graph--
# AND Plot the given data points with the extra data points
#subplot(3,1,2)
#hold on;
#plot(linx(:), liny(:), "b-");
#plot(complete_year(:), complete_population(:), "or");
#title("Year vs Population graph (compare the interpolated value to the data points in year(5,15,25,35))");
##ylabel("Population (million)");
#label("Year (relative # of years from 1970)");
#legend("pop(year)", "Data point");
#legend("location", "east");
#hold off;

#subplot(3,1,3)
#hold on;

# Evaluate the first_derivative with the created list of x coordinates
#liny_first_d = evalpoly(first_derivative, linx(:));

# Plot the Year vs Population graph
#plot(linx(:), liny_first_d(:), "b-");
#legend("Gradient = population(year)'");
#title("Gradient of the model");
#hold off;


#interpolated_values = evalpoly(

#plot(time, manual, temperature);