#import "Math";


matrix_equal :: (a: [] float, b: [] float) -> bool {
  for i: 0..a.count-1
    if abs(a[i] - b[i]) > 0.001 return false;
  return true;
}


matrix_to_string :: (m: [] float, max: int = -1) -> string {
  b: String_Builder;
  init_string_builder(*b);
  append(*b, "[");
  for m {
    append(*b, tprint("%", it));
    if it_index < m.count-1 append(*b, ", ");
    if max > 0 && it_index >= max {
      append(*b, "...");
      break;
    }
  }
  append(*b, "]");
  return builder_to_string(*b);
}

