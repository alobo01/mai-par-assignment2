(define (domain restaurant-places-ok)
  (:requirements :strips :typing :disjunctive-preconditions :negative-preconditions :equality :conditional-effects)
  (:types 
    robot 
    ingredient 
    tool 
    dish 
    location
  )
  (:constants
    DWA MIXA CA CTA - location
  )
  
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (ingredient-at ?ingredient - ingredient ?loc - location)
    (tool-at ?tool - tool ?loc - location)
    (ingredient-prepared ?ingredient - ingredient)
    (dish-assembled ?dish - dish)
    (dish-plated ?dish - dish ?loc - location)
    (tool-clean ?tool - tool)
    (holding ?r - robot ?ingredient - ingredient)
    (adjacent ?loc1 - location ?loc2 - location)
    (used-in ?ingredient - ingredient ?dish - dish)
    (need-mix ?ingredient - ingredient)
    (need-cook ?ingredient - ingredient)
    (need-cut ?ingredient)
  )

  (:action pick-up-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?dish - dish)
    :precondition (and 
      (robot-at ?r ?loc)(used-in ?ingredient ?dish)
      (ingredient-at ?ingredient ?loc) 
      (not (exists (?i - ingredient) (holding ?r ?i)))
    )
    :effect (and 
      (holding ?r ?ingredient) 
      (not (ingredient-at ?ingredient ?loc))
    )
  )


  (:action mix-rice
      :parameters (?r - robot ?ingredient - ingredient ?loc - location)
      :precondition (and 
      (need-mix ?ingredient)
      (not(ingredient-prepared ?ingredient))
      (robot-at ?r ?loc)(robot-at ?r MIXA) 
      (holding ?r ?ingredient)
      )
      :effect (and 
      (not(need-mix ?ingredient))
      (holding ?r ?ingredient)
      )
  )

  (:action cook-rice
      :parameters (?r - robot ?ingredient - ingredient ?loc - location)
      :precondition (and 
      (not(need-mix ?ingredient))
      (not(ingredient-prepared ?ingredient))
      (robot-at ?r ?loc)(robot-at ?r CA)
      (holding ?r ?ingredient)
      (need-cook ?ingredient)
      )
      :effect (and 
      (not(need-cook ?ingredient))
      (holding ?r ?ingredient)
      )
    )

  (:action cut
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?tool - tool)
    :precondition (and 
      (robot-at ?r ?loc)(robot-at ?r CTA)
      (need-cut ?ingredient)
      (holding ?r ?ingredient) 
      (tool-at ?tool ?loc) 
      (tool-clean ?tool)
      (not(ingredient-prepared ?ingredient))
    )
    :effect (and 
      (not (holding ?r ?ingredient))
      (not (tool-clean ?tool))
      (holding ?r ?tool)
      (not(need-cut ?ingredient))
      (ingredient-at ?ingredient ?loc)
    )
  )

  (:action clean-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r DWA)
      (robot-at ?r ?loc) 
      (holding ?r ?tool)
      (not (tool-clean ?tool))
    )
    :effect (and 
      (tool-clean ?tool)
      (holding ?r ?tool)
    )
  )
  
  
  (:action prepare-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?tool - tool)
    :precondition (and 
      (robot-at ?r ?loc)
      (holding ?r ?ingredient) 
      (not(need-cook ?ingredient))
      (not(need-mix ?ingredient))
      (not(need-cut ?ingredient))
      (not(ingredient-prepared ?ingredient))
    )
    :effect (and 
      (ingredient-prepared ?ingredient) 
      (holding ?r ?ingredient)
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
  
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location ?ingredient - ingredient)
    :precondition (and 
      (robot-at ?r ?loc1) 
      (adjacent ?loc1 ?loc2)
    )
    :effect (and 
      (robot-at ?r ?loc2) 
      (not (robot-at ?r ?loc1))
      (when (holding ?r ?ingredient)
              (and(holding ?r ?ingredient)))
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