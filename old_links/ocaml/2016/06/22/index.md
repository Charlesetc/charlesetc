---
layout: post

title: "OCaml Objects, like wow"

date: "2017-02-26 12:14:30 -0700"

categories: ocaml

---

OCaml is an extremely well-thought out language. Objects might seem
like something most languages have, but OCaml brings something pretty
special to the table.

I'll go over:

* records, simple but necessary to understand objects.
* **objects** -- herein lies awesome 🚀🎩

# Records

```ocaml
type circle = {
  radius : float ;
  color : string ;
}
```

This makes a circle type with radius and color attributes! Not too fancy
yet.

A basic circle instantiation:

```ocaml
let blue_circle = { radius = 2.0 ; color = "blue" }
```

## Pattern matching

```ocaml
match circle with
| { radius ; color = "red" } -> string_of_float radius
| { color ; _ } -> color
```

In the first branch, `radius` is a variable for `radius` field, and we
check for only red circles.

In the second, we ignore all fields other than binding `color`.

# the Problem

Let's consider two very alike record types:

```ocaml
(* same circle type we started with: *)
type circle = {
  radius : float ;
  color : string ;
}

(* cylinder type is similar but has a height and no color: *)
type cylinder = {
  radius : float ;
  height : float ;
}

(* a function to get the radius from an unspecified type *)
let get_radius x = match x with
| { radius ; _ } -> radius

let () =

  (* define some data *)
  let cylinder = { radius = 2. ; height = 3. } in
  let circle = { radius = 1.2 ; color = "blue" } in

  (* print the radius of a cylinder *)
  (* works just fine *)
  print_float (get_radius cylinder) ;

  (* THIS DOES NOT COMPILE *)
  print_float (get_radius circle)
```

This doesn't work! The problem is that when we use `get_radius` the first
time, its type is inferred to be `cylinder -> float`.

Now that OCaml knows `get_radius` takes a cylinder, it couldn't possibly
take a circle!

What we need is an object.

# Objects

Here's the same code using objects instead:

```ocaml
(* define a class for cylinders *)
class cylinder radius height = object
  method radius : float = radius
  method height : float = height
end

(* similarly define circles *)
class circle radius color = object
  method radius : float = radius
  method color : string = color
end

(* our function uses the #radius method call *)
let get_radius x = x#radius

let () =
  (* make our object instances *)
  let circle = new circle 2.3 "blue" in
  let cylinder = new cylinder 88. 3.5 in

  (* call our function with different types! *)
  print_float (get_radius circle) ;
  print_float (get_radius cylinder)
```

What happens is that `get_radius` is inferred to have an **open type**,
represented in OCaml as `< radius : float ; .. >`. When you pass in an
object, any object will work so long as it has a `radius` method that
returns a float.

This is awesome! We can write polymorphic code so easily.

It's called *structural typing*, and can be compared to
compile-time-checked duck typing. (If you ever try to pass an object that
doesn't have a radius to `get_radius`, you'll get a compile time type
error.)

OCaml's object system can ignore what the object is and just focus
on what it can do.

# Okay but...

Objects in OCaml are not perfect.

* The syntax for defining them is clunkier than records.
* They have dynamic dispatched methods which are generally slower than
  record access.
* Objects can't be used in pattern matching which is pretty unfortunate.

Also, most people writing OCaml are allergic to the term
"object".

Nevertheless, OCaml objects are **so cool** and can help you write clean,
reusable code: completely without inheritence or subtyping.

Structural typing for the win!
