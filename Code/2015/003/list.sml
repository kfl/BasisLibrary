(* list.sml
 *
 * Reference code for SML Basis Library Proposal 2015-003.
 *)

structure ListExt : LIST_EXT =
  struct

    open List

    fun unfoldr getNext strm = let
	  fun lp (strm, items) = (case getNext strm
		 of NONE => items
		  | SOME(x, rest) => lp(rest, x::items)
		(* end case *))
	  in
	    lp (strm, [])
	  end

    fun unfoldl getNext strm = rev(unfoldr getNext strm)

    fun reduce f id [] = id
      | reduce f _ (x::xs) = foldl f x xs

    fun appi f l = let
	  fun appf (_, []) = ()
	    | appf (i, x::xs) = (f(i, x); appf(i+1, xs))
	  in
	    appf (0, l)
	  end

    fun mapi f l = let
	  fun mapf (_, []) = []
	    | mapf (i, x::xs) = (f(i, x) :: mapf(i+1, xs))
	  in
	    mapf (0, l)
	  end

    fun mapPartiali f l = let
	  fun mapf (_, []) = []
	    | mapf (i, x::xs) = (case f(i, x)
		 of NONE => mapf (i+1, xs)
		  | SOME y => y :: mapf(i+1, xs)
		(* end case *))
	  in
	    mapf (0, l)
	  end

    fun foldli f init l = let
          fun lp (_, [], acc) = acc
	    | lp (i, x::xs, acc) = lp (i+1, xs, f(i, x, acc))
	  in
	    lp (0, l, init)
	  end

    fun foldri f init l = let
          fun lp (_, []) = init
	    | lp (i, x::xs) = f (i, x, lp (i+1, xs))
	  in
	    lp (0, l)
	  end

    fun findi f l = let
	  fun lp (_, []) = NONE
	    | lp (i, x::xs) = if (f(i, x)) then SOME(i, x) else lp(i+1, xs)
	  in
	    lp (0, l)
	  end

    fun revMap f l = let
	  fun mapf (x::xs, ys) = mapf (xs, f x :: ys)
	    | mapf ([], ys) = ys
	  in
	    mapf (l, [])
	  end
    fun revMapi f l = let
	  fun mapf (i, x::xs, ys) = mapf (i+1, xs, f(i, x) :: ys)
	    | mapf (_, [], ys) = ys
	  in
	    mapf (0, l, [])
	  end

    fun revMapPartial f l = rev (mapPartial f l)
    fun revMapPartiali f l = rev (mapPartiali f l)

    fun concatMap f l = concat(map f l)
    fun concatMapi f l = concat(mapi f l)

    fun foldMapl reduceFn mapFn init l =
	  foldl (fn (x, acc) => reduceFn(mapFn x, acc)) init l

    fun foldMapr reduceFn mapFn init l =
	  foldr (fn (x, acc) => reduceFn(mapFn x, acc)) init l

    fun splitAt (xs, i) = (List.take (xs, i), List.drop (xs, i))

    fun update (xs, i, y) = let
	  fun upd (x::xs, 0, prefix) = revAppend(prefix, y::xs)
	    | upd ([], _, _) = raise Subscript
	    | upd (x::xs, i, prefix) = upd (xs, i-1, x::prefix)
	  in
	    if (i < 0) then raise Subscript else upd(xs, i, [])
	  end

    val sub = nth

  end
