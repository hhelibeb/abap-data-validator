CLASS zcl_adv_email_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_email_check IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    valid = abap_false.

    DATA(string_email) = CONV string( data ).

*regex source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/email
    IF NOT contains( val = string_email regex = '^[a-zA-Z0-9.!#$%&''*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' ).
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
