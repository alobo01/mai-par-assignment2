(define (problem sushi-order)
  (:domain restaurant)
  (:objects
    robot1 - robot
    rice fish noodles broth vegetables - ingredient
    knife - tool
    sushi ramen - dish
    CA SA PA SVA DWA CTA MIXA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients need locations
    (ingredient-at rice SA)
    (ingredient-at fish SA)
    (ingredient-at noodles SA)  ; Added
    (ingredient-at broth SA)    ; Added
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
    (adjacent SA SVA)
    (adjacent SVA SA)
    (adjacent SVA PA)
    (adjacent PA SVA)
    (adjacent PA MIXA)
    (adjacent MIXA PA)
    (adjacent MIXA CTA)
    (adjacent CTA MIXA)
    (adjacent PA CA)
    (adjacent CA PA)
  )
  
  (:goal
    (and 
      (dish-plated ramen SVA)
      (dish-plated sushi SVA)
    )
  )
)