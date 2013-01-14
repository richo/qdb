#!/usr/bin/env csi -ss

(load-relative "template.scm")
(require "pilgrim/pilgrim")

(define qdb-port
  (lambda () (string->number (get-environment-variable "PORT"))))

(define main
  (lambda (argv)
    (start (qdb-port) (lambda (request response)
                      (let ((request-path (get-request-path request)))
                        (cond
                          ((equal? request-path "/")
                           (set-response-body (render-template "index.html")
                                              response))
                          ((equal? request-path "/quotes")
                           (set-response-body "Quotes page!"
                                              response))
                          (else
                           (set-response-status 404
                           (set-response-body "Page not found"
                                              response)))
                        ))))))
