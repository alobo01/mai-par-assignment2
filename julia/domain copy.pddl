(define (domain robot_chef_simple)
  (:requirements :strips :typing :negative-preconditions :fluents :universal-preconditions :disjunctive-preconditions :conditional-effects)

  ;; Types
  (:types
    robot location item process status - object
    ingredient tool dish - item
  )

  ;; Predicates
  (:predicates
    (robot-at ?r - robot ?loc - location) ;; Robot is at a specific location
    (holding ?r - robot ?i - ingredient) ;; Robot is holding an ingredient
    (holding-item ?r - robot ?i - ingredient ?s - status) ;; Robot is holding an ingredient
    (connected ?loc1 - location ?loc2 - location) ;; Locations are connected
    (robot-free ?r - robot)


    (prepared ?d - dish)
    (requires-ingredient ?d - dish ?i - ingredient)
    (requires-item ?p - process ?i - item ?s - status)
    (cause-increase ?p -process ?i - item ?s - status)
    (done-at ?d - dish ?l - location)
    (applicable ?s - status ?i - item)
  )

  ;; Functions
  (:functions
    (ingredient-count ?i - ingredient ?loc - location)  ;; Count of ingredients available
    (item-count ?i - item ?s - status ?loc - location)
    )

  (:action to-process
    :parameters (?r - robot ?p - process ?loc - location)
    :precondition (and 
      (robot-free ?r)
      (imply
        (done-at ?p ?loc)
        (robot-at ?r ?loc)
      )
      (forall (?i - item ?s - status)
        (and
          (applicable ?s ?i)
          (imply
            (requires-item ?p ?i ?s)
            (> (item-count ?i ?s ?loc) 0)
          )
        )
      )
    )
    :effect (and 
      (forall (?i - item ?s - status)
        (and
          (when
            (requires-item ?p ?i ?s)
            (decrease (item-count ?i ?s ?loc) 1)
          )
          (when
            (and (cause-increase ?p ?i ?s) (applicable ?s ?i))
            (increase (item-count ?i ?s ?loc) 1)
          )
        )
      )
    )
  )


  ;; Pick-up action: Robot picks up an ingredient
  (:action pick-up-item
    :parameters (?r - robot ?i - item ?s - status ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (not (holding-item ?r ?i ?s)) 
      (robot-free ?r)
      (> (item-count ?i ?s ?loc) 0)
      )
    :effect (and 
      (holding-item ?r ?i ?s) 
      (not (robot-free ?r))
      (decrease (item-count ?i ?s ?loc) 1)
      )
  )

  ;; Use-ingredient action: Robot uses an ingredient and decreases its count
  (:action drop-item
    :parameters (?r - robot ?i - ingredient ?s - status ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-item ?r ?i ?s)
      (not (robot-free ?r)))
    :effect (and 
      (increase (item-count ?i ?s ?loc) 1) 
      (not (holding ?r ?i)) 
      (robot-free ?r)
    ) 
  )







  ;; Prepare action
  (:action prepare
    :parameters (?r - robot ?loc - preparation-location ?d - dish)
    :precondition (and 
      (robot-at ?r ?loc)
      (forall (?i - ingredient)
        (imply 
          (requires-ingredient ?d ?i)
          (> (ingredient-count ?i ?loc) 0)))
    )
    :effect (and 
      (prepared ?d) 
      (forall (?i - ingredient)
        (when (requires-ingredient ?d ?i)
          (decrease (ingredient-count ?i ?loc) 1))))
  )


  

  ;; Move action: Robot moves between connected locations
  (:action move
    :parameters (?r - robot ?loc1 - location ?loc2 - location)
    :precondition (and (robot-at ?r ?loc1) (connected ?loc1 ?loc2))
    :effect (and (robot-at ?r ?loc2) (not (robot-at ?r ?loc1)))
  )

  ;; Pick-up action: Robot picks up an ingredient
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

  ;; Use-ingredient action: Robot uses an ingredient and decreases its count
  (:action drop-ingredient
    :parameters (?r - robot ?i - ingredient ?loc - location)
    :precondition (and (robot-at ?r ?loc) (holding ?r ?i) (not (robot-free ?r)))
    :effect (and (increase (ingredient-count ?i ?loc) 1) (not (holding ?r ?i)) (robot-free ?r)) 
  )
)