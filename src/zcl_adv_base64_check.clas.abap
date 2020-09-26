CLASS zcl_adv_base64_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_BASE64_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA(string_base64) = CONV string( data ).
    IF string_base64 IS INITIAL.
      valid = abap_true.
      RETURN.
    ENDIF.

    DATA: bindata TYPE xstring.

    CALL FUNCTION 'SSFC_BASE64_DECODE'
      EXPORTING
        b64data                  = string_base64
        b_check                  = 'X'
      IMPORTING
        bindata                  = bindata
      EXCEPTIONS
        ssf_krn_error            = 1
        ssf_krn_noop             = 2
        ssf_krn_nomemory         = 3
        ssf_krn_opinv            = 4
        ssf_krn_input_data_error = 5
        ssf_krn_invalid_par      = 6
        ssf_krn_invalid_parlen   = 7
        OTHERS                   = 8.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF bindata IS INITIAL.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
