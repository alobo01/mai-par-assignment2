(define (domain restaurant-places-ok)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality)
  (:types 
    robot 
    ingredient 
    tool 
    dish 
    location
  )
  (:constants
    DWA - location
  )
  
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (at ?loc - location ?room - location)
    (ingredient-at ?ingredient - ingredient ?loc - location)
    (tool-at ?tool - tool ?loc - location)
    (ingredient-prepared ?ingredient - ingredient)
    (dish-assembled ?dish - dish)
    (dish-plated ?dish - dish ?loc - location)
    (tool-clean ?tool - tool)
    (holding ?r - robot ?ingredient - ingredient)
    (adjacent ?loc1 - location ?loc2 - location)
    (used-in ?ingredient - ingredient ?dish - dish)
    (substitute ?ingredient1 - ingredient ?ingredient2 - ingredient ?dish - dish)
  )

  (:action substitution
    :parameters (?r - robot ?dish - dish ?ingredient1 - ingredient ?ingredient2 - ingredient ?loc - location)
    :precondition (and
      (not(ingredient-at ?ingredient1 ?loc))
      (not(ingredient-prepared ?ingredient1))
      (used-in ?ingredient1 ?dish)
      (ingredient-at ?ingredient2 ?loc)
      (not(substitute ?ingredient1 ?ingredient2 ?dish))
      (forall (?d - dish) (not (used-in ?ingredient2 ?d)))
    )
    :effect (and 
      (holding ?r ?ingredient2) 
      (not (ingredient-at ?ingredient2 ?loc))
      (not(used-in ?ingredient1 ?dish))
      (used-in ?ingredient2 ?dish)
      (substitute ?ingredient2 ?ingredient1 ?dish)
    )
  )
  
  (:action pick-up-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (ingredient-at ?ingredient ?loc) 
      (not (exists (?i - ingredient) (holding ?r ?i)))
    )
    :effect (and 
      (holding ?r ?ingredient) 
      (not (ingredient-at ?ingredient ?loc))
    )
  )
  
  (:action prepare-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?tool - tool)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding ?r ?ingredient) 
      (tool-at ?tool ?loc) 
      (tool-clean ?tool)
    )
    :effect (and 
      (ingredient-prepared ?ingredient) 
      (not (holding ?r ?ingredient))
      (not (tool-clean ?tool))
      (holding ?r ?tool)
    )
  )
  
  (:action assemble-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (forall (?i - ingredient) 
        (imply (used-in ?i ?dish) (ingredient-prepared ?i)))
    )
    :effect (dish-assembled ?dish)
  )
  
  (:action clean-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (tool-at ?tool ?loc)
      (= ?loc DWA)
      (holding ?r ?tool)
      (not (tool-clean ?tool))
    )
    :effect (and 
      (tool-clean ?tool)
      (tool-at ?tool ?loc) 
      (holding ?r ?tool)
    )
  )
  
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location)
    :precondition (and 
      (robot-at ?r ?loc1) 
      (adjacent ?loc1 ?loc2)
    )
    :effect (and 
      (robot-at ?r ?loc2) 
      (not (robot-at ?r ?loc1))
    )
  )

  (:action plate-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (dish-assembled ?dish)
    )
    :effect (and 
      (dish-plated ?dish ?loc)
    )
  )
)