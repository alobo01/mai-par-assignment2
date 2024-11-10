(define (problem priority)
  (:domain priority)
  (:objects
    robot1 - robot
    ramen sushi pho - dish
  )
  
  (:init
    (robot-at robot1 SA)
    ; Dishes assembled
    (dish-assembled pho)
    (dish-assembled ramen)
    (dish-assembled sushi)
    
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
      (dish-plated ramen SVA)
      (dish-plated sushi SVA)
      (dish-plated pho SVA)
    )
  )
)