#import "Tensor";
#import "Basic";
#import "Time";


invert :: (matrix: [] float32, inverse: [] float32) -> float64, float64, int, s32 {
  assert(matrix.count == inverse.count);

  N := cast(s32) sqrt(cast(float) matrix.count);
  assert(N*N == matrix.count);

  // Set up data buffers
  A := alloc(size_of(float32) * matrix.count); defer free(A);
  IPIV := alloc(size_of(s32) * matrix.count); defer free(IPIV);
  INFO: s32;
  WORK := alloc(size_of(float32) * matrix.count); defer free(WORK);
  LWORK: s32 = cast(s32) matrix.count;

  memcpy(A, matrix.data, size_of(float32) * matrix.count);

  // Get LU factorization
  lu_start_time := get_current_file_time();
  sgetrf_(*N, *N, A, *N, IPIV, *INFO);
  lu_end_time := get_current_file_time();
  if INFO != 0 return 0, 0, 1, INFO;

  // Get inverse
  inv_start_time := get_current_file_time();
  sgetri_(*N, A, *N, IPIV, WORK, *LWORK, *INFO);
  inv_end_time := get_current_file_time();
  if INFO != 0 return 0, 0, 2, INFO;

  memcpy(inverse.data, A, size_of(float32) * matrix.count);
  return (lu_end_time-lu_start_time)/10000000.0, (inv_end_time-inv_start_time)/10000000.0, 0, INFO;
}


invert_3x3_noneye :: () {
  matrix := float32.[1, 3, 1, 2, 2, 2, 1, 1, 3];
  actual_inverse := float32.[-0.5, 1.0, -0.5, 0.5, -0.25, 0, 0, -0.25, 0.5];

  print("\n");
  print("[invert_3x3_noneye]\n");
  print("inverting 3x3 matrix: %\n", matrix_to_string(matrix));
  print("expected inverse: %\n", matrix_to_string(actual_inverse));

  inverse := array_copy(matrix);
  lu_time, inv_time, err, info := invert(matrix, inverse);
  assert(err == 0);

  print("actual inverse: %\n", matrix_to_string(inverse));
  if matrix_equal(inverse, actual_inverse) print("[MATCH!]\n");
  else print("===== ERROR INCORRECT! =====\n");

  print("[LU  TIME] % s\n", lu_time);
  print("[INV TIME] % s\n", inv_time);
}


invert_3x3_eye :: () {
  matrix := float32.[1, 0, 0, 0, 1, 0, 0, 0, 1];
  actual_inverse := float32.[1, 0, 0, 0, 1, 0, 0, 0, 1];

  print("\n");
  print("[invert_3x3_eye]\n");
  print("inverting 3x3 matrix: %\n", matrix_to_string(matrix));
  print("expected inverse: %\n", matrix_to_string(actual_inverse));

  inverse := array_copy(matrix);
  lu_time, inv_time, err, info := invert(matrix, inverse);
  assert(err == 0);

  print("actual inverse: %\n", matrix_to_string(inverse));
  if matrix_equal(inverse, actual_inverse) print("[MATCH!]\n");
  else print("===== ERROR INCORRECT! =====\n");

  print("[LU  TIME] % s\n", lu_time);
  print("[INV TIME] % s\n", inv_time);
}


test_invert_matrix :: () {
  invert_3x3_eye();
  invert_3x3_noneye();
}

