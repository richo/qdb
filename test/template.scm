(test-begin "template")

(test "Should render templates without interpolated forms"
      "Rawr Test Thing\n"
      (load-template "test/no_interpolated_forms.html"))

(test-end)
