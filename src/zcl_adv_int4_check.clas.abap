CLASS zcl_adv_int4_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_int4_check IMPLEMENTATION.

  METHOD zif_adv_check~check.

    valid = abap_false.

    DATA(string_number) = CONV string( data ).

    IF not contains( val = string_number regex = '^-?(\d{1,9}|1\d{9}|2(0\d{8}|1([0-3]\d{7}|4([0-6]\d{6}|7([0-3]\d{5}|4([0-7]\d{4}|8([0-2]\d{3}|3([0-5]\d{2}|6([0-3]\d|4[0-7])))))))))$|^-2147483648$').
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
