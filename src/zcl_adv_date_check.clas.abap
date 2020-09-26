CLASS zcl_adv_date_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_DATE_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA(string_date) = CONV string( data ).

    IF NOT contains( val = string_date regex = '^\d{8}$' ).
      RETURN.
    ENDIF.

    DATA(date) = CONV datum( string_date ).

    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = date
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
