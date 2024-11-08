(define (problem robot_chef_updated_problem)
  (:domain robot_chef_updated)

  ;; Objects
  (:objects
    robot1 - robot
    pa - preparing-location
    cla - cleaning-location
    ka - cooking-location
    sa - storage-location
    knife - tool
    rice fish seaweed flour chocolate - ingredient
    sushi pollofre - dish
    cooked raw clean dirty - status
    cleaning cooking - process
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


    ;; Initial tool state and location
    (item-at knife sa)
    (clean knife)

    ;; Ingredient initial counts in storage
    (= (ingredient-count rice sa) 1)
    (= (ingredient-count fish sa) 1)
    (= (ingredient-count seaweed sa) 1)
    (= (ingredient-count flour sa) 1)
    (= (ingredient-count chocolate sa) 1)

    (requires-cooking chocolate)
    (requires-cooking rice)
    (requires-ingredient sushi rice)
    (requires-ingredient sushi fish)
    (requires-ingredient sushi seaweed)
    (requires-ingredient pollofre flour)
    (requires-ingredient pollofre chocolate)
    (requires-tool pollofre knife)
    (requires-tool sushi knife)
  )

  ;; Goal state
  (:goal 
    (and
      (prepared sushi)
      (prepared pollofre)
    )
  )
)
