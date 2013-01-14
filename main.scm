#!/usr/bin/env csi -ss

(require "pilgrim/pilgrim")

(define qdb-port
  (string->number (get-environment-variable "PORT")))

(define main
  (lambda (argv)
    (start qdb-port (lambda (request response)
             (set-response-body "'(db)"
                                response)
             ))))
