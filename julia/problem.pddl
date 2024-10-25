(define (problem robot_chef_general_problem)
  (:domain robot_chef_general)

  ;; Objects
  (:objects
    robot1 - robot
    sa pa - location
    sushiTool - tool
    rice fish seaweed - ingredient
    sushi - dish
    prepare - process
    unprepared prepared raw cooked clean dirty - status
  )

  ;; Initial state
  (:init
    ;; Robot and location setup
    (robot-at robot1 pa)  
    (connected sa pa)  
    (connected pa sa)  
    (robot-free robot1)

    ;; Applicable statuses for ingredients, dish, and tool
    (applicable cooked rice)
    (applicable raw rice)
    (applicable cooked fish)
    (applicable raw fish)
    (applicable cooked seaweed)
    (applicable raw seaweed)
    (applicable prepared sushi)
    (applicable unprepared sushi)
    (applicable clean sushiTool)
    (applicable dirty sushiTool)

    ;; Define process requirements for preparing sushi
    (requires-item prepare sushi rice raw)
    (requires-item prepare sushi fish raw)
    (requires-item prepare sushi seaweed raw)
    (requires-item prepare sushi sushiTool clean)
    (done-at prepare sushi pa)
    (cause-status prepare sushi sushi prepared)

    ;; Initial locations and statuses of items
    (item-at rice raw sa)
    (item-at fish raw sa)
    (item-at seaweed raw sa)
    (item-at sushiTool clean sa)
    (item-at sushi unprepared pa)

    ;; Initial quantity of ingredients
    

  )

  ;; Goal state
  (:goal 
    (item-at sushi prepared pa)
  )
)
