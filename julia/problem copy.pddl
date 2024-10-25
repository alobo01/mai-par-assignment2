(define (problem robot_chef_simple_problemcf)
  (:domain robot_chef_simple)

  ;; Objects
  (:objects
    robot1 - robot
    sa - storage-location
    pa - preparation-location
    rice fish seaweed - ingredient  ;; Ingredients
    sushi - dish
  )

  ;; Initial state
  (:init
    (robot-at robot1 pa)  ;; Robot starts in the storage area
    (not (prepared sushi))
    (requires-ingredient sushi rice)
    (requires-ingredient sushi fish)
    (requires-ingredient sushi seaweed)
    (not (prepared sushi))
    (connected sa pa)  ;; Storage and preparation areas are connected
    (connected pa sa)  
    (robot-free robot1)
    (= (ingredient-count rice sa) 1)  ;; Initialize rice count to 3
    (= (ingredient-count fish sa) 1)  ;; Initialize fish count to 3
    (= (ingredient-count seaweed sa) 1)  ;; Initialize seaweed count to 3
    (= (ingredient-count rice pa) 0)  ;; Initialize rice count to 3
    (= (ingredient-count fish pa) 0)  ;; Initialize fish count to 3
    (= (ingredient-count seaweed pa) 0)  ;; Initialize seaweed count to 3
  )

  ;; Goal: Ingredients used in the preparation area
  (:goal (
    prepared sushi
  ))

)
