(define (domain restaurant-two)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality :conditional-effects)
  (:types 
    robot 
    item
    dish 
    location
  )
  (:constants
    DWA MIXA CA CTA PA SA SVA - location
    knife - item
  )
  
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (item-at ?tool - item ?loc - location)
    (ingredient-prepared ?ingredient - item)
    (dish-assembled ?dish - dish)
    (dish-plated ?dish - dish ?loc - location)
    (tool-clean ?tool - item)
    (holding-item ?r - robot ?item - item)
    (holding-dish ?r - robot ?dish - dish)
    (adjacent ?loc1 - location ?loc2 - location)
    (used-in ?item - item ?dish - dish)
    (need-mix ?item - item)
    (need-cook ?item - item)
    (need-cut ?item - item)
    ;(priorization ?dish1 - dish ?dish2 - dish)
  )

  (:action pick-up-item
    :parameters (?r - robot ?item - item ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (item-at ?item ?loc) 
      (not (exists (?i - item) (holding-item ?r ?i)))
      (not (exists (?d - dish) (holding-dish ?r ?d)))
    )
    :effect (and 
      (holding-item ?r ?item) 
      (not(item-at ?item ?loc))
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

  (:action drop-item
    :parameters (?r - robot ?item - item ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-item ?r ?item)
    )
    :effect (and 
      (not(holding-item ?r ?item))
      (item-at ?item ?loc)
    )
  )

  (:action mix
      :parameters (?r - robot ?item - item ?loc - location)
      :precondition (and 
      (need-mix ?item)
      (not(ingredient-prepared ?item))
      (robot-at ?r ?loc)
      (robot-at ?r MIXA) 
      (item-at ?item ?loc)
      )
      :effect (and 
      (not(need-mix ?item))
      )
  )

  (:action cook
      :parameters (?r - robot ?item - item ?loc - location)
      :precondition (and 
      (not(need-mix ?item))
      (not(ingredient-prepared ?item))
      (robot-at ?r ?loc)
      (robot-at ?r CA)
      (item-at ?item ?loc)
      (need-cook ?item)
      )
      :effect (and 
      (not(need-cook ?item))
      (ingredient-prepared ?item)
      )
    )
  
  (:action assemble-dish
    :parameters (?r - robot ?loc - location ?dish - dish)
    :precondition (and
      (robot-at ?r ?loc)
      (robot-at ?r PA)
      ;(priorization ?dish1 ?dish2)
      (forall (?i - item)
        (imply (used-in ?i ?dish)
          (and (ingredient-prepared ?i) (item-at ?i ?loc))
        )
      )
    )
    :effect (and
      (dish-assembled ?dish)
      (forall (?i - item)
        (when (used-in ?i ?dish)
          (not (item-at ?i ?loc))
        )
      )
    )
  )

  (:action carrying-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition(and
      (robot-at ?r ?loc)
      (robot-at ?r PA)
      (dish-assembled ?dish)
      ;(priorization ?dish1 ?dish2)
      (not (exists (?i - item) (holding-item ?r ?i)))
      (not (exists (?d - dish) (holding-dish ?r ?d)))
    )
    :effect(and
      (holding-dish ?r ?dish)
    )
  )


  (:action plate-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (holding-dish ?r ?dish)
      ;(priorization ?dish1 ?dish2)
    )
    :effect (and 
      (dish-plated ?dish ?loc)
      (not(holding-dish ?r ?dish))
    )
  )

(:action cut
    :parameters (?r - robot ?ingredient - item ?loc - location ?tool - item)
    :precondition (and 
      (robot-at ?r ?loc)(robot-at ?r CTA)
      (need-cut ?ingredient)
      (item-at ?ingredient ?loc) 
      (item-at knife ?loc)(item-at ?tool ?loc) 
      (tool-clean knife)(tool-clean ?tool)
      (not(ingredient-prepared ?ingredient))
    )
    :effect (and 
      (not (tool-clean knife))
      (not(need-cut ?ingredient))
      (item-at ?ingredient ?loc)
      (ingredient-prepared ?ingredient)
    )
  )



(:action clean-tool
    :parameters (?r - robot ?tool - item ?loc - location)
    :precondition (and 
      (robot-at ?r DWA)
      (robot-at ?r ?loc) 
      (item-at knife ?loc)
      (item-at ?tool ?loc)
      (not (tool-clean knife))
    )
    :effect (and 
      (tool-clean knife)
    )
  )

)