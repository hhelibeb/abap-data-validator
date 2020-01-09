*"* use this source file for your ABAP unit test classes
CLASS ltc_base64_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_base64_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '^'  valid = abap_false )
        ( data = 'A'  valid = abap_false )
        ( data = 'A^' valid = abap_false )
        ( data = '4rdHFh%2BHYoS8oLdVvbUzEVqB8Lvm7kSPnuwF0AAABYQ%3D' valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_base64_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.

  ENDMETHOD.

  METHOD valid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = ''         valid = abap_true )
        ( data = 'Zm9vYmFy' valid = abap_true )
        ( data = 'Zm9vYmE=' valid = abap_true )
        ( data = 'Zm9vYg==' valid = abap_true )
        ( data = 'AA=='     valid = abap_true )
        ( data = 'AAA='     valid = abap_true )
        ( data = 'AAAA'     valid = abap_true )
        ( data = '/w=='     valid = abap_true )
        ( data = '//8='     valid = abap_true )
        ( data = '////'     valid = abap_true )
        ( data = '/+8='     valid = abap_true )
        ( data = 'YmFzZTY0IHRlc3QgdGV4dA==' valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_base64_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
