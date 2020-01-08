
#lang racket

;Aufgabe 1.1:
;Eine Funktion ist eine Funktion höherer Ordnung, wenn sie als Parameter eine Funktion
;übergeben bekommt oder eine Funktion zurückgibt

;Aufgabe 1.2:

(define (test-vergleich x)
  (cond [(x 0 0) #f]
        [(x 11 12) #f]
        [else #t]))

(define (ermittle-vergleichsoperation x y)
  (cond [(< x y) <]
        [(> x y) >]
        [(= x y) =]))
;a) ist eine Funktion höherer Ordnung, da eine Funktion als Parameter übergeben wird
;b) ist keine Funktion höherer Ordnung
;c) ist keine Funktion höherer Ordnung
;d) ist eine Funktion höherer Ordnung, da eine Funktion zurückgegeben wird
;e) ist eine Funktion höherer Ordnung, da eine Funktion als Parameter übergeben wird

;Aufgabe 1.3:
(define (schweinchen-in-der-mitte f arg1)
  (lambda (arg2 arg3) (f arg2 arg1 arg3)))

;Die Umgebung/ der funktionale Abschluss von schweinchen-in-der-mitte ist zunächst
;list und 4
;Dann wird die Funktion, die von schweinchen-in-der-mitte zurückgegeben wurde, mit der
;Umgebung list 4 1 3      (f arg1 arg2 arg3)
;Die Werte list und 4 wurden an die Funktion/Closure gebunden und können verwendet werden,
;aber von außen nicht ausgelesen werden.

;Aufgabe 1.4:

(foldl (curry + 3) 1 '(2 3 5))
;->20
;Alle Werte der Liste werden zusammengerechnet und um 3 inkrementiert und das neutrale
;Element wird am Ende dazugerechnet: 2+3 + 3+3 + 3+5 + 1 = 20

(map even? '(4 587 74 69 969 97 459 4))
;>'(#t #f #t #f #f #f #f #t)
;Es wird eine Liste zurückgegeben, mit den Ergebnisen der even? Funktion angewandt auf jedes
;Element der eingegebenen Liste

(filter number? '(#f (2) 3 (()) 4 -7 "c"))
;->'(3 4 -7)
;Es werden alle Elemente, die die Bedingung number? erfüllen in einer Liste ausgegeben
;(2) wird nicht als number erkannt

((curry filter (compose test-vergleich
                       (curry ermittle-vergleichsoperation 11)))
 '(5682 48 24915 -45 -6 48 11))
;(-45 -6)
;test-vergleich gibt nur #t zurück, wenn die übergebene Funktion nicht 0 0 und 11 12 ui
;#f auswertet.
;(curry ermittle-vergleichsoperation 11) gibt < zurück, wenn das 2. Element größer ist usw.
;test-vergleich gibt also nur #t für alle Elemente der Liste wieder, die kleiner als 11 sind
; also werden nur -45 und -6 in einer Liste ausgegeben

;Aufgabe 2.1:
(define xs '(0 3 -2 4 7 8))

(map(curryr expt 2) xs)
(define sqr-list (curry map sqr))

;Aufgabe 2.2: 
(filter (lambda (x)
          (or (= 0 (remainder x 3))
              (= 0 (remainder x 7))))
        xs)

;Aufgabe 2.3:
(foldl + 0 (filter(lambda (x)
                   (> x 6))
       xs))


;Aufgabe 3.1:
(require se3-bib/setkarten-module)

(define Anzahl '(1 2 3))
(define Form '(oval waves rectangle))
(define Fuellung '(outline solid hatched))
(define Farbe '(red green blue))

(define (show-card card)
   (apply show-set-card card))

;(define Card '(2 oval solid blue))
;(show-card Card)

;Aufgabe 3.2:
;Erzeuge ein Kartendeck mit allen möglichen Kombinationen
(define (create-deck)
   (for*/list ([i Anzahl]
                [j Form]
                [k Fuellung]
                [l Farbe]
                )
      (list i j k l)))



;Stelle alle Karten eines Kartendecks visuell dar
(define (visualize-cards cards)
   (map show-card cards)
   )

;(visualize-cards (create-deck))

;Aufgabe 3.3
( define (is-a-set? cards)
   (if
    (= 3 (length cards))
   
    ; Abbruchbedingung der Rekursion
    (if 
     (> 1 (length (car cards)))
     #t
     
     ;Für jede Eigenschaft muss gelten, dass entweder alle gleich oder alle unterschiedlich sind
     (and      
       (or
         (all-the-same?  (map car cards))
         (all-different? (map car cards)))
        (is-a-set? (map cdr cards))))   ;map cdr um von jedem Elemet der Liste den Rest zu nehmen
    #f))


( define (all-the-same? list)
   ; Sind das vordereste und das 2. Element identisch?
    (if
     (equal? (car list) (cadr list))
     ;Sind das vorderste und das letzte Element identisch?
     (if
      (equal? (car list) (caddr list))
       #t
       #f)
     #f))

( define (all-different? list)
   ; Sind das vordereste und das 2. Element identisch?
    (if
     (equal? (car list) (cadr list))
     #f
     ;Sind das vorderste und das letzte Element identisch?
     (if
      (equal? (car list) (caddr list))
       #f
       ;Sind das mittlere und das letzte Element identisch?
     (if
      (equal? (cadr list) (caddr list))
      #f
      #t))))


(is-a-set? '((2 red oval hatched)
              (2 red rectangle hatched)
              (2 red wave hatched)))
   (take (shuffle (create-deck)) 12)