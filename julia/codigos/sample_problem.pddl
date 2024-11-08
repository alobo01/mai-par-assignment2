(define (problem llevar-y-procesar-carga)
    (:domain carga)
    (:objects
        A                         - almacen
        F1 F2                     - fabrica
        P                         - puerto
        C                         - ciudad
        Tren                      - tren
        K1 K2 K3 K4 K5 K6 K7 K8   - contenedor
    )
    (:init
                                       ; datos de contenedores
        (esta K1 P)                    ; K1 en el puerto y es contenedor
        (esta K2 P)                    ; K2 en el puerto y es contenedor
        (esta K3 P)                    ; K3 en el puerto y es contenedor
        (esta K4 P)                    ; K4 en el puerto y es contenedor
        (esta K5 P)                    ; K5 en el puerto y es contenedor
        (esta K6 P)                    ; K6 en el puerto y es contenedor
        (esta K7 P)                    ; K7 en el puerto y es contenedor
        (esta K8 P)                    ; K8 en el puerto y es contenedor

    
                                       ; datos del tren
        (esta Tren P) (= (carga-maxima Tren) 4) (= (carga-actual Tren) 0)
    
                                       ; datos de las locaciones
        (ruta A P)                     ; hay cómo ir de A ←→ P
        (ruta A C)                     ; hay cómo ir de A ←→ C
        (ruta A F2)                    ; hay cómo ir de A ←→ F2
        (ruta C P)                     ; hay cómo ir de C ←→ P
        (ruta C F1)                    ; hay cómo ir de C ←→ F1
        (ruta C F2)                    ; hay cómo ir de C ←→ F2
        (procesadora F1)               ; hay cómo procesar en F1
        (= (capacidad F1) 3)           ; F1 puede recibir 3
        (= (ocupacion F1) 0)           ; F1 inicia sin contenedores
        (procesadora F2)               ; hay cómo procesar en F2
        (= (capacidad F2) 1)           ; F2 puede recibir 1
        (= (ocupacion F2) 0)           ; F2 inicia sin contenedores
        (despachadora A)               ; hay cómo despachar en A
        (= (capacidad A) 2)            ; A solo recibe 2 sin haber despachado
        (= (ocupacion A) 0)            ; A inicia sin contenedores
        (= (capacidad C) 0)            ; C no puede recibir
        (= (ocupacion C) 0)            ; C inicia sin contenedores
        (= (capacidad P) 0)            ; P inicia sin contenedores
        (= (ocupacion P) 1000)         ; P inicia ocupadísimo
    )
    (:goal
        (and
            (despachado K1)            ; K1 ha sido procesado y despachado
            (despachado K2)            ; K2 ha sido procesado y despachado
            (despachado K3)            ; K3 ha sido procesado y despachado
            (despachado K4)            ; K4 ha sido procesado y despachado
            (despachado K5)            ; K5 ha sido procesado y despachado
            (despachado K6)            ; K6 ha sido procesado y despachado
            (despachado K7)            ; K7 ha sido procesado y despachado
            (despachado K8)            ; K8 ha sido procesado y despachado
        )
    )
)