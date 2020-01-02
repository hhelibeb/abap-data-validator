*"* use this source file for your ABAP unit test classes
CLASS ltc_timestamp_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_timestamp_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '99991232000000'  valid = abap_false )
        ( data = '20200101HHMMSS'  valid = abap_false )
        ( data = '20200101000000X' valid = abap_false )
        ( data = 'X201001235959'  valid = abap_false )
        ( data = '201001235960'       valid = abap_false )
        ( data = 'MQSCL2'  valid = abap_false )
        ( data = ''          valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_timestamp_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = '19000101000000'  valid = abap_true )
        ( data = `19000101000000 ` valid = abap_true )
        ( data = '99991231235959'  valid = abap_true )
    ).

    GET TIME STAMP FIELD DATA(ts).

    cases = VALUE #( BASE cases (  data = ts valid = abap_true ) ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_timestamp_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
