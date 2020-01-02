CLASS zcl_adv_url_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_url_check IMPLEMENTATION.

  METHOD zif_adv_check~check.

    valid = abap_false.

    DATA(string_url) = CONV string( data ).
*regex source: https://www.regextester.com/94502
    IF not contains( val = string_url regex = `^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#\[\]@!\$&'\(\)\*\+,;=.]+$` ).
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
