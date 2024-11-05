(define (problem robot-recharge-problem)
  (:domain robot-recharge)

  (:objects
    robot1 - robot
    loc1 loc2 loc3 loc4 loc5 loc6 loc7 loc8 loc9 - location
    low charged - battery-level
  )

  (:init
    (at robot1 loc1)                    ; Robot starts at loc1
    (battery-level robot1 low)           ; Battery is initially low
    (charger loc9)                       ; Charger is located at loc9

    ; Defining possible movements on a 3x3 grid for simplicity
    ; loc1 can move up to loc2 or left to loc4, etc.
  )

  (:goal
    (and
      (at robot1 loc9)                   ; Robot is at charger location
      (battery-level robot1 charged)     ; Battery is charged
    )
  )
)
