# Racket Syntax

Prefix notation:  
Operators are written before their operands, for example: `(+ 1 2)`


```
; comment

#| longer
   comment |#
```
(**define**  _id  value_)  
(**define**  _id  expression_)  
(**define**  (_name  id  ..._)  _body_)
```
(define a 20)
(define b (* 3 2))
(define (example1 x y)
    (+ x y))

a                               > 20             
b                               > 6             
(example1 2 3)                  > 5
```
(**lambda**  (_id  ..._)  _body_)
```
(lambda (x) (* 2 x))            ; anonymous function
((lambda (x) (* 2 x)) 3)        > 6   

(define example2                ; equivalent definition to example1
    (lambda (x y) (+ x y)))

(example2 2 3)                  > 5
``` 
(**if**  _test-expression  then-expression  else-expression_)  
```
(if (positive? 5) "yes" "no")   > "yes" 

(define (max2 a b)
    (if (> a b)                 ; if a>b,
        a                       ; then a
        b))                     ; else b
(max2 3 7)                      > 7
```
(**when**  _test-expression  body_)
```
(when (positive? -5)            ; #f
    (display "hello"))
(when (positive? 5)             ; #t
    (display "hi")
    (display " there"))         > hi there
```
(**unless**  _test-expression  body_)  
Equivalent to (**when**  (not  _test-expression_)  _body_)
```
(unless (positive? 5)           ; #f
    (display "hello"))
(unless (positive? -5)          ; #t
    (display "hi")
    (display " there"))         > hi there
```
(**cond**  [_test-expression  then-body_]  
           [_..._]  
           [**else**  _then-body_])             
**else** is a catch-all.
```
(define (type-of n)
  (cond [(boolean? n) 'boolean]
        [(list? n)    'list]
        [(number? n)  'number]))

(type-of (* 2 3 4))             > 'number
(type-of (not 42))              > 'boolean
(type-of '())                   > 'list
```
(**let**  ([_id  expression_]  
           [_..._])  
           _body_)
```
(let ([x 2]                     ; variable x = 2
      [y (+ 1 2)])              ; variable y = 3
     (+ x y))                   ; body
                                > 5

(let* ([x 3]                    ; let* for sequential dependencies
       [y (* x x)])
      (+ x y))                  > 12
```



(156)
