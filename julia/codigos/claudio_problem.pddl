(define (problem claudio-restaurant-problem)
  (:domain claudio-restaurant)

  (:objects
    robot1 - robot
    tomato cheese dough - ingredient
    oven knife - tool
    pizza - dish
    kitchen pantry dining-room - location
    high - priority
  )

  (:init
    ; Initial robot location
    (robot-at robot1 kitchen)

    ; Locations of ingredients
    (ingredient-at tomato pantry)
    (ingredient-at cheese pantry)
    (ingredient-at dough pantry)

    ; Location of tools
    (tool-at oven kitchen)
    (tool-at knife kitchen)

    ; Tool cleanliness
    (tool-clean oven)
    (tool-clean knife)

    ; Adjacent locations
    (adjacent kitchen pantry)
    (adjacent kitchen dining-room)
    (adjacent pantry kitchen)
    (adjacent dining-room kitchen)

    ; Dish requirements
    (ingredient-needed tomato pizza)
    (ingredient-needed cheese pizza)
    (ingredient-needed dough pizza)

    ; Ingredient relationships
    (used-in tomato pizza)
    (used-in cheese pizza)
    (used-in dough pizza)

    ; Substitute relationships (for example purposes)
    (can-substitute dough tomato pizza)

    ; Order details
    (order-received pizza high)

    ; Fluent values
    (= (order-queue-size high) 1)
  )

  (:goal
    (and
      (dish-plated pizza dining-room)
      (= (order-queue-size high) 0)
    )
  )
)
