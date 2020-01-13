CLASS zcl_adata_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_spec_type TYPE string.

    TYPES: BEGIN OF ty_rule,
             fname            TYPE name_komp, "field name
             required         TYPE abap_bool,
             initial_or_empty TYPE abap_bool,
             user_type        TYPE ty_spec_type,
             regex            TYPE string, "custom regular expression rule
             regex_msg        TYPE string, "custom regular expression error message
           END OF ty_rule.

    TYPES: ty_rules_t TYPE HASHED TABLE OF ty_rule WITH UNIQUE KEY fname user_type.

    TYPES: BEGIN OF ty_msg,
             text TYPE string,
           END OF ty_msg.
    TYPES: ty_msg_t TYPE STANDARD TABLE OF ty_msg WITH EMPTY KEY.

    TYPES: BEGIN OF ty_check_config,
             type    TYPE ty_spec_type,
             class   TYPE seoclsname,
             message TYPE string,
           END OF ty_check_config.
    TYPES: ty_check_config_t TYPE HASHED TABLE OF ty_check_config WITH UNIQUE KEY type.

    TYPES: BEGIN OF ty_default_msg,
             required         TYPE string,
             initial_or_empty TYPE string,
             default          TYPE string,
             class_error      TYPE string,
           END OF ty_default_msg.

    TYPES: BEGIN OF ty_result,
             row     TYPE int4,
             fname   TYPE name_komp,
             error   TYPE abap_bool,
             message TYPE ty_msg_t,
           END OF ty_result.

    TYPES: ty_result_t TYPE SORTED TABLE OF ty_result WITH UNIQUE KEY row fname.

    CONSTANTS: c_type_date TYPE ty_spec_type VALUE 'DATE'.
    CONSTANTS: c_type_time TYPE ty_spec_type VALUE 'TIME'.
    CONSTANTS: c_type_email TYPE ty_spec_type VALUE 'EMAIL'.
    CONSTANTS: c_type_int4 TYPE ty_spec_type VALUE 'INT4'.
    CONSTANTS: c_type_regex TYPE ty_spec_type VALUE 'REGEX'.
    CONSTANTS: c_type_timestamp TYPE ty_spec_type VALUE 'TIMESTAMP'.
    CONSTANTS: c_type_url TYPE ty_spec_type VALUE 'URL'.
    CONSTANTS: c_type_hex TYPE ty_spec_type VALUE 'HEX'.
    CONSTANTS: c_type_json TYPE ty_spec_type VALUE 'JSON'.
    CONSTANTS: c_type_imei TYPE ty_spec_type VALUE 'IMEI'.
    CONSTANTS: c_type_guid TYPE ty_spec_type VALUE 'GUID'.
    CONSTANTS: c_type_base64 TYPE ty_spec_type VALUE 'BASE64'.
    CONSTANTS: c_type_html TYPE ty_spec_type VALUE 'HTML'.


    METHODS:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! initialize some configurations, pass your own configurations on demand
      "! @parameter check_class_conifg | check classes & type names
      "! @parameter default_message    | default message for some base checks
      constructor IMPORTING check_class_conifg TYPE ty_check_config_t OPTIONAL
                            default_message    TYPE ty_default_msg OPTIONAL.

    METHODS: "! <p class="shorttext synchronized" lang="en"></p>
      "! <p>Validation method for internal table</p>
      "! @parameter rules            | rules for validation
      "! @parameter data             | internal table to be validated
      "! @parameter results          | if all of data is valid, result will be empty
      "! @raising zcx_adv_exception  | type of importing error/check class error
      validate IMPORTING !rules         TYPE ty_rules_t
                         !data          TYPE ANY TABLE
               RETURNING VALUE(results) TYPE ty_result_t
               RAISING   zcx_adv_exception.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: check_config TYPE ty_check_config_t.

    DATA: default_msg TYPE ty_default_msg.

    DATA: results_temp TYPE ty_result_t.

    METHODS: basic_check IMPORTING !rules TYPE ty_rules_t
                                   !data  TYPE STANDARD TABLE
                         RAISING   zcx_adv_exception.

    METHODS: extend_check IMPORTING !rules TYPE ty_rules_t
                                    !data  TYPE STANDARD TABLE
                          RAISING   zcx_adv_exception.

    METHODS: is_flat_table IMPORTING !data       TYPE ANY TABLE
                           RETURNING VALUE(flat) TYPE abap_bool
                           RAISING   zcx_adv_exception.

    METHODS: set_result IMPORTING !row       TYPE int4
                                  !fname     TYPE name_komp
                                  !type_name TYPE ty_spec_type OPTIONAL
                                  !msg_text  TYPE string.
