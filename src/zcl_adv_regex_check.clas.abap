CLASS zcl_adv_regex_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_regex_check IMPLEMENTATION.

  METHOD zif_adv_check~is_valid.

    DATA: regex TYPE REF TO cl_abap_regex.

    valid = abap_false.

    DATA(string_regex) = CONV string( data ).

    TRY.
        regex = NEW #( pattern  = string_regex ).
      CATCH cx_sy_invalid_regex INTO DATA(ex).
        RETURN.
    ENDTRY.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
