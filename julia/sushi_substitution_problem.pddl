(define (problem sushi_substitucion_problem)
  (:domain sushi_substitucion)
  (:objects
    robot1 - robot
    rice fish avocado cucumber - ingredient
    knife - tool
    sushi - dish
    SA SVA - location
  )
  
  (:init
    (robot-at robot1 CA)
    ; All ingredients available in the Storage Area
    (ingredient-at rice SA)
    (ingredient-at avocado SA)
    (ingredient-at cucumber SA)

    ; All the preparation requirements for these ingredients
    (need-cut avocado)
    (need-cut cucumber)
    (need-cook rice)
    (need-mix rice)

    ; The possible replacements of the recipe sushi
    (replaceable fish avocado sushi)
    (replaceable avocado cucumber sushi)

    ; Tool to cut placed in the cutting area
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
      (tool-clean knife)  ; it is cleaned
      (tool-at knife CTA) ; it is placed back where it is used
      (dish-plated sushi SVA)
    )
  )
)