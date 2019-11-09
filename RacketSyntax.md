# Racket Syntax

Präfixnotation: Operatoren stehen vor den Operanden, Bsp.: `(+ 1 2)`

```
; Kommentar

#| mehrzeiliger
   Kommentar |#
```

Definitionen:
(**define** _<Name> <Wert>_)
(**define** _<Name> <s−expression>_)
```
(define a 20)
(define b (* 3 2))
(define (Addition1 a b)
    (+ a b))

a                             -> 20
b                             -> 6
(Addition 2 3)                -> 5
```

Lambda:
(**lambda** _(<parameters>) <body>_)
```
(lambda (r) (* 2 r))
    ; anonyme Funktion
((lambda (r) (* 2 r)) 3)      -> 6

; äquivalente Definition zu Addition1:
(define Addition2
    (lambda (a b) (+ a b)))

(Addition2 2 3)               -> 5
```

Bedingte Ausdrücke:
(**if** _<test> <consequent> <alternate>_)
(**when** _<test> <conseqent>_)
```
(define (max2 a b)
    (if (> a b)     ; wenn a>b ist,
        a           ; dann a
        b))         ; andernfalls b
```

Folie 136





and
let*
quasiquote
quote
do
begin
case
set!
letrec
or
else
cond
delay
