(* vector.sml
 *
 * Reference code for SML Basis Library Proposal 2015-003.
 *)

structure VectorExt : VECTOR_EXT =
  struct

    open Vector

    fun toList v = List.tabulate(length v, fn i => sub(v, i))

    fun append (v, x) = concat[v, fromList[x]]

    fun prepend (x, v) = concat[fromList[x], v]

  end
