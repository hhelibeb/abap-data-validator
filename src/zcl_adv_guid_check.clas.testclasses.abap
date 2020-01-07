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
        ( data = '0050561EFE691ED9A9E5182BE684EZEA'     valid = abap_false )
        ( data = '!'                                    valid = abap_false )
        ( data = 'your mom'                             valid = abap_false )
        ( data = 'NULL'                                 valid = abap_false )
        ( data = '0050561efe691ed9a9e5182be684e5ea'     valid = abap_false )
        ( data = 'C56A4180-65AA-42EC-A945-5FD21DEC0538' valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_guid_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = '0050561EFE691ED9A9E5182BE684E5EA' valid = abap_true )
        ( data = 'C56A418065AA42ECA9455FD21DEC0538' valid = abap_true )
        ( data = '42F10816850C1EE7A7813CEF57F5C70D' valid = abap_true )
        ( data = '667F98FDC91D46CF90629A879F18EA0D' valid = abap_true )
        ( data = '053F21DC7A8749CD93C36B8EB84D3671' valid = abap_true )
        ( data = '8C588E09BE65423CBCCE73C401E7B770' valid = abap_true )
        ( data = '67C9540D1EA8427087BC8EF993D0A811' valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_guid_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
