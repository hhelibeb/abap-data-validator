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

    METHODS: deep_input FOR TESTING.
    METHODS: empty_input FOR TESTING.
    METHODS: regex_input FOR TESTING.
    METHODS: initial_input FOR TESTING.
    METHODS: error_input FOR TESTING.
    METHODS: no_error_input FOR TESTING.
    METHODS: class_check FOR TESTING.

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
      cl_abap_unit_assert=>fail(
         msg = 'Table with deep structure should be not supported. '
     ).
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
      cl_abap_unit_assert=>fail(
         msg = 'No exception should be raised with empty input'
     ).
    ENDIF.

  ENDMETHOD.

  METHOD error_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field1 = '19000000' field6 = 'ZZZ@...')
        ( field1 = '202011321' field6 = 'ZZZ2gmail.com')
        ( field1 = '' field2 = '20220101' field6 = '')
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
      cl_abap_unit_assert=>fail(
         msg = 'No exception should be raised'
     ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD1' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '1' fname 'FIELD1' should be error. |
    ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '1' fname 'FIELD6' s should be error. |
    ).
    ENDIF.

    READ TABLE result WITH KEY row = 2 fname = 'FIELD2' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '2' fname 'FIELD2' should not be error. |
    ).
    ENDIF.

    READ TABLE result WITH KEY row = 3 fname = 'FIELD2' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '1' fname 'FIELD6' should be error. |
    ).
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
      cl_abap_unit_assert=>fail(
         msg = 'No exception should be raised'
     ).
    ENDIF.

    IF result IS NOT INITIAL.
      cl_abap_unit_assert=>fail(
         msg = 'No error should be raised'
     ).
    ENDIF.

  ENDMETHOD.

  METHOD no_error_input.
    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field1 = '19680101' field6 = 'ZZZ@sf.com')
        ( field1 = '20000229' field6 = 'ZZ.Z2@gmail.com.cn')
        ( field1 = '99991231' field2 = '' field6 = 'moe@moe.xyz')
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
      cl_abap_unit_assert=>fail(
         msg = 'No exception should be raised'
     ).
    ENDIF.

    IF result IS NOT INITIAL.
      cl_abap_unit_assert=>fail(
         msg = 'No error should be raised'
     ).
    ENDIF.
  ENDMETHOD.

  METHOD regex_input.

    DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field6 = 'ZZ.Z2@gmail.com')
        ( field6 = 'ZZ.Z2@gmail.com.cn')
        ( field6 = '')
    ).

    rules = VALUE #(
      ( fname = 'FIELD6' user_type = zcl_adata_validator=>c_type_email regex = 'gmail\.com$' regex_msg = 'Only gmail supported')
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
      cl_abap_unit_assert=>fail(
         msg = 'No exception should be raised'
     ).
    ENDIF.

    READ TABLE result WITH KEY row = 1 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '1' fname 'FIELD6' should not be error. |
    ).
    ENDIF.

    READ TABLE result WITH KEY row = 2 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '2' fname 'FIELD6' should be error. |
    ).

    ENDIF.

    READ TABLE result WITH KEY row = 3 fname = 'FIELD6' error = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail(
        msg = |Result of row '3' fname 'FIELD6' should not be error. |
    ).
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
    ).

    cases = VALUE #(
        ( field1 = 'A$$')
    ).

    DATA(adata_validation) = NEW zcl_adata_validator( ).
    TRY.
        DATA(result) = adata_validation->validate(
             rules   = rules
             data    = cases
         ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
        cl_abap_unit_assert=>fail(
           msg = msg
        ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
