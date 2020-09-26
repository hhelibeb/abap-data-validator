CLASS zcl_adv_hex_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_HEX_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA: xstring_hex TYPE xstring.

    DATA(string_hex) = CONV string( data ).

    IF string_hex IS INITIAL.
      RETURN.
    ENDIF.

    xstring_hex = string_hex.

    IF CONV string( xstring_hex ) <> string_hex.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
