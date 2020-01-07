CLASS zcl_adv_int4_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS: "! <p class="shorttext synchronized" lang="en"></p>
      "! remove potential leading zero
      "! @parameter number | <p class="shorttext synchronized" lang="en"></p>
      remove_mess_char CHANGING number TYPE string.
ENDCLASS.



CLASS zcl_adv_int4_check IMPLEMENTATION.

  METHOD zif_adv_check~is_valid.

    DATA(regex_string) = '^[-+]?(\d{1,9}|1\d{9}|2(0\d{8}|1([0-3]\d{7}|4([0-6]\d{6}|7([0-3]\d{5}|4([0-7]\d{4}|8([0-2]\d{3}|3([0-5]\d{2}|6([0-3]\d|4[0-7])))))))))$|^-2147483648$'.

    valid = abap_false.

    DATA(string_number) = CONV string( data ).

    remove_mess_char( CHANGING number = string_number ).

    IF NOT contains( val = string_number regex = regex_string ).
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.

  METHOD remove_mess_char.

    DATA: sign TYPE string.

    SHIFT number RIGHT DELETING TRAILING space.
    SHIFT number LEFT DELETING LEADING space.

    DATA(len) = strlen( number ) - 1.

    IF contains( val = number(1) regex = '[+-]' ).
      sign = number(1).
      number = number+1(len).
    ELSEIF contains( val = number+len(1) regex = '[+-]' ).
      sign = number+len(1).
      number = number(len).
    ENDIF.

    IF contains( val = number regex = '[^0]' ). " always valid when a string only has zero
      SHIFT number LEFT DELETING LEADING '0'.
    ENDIF.

    SHIFT number RIGHT DELETING TRAILING space.
    SHIFT number LEFT DELETING LEADING space.

    IF sign IS NOT INITIAL.
      number = sign && number.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
