#import "Basic";
#import "Tensor";


test_matrix_matrix_multiply :: () {
  // Row and column sizes
  N: s32 : 3;
  K: s32 : 5;
  M: s32 : 3;

  // Data buffers
  A :: float32.[0.96305189, 0.67752639, 0.68581186, 0.09721306, 0.94558097,
                0.36529431, 0.15653392, 0.51947384, 0.67272311, 0.87729678,
                0.83879061, 0.72928282, 0.48221868, 0.01604711, 0.77600499];

  B :: float32.[0.12548722, 0.44060251, 0.92752556,
                0.13542607, 0.52348318, 0.79902075,
                0.31395581, 0.44237195, 0.49591046,
                0.88571785, 0.17220335, 0.63651037,
                0.73519486, 0.13887342, 0.07467501];

  C :: float32.[0.68011446, 1.10546603, 1.37596757,
                1.7314356 , 1.49820719, 2.00923846,
                0.5006437 , 1.21814295, 1.00442146];

  C_out: [N*M] float32;

  // Don't transpose
  TRANSA: u8 : #char "N";
  TRANSB: u8 : #char "N";

  // Don't blend
  ALPHA: float32 : 1.0;
  BETA:  float32 : 0.0;

  // Leading elements (use whole matrices)
  LDA: s32 : M;
  LDB: s32 : K;
  LDC: s32 : M;

  // Invoke matmul
  sgemm_(*TRANSA, *TRANSB, *M, *N, *K, *ALPHA, A.data, *LDA, B.data, *LDB, *BETA, C_out.data, *LDC);

  print("A:        %\n", matrix_to_string(A));
  print("B:        %\n", matrix_to_string(B));
  print("C:        %\n", matrix_to_string(C_out));
  print("Expected: %\n", matrix_to_string(C));

  if matrix_equal(C, C_out) print("[MATCH!]\n");
  else print("========== ERROR INCORRECT! ==========\n");
}


