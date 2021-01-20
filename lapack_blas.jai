#if OS == .LINUX {
  lapack  :: #foreign_library "linux/liblapack";
  blas    :: #foreign_library "linux/libblas";
  fortran :: #foreign_library "linux/libgfortran";
} else {
  #import "Basic";
  print("[ERROR] LAPACK not yet supported on operating systems other than Linux\n");
}

// NOTE: Matrices in LAPACK/BLAS are row-major
// These procedures all take pointers to the arguments, despite many being input arguments.

// LU factorization of float matrix
sgetrf_ :: (N: *s32,     // Rows
            M: *s32,     // Cols
            A: *float32, // Matrix (in/out parameter)
            LDA: *s32,   // Leading element (== N to factorize the whole matrix)
            IPIV: *s32,  // Pivot array, pass in empty memory and get back pivots for sgetri_
            INFO: *s32)  // Error code
            #foreign lapack;

// Invert square float matrix given LU factorization
sgetri_ :: (N: *s32,        // Number of rows (also number of columns)
            A: *float32,    // Matrix (in/out parameter)
            LDA: *s32,      // Leading element (== N to invert the whole matrix)
            IPIV: *s32,     // Pivot array from sgetrf_
            WORK: *float32, // Workspace memory of size N*N
            LWORK: *s32,    // Size of workspace == N*N
            INFO: *s32)     // Error code
            #foreign lapack;

// Matrix-Matrix multiplication:  alpha * [M K] @ [K N] + beta * [M N] = [M N]
sgemm_ :: (TRANSA: *u8,     // 'T' to transpose A, 'N' to use A unchanged
           TRANSB: *u8,     // 'T' to transpose B, 'N' to use B unchanged
           M: *s32,         // Number of rows in A and C
           N: *s32,         // Number of cols in B and C
           K: *s32,         // Number of cols of A and rows of B
           ALPHA: *float32, // Multiplier on blended matmul, use 1 for normal matmul
           A: *float32,     // A Matrix
           LDA: *s32,       // Leading element of A (usually M unless transposed then K)
           B: *float32,     // B Matrix
           LDB: *s32,       // Leading element of B (usually K unless transposed then N)
           BETA: *float32,  // Multiplier on C for blended matmul, use 0 for normal matmul
           C: *float32,     // C Matrix (in/out parameter) not used for input unless BETA > 0
           LDC: *s32)       // Leading element of C (usually M)
           #foreign blas;

// Matrix-vector multiplication:  alpha * [M M] * [N] + beta * [N]
sgemv_ :: (TRANS: *u8,      // 'T' to transpose A, 'N' to use unchanged
           M: *s32,         // Rows
           N: *s32,         // Cols
           ALPHA: *float32, // Multiplier on blended mat-vec-mul, use 1 for normal mat-vec-mul
           A: *float32,     // Matrix
           LDA: *s32,       // Leading element, use M
           X: *float32,     // Vector
           INCX: *s32,      // Increment for elements of X (stride), usually use 1
           BETA: *float32,  // Multiplier on blended mat-vec-mul, use 0 for normal mat-vec-mul
           Y: *float32,     // Vector
           INCY: *s32)      // Increment for elements of Y (stride), usually use 1
           #foreign blas;

// Vector-vector dot product
sdot_ :: (N: *s32,      // Length of the vectors
          SX: *float32, // Vector X
          INCX: *s32,   // Stride of X
          SY: *float32, // Vector Y
          INCY: *s32)   // Stride of Y
          -> float32 #foreign blas;

// Vector-vector blended addition: alpha * A + X
saxpy_ :: (N: *s32,       // Length of the vectors
           SA: *float32,  // Blend multiplier alpha
           SX: *float32,  // Vector X
           INCX: *s32,    // Stride of X
           SY: *float32,  // Vector Y (in/out parameter)
           INCY: *s32)    // Stride of Y
           #foreign blas;

// Scalar-vector multiply
sscal_ :: (N: *s32,       // Length of the vector
           SA: *float32,  // Scalar
           SX: *float32,  // Vector X (in/out parameter)
           INCX: *s32)    // Sstride of X
           #foreign blas;

// Vector 2-norm
snrm2_ :: (N: *s32,     // Length of the vector
           X: *float32, // Vector X
           INCX: *s32)  // Stride of X
           -> float32 #foreign blas;


// Scalar-matrix multiply
slascl_ :: (TYPE: *u8,        // 'G' if it's a full matrix, otherwise see docs (lower triangular etc)
            KL: *s32,         // Lower bandwidth of A (for non-full matrices)
            KU: *s32,         // Upper bandwidth of A (for non-full matrices)
            CFROM: *float32,  // Multiplies by this scalar
            CTO: *float32,    // Divides by this scalar (set to 1 to just multiply)
            M: *s32,          // Rows
            N: *s32,          // Cols
            A: *float32,      // Matrix
            LDA: *s32,        // Leading element, usually == M
            INFO: *s32)       // Error code
            #foreign lapack;

// Vector of random numbers
slarnv_ :: (IDIST: *s32,  // 1: uniform(0,1)    2: uniform(-1,1)    3: normal(0,1)
            ISEED: *s32,  // Array of 4 ints in [0,4095]  (in/out parameter)
            N: *s32,      // Number of random numbers to generate
            X: *float32)  // Data buffer to store the numbers in
            #foreign lapack;

// Initialize matrix to beta on the diagonal, and alpha on the off-diagonals
slaset_ :: (UPLO: *u8,        // 'U' to set upper tri, 'L' to set lower tri, otherwise set all
            M: *s32,          // Rows
            N: *s32,          // Cols
            ALPHA: *float32,  // Value to put on the off-diagonals
            BETA: *float32,   // Value to put on the diagonal
            A: *float32,      // Matrix
            LDA: *s32)        // Leading element, usually == M
            #foreign lapack;

