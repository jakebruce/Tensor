#import "Basic";
#import "Tensor";


test_matrix_vector_multiply :: () {
  //Rows and columns of A
  M: s32 : 3;
  N: s32 : 5;

  A :: float32.[0.10968253, 0.01451699, 0.29411929, 0.92508547, 0.77869525,
                0.17571609, 0.33044495, 0.55996705, 0.36743314, 0.46697657,
                0.10593391, 0.62186396, 0.04233635, 0.82629208, 0.01485058];

  X :: float32.[0.20257990, 0.68658769, 0.18523892, 0.40028493, 0.73590237];

  Y :: float32.[0.93666215, 1.29178516, 0.50814143];

  Y_out: [M] float32;

  // Don't transpose
  TRANS: u8 : #char "N";

  // Don't blend
  ALPHA: float32 : 1;
  BETA:  float32 : 0;

  // Stride of 1
  INCX: s32 : 1;
  INCY: s32 : 1;

  // Use the whole matrix
  LDA: s32 : M;

  // Invoke the mat-vec-mul
  sgemv_(*TRANS, *M, *N, *ALPHA, A.data, *LDA, X.data, *INCX, *BETA, Y_out.data, *INCY);

  print("A:        %\n", matrix_to_string(A));
  print("x =       %\n", matrix_to_string(X));
  print("y =       %\n", matrix_to_string(Y_out));
  print("Expected: %\n", matrix_to_string(Y));

  if matrix_equal(Y, Y_out) print("[MATCH!]\n");
  else print("========== ERROR INCORRECT! ==========\n");
}

