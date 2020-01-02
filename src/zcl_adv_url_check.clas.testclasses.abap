*"* use this source file for your ABAP unit test classes
CLASS ltc_url_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             data  TYPE string,
             valid TYPE abap_bool,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.


    METHODS: invalid_input FOR TESTING.
    METHODS: valid_input FOR TESTING.

ENDCLASS.

CLASS ltc_url_check IMPLEMENTATION.

  METHOD invalid_input.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( data = 'http://invalid.com/perl.cgi?key= | http://web-site.com/cgi-bin/perl.cgi?key1=value1&key2'  valid = abap_false )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_url_check=>zif_adv_check~is_valid( <case>-data ).

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
        ( data = 'http://blpsprd01.mysap.com:8000/sap(bD1lbiZjPTMwMSZkPW1pbg==)/bc/bsp/sap/crm_ui_start/default.htm?sap-client=301&sap-language=EN'  valid = abap_true )
        ( data = 'https://www.google.com/search?client=firefox-b-d&ei=2U8NXs32D4uBk74Pj8yPuAw&q=regex+validation&oq=regex+validation&gs_l=psy-ab.3..0i7i30l10.339237.341461..' &&
        '341795...0.0..1.869.2802.2-2j1j0j2j1......0....1..gws-wiz.......0i8i30j0j0i30.KcKWGUaJUqw&ved=0ahUKEwiNx5P96ePmAhWLwMQBHQ_mA8cQ4dUDCAo&uact=5'   valid = abap_true )
        ( data = 'https://dotabap.org/'          valid = abap_true )
        ( data = 'http://255.255.255.255'        valid = abap_true )
        ( data = 'http://example.com'            valid = abap_true )
        ( data = 'www.example.com'               valid = abap_true )
    ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      DATA(valid) = zcl_adv_url_check=>zif_adv_check~is_valid( <case>-data ).

      cl_abap_unit_assert=>assert_equals(
        act = valid
        exp = <case>-valid
        msg = |Result of { <case>-data } should be '{ <case>-valid }'|
      ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
