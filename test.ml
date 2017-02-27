
class cylinder radius height = object
  method radius : float = radius
  method height : float = height
end

class circle radius color = object
  method radius : float = radius
  method color : string = color
end

let get_radius x = x#radius

let () =
  let circle = new circle 2.3 "blue" in
  let cylinder = new cylinder 88. 3.5 in

  print_float (get_radius circle) ;
  print_float (get_radius cylinder)
