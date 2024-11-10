(define (domain restaurant-places-counting)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality :conditional-effects :fluents)
  (:types 
    robot 
    ingredient 
    tool 
    dish 
    location
  )
  (:constants
    DWA MIXA CA CTA PA SA - location
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
    (holding-dish ?r - robot ?dish - dish)
    (holding-tool ?r - robot ?tool - tool)
    (adjacent ?loc1 - location ?loc2 - location)
    (used-in ?ingredient - ingredient ?dish - dish)
    (need-mix ?ingredient - ingredient)
    (need-cook ?ingredient - ingredient)
    (need-cut ?ingredient)
  )

  (:functions
    (ingredient-count ?i - ingredient)

  )

  (:action pick-up-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (ingredient-at ?ingredient ?loc) 
      (not (exists (?i - ingredient) (holding-ingredient ?r ?i)))
      (not (exists (?t - tool) (holding-tool ?r ?t)))
      (not (exists (?d - dish) (holding-dish ?r ?d)))
      (imply (robot-at ?r SA)
      (> (ingredient-count ?ingredient) 0))
    )
    :effect (and 
      (holding-ingredient ?r ?ingredient) 
      ;;(not(ingredient-at ?ingredient ?loc))
      (when (robot-at ?r SA) 
        (decrease (ingredient-count ?ingredient) 1))
    )
  )

  (:action pick-up-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (tool-at ?tool ?loc) 
      (not (exists (?i - ingredient) (holding-ingredient ?r ?i)))
      (not (exists (?t - tool) (holding-tool ?r ?t)))
      (not (exists (?d - dish) (holding-dish ?r ?d)))
    )
    :effect (and 
      (holding-tool ?r ?tool) 
      (not(tool-at ?tool ?loc))
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

  (:action drop-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-ingredient ?r ?ingredient)
    )
    :effect (and 
      (not(holding-ingredient ?r ?ingredient))
      (ingredient-at ?ingredient ?loc)
    )
  )

  (:action drop-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-tool ?r ?tool)
    )
    :effect (and 
      (not(holding-tool ?r ?tool))
      (tool-at ?tool ?loc)
    )
  )

  (:action mix
      :parameters (?r - robot ?ingredient - ingredient ?loc - location)
      :precondition (and 
      (need-mix ?ingredient)
      (not(ingredient-prepared ?ingredient))
      (robot-at ?r ?loc)
      (robot-at ?r MIXA) 
      (ingredient-at ?ingredient ?loc)
      )
      :effect (and 
      (not(need-mix ?ingredient))
      )
  )

  (:action cook
      :parameters (?r - robot ?ingredient - ingredient ?loc - location)
      :precondition (and 
      (not(need-mix ?ingredient))
      (not(ingredient-prepared ?ingredient))
      (robot-at ?r ?loc)
      (robot-at ?r CA)
      (ingredient-at ?ingredient ?loc)
      (need-cook ?ingredient)
      )
      :effect (and 
      (not(need-cook ?ingredient))
      (ingredient-prepared ?ingredient)
      )
    )
  
  (:action assemble-dish
    :parameters (?r - robot ?dish - dish)
    :precondition (and
      (robot-at ?r PA)
      (forall (?i - ingredient)
        (imply (used-in ?i ?dish)
          (and (ingredient-prepared ?i) (ingredient-at ?i PA))
        )
      )
    )
    :effect (and
      (dish-assembled ?dish)
      (forall (?i - ingredient)
        (when (used-in ?i ?dish)
          (not (ingredient-at ?i PA))
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
      (not (exists (?i - ingredient) (holding-ingredient ?r ?i)))
      (not (exists (?t - tool) (holding-tool ?r ?t)))
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
    )
    :effect (and 
      (dish-plated ?dish ?loc)
    )
  )

(:action cut
    :parameters (?r - robot ?ingredient - ingredient ?tool - tool)
    :precondition (and 
      (robot-at ?r CTA)
      (need-cut ?ingredient)
      (ingredient-at ?ingredient CTA) 
      (tool-at ?tool CTA) 
      (tool-clean ?tool)
      (not(ingredient-prepared ?ingredient))
    )
    :effect (and 
      (not (tool-clean ?tool))
      (not(need-cut ?ingredient))
      (ingredient-at ?ingredient CTA)
      (ingredient-prepared ?ingredient)
    )
  )



(:action clean-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r DWA)
      (robot-at ?r ?loc) 
      (tool-at ?tool ?loc)
      (not (tool-clean ?tool))
    )
    :effect (and 
      (tool-clean ?tool)
    )
  )

)