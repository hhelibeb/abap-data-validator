*"* use this source file for your ABAP unit test classes
CLASS ltc_hex_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_hex_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '123'  valid = abap_false )
        ( data = '123X'  valid = abap_false )
        ( data = '0x00'  valid = abap_false )
        ( data = '12a1'  valid = abap_false )
        ( data = '12G1'  valid = abap_false )
        ( data = ''  valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_hex_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = '0123'                             valid = abap_true )
        ( data = '00'                               valid = abap_true )
        ( data = 'FF'                               valid = abap_true )
        ( data = '42F10816850C1EE7A7813C906AF44718' valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_hex_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
