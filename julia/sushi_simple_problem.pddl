(define (problem places-ok)
  (:domain restaurant-places-ok)
  (:objects
    robot1 - robot
    rice fish - ingredient
    knife - tool
    sushi - dish
    SA SVA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients available in the storage area
    (ingredient-at rice SA)
    (ingredient-at fish SA)

    ; All the preparation requirements for these ingredients
    (need-cook rice)
    (need-mix rice)
    (need-cut fish)

    ; Available tools
    (tool-at knife CTA)
    (tool-clean knife)
    
    ; Sushi recipe
    (used-in rice sushi)
    (used-in fish sushi)
    
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
  )
  
  (:goal
    (and 
      (tool-clean knife)
      (tool-at knife CTA) ; it is placed back where it is used
      (dish-plated sushi SVA)
    )
  )
)