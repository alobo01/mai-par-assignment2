(define (domain robot-recharge)
  (:requirements :probabilistic-effects :strips :typing)
  
  (:types 
    location - object
    battery-level - object
    robot - object
  )

  (:predicates
    (at ?r - robot ?loc - location)        ; Robot is at location
    (battery-level ?r - robot ?level - battery-level) ; Battery level of the robot
    (charger ?loc - location)              ; Location of the charger
  )

  (:action move-up
    :parameters (?r - robot ?from ?to-right ?to-left ?to-up - location)
    :precondition (at ?r ?from)
    :effect (probabilistic 
      0.8 (and (not (at ?r ?from)) (at ?r ?to-up))
      0.1 (and (not (at ?r ?from)) (at ?r ?to-right))
      0.1 (and (not (at ?r ?from)) (at ?r ?to-left))
    )
  )

  (:action move-down
    :parameters (?r - robot ?from ?to - location)
    :precondition (at ?r ?from)
    :effect (probabilistic 
      0.8 (and (not (at ?r ?from)) (at ?r ?to))
      0.2 (at ?r ?from) ; No movement, stays in place
    )
  )

  (:action move-left
    :parameters (?r - robot ?from ?to - location)
    :precondition (at ?r ?from)
    :effect (probabilistic 
      0.8 (and (not (at ?r ?from)) (at ?r ?to))
      0.2 (at ?r ?from) ; No movement, stays in place
    )
  )

  (:action move-right
    :parameters (?r - robot ?from ?to - location)
    :precondition (at ?r ?from)
    :effect (probabilistic 
      0.8 (and (not (at ?r ?from)) (at ?r ?to))
      0.2 (at ?r ?from) ; No movement, stays in place
    )
  )

  (:action recharge
    :parameters (?r - robot ?loc - location)
    :precondition (and (at ?r ?loc) (charger ?loc) (battery-level ?r low))
    :effect (and (not (battery-level ?r low)) (battery-level ?r charged))
  )
)
