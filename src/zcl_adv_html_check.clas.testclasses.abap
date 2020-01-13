*"* use this source file for your ABAP unit test classes
CLASS ltc_html_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_html_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '<HTML></HTML>'   valid = abap_false )
    ).

  ENDMETHOD.

  METHOD valid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data =
            |<!DOCTYPE html>|                 &&
            |<html lang=en>|                  &&
            |<head>|                          &&
            |    <meta charset=utf-8>|        &&
            |    <title>Page Title</title>|   &&
            |</head>|                         &&
            |<body>|                          &&
            |    <h1>This is a Heading</h1>|  &&
            |    <p>This is a paragraph.</p>| &&
            |</body>|                         &&
            |</html>|
          valid = abap_true )
    ).

  ENDMETHOD.

ENDCLASS.
