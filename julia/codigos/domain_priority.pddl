(define (domain priority)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality :conditional-effects)
  (:types 
    robot 
    dish 
    location
  )
  (:constants
    DWA MIXA CA CTA PA SA SVA - location
  )
  
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (dish-assembled ?dish - dish)
    (dish-plated ?dish - dish ?loc - location)
    (holding-dish ?r - robot ?dish - dish)
    (adjacent ?loc1 - location ?loc2 - location)
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

  (:action carrying-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition(and
      (robot-at ?r ?loc)
      (robot-at ?r PA)
      (dish-assembled ?dish)
      (not (exists (?d - dish) (holding-dish ?r ?d)))
    )
    :effect(and
      (holding-dish ?r ?dish)
      (not(dish-assembled ?dish))
    )
  )


  (:action plate-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (holding-dish ?r ?dish)
    )
    :effect (and 
      (dish-plated ?dish ?loc)
      (not(holding-dish ?r ?dish))
    )
  )

)