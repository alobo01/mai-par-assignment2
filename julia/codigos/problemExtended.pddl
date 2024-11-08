(define (problem sushi-preparation)
  (:domain robot_chef_extended_fluents)

  ;; Objects
  (:objects
    robot1 - robot
    rice fish vegetables - ingredient
    sushi - dish
    knife mixing-bowl - tool
    sa cta mixa ca pa sva dwa - location
  )

  ;; Initial conditions
  (:init
    ;; Robot location and free to perform actions
    (robot-at robot1 sa)
    (robot-free robot1)

    ;; Ingredients available in the storage area
    (= (ingredient-count rice sa) 3)
    (= (ingredient-count fish sa) 3)
    (= (ingredient-count vegetables sa) 3)

    ;; Tools are clean and ready for use
    (tools-clean knife)
    (tools-clean mixing-bowl)

    ;; Connectivity between areas (gray areas are not connected)
    (connected sa cta)
    (connected cta mixa)
    (connected mixa ca)
    (connected ca pa)
    (connected pa sva)
    (connected pa dwa)
  )

  ;; Goal: Sushi is prepared and plated in the serving area, tools are cleaned
  (:goal
    (and
      (dish-prepared sushi)
      (tools-clean knife)
      (tools-clean mixing-bowl)
    )
  )
)
