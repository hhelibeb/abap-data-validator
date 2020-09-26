CLASS zcl_adv_imei_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_IMEI_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA: imei_index TYPE i,
          sum        TYPE i.

    DATA(imei_string) = CONV string( data ).

    IF NOT contains( val = imei_string regex = '^\d{15}$' ).
      RETURN.
    ENDIF.

*https://en.wikipedia.org/wiki/Luhn_algorithm
    DO strlen( imei_string ) TIMES.
      DATA(digit)  = CONV int4( imei_string+imei_index(1) ).
      IF imei_index MOD 2 = 1.
        digit = digit * 2.
      ENDIF.
      IF digit > 9.
        digit = digit - 9.
      ENDIF.
      sum = sum + digit.
      imei_index = imei_index + 1.
    ENDDO.

    IF sum MOD 10 = 0.
      valid = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
