(define (problem sushi-order-with-sustitutions)
  (:domain restaurant-with-substitutions)
  (:objects
    robot1 - robot
    rice fish avocado noodles broth vegetables - ingredient
    knife - tool
    sushi ramen - dish
    CA SA PA SVA CTA MIXA DWA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients need locations
    (ingredient-at rice SA)
    (ingredient-at avocado SA)
    (ingredient-at noodles SA)    ; Added
    (ingredient-at broth SA)      ; Added
    (ingredient-at vegetables SA) ; Added
    (tool-at knife CTA)
    (tool-clean knife)
    
    ; Define ingredients needed for sushi
    (used-in rice sushi)
    (used-in fish sushi)
    (used-in noodles ramen)
    (used-in vegetables ramen)
    (used-in broth ramen)
    
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
    )
  )
)