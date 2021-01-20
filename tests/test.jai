#load "utils.jai";
#load "invert_matrix.jai";
#load "matrix_vector_multiply.jai";
#load "matrix_matrix_multiply.jai";


main :: () {
  test_invert_matrix();
  test_matrix_vector_multiply();
  test_matrix_matrix_multiply();
}

