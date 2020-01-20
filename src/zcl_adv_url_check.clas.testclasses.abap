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
        ( data = 'http://'                                   valid = abap_false )
        ( data = 'http://.'                                  valid = abap_false )
        ( data = 'http://..'                                 valid = abap_false )
        ( data = 'http://../'                                valid = abap_false )
        ( data = 'http://?'                                  valid = abap_false )
        ( data = 'http://??'                                 valid = abap_false )
        ( data = 'http://??/'                                valid = abap_false )
        ( data = 'http://#'                                  valid = abap_false )
        ( data = 'http://##'                                 valid = abap_false )
        ( data = 'http://##/'                                valid = abap_false )
        ( data = 'http://foo.bar?q=Spaces should be encoded' valid = abap_false )
        ( data = '//'                                        valid = abap_false )
        ( data = '//a'                                       valid = abap_false )
        ( data = '///a'                                      valid = abap_false )
        ( data = '///'                                       valid = abap_false )
        ( data = 'http:///a'                                 valid = abap_false )
        ( data = 'foo.com'                                   valid = abap_false )
        ( data = 'rdar://1234'                               valid = abap_false )
        ( data = 'h://test'                                  valid = abap_false )
        ( data = 'http:// shouldfail.com'                    valid = abap_false )
        ( data = ':// should fail'                           valid = abap_false )
        ( data = 'http://foo.bar/foo(bar)baz quux'           valid = abap_false )
        ( data = 'ftps://foo.bar/'                           valid = abap_false )
        ( data = 'http://-error-.invalid/'                   valid = abap_false )
        ( data = 'http://-a.b.co'                            valid = abap_false )
        ( data = 'http://a.b-.co'                            valid = abap_false )
        ( data = 'http://0.0.0.0'                            valid = abap_false )
        ( data = 'http://10.1.1.0'                           valid = abap_false )
        ( data = 'http://10.1.1.255'                         valid = abap_false )
        ( data = 'http://224.1.1.1'                          valid = abap_false )
        ( data = 'http://1.1.1.1.1'                          valid = abap_false )
        ( data = 'http://123.123.123'                        valid = abap_false )
        ( data = 'http://3628126748'                         valid = abap_false )
        ( data = 'http://.www.foo.bar/'                      valid = abap_false )
        ( data = 'http://.www.foo.bar./'                     valid = abap_false )
        ( data = 'http://10.1.1.254'                         valid = abap_false )
        ( data = 'http://10.1.1.22'                          valid = abap_false )
        ( data = 'http://10.1.1.1'                           valid = abap_false )
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
        ( data = 'https://dotabap.org/'                            valid = abap_true )
        ( data = 'http://223.255.255.254'                          valid = abap_true )
        ( data = 'http://1.1.1.253'                                valid = abap_true )
        ( data = 'http://example.com'                              valid = abap_true )
        ( data = 'http://例子.测试'                                 valid = abap_true )
        ( data = 'http://مثال.إختبار'                                  valid = abap_true )
        ( data = 'http://✪df.ws/123'                               valid = abap_true )
        ( data = 'http://userid:password@example.com:8080'         valid = abap_true )
        ( data = 'http://userid:password@example.com:8080/'        valid = abap_true )
        ( data = 'http://userid@example.com'                       valid = abap_true )
        ( data = 'http://userid@example.com/'                      valid = abap_true )
        ( data = 'http://userid@example.com:8080'                  valid = abap_true )
        ( data = 'http://userid@example.com:8080/'                 valid = abap_true )
        ( data = 'http://userid:password@example.com'              valid = abap_true )
        ( data = 'http://userid:password@example.com/'             valid = abap_true )
        ( data = 'http://142.42.1.1/'                              valid = abap_true )
        ( data = 'http://142.42.1.1:8080/'                         valid = abap_true )
        ( data = 'http://➡.ws/䨹'                                  valid = abap_true )
        ( data = 'http://⌘.ws'                                     valid = abap_true )
        ( data = 'http://⌘.ws/'                                    valid = abap_true )
        ( data = 'http://foo.com/blah_(wikipedia)#cite-1'          valid = abap_true )
        ( data = 'http://foo.com/blah_(wikipedia)_blah#cite-1'     valid = abap_true )
        ( data = 'http://foo.com/unicode_(✪)_in_parens'            valid = abap_true )
        ( data = 'http://foo.com/(something)?after=parens'         valid = abap_true )
        ( data = 'http://☺.damowmow.com/'                          valid = abap_true )
        ( data = 'http://code.google.com/events/#&product=browser' valid = abap_true )
        ( data = 'http://j.mp'                                     valid = abap_true )
        ( data = 'ftp://foo.bar/baz'                               valid = abap_true )
        ( data = 'http://foo.bar/?q=Test%20URL-encoded%20stuff'    valid = abap_true )
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
