*"* use this source file for your ABAP unit test classes
CLASS ltc_json_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_json_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = 'zzz'   valid = abap_false )
        ( data = '{A:1}' valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_json_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = '{"A":1}'    valid = abap_true )
        ( data = '123'        valid = abap_true )
        ( data = '"string"'   valid = abap_true )
        ( data = '[{"field1":"Hello World!","field2":"Eat me!","field3":20,"field4":"I am BIG!"},{"field1":"Hello World!","field2":"Eat me!","field3":20,"field4":"I am BIG!"}]' valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_json_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
