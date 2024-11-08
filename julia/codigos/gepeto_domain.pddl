(define (domain restaurant)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions)
  (:types 
    robot 
    ingredient 
    tool 
    dish 
    location
  )
  
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (ingredient-at ?ingredient - ingredient ?loc - location)
    (tool-at ?tool - tool ?loc - location)
    (ingredient-prepared ?ingredient - ingredient)
    (dish-assembled ?dish - dish)
    (dish-plated ?dish - dish ?loc - location)
    (tool-clean ?tool - tool)
    (holding-ingredient ?r - robot ?ingredient - ingredient)
    (adjacent ?loc1 - location ?loc2 - location)
    (used-in ?ingredient - ingredient ?dish - dish)
  )
  
  (:action pick-up-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (ingredient-at ?ingredient ?loc) 
      (not (exists (?i - ingredient) (holding-ingredient ?r ?i)))
    )
    :effect (and 
      (holding-ingredient ?r ?ingredient) 
      (not (ingredient-at ?ingredient ?loc))
    )
  )
  
  (:action prepare-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?tool - tool)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-ingredient ?r ?ingredient) 
      (tool-at ?tool ?loc) 
      (tool-clean ?tool)
    )
    :effect (and 
      (ingredient-prepared ?ingredient) 
      (not (holding-ingredient ?r ?ingredient))
      (not (tool-clean ?tool))
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
      (not (tool-clean ?tool))
    )
    :effect (tool-clean ?tool)
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