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
    ; All ingredients need locations
    (ingredient-at rice SA)
    (need-cook rice)
    (need-mix rice)
    (need-cut fish)
    (ingredient-at fish SA)
    (need-cut fish)
    (tool-at knife CTA)
    (tool-clean knife)
    
    ; Define ingredients needed for sushi
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
      (dish-plated sushi SVA)
    )
  )
)