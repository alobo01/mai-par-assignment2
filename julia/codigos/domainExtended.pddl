(define (domain robot_chef_extended_fluents)
  (:requirements :strips :typing :negative-preconditions :fluents :universal-preconditions :disjunctive-preconditions :conditional-effects)

  ;; Types
  (:types
    robot location ingredient dish tool - object
    storage-location preparation-location serving-location cooking-location washing-location mixing-location cutting-location - location
  )

  ;; Predicates
  (:predicates
    (robot-at ?r - robot ?loc - location) ;; Robot is at a specific location
    (holding ?r - robot ?i - ingredient) ;; Robot is holding an ingredient
    (connected ?loc1 - location ?loc2 - location) ;; Locations are connected
    (robot-free ?r - robot) ;; Robot is free to pick up an item
    (tools-clean ?t - tool) ;; The tool is clean and ready for use
    (dish-ordered ?d - dish) ;; A specific dish is ordered
    (dish-prepared ?d - dish) ;; The dish has been prepared
    (ingredient-prepared ?i - ingredient) ;; Ingredient is prepared (e.g., cooked)
  )

  ;; Functions
  (:functions
    (ingredient-count ?i - ingredient ?loc - location) ;; Track availability of ingredients at a location
  )

  ;; Actions

  ;; Moving the robot between connected locations
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location)
    :precondition (and 
      (robot-at ?r ?loc1)
      (connected ?loc1 ?loc2)
    )
    :effect (and 
      (robot-at ?r ?loc2) 
      (not (robot-at ?r ?loc1))
    )
  )

  ;; Picking up an ingredient from a storage location
  (:action pick-up
    :parameters (?r - robot ?i - ingredient ?loc - storage-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (not (holding ?r ?i)) 
      (robot-free ?r)
      (> (ingredient-count ?i ?loc) 0)
    )
    :effect (and 
      (holding ?r ?i) 
      (not (robot-free ?r))
      (decrease (ingredient-count ?i ?loc) 1)
    )
  )

  ;; Dropping an ingredient at a location
  (:action drop
    :parameters (?r - robot ?i - ingredient ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc)
      (holding ?r ?i)
    )
    :effect (and 
      (not (holding ?r ?i)) 
      (robot-free ?r)
      (increase (ingredient-count ?i ?loc) 1)
    )
  )

  ;; Cooking an ingredient at the cooking area
  (:action cook
    :parameters (?r - robot ?i - ingredient ?loc - cooking-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding ?r ?i) 
      (not (ingredient-prepared ?i))
    )
    :effect (and 
      (ingredient-prepared ?i)
      (not (holding ?r ?i))
      (robot-free ?r)
    )
  )

  ;; Cleaning tools after use in the washing area
  (:action clean-tools
    :parameters (?r - robot ?t - tool ?loc - washing-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (not (tools-clean ?t))
    )
    :effect (tools-clean ?t)
  )

  ;; Preparing the dish at the preparation area
  (:action prepare-dish
    :parameters (?r - robot ?d - dish ?loc - preparation-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (dish-ordered ?d)
    )
    :effect (dish-prepared ?d)
  )
)
