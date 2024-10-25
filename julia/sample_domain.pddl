(define (domain carga)
    (:requirements
        :adl
        :fluents
    )
    (:types
        tren          - object
        contenedor    - object
        ubicacion     - location
        puerto        - ubicacion
        ciudad        - ubicacion
        almacen       - ubicacion
        fabrica       - ubicacion
    )
    (:functions
        (carga-maxima ?t - tren)       ; con cuánto máximo puede un tren
        (carga-actual ?t - tren)       ; cuánto lleva ahora un tren
        (capacidad ?f - ubicacion)     ; cuánto máximo recibe el lugar
        (ocupacion ?f - ubicacion)     ; cuánto tiene ahora el lugar
    )
    (:predicates
        (ruta ?ori - ubicacion ?dst - ubicacion)
                                       ; hay ruta de ORI a DST?
        (esta ?o - object ?u - ubicacion)
                                       ; está el objeto O en la ubicación U? 
        (cargado ?c - contenedor ?t - tren)
                                       ; está el objeto C en el tren T?
        (procesado ?c - contenedor)    ; fue procesado el contenedor C?
        (despachado ?c - contenedor)   ; fue despachado el contenedor C?
        (procesadora ?u - fabrica)     ; si U procesa
        (despachadora ?u - almacen)    ; si U despacha
    )
    (:action ir
        :parameters (?t - tren ?ori - ubicacion ?dst - ubicacion)
        :precondition (and
            (or
                (ruta ?ori ?dst)       ; hay cómo ir de ORI a DST
                (ruta ?dst ?ori)       ; hay cómo ir de DST a ORI
            )
            (esta ?t ?ori)             ; el tren está en ORI
            (not (esta ?t ?dst))       ; y no está en DST
        )
        :effect (and
            (not (esta ?t ?ori))       ; ya no está en ORI
            (esta ?t ?dst)             ; y está en DST
        )
    )
    (:action cargar
        :parameters (?t - tren ?o - contenedor ?u - ubicacion)
        :precondition (and
            (esta ?t ?u)               ; el tren está en una ubicación
            (esta ?o ?u)               ; el objeto está en una ubicación
            (not (cargado ?o ?t))      ; el objeto no está cargado
            (<= (+ (carga-actual ?t) 1) (carga-maxima ?t))
                                       ; el tren tiene capacidad (actual+1<=máx)
        )
        :effect (and
            (not (esta ?o ?u))         ; el objeto no está en la ubicación
            (cargado ?o ?t)            ; el objeto está en el tren
            (increase (carga-actual ?t) 1)
                                       ; se cargó el tren y usó capacidad
                                       ; (actual += 1)
            (decrease (ocupacion ?u) 1)
                                       ; disminuyó la ocupación (actual-=1)
        )
    )
    (:action descargar
        :parameters (?t - tren ?o - contenedor ?u - ubicacion)
        :precondition (and
            (esta ?t ?u)               ; el tren está en la ubicación
                                       ; (donde debe descargar)
            (cargado ?o ?t)            ; tiene un objeto cargado
            (not (esta ?o ?u))         ; el objeto no está en la ubicación
            (<= (+ (ocupacion ?u) 1) (capacidad ?u))
                                       ; debe haber al menos un cupo para recibir
        )
        :effect (and
            (not (cargado ?o ?t))      ; ahora el objeto no está cargado
            (esta ?o ?u)               ; pero está en la ubicación
            (decrease (carga-actual ?t) 1)
                                       ; y se liberó capacidad en el tren
                                       ; (actual-=1)
            (increase (ocupacion ?u) 1)
                                       ; aumentó la ocupación en este sitio
                                       ; (ocupación+=1)
        )
    )
    (:action procesar
        :parameters (?o - contenedor ?u - fabrica)
        :precondition (and
            (procesadora ?u)           ; aquí se procesa
            (esta ?o ?u)               ; el objeto está en la ubicación
            (not (procesado ?o))       ; no se ha procesador aún
            (not (despachado ?o))      ; no se ha despachado aún
        )
        :effect (and
            (procesado ?o)             ; ha sido procesado
                                       ; (y todo lo demás igual)
        )
    )
    (:action despachar
        :parameters (?o - contenedor ?u - almacen)
        :precondition (and
            (despachadora ?u)          ; aquí se despacha
            (esta ?o ?u)               ; el objeto está en la ubicación
            (procesado ?o)             ; ha sido procesado antes
            (not (despachado ?o))      ; pero no se ha despachado aún
        )
        :effect (and
            (despachado ?o)            ; ha sido despachado
                                       ; (y todo lo demás igual)
            (decrease (ocupacion ?u) 1)
                                       ; disminuyó la ocupación del sitio
                                       ; (ocupación-=1)
        )
    )
)