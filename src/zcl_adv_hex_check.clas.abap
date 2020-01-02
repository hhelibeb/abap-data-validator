CLASS zcl_adv_hex_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_hex_check IMPLEMENTATION.

  METHOD zif_adv_check~check.

    DATA: xstring_hex TYPE xstring.

    valid = abap_false.

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
