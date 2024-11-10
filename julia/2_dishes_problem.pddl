(define (problem places-ok)
  (:domain restaurant-places-ok)
  (:objects
    robot1 - robot
    rice fish vegetables steak - ingredient
    knife - tool
    sushi - steakDish - dish
    SA SVA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients available in the storage area
    (ingredient-at rice SA)
    (ingredient-at fish SA)
    (ingredient-at vegetables SA)
    (ingredient-at steak SA)



    ; All the preparation requirements for these ingredients
    (need-cook rice)
    (need-mix rice)
    (need-cut fish)
    (need-cook steak)
    (need-cut vegetables)
    (need-mix vegetables)

    ; Available tools
    (tool-at knife CTA)
    (tool-clean knife)
    
    ; Sushi recipe
    (used-in rice sushi)
    (used-in fish sushi)
    

    ; Steak recipe
    (used-in vegetables steakDish)
    (used-in steak steakDish)

    ; Simplified adjacency relationships (bidirectional)
    (adjacent SVA CA)
    (adjacent CA SVA)
    (adjacent CA DWA)
    (adjacent CA PA)
    (adjacent DWA CA)
    (adjacent DWA PA)
    (adjacent PA DWA)
    (adjacent PA MIXA)
    (adjacent PA CA)
    (adjacent MIXA PA)
    (adjacent MIXA CTA)
    (adjacent MIXA SA)
    (adjacent SA MIXA)
    (adjacent SA CTA)
    (adjacent CTA MIXA)
    (adjacent CTA SA)

    ; priority ( We need sushi as a starter )
    (priority-over sushi steakDish)
  )
  
  (:goal
    (and 
      (tool-clean knife)
      (tool-at knife CTA) ; it is placed back where it is used
      (dish-plated sushi SVA)
      (dish-plated steakDish SVA)
    )
  )
)