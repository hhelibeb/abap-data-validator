*"* use this source file for your ABAP unit test classes
CLASS ltc_regex_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_regex_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '['  valid = abap_false )
        ( data = '[0-9]++'   valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_regex_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = '^-?(\d{1,9}|1\d{9}|2(0\d{8}|1([0-3]\d{7}|4([0-6]\d{6}|7([0-3]\d{5}|4([0-7]\d{4}|8([0-2]\d{3}|3([0-5]\d{2}|6([0-3]\d|4[0-7])))))))))$|^-2147483648$'  valid = abap_true )
        ( data = '.+'     valid = abap_true )
        ( data = '[0-9]'  valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_regex_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
