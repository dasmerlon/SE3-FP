#lang racket

#|
################################################################################
##                                                                            ##  
##            This file is part of the se3-bib Racket module v3.0             ##  
##                Copyright by Leonie Dreschler-Fischer, 2010                 ##
##              Ported to Racket v6.2.1 by Benjamin Seppke, 2015              ##  
##                                                                            ##  
################################################################################
|#

(provide
 
 ;high order functions
 conjoin disjoin
 always never
 identity id
 iter-until iterate ;recursive
 gen-iterate ;with generators
 fgenerator
 take-generator-until
 reduce reduce-right ;deprecated
 !=
 
 ;lists
 sublis subtree subseq 
 position
 atom?
 concat  
 mklist 
 ensure-car
 nats-1-n
 list-of-n-items
 
 ; strings
 writeln space
 
 ; numbers 
 random-real random-elt one-of
 fac fib
 
 ;memoization
 memo
 
 ; non deterministic functions
 amblist amb-car amb-cdr
 
 ; system
 klingeling
 
 ; Newton-Verfahren
 deriv newton tangente

 ; more flexible eval 
 racket/base-eval
 
 ; deprecated
 some some? every
 ; ====================================
 ; provided by racket:
 
 ; high order functions:
 ;    compose 
 ;    foldl foldr 
 ;    filter filter-not
 ;    negate
 ;    const
 ;    curry curryr
 ;    build-list
 ;    
 
 ; list processing
 ;    take drop
 ;    last
 ;    flatten 
 ;    append-map fuer mappend
 
 ; numeric functions
 ;    pi
 ;    add1, sub1
 
 ; streams (ersetzt durch #lang lazy)
 ;    head-stream tail-stream cons-stream
 ;    empty-stream? cons-stream2
 ;    the-empty-stream stream-ref
 ;    map-stream filter-stream for-each-stream
 ;    take-stream drop-stream force-stream
 ;    append-streams mappend-stream combine-all-streams
 ;    print-stream integers-from-n 
 ;    divisible? not-divisible?
 ;
 ;   no-sevens fibs ints
 ;   sieve
 
 
 ; deprecated
 ;    != odd even
 ; find-if aus Swindle wird in Racket findf
 ; some entspricht memf in Racket
 )

;==============================================  

(require 
  racket/trace
  mzlib/defmacro; fuer define-macro
  swindle/extra; fuer amb
  racket/generator; fuer sequenzen
  (only-in racket/gui bell)) ; fuer bell

(define racket/base-eval
  ;;; Performes an eval in the racket/base environment,
  ;;; also works in definition environments.
  (let ((ns (make-base-namespace)))
    (parameterize ((current-namespace ns))
      (namespace-require 'racket/base))
    (lambda (expr) (eval expr ns))))


(define always
  ;;; the function that is constantly #t.
  (const #t))

(define never
  ;;;the function that is constantly #f.
  (const #f))

(define disjoin 
  ;; return a composite predicate that is true 
  ;; if any of the component  predicates are true
  ;; all predicates must take the same number of args
  (lambda functions
    (lambda args
      (ormap 
       (lambda (f)
         (apply f args))
       functions))))

(define conjoin 
  ;; return a composite predicate that is true 
  ;; if all of the component  predicates are true
  ;; all predicates must take the same number of args
  (lambda functions
    (lambda args
      (andmap 
       (lambda (f)
         (apply f args))
       functions))))

(define (identity x)
  ; identity : (any -> any)
  ; return an argument unchanged
  x)

; basic utilities
(define (id . args) (apply values args) )
; die Identitaetsfunktion fuer beliebig viele Argumente

(define != (compose not =)) 

(define (iterate f end? seed)
  ; apply f to seed and repeat the process 
  ; on the sequence of results (f (f (.. seed)))
  ; until (end? (f(f ..seed))) is satisfied. 
  ; return the last value.
  (letrec ([iteration 
            (lambda (result nth-term)
              (let ([new-term (f nth-term)])
                (if (end? nth-term) result
                    (iteration 
                     (cons new-term result)
                     new-term))))])
    (reverse 
     (iteration (list seed) seed))))

(define (fgenerator f init)
  ; return a generator for iterative applications of f,
  ; starting with init
  (generator ()
             (letrec 
                 ([floop 
                   (lambda (x)
                     (yield x)
                     (floop (f x)))])
               (floop init))))

(define (take-generator-until seq end?)
  ; collect the sequence generated by seq into a list
  ; until end? is satisfied
  (for/list 
      ([item (in-producer seq end?)])
    item ))

(define (gen-iterate f end? seed)
  ; collect iterative applications of f, 
  ; starting with seed
  ; stop when end is satisfied.
  
  (let ([fgen (fgenerator f seed)])
    (take-generator-until fgen end?)))

; deprecated, use foldl
(define (reduce f xs seed)
  (cond [(null? xs) seed]
        [else
         (reduce f 
                 (cdr xs)
                 (f (car xs) seed))]))

; deprecated, use foldr

(define (reduce-right f xs seed)
  ; allgemein rekursive Reduktion
  (if (null? xs)
      seed
      (f (car xs) 
         (reduce-right  f (cdr xs) seed))))

;deprecated, use ormap
(define some? ormap)

;deprecated, use memf
(define some memf)

;deprecated, use andmap
(define every andmap)
; also provided by swindle
;; does each set of args satisfy p?

(define (iter-until f end? seed)
  ; the until function of Miranda
  ; apply f to seed and repeat the process on the sequence of results (f (f (.. seed)))
  ; until (end? (f(f ..seed))) is satisfied. return the last value.
  
  (if (end? seed) seed
      (iter-until f end? (f seed))))



(define writeln 
  ; display all the args, followed by a newline
  (lambda args
    (for-each display args)
    (newline)))

(define (space n) 
  (make-string n #\space))



; ===========================================
; numerical functions
; ===========================================

;;; Choose an element from a list at random
(define (random-elt choices)
  (list-ref choices 
            (random (length choices))))

(define (one-of set)
  ;;;Pick one element of set, and make a list of it.
  (list (random-elt set)))

(define (random-real)
  ; return a random number between 0.0 and 1.0
  (/ (random 4294967087)
     4294967087.0))

; ========================================
; list functions
; ========================================

(define (sublis subs xs)
  ; substitute the elements of a linear list
  (let ([replacement 
         (lambda (x)
           (let ((found (assoc x subs)))
             (if (not found) x
                 (cdr found))))])
    (map replacement xs)))

;;>> (maptree func tree)
;;>   Applies given function to a tree made of cons cells, and return the
;;>   results tree with the same shape.
(define (maptree f x)
  (let loop ([x x])
    (cond [(list? x) (map loop x)]
          [(pair? x) (cons (loop (car x)) (loop (cdr x)))]
          [else (f x)])))

(define (subtree subs xs)
  ; subs: an assocoation list
  ; xs: a potentially nested list
  ; substitute the leaves of a tree 'xs'
  ; according to the dotted pairs of 'subs'
  (let ((replacement 
         (lambda (x)
           (let ((found (assoc x subs)))
             (if (not found) x
                 (cdr found))))))
    (maptree replacement xs)))

(define (subseq xs from to)
  ; the sublist of xs starting by element 'from'
  ; and ending by element 'to', zero indexed
  ;bugfix: former versions of take and drop had a different order of the arguments
  (take (drop xs from)
        (add1 (- to from)) 
        ))

(define (atom? v)
  (not (pair? v)))

(define (position x xs start)
  ; at which position does x occur in xs (skipping up to start elements)?
  (letrec 
      ((locate
        (lambda (x xs pos)
          (cond ((null? xs) #f)
                ((equal? x (car xs)) pos)
                (else (locate x (cdr xs) (+ 1 pos)))))))
    (locate x (drop xs start) start)))

(define (nats-1-n n)
  (build-list n (curry + 1)))


(define (list-of-n-items n item)
  (build-list n (const item)))

(define (mklist x)
  "Return x if it is a list, otherwise (x)."
  (if (list? x)
      x
      (list x))) 

(define (concat xss)
  ;; concatenate the sublists of a list of list
  (apply append xss))


(define (klingeling wieoft)
  (iter-until 
   (lambda (x) (bell) (add1 x))
   (curry = wieoft)
   0)
  (void))

;;;; =============================================================================================
;;;; Memoization
;;;; =============================================================================================
(define (fib n)
  "compute the n-th fibonacci number"
  (cond ((= 0 n) 1)
        ((= 1 n) 1)
        (else ( + (fib (- n 1))
                  (fib (- n 2))))))

(define (fac n)
  (if (= n 0) 1 (* n (fac (- n 1)))))

(define (memo fn)
  "Return a memo-function of fn."
  (letrec 
      ((table '())
       (store 
        (lambda (arg val) 
          (set! table (cons (cons arg val) table))
          val))
       (retrieve 
        (lambda (arg) 
          (let ((val-pair (assoc arg table)))
            (if val-pair (cdr val-pair) #f))))
       (ensure-val 
        (lambda (x)
          (let ((stored-val (retrieve x)))
            (if stored-val stored-val
                (store x (fn x)))))))
    ensure-val)) 


; non determinism
(define-syntax amblist
  ; return non deterministically one element from l
  ; macro, only for very short lists,
  ; the elements of the list have to be quoted
  (syntax-rules ()
    ((amb l) (eval `(amb ,@l)))
    ))

(define (amb-car xs)
  ;recursively try all elements of xs with amb
  ; like amblist, but amb-car is a function,
  ; the elements of the list don't need to be quoted
  (if (null? xs) (amb)
      (amb (car xs) (amb-car (cdr xs)))))

(define (amb-cdr xs)
  ;recursively try all cdrs of xs with amb
  (if (null? xs) (amb)
      (amb xs (amb-cdr (cdr xs)))))

; syntax utilities
(define-syntax ensure-car 
  ; evaluate expr only if l is a proper list
  (syntax-rules ()
    ((ensure-car l expr) 
     (if (pair? l) expr #f))
    ))

(define-syntax <0>
  ; three way case : <0, ==, >0
  (syntax-rules ()
    ((<0> num case<0 case=0 case>0)
     (cond ((< num 0) case<0)
           ((= num 0) case=0)
           ((> num 0) case>0)))))

;;; Newton-Method
(define (deriv f)
  ; the derivative of f'
  (let ([dx 0.00001])
    (lambda (x)
      (/ (- (f (+ x dx)) (f x))
         dx))))

(define (newton f)
  ;;Find a root of f, start with first-guess.
  (lambda (first-guess)
    (let* ((eps 0.00001)
           (good-enough?
            (lambda (y)
              (< (abs (f y)) eps)))
           (improve 
            (lambda (y)
              (- y (/ (f y)
                      ((deriv f) y)))))) 
      (iter-until
       improve good-enough? first-guess))))

(define (tangente f x)
  ; the tangent of f is a straight line 
  ; with a gradient m = (deriv f)
  ; and the intercept c = (f x)- m*x
  (lambda (xx)
    (let* ((m ((deriv f) x))
           (c (-(f x)(* m x))))
      (+ (* m xx) c))))


