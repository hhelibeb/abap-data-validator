*"* use this source file for your ABAP unit test classes
CLASS ltc_validation_check DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.


    TYPES: BEGIN OF ty_case,
             field1 TYPE string,
             field2 TYPE dats,
             field3 TYPE uzeit,
             field4 TYPE n LENGTH 8,
             field5 TYPE int4,
             field6 TYPE string,
             field7 TYPE string,
             field8 TYPE string,
           END OF ty_case.
    TYPES: ty_case_t TYPE STANDARD TABLE OF ty_case.

    TYPES: BEGIN OF ty_case_element,
             data    TYPE string,
             element TYPE rollname,
             expect  TYPE abap_bool,
           END OF ty_case_element.
    TYPES: ty_case_element_t TYPE STANDARD TABLE OF ty_case_element WITH EMPTY KEY.

    METHODS: deep_input FOR TESTING.
    METHODS: empty_input FOR TESTING.
    METHODS: regex_input FOR TESTING.
    METHODS: initial_input FOR TESTING.
    METHODS: error_input FOR TESTING.
    METHODS: no_error_input FOR TESTING.
    METHODS: class_check FOR TESTING.
    METHODS: class_not_exists FOR TESTING.
    METHODS: check_by_element FOR TESTING.
    METHODS: check_by_element_illegal_input FOR TESTING.
    METHODS: check_table_by_elements FOR TESTING.

ENDCLASS.

