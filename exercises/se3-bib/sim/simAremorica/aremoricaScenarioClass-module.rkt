#lang swindle

#|
################################################################################
##                                                                            ##  
##            This file is part of the se3-bib Racket module v3.0             ##  
##                Copyright by Leonie Dreschler-Fischer, 2010                 ##
##              Ported to Racket v6.2.1 by Benjamin Seppke, 2015              ##  
##                                                                            ##  
################################################################################
|#
  
(require se3-bib/sim/simAppl/sim-application-package)
  
(defclass* aremorica-scenario 
  (customer-server-scenario)
  :documentation 
  "A little village in Aremorica with brave gaulles"
  :autopred #t ; auto generate predicate sim-scenario?
  :printer  #t)

;for testing:
#|
require se3-bib/sim/simAremorica/aremorica-scenario-package)
(define littleVillage 
  (make aremorica-scenario :actor-name "Aremorica" ))
|#
