(define (domain robot_chef_updated)
  (:requirements :strips :typing :negative-preconditions :conditional-effects :fluents :disjunctive-preconditions)

  ;; Types
  (:types
    robot location item status - object
    processed-item dish - item
    tool ingredient - processed-item
    storage-location cooking-location cleaning-location preparing-location - location
  )

  ;; Predicates
  (:predicates
    (robot-at ?r - robot ?loc - location)
    (holding-item ?r - robot ?i - item)
    (connected ?loc1 - location ?loc2 - location)
    (robot-free ?r - robot)

    ;; Specific location for each type of item
    (item-at ?i - item ?loc - location)

    ;; Dish preparation priority
    (priority-over ?d1 ?d2 - dish)
    (prepared ?dish - dish)
    (cooked ?i - ingredient)
    (clean ?t - tool)
      (requires-cooking ?i - ingredient)
    (requires-ingredient ?dish - dish ?i - ingredient)
    (requires-tool ?dish - dish ?t - tool)
)

  ;; Functions
  (:functions
    (ingredient-count ?i - ingredient ?loc - location)
  )

  ;; Actions

  ;; Cook ingredient action
  (:action cook
    :parameters (?r - robot ?ing - ingredient ?loc - cooking-location)
    :precondition (and 
      (robot-free ?r)
      (requires-cooking ?ing)
      (robot-at ?r ?loc)
      (item-at ?ing ?loc)
      (not (cooked ?ing))
    )
    :effect (and 
      (cooked ?ing)
    )
  )

  ;; Clean tool action
  (:action cleaning
    :parameters (?r - robot ?tool - tool ?loc - cleaning-location)
    :precondition (and 
      (robot-free ?r)
      (robot-at ?r ?loc)
      (item-at ?tool ?loc)
      (not (clean ?tool))
    )
    :effect (and 
      (clean ?tool)
    )
  )

  ;; Prepare dish action
  (:action prepare-dish
    :parameters (?r - robot ?dish - dish ?loc - preparing-location)
    :precondition (and 
      (robot-free ?r)
      (robot-at ?r ?loc)
      (not (prepared ?dish))
      (forall (?i - ingredient)
        (imply (requires-ingredient ?dish ?i)
          (and
            (imply (requires-cooking ?i) (cooked ?i))
            (item-at ?i ?loc)) 
        )
      )
      (forall (?t - tool)
        (imply (requires-tool ?dish ?t)
          (and
            (item-at ?t ?loc)
            (clean ?t)) 
        )
      )
      (not 
        (exists (?dish2) 
          (and
            (priority-over ?dish2 ?dish)
            (not (prepared ?dish2)))
        )
      )
    )
    :effect (and 
      (prepared ?dish)
      (forall (?i - ingredient)
        (when (requires-ingredient ?dish ?i)
          (and
            (not (cooked ?i))
            (not (item-at ?i ?loc))
          ) 
        )
      )
      (forall (?t - tool)
        (when (requires-tool ?dish ?t)
          (not (clean ?t))
        )
      )
    )
  )

  ;; Pick-up action for ingredients
  (:action pick-up-ingredient
    :parameters (?r - robot ?i - ingredient ?loc - storage-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (robot-free ?r)
      (> (ingredient-count ?i ?loc) 0)
    )
    :effect (and 
      (holding-item ?r ?i) 
      (not (robot-free ?r))
      (decrease (ingredient-count ?i ?loc) 1)
    )
  )


  ;; Pick-up other items
  (:action pick-up-items
    :parameters (?r - robot ?i - item ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (robot-free ?r)
      (item-at ?i ?loc)
    )
    :effect (and 
      (holding-item ?r ?i) 
      (not (robot-free ?r))
      (not (item-at ?i ?loc))
    )
  )


  ;; Drop action: Robot drops an item
  (:action drop
    :parameters (?r - robot ?i - item ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-item ?r ?i)
    )
    :effect (and 
      (item-at ?i ?loc)
      (not (holding-item ?r ?i)) 
      (robot-free ?r)
    ) 
  )

  ;; Move action: Robot moves between connected locations
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location)
    :precondition (and (robot-at ?r ?loc1) (connected ?loc1 ?loc2))
    :effect (and (robot-at ?r ?loc2) (not (robot-at ?r ?loc1)))
  )
)
