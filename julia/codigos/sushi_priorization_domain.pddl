(define (domain restaurant-priorization)
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
    (priorization ?dish1 - dish ?dish2 - dish ?dish3 - dish)
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
    :parameters (?r - robot ?dish1 - dish ?dish2 - dish ?dish3 - dish ?loc - location)
    :precondition(and
      (robot-at ?r ?loc)
      (robot-at ?r PA)
      (dish-assembled ?dish1)
      (priorization ?dish1 ?dish2 ?dish3)
      (not (exists (?d - dish) (holding-dish ?r ?d)))
    )
    :effect(and
      (holding-dish ?r ?dish1)
    )
  )


  (:action plate-dish
    :parameters (?r - robot ?dish1 - dish ?dish2 - dish ?dish3 ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (holding-dish ?r ?dish1)
      (priorization ?dish1 ?dish2 ?dish3)
    )
    :effect (and 
      (dish-plated ?dish1 ?loc)
      (not(holding-dish ?r ?dish1))
      (not(dish-assembled ?dish1))
      (priorization ?dish2 ?dish3 ?dish1)
    )
  )

)