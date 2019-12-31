*"* use this source file for your ABAP unit test classes
CLASS ltc_email_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.

    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_email_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = '120190228'                            valid = abap_false )
        ( data = ''                                     valid = abap_false )
        ( data = 'Abc.example.com'                      valid = abap_false )
        ( data = 'a"b(c)d,e:f;gi[j\k]l@example.com'     valid = abap_false )
        ( data = 'A@b@c@example.com'                    valid = abap_false )
        ( data = 'john.doe@example..com'                valid = abap_false )
        ( data = 'user@[IPv6:2001:db8::1]'              valid = abap_false )
        ( data = 'this\ still\"not\allowed@example.com' valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_email_check=>zif_adv_check~check( <case>-data ).

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
        ( data = 'HHELIBEB@GMAIL.com'  valid = abap_true )
        ( data = 'sujo@vip.qq.com'     valid = abap_true )
        ( data = 'my.sap@outlook.com'  valid = abap_true )
        ( data = 'disposable.style.email.with+symbol@example.com'  valid = abap_true )
        ( data = 'other.email-with-dash@example.com'               valid = abap_true )
        ( data = 'x@example.com'                                   valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_email_check=>zif_adv_check~check( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
