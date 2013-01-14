(test-begin "template")

(test "Should load templates without interpolated forms"
      '(Rawr Test Thing)
      (load-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms"
      "Rawr Test Thing"
      (render-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms with locals"
      "Rawr Test Thing"
      (render-template "test/no_interpolated_forms.html" '((foo . "rawr"))))

(test "Should render templates with interpolated forms"
      "Rawr Test buttslol Foo"
      (render-template "test/interpolated_forms.html"))

(test "Should render templates with escaped forms"
      "Rawr Test (hello world)"
      (render-template "test/escaped_forms.html"))

(test "Should render templates with inline html"
      "<html><head><title>butts</title></head><body>lols</body></html>"
      (render-template "test/inline_html.html"))

(test "Should render templates with local variables"
      "rawr test butts"
      (render-template "test/local_variables.html" '((key . "butts"))))

(test "Should include variables from local scope"
      "rawr test butts"
      (let ((somevar "butts"))
        (render-template "test/local_variables.html" `((key . ,somevar)))))

(test "Should handle inline variables in other forms"
      "test butts test"
      (render-template "test/inline_list_variable.html" '((key . 'butts))))

(test-end)
