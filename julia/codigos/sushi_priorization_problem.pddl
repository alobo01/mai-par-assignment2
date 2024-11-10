(define (problem sushi-order-with-priorization)
  (:domain restaurant-priorization)
  (:objects
    robot1 - robot
    sushi ramen pho - dish
  )
  
  (:init
    (robot-at robot1 CA)
    ; Assembled-dishes
    (dish-assembled sushi)
    (dish-assembled ramen)
    (dish-assembled pho)

    ; Priority order
    (priorization sushi ramen pho)
    
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
      (dish-plated sushi SVA)
      (dish-plated ramen SVA)
      (dish-plated pho SVA)
    )
  )
)