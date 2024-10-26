(define (problem robot_chef_general_problem)
  (:domain robot_chef_general)

  ;; Objects
  (:objects
    robot1 - robot
    pa cla ka - location ; preparation, cleaning, kitchen
    sa - storage-location
    knife - tool
    rice fish seaweed flour chocolat - ingredient
    sushi pollofre - dish
    preparing cleaning cooking - process
    unprepared prepared raw cooked clean dirty - status
  )

  ;; Initial state
  (:init
    ;; Robot and location setup
    (robot-at robot1 pa)  
    (connected sa pa)  
    (connected pa sa)  
    (connected pa cla)  
    (connected cla pa) 
    (connected ka cla)  
    (connected cla ka)  
    (robot-free robot1)
    (priority-over pollofre sushi)

    ;; Applicable statuses for ingredients, dish, and tool
    (applicable cooked rice)
    (applicable raw rice)
    (applicable cooked fish)
    (applicable raw fish)
    (applicable cooked seaweed)
    (applicable raw seaweed)
    (applicable prepared sushi)
    (applicable unprepared sushi)
    (applicable clean knife)
    (applicable dirty knife)
    (applicable raw flour)
    (applicable raw chocolat)
    (applicable cooked chocolat)
    (applicable unprepared pollofre)
    (applicable prepared pollofre)

    ;; Define process for preparing sushi
    (requires-item preparing sushi rice raw)
    (requires-item preparing sushi fish raw)
    (requires-item preparing sushi seaweed raw)
    (requires-item preparing sushi knife clean)
    (requires-item preparing sushi sushi unprepared)
    (done-at preparing sushi pa)
    (cause-status preparing sushi sushi prepared)
    (cause-status preparing sushi knife dirty)

    ;; Define process for preparing pollofre
    (requires-item preparing pollofre flour raw)
    (requires-item preparing pollofre chocolat cooked)
    (requires-item preparing pollofre knife clean)
    (requires-item preparing pollofre pollofre unprepared)
    (done-at preparing pollofre pa)
    (cause-status preparing pollofre pollofre prepared)

    ;; Define process for cleaning knife
    (requires-item cleaning knife knife dirty)
    (done-at cleaning knife cla)
    (cause-status cleaning knife knife clean)

    ;; Define process for cooking chocolate
    (requires-item cooking chocolat chocolat raw)
    (done-at cooking chocolat ka)
    (cause-status cooking chocolat chocolat cooked)

    ;; Initial locations and statuses of items
    (item-at rice raw sa)
    (item-at fish raw sa)
    (item-at seaweed raw sa)
    (item-at chocolat raw sa)
    (item-at flour raw sa)
    (item-at knife clean sa)
    (item-at knife clean sa)
    (item-at sushi unprepared pa)
    (item-at pollofre unprepared pa)

    ;; Initial quantity of ingredients
    (= (ingredient-count rice sa) 1)
    (= (ingredient-count fish sa) 1)
    (= (ingredient-count seaweed sa) 1)
    (= (ingredient-count flour sa) 1)
    (= (ingredient-count chocolat sa) 1)

  )

  ;; Goal state
  (:goal 
    (and
      (item-at sushi prepared pa)
      (item-at pollofre prepared pa)
    )
  )
)
