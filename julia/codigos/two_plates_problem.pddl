(define (problem sushi-two)
  (:domain restaurant-two)
  (:objects
    robot1 - robot
    rice fish noodles vegetables - item
    sushi ramen - dish
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients available in the storage area
    ;(item-at rice SA)
    ;(item-at fish SA)
    (item-at noodles SA)      
    (item-at vegetables SA) 

    ; All the preparation requirements for these ingredients
    ;(need-mix rice)
    ;(need-cook rice)
    ;(need-cut fish)
    (need-cook noodles)
    (need-cut vegetables)

    ; Available tools
    (item-at knife CTA)
    (tool-clean knife)
    
    ; Sushi recipe
    ;(used-in rice sushi)
    ;(used-in fish sushi)

    ; Ramen recipe
    (used-in noodles ramen)
    (used-in vegetables ramen)
    
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
      (item-at knife CTA) ; it is placed back where it is used
      ;(dish-plated sushi SVA)
      (dish-plated ramen SVA)
    )
  )
)