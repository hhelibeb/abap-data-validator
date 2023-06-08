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

     TRY.
        DATA(bindata) = xco_cp=>string( string_base64 )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.
     CATCH cx_no_check.
        return.
     ENDTRY.

    IF bindata IS INITIAL.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