CLASS ltc_validation_check IMPLEMENTATION.


  METHOD deep_input.

    DATA: deep_table TYPE zcl_adata_validator=>ty_result_t.
    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.
    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = deep_table
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS NOT BOUND.
      cl_abap_unit_assert=>fail( msg = 'Table with deep structure should be not supported. ' ).
    ENDIF.
  ENDMETHOD.

  METHOD empty_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.
    DATA: input TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.

    rules = VALUE #(
      ( fname = 'CARRID' required = abap_true  user_type = '' )
      ( fname = 'CONNID' required = abap_true  user_type = '' )
    ).

    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = input
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS BOUND OR result IS NOT INITIAL.
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised with empty input' ).
    ENDIF.

  ENDMETHOD.

  METHOD error_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field1 = '19000000' field6 = 'ZZZ@...' )
        ( field1 = '202011321' field6 = 'ZZZ2gmail.com' )
        ( field1 = '' field2 = '20220101' field6 = '' )
    ).

    rules = VALUE #(
      ( fname = 'FIELD1' required = abap_true                                user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD2'                       initial_or_empty = abap_true  user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD6' required = abap_true                                user_type = zcl_adata_validator=>c_type_email )
    ).


    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS BOUND .
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised' ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD1' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '1' fname 'FIELD1' should be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '1' fname 'FIELD6' s should be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 2 fname = 'FIELD2' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '2' fname 'FIELD2' should not be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 3 fname = 'FIELD2' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '3' fname 'FIELD6' should be error. | ).
    ENDIF.

  ENDMETHOD.

  METHOD initial_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    rules = VALUE #(
      ( fname = 'FIELD1' required = abap_true                                user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD2'                       initial_or_empty = abap_true  user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD6' required = abap_true                                user_type = zcl_adata_validator=>c_type_email )
    ).


    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS BOUND .
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised' ).
    ENDIF.

    IF result IS NOT INITIAL.
      cl_abap_unit_assert=>fail( msg = 'No error should be raised' ).
    ENDIF.

  ENDMETHOD.

  METHOD no_error_input.
    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field1 = '19680101' field6 = 'ZZZ@sf.com' )
        ( field1 = '20000229' field6 = 'ZZ.Z2@gmail.com.cn' )
        ( field1 = '99991231' field2 = '' field6 = 'moe@moe.xyz' )
    ).

    rules = VALUE #(
      ( fname = 'FIELD1' required = abap_true                                user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD2'                       initial_or_empty = abap_true  user_type = zcl_adata_validator=>c_type_date )
      ( fname = 'FIELD6' required = abap_true                                user_type = zcl_adata_validator=>c_type_email )
    ).


    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = cases
         ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS BOUND .
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised' ).
    ENDIF.

    IF result IS NOT INITIAL.
      cl_abap_unit_assert=>fail( msg = 'No error should be raised' ).
    ENDIF.
  ENDMETHOD.

  METHOD regex_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field6 = 'ZZ.Z2@gmail.com' )
        ( field6 = 'ZZ.Z2@gmail.com.cn' )
        ( field6 = '' )
    ).

    rules = VALUE #(
      ( fname = 'FIELD6' user_type = zcl_adata_validator=>c_type_email regex = 'gmail\.com$' regex_msg = 'Only gmail supported' )
    ).

    TRY.
        DATA(result) = NEW zcl_adata_validator( )->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.


    IF ex IS BOUND .
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised' ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '1' fname 'FIELD6' should not be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 2 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '2' fname 'FIELD6' should be error. | ).

    ENDIF.

    READ TABLE result WITH KEY row = 3 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '3' fname 'FIELD6' should not be error. | ).
    ENDIF.

  ENDMETHOD.


  METHOD class_check.
    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    rules = VALUE #(
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_date      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_email     )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_time      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_int4      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_regex     )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_timestamp )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_url       )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_hex       )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_json      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_imei      )
    ).

    cases = VALUE #( ( field1 = 'A$$' ) ).

    TRY.
        DATA(result) = NEW zcl_adata_validator( )->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
        cl_abap_unit_assert=>fail( msg = msg ).
    ENDTRY.

  ENDMETHOD.

  METHOD class_not_exists.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    rules = VALUE #(
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_date      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_email     )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_time      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_int4      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_regex     )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_timestamp )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_url       )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_hex       )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_json      )
      ( fname = 'FIELD1' user_type = zcl_adata_validator=>c_type_imei      )
    ).

    cases = VALUE #(
      ( field1 = 'A$$' )
      ( field2 = 'A$$' )
    ).

    DATA: check_class_config TYPE zcl_adata_validator=>ty_check_config_t.

    check_class_config = VALUE #( ( type = zcl_adata_validator=>c_type_date  class = 'ZCL_ADATA_VALIDATOR' ) ).

    TRY.
        DATA(result) = NEW zcl_adata_validator( check_class_conifg = check_class_config )->validate(
             rules   = rules
             data    = cases
         ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS NOT BOUND.
      cl_abap_unit_assert=>fail( msg = 'exception expected for ZCL_ADATA_VALIDATOR' ).
    ENDIF.


    check_class_config = VALUE #( ( type = zcl_adata_validator=>c_type_email class = 'ZCL_ADV_XXX_CHECK' ) ).

    TRY.
        DATA(result2) = NEW zcl_adata_validator( check_class_conifg = check_class_config )->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex2).
        DATA(msg2) = ex2->get_text( ).
    ENDTRY.

    IF ex2 IS NOT BOUND.
      cl_abap_unit_assert=>fail( msg = 'exception expected for ZCL_ADV_XXX_CHECK' ).
    ENDIF.


  ENDMETHOD.

  METHOD check_by_element.

    DATA: cases TYPE ty_case_element_t.

    cases = VALUE #(
        ( data = 'XX'                               element = 'GUID'                         expect = abap_false )
        ( data = 'ZZZ'                              element = 'INT4'                         expect = abap_false )
        ( data = 'XX'                               element = 'RAW128'                       expect = abap_false )
        ( data = 'XX'                               element = 'DATUM'                        expect = abap_false )
        ( data = 'XX'                               element = 'UZEIT'                        expect = abap_false )
        ( data = '20190101000000X'                  element = 'TIMESTAMP'                    expect = abap_false )
        ( data = 'XX'                               element = 'ANZMS'                        expect = abap_false )
        ( data = '1000.00'                          element = 'ANZMS'                        expect = abap_false )
        ( data = '667F98FDC91D46CF90629A879F18EA0D' element = 'GUID'                         expect = abap_true  )
        ( data = '2147483647'                       element = 'INT4'                         expect = abap_true  )
        ( data = '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D' &&
                 '667F98FDC91D46CF90629A879F18EA0D'
                                                    element = 'RAW128'                       expect = abap_true  )
        ( data = '20200228'                         element = 'DATUM'                        expect = abap_true  )
        ( data = '235959'                           element = 'UZEIT'                        expect = abap_true  )
        ( data = '20190101000000'                   element = 'TIMESTAMP'                    expect = abap_true  )
        ( data = '20190101000000'                   element = 'LXE_SNO_DE_TIME_LAST_CHANGED' expect = abap_true  )
        ( data = '33'                               element = 'ANZMS'                        expect = abap_true  )
        ( data = '999.99-'                          element = 'ANZMS'                        expect = abap_true  )
        ( data = '+999.99'                          element = 'ANZMS'                        expect = abap_true  )
    ).

    DATA(validator) = NEW zcl_adata_validator( ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      TRY.
          DATA(result) = validator->validate_by_element(
            data    = <case>-data
            element = <case>-element
          ).
        CATCH zcx_adv_exception INTO DATA(ex).
          DATA(msg) = ex->get_text( ).
          cl_abap_unit_assert=>fail( msg = 'unexpected exception' ).
      ENDTRY.

      cl_abap_unit_assert=>assert_equals(
        act = result-valid
        exp = <case>-expect
        msg = |Result of data: '{ <case>-data }' type: '{ result-type }' should be '{ <case>-expect }'|
      ).

    ENDLOOP.

  ENDMETHOD.

  METHOD check_table_by_elements.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field1 = '19000000'  )
        ( field1 = '202011321' )
        ( field1 = '20201121'  )
    ).

    rules = VALUE #(
      ( fname = 'FIELD1' required = abap_true ref_element = 'DATUM' )
    ).


    DATA(validator) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = validator->validate(
             rules   = rules
             data    = cases
        ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.

    IF ex IS BOUND .
      cl_abap_unit_assert=>fail( msg = 'No exception should be raised' ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD1' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '1' fname 'FIELD1' should be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 2 fname = 'FIELD1' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '2' fname 'FIELD1' should not be error. | ).
    ENDIF.

    READ TABLE result WITH KEY row = 3 fname = 'FIELD1' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail( msg = |Result of row '3' fname 'FIELD1' should be error. | ).
    ENDIF.

  ENDMETHOD.

  METHOD check_by_element_illegal_input.

    DATA: cases TYPE ty_case_element_t.

    cases = VALUE #(
        ( data = 'XX'  element = ''        expect = abap_false )
        ( data = 'ZZZ' element = 'MY TEST' expect = abap_false )
        ( data = 'ZZZ' element = 'SFLIGHT' expect = abap_false )
    ).

    DATA(validator) = NEW zcl_adata_validator( ).

    LOOP AT cases ASSIGNING FIELD-SYMBOL(<case>).

      TRY.
          DATA(result) = validator->validate_by_element(
            data    = <case>-data
            element = <case>-element
          ).
        CATCH zcx_adv_exception INTO DATA(ex).
          DATA(msg) = ex->get_text( ).
      ENDTRY.

      IF ex IS NOT BOUND.
        cl_abap_unit_assert=>fail( msg = 'exception should be thrown' ).
      ENDIF.

      FREE ex.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
