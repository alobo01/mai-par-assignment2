(define (domain claudio-restaurant)
  (:requirements :strips :typing :negative-preconditions :fluents :disjunctive-preconditions :quantified-preconditions)
  
  (:types 
    robot 
    ingredient 
    tool 
    dish 
    location
    priority - object
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
    (ingredient-needed ?ingredient - ingredient ?dish - dish)
    (ingredient-missing ?ingredient - ingredient)
    (can-substitute ?ingredient1 - ingredient ?ingredient2 - ingredient ?dish - dish)
    (order-received ?dish - dish ?priority - priority)
  )
  
  (:functions
    (order-queue-size ?priority - priority) ; Declared as a fluent here
  )
  
  (:action detect-missing-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?dish - dish)
    :precondition (and 
      (robot-at ?r ?loc)
      (ingredient-needed ?ingredient ?dish)
      (not (ingredient-at ?ingredient ?loc)))
    :effect (ingredient-missing ?ingredient)
  )

  (:action substitute-ingredient
    :parameters (?r - robot ?dish - dish ?ingredient1 - ingredient ?ingredient2 - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (ingredient-missing ?ingredient1)
      (ingredient-at ?ingredient2 ?loc)
      (can-substitute ?ingredient2 ?ingredient1 ?dish))
    :effect (and
      (not (ingredient-missing ?ingredient1))
      (ingredient-prepared ?ingredient2)
      (used-in ?ingredient2 ?dish))
  )
      
  (:action receive-new-order
    :parameters (?r - robot ?dish - dish ?priority - priority ?loc - location)
    :precondition (and
      (robot-at ?r ?loc)
      (not (order-received ?dish ?priority)))
    :effect (and
      (order-received ?dish ?priority)
      (increase (order-queue-size ?priority) 1))
  )

  (:action execute-order
    :parameters (?r - robot ?dish - dish ?priority - priority ?loc - location)
    :precondition (and
      (robot-at ?r ?loc)
      (order-received ?dish ?priority)
      (dish-assembled ?dish))
    :effect (and
      (not (order-received ?dish ?priority))
      (decrease (order-queue-size ?priority) 1)
      (dish-plated ?dish ?loc))
  )

  (:action pick-up-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (ingredient-at ?ingredient ?loc) 
      (not (holding-ingredient ?r ?ingredient)))
    :effect (and 
      (holding-ingredient ?r ?ingredient) 
      (not (ingredient-at ?ingredient ?loc))
    ))

  (:action prepare-ingredient
    :parameters (?r - robot ?ingredient - ingredient ?loc - location ?tool - tool)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-ingredient ?r ?ingredient) 
      (tool-at ?tool ?loc) 
      (tool-clean ?tool))
    :effect (and 
      (ingredient-prepared ?ingredient) 
      (not (holding-ingredient ?r ?ingredient))
      (not (tool-clean ?tool))
    ))

  (:action assemble-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (forall (?i - ingredient) 
        (or (not (used-in ?i ?dish)) (ingredient-prepared ?i))))
    :effect (dish-assembled ?dish)
  )

  (:action clean-tool
    :parameters (?r - robot ?tool - tool ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (tool-at ?tool ?loc) 
      (not (tool-clean ?tool)))
    :effect (tool-clean ?tool)
  )
  
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location)
    :precondition (and 
      (robot-at ?r ?loc1) 
      (adjacent ?loc1 ?loc2))
    :effect (and 
      (robot-at ?r ?loc2) 
      (not (robot-at ?r ?loc1)))
  )

  (:action plate-dish
    :parameters (?r - robot ?dish - dish ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (dish-assembled ?dish))
    :effect (dish-plated ?dish ?loc)
  )
)
