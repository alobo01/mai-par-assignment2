(define (domain robot_chef_general)
  (:requirements :strips :typing :negative-preconditions :universal-preconditions :disjunctive-preconditions :conditional-effects :fluents)

  ;; Types
  (:types
    robot location ingredient  item status - object
    uncountable-item contable-item - item
    tool dish - uncountable-item
    ingredient - contable-item
    ingredient-status - status
    preparation-location storage-location - location
    process - object
  )

  ;; Predicates
  (:predicates
    (robot-at ?r - robot ?loc - location) ;; Robot is at a specific location
    (holding-item ?r - robot ?i - ingredient ?s - status) ;; Robot is holding an ingredient
    (connected ?loc1 - location ?loc2 - location) ;; Locations are connected
    (robot-free ?r - robot) ;; Robot has no item in hand
    (requires-item ?p - process ?oi ?i - item ?s - status) ;; Process requires item with specific status
    (cause-status ?p - process ?oi ?i - item ?s - status) ;; Process causes a change to item status
    (done-at ?p - process ?i - item ?l - location) ;; Process is completed at location
    (applicable ?s - status ?i - item) ;; Status is applicable for item
    (item-at ?i - item ?s - status ?loc - location) ;; Item with status is present at location
  )

  ;;Functions
  (:functions
    (ingredient-count ?i - ingredient ?loc - storage-location)

  )
  

  ;; Actions

  ;; Process action: The robot performs a process with an item at a location
  (:action to-process
    :parameters (?r - robot ?p - process ?oi - item ?loc - location)
    :precondition (and 
      (robot-free ?r)
      (imply
        (done-at ?p ?oi ?loc)
        (robot-at ?r ?loc)
      )
      (forall (?i - item ?s - status)
        (imply
          (requires-item ?p ?oi ?i ?s)
          (item-at ?i ?s ?loc)
        )
      )
    )
    :effect (and 
      (forall (?i - item ?s - status)
        (and
          (when
            (requires-item ?p ?oi ?i ?s)
            (not (item-at ?i ?s ?loc)) ;; Remove item from location once used
          )
          (when
            (and (cause-status ?p ?oi ?i ?s) (applicable ?s ?i))
            (item-at ?i ?s ?loc) ;; Add item back with updated status if applicable
          )
        )
      )
    )
  )

  ;; Pick-up action: Robot picks up an item
  (:action pick-up-uncitem
    :parameters (?r - robot ?i - uncountable-item ?s - status ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (not (holding-item ?r ?i ?s)) 
      (robot-free ?r)
      (item-at ?i ?s ?loc)
      )
    :effect (and 
      (holding-item ?r ?i ?s) 
      (not (robot-free ?r))
      (not (item-at ?i ?s ?loc)) ;; Item is no longer at location once picked up
      )
  )

  (:action pick-up-contitem
    :parameters (?r - robot ?i - contable-item ?s - status ?loc - storage-location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (not (holding-item ?r ?i ?s)) 
      (robot-free ?r)
      (item-at ?i ?s ?loc) ; All items are in this state
      (> (ingredient-count ?i ?loc) 0)
      )
    :effect (and 
      (holding-item ?r ?i ?s) 
      (not (robot-free ?r))
      (decrease (ingredient-count ?i ?loc) 1) ;; Item is no longer at location once picked up
      )
  )

  ;; Drop action: Robot drops an item, making it available at the location
  (:action drop-item
    :parameters (?r - robot ?i - item ?s - status ?loc - location)
    :precondition (and 
      (robot-at ?r ?loc) 
      (holding-item ?r ?i ?s)
      (not (robot-free ?r)))
    :effect (and 
      (item-at ?i ?s ?loc) ;; Item is now at location
      (not (holding-item ?r ?i ?s)) 
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
