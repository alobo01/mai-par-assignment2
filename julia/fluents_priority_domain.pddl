(define (domain priorization)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality :conditional-effects :fluents)
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

  (:functions
    (priority ?dish - dish)    ; Priority value for each dish
    (current-priority-level)   ; Tracks which priority level should be served next
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
      (= (priority ?dish) (current-priority-level))  ; Can only carry dish matching current priority
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
      (= (priority ?dish) (current-priority-level))  ; Can only plate dish matching current priority
    )
    :effect (and 
      (dish-plated ?dish ?loc)
      (not(holding-dish ?r ?dish))
      (increase (current-priority-level) 1)  ; Move to next priority level
    )
  )
)