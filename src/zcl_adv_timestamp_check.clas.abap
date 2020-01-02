CLASS zcl_adv_timestamp_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_TIMESTAMP_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    valid = abap_false.

    DATA(string_ts) = CONV string( data ).

    IF not contains( val = string_ts regex = '\d{14} ?$').
      RETURN.
    ENDIF.

    DATA(date) = CONV datum( string_ts(8) ).
    DATA(time) = CONV uzeit( string_ts+8(6) ).

    IF zcl_adv_date_check=>zif_adv_check~is_valid( date ) AND zcl_adv_time_check=>zif_adv_check~is_valid( time ).
      valid = abap_true.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
