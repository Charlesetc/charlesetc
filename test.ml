type only_apple = Apple of { color : string
                          ; sweetness : int }

let best_apple_ever = Apple { color = "red"; sweetness = 10000 }

(* how do you get the sweetness of an Apple? Pattern match against it. *)
let what_was_the_sweetness_again =
  match best_apple_ever with
  | Apple { sweetness ; _ } -> sweetness

(* actually let's have more kinds of fruit *)

type fruit = Pear of { color : string
                     ; sweetness : int }
           | Grapes of int
           (* This one doesn't carry data apart from being a banana *)
           | Banana

let best_pear_ever = Pear { color = "green"; sweetness = 5 }

let what_was_the_sweetness_again =
  match best_pear_ever with
  | Pear { sweetness ; _ } -> sweetness
  | Grapes _
  | Banana -> raise (Failure "can't find out the sweetness of grapes or bananas")
