#lang racket
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))
(define Wolf 'Wolf)

; übergebe den gesicherten name space als zweites Argument für eval
(eval Wolf ns)