ENDCLASS.



CLASS zcl_adata_validator IMPLEMENTATION.


  METHOD basic_check.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<data>).

      DATA(data_row) = sy-tabix.

      LOOP AT rules ASSIGNING FIELD-SYMBOL(<rule>).

        ASSIGN COMPONENT <rule>-fname OF STRUCTURE <data> TO FIELD-SYMBOL(<field>).
        IF sy-subrc = 0.

          IF <rule>-required = abap_true.
            IF <field> IS INITIAL OR ( CONV string( <field> ) = '' ).
              set_result(
                row      = data_row
                fname    = <rule>-fname
                msg_text = default_msg-required
              ).
            ENDIF.
          ENDIF.

          IF <rule>-initial_or_empty = abap_true.
            IF <field> IS NOT INITIAL AND ( CONV string( <field> ) <> '' ).
              set_result(
                row      = data_row
                fname    = <rule>-fname
                msg_text = default_msg-initial_or_empty
              ).
            ENDIF.
          ELSEIF <rule>-regex IS NOT INITIAL AND ( <field> IS NOT INITIAL AND ( CONV string( <field> ) <> '' ) ).
            IF NOT contains( val = <field> regex = <rule>-regex ).
              set_result(
                row      = data_row
                fname    = <rule>-fname
                msg_text = <rule>-regex_msg
              ).
            ENDIF.
          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    IF check_class_conifg IS NOT INITIAL.
      check_config = check_class_conifg.
    ELSE.
      check_config = VALUE #(
        ( type = c_type_date      class = 'ZCL_ADV_DATE_CHECK'
          message = 'Invalid value for field "&1". Date format should be YYYYMMDD.' )
        ( type = c_type_email     class = 'ZCL_ADV_EMAIL_CHECK' )
        ( type = c_type_time      class = 'ZCL_ADV_TIME_CHECK' )
        ( type = c_type_int4      class = 'ZCL_ADV_INT4_CHECK' )
        ( type = c_type_regex     class = 'ZCL_ADV_REGEX_CHECK' )
        ( type = c_type_timestamp class = 'ZCL_ADV_TIMESTAMP_CHECK' )
        ( type = c_type_url       class = 'ZCL_ADV_URL_CHECK' )
        ( type = c_type_hex       class = 'ZCL_ADV_HEX_CHECK' )
        ( type = c_type_json      class = 'ZCL_ADV_JSON_CHECK' )
        ( type = c_type_imei      class = 'ZCL_ADV_IMEI_CHECK' )
        ( type = c_type_guid      class = 'ZCL_ADV_GUID_CHECK' )
        ( type = c_type_base64    class = 'ZCL_ADV_BASE64_CHECK' )
        ( type = c_type_html      class = 'ZCL_ADV_HTML_CHECK' )
      ).
    ENDIF.

    IF default_message IS NOT INITIAL.
      default_msg = default_message.
    ELSE.
      default_msg-required         = |&1 is required. |.
      default_msg-initial_or_empty = |&1 should be empty. |.
      default_msg-default          = |Invalid value for field "&1", type "&2" |.
      default_msg-class_error      = |Class &1 is invalid, check your configuration and code. |.
    ENDIF.
  ENDMETHOD.


  METHOD extend_check.

    DATA: adv_check TYPE REF TO zif_adv_check.

    DATA: ptab TYPE abap_parmbind_tab,
          etab TYPE abap_excpbind_tab.

    DATA: valid TYPE abap_bool.

    TRY.
        DATA(classes_list) = cl_sic_configuration=>get_classes_for_interface( zif_adv_check=>c_interface_name ).
      CATCH cx_class_not_existent.
    ENDTRY.

    DATA(method_name)  = |{ zif_adv_check=>c_interface_name }~{ zif_adv_check=>c_method_name }|.


    LOOP AT data ASSIGNING FIELD-SYMBOL(<data>).

      DATA(data_row) = sy-tabix.

      LOOP AT rules ASSIGNING FIELD-SYMBOL(<rule>) WHERE initial_or_empty = abap_false.

        ASSIGN COMPONENT <rule>-fname OF STRUCTURE <data> TO FIELD-SYMBOL(<field>).
        IF sy-subrc = 0.
          IF <field> IS NOT INITIAL AND ( CONV string( <field> ) <> '' ).

            READ TABLE check_config WITH KEY type = <rule>-user_type ASSIGNING FIELD-SYMBOL(<config>).
            IF sy-subrc = 0.
              IF <config>-class IS NOT INITIAL AND line_exists( classes_list[ clsname = <config>-class ] ).

                ptab = VALUE #( (
                   name  = 'DATA'
                   kind  = cl_abap_objectdescr=>exporting
                   value = REF #( <field> ) )
                 ( name  = 'VALID'
                   kind  = cl_abap_objectdescr=>returning
                   value = REF #( valid ) )
               ).

                TRY.
                    CALL METHOD (<config>-class)=>(method_name) PARAMETER-TABLE ptab.
                    IF valid = abap_false.
                      set_result(
                          row       = data_row
                          fname     = <rule>-fname
                          msg_text  = <config>-message
                          type_name = <rule>-user_type ).
                    ENDIF.
                  CATCH: cx_sy_dyn_call_excp_not_found,
                         cx_sy_dyn_call_illegal_class,
                         cx_sy_dyn_call_illegal_method,
                         cx_sy_dyn_call_illegal_type,
                         cx_sy_dyn_call_param_missing,
                         cx_sy_dyn_call_param_not_found,
                         cx_sy_dyn_call_parameter_error,
                         cx_sy_dyn_call_error.
                    zcx_adv_exception=>raise( |Error when call { <config>-class }=>{ method_name }, check your config and code. | ).
                ENDTRY.
              ELSE.
                zcx_adv_exception=>raise( |Class { <config>-class }not exists. | ).
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.


  METHOD is_flat_table.

    flat = abap_false.

    DATA(table_descr) = CAST cl_abap_tabledescr( cl_abap_datadescr=>describe_by_data( data ) ).

    DATA(line_descr) = CAST cl_abap_structdescr( table_descr->get_table_line_type( ) ).

    IF line_descr->type_kind = cl_abap_datadescr=>typekind_struct1.
      flat = abap_true.
      RETURN.
    ENDIF.

    TYPES: BEGIN OF ty_black_list,
             kind TYPE abap_typekind,
           END OF ty_black_list.
    DATA: black_list TYPE HASHED TABLE OF ty_black_list WITH UNIQUE KEY kind.

    black_list = VALUE #(
        ( kind = cl_abap_datadescr=>typekind_any     )
        ( kind = cl_abap_datadescr=>typekind_class   )
        ( kind = cl_abap_datadescr=>typekind_data    )
        ( kind = cl_abap_datadescr=>typekind_dref    )
        ( kind = cl_abap_datadescr=>typekind_intf    )
        ( kind = cl_abap_datadescr=>typekind_iref    )
        ( kind = cl_abap_datadescr=>typekind_oref    )
        ( kind = cl_abap_datadescr=>typekind_struct2 )
        ( kind = cl_abap_datadescr=>typekind_table   )
        ( kind = cl_abap_datadescr=>typekind_bref    )
    ).

    LOOP AT line_descr->get_components( ) ASSIGNING FIELD-SYMBOL(<component>).

      READ TABLE black_list WITH KEY kind = <component>-type->type_kind TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        flat = abap_false.
        RETURN.
      ENDIF.

    ENDLOOP.

    flat = abap_true.

  ENDMETHOD.


  METHOD set_result.

    DATA(sub_msg_text) = COND #( WHEN msg_text IS NOT INITIAL THEN msg_text
                                 ELSE                              default_msg-default ).

    REPLACE ALL OCCURRENCES OF '&1' IN sub_msg_text WITH fname.
    IF type_name IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF '&2' IN sub_msg_text WITH type_name.
    ENDIF.

    READ TABLE results_temp WITH KEY row = row fname = fname ASSIGNING FIELD-SYMBOL(<result>).
    IF sy-subrc = 0.
      <result>-message = VALUE #( BASE <result>-message
          ( text = sub_msg_text )
      ).
    ELSE.
      DATA: result_temp LIKE LINE OF results_temp.
      result_temp = VALUE #(
         row     = row
         fname   = fname
         error   = abap_true
         message = VALUE #( ( text = sub_msg_text ) )
      ).
      INSERT result_temp INTO TABLE results_temp.
    ENDIF.

  ENDMETHOD.


  METHOD validate.

    CLEAR: results_temp.

    IF is_flat_table( data ) = abap_false.
      zcx_adv_exception=>raise( |Only support table with flat structure (or structure with string type).| ).
    ENDIF.

    IF data IS INITIAL.
      RETURN.
    ENDIF.

    basic_check( rules = rules data = data ).

    extend_check( rules = rules data = data ).

    results = results_temp.

  ENDMETHOD.
ENDCLASS.
