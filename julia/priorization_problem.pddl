(define (problem sushi-order-with-priorization-f)
  (:domain restaurant-priorization-f)
  (:objects
    robot1 - robot
    rice fish noodles broth vegetables - ingredient
    knife - tool
    sushi ramen - dish
    SA SVA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients available in the storage area
    (ingredient-at rice SA)
    (ingredient-at fish SA)
    (ingredient-at noodles SA)   
    (ingredient-at broth SA)      
    (ingredient-at vegetables SA) 

    ; All the preparation requirements for these ingredients
    (need-mix rice)
    (need-cook rice)
    (need-cut fish)
    (need-cook noodles)
    (need-cut vegetables)
    (need-mix broth)
    (need-cook broth)

    ; Available tools
    (tool-at knife CTA)
    (tool-clean knife)
    
    ; Sushi recipe
    (used-in rice sushi)
    (used-in fish sushi)

    ; Ramen recipe
    (used-in noodles ramen)
    (used-in vegetables ramen)
    (used-in broth ramen)

    ; Priorization of Sushi over Ramen (higher number indicates higher priority)
    (= (priority sushi) 2)  ; Higher priority
    (= (priority ramen) 1)   ; Lower priority
    
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
      (dish-plated ramen SVA)
    )
  )
)