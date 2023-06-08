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
    DATA: string_date TYPE c LENGTH 8.

    string_date = CONV #( data ).

    IF NOT contains( val   = string_date
                     regex = '^\d{8}$' ).
      RETURN.
    ENDIF.

    TRY.
        DATA(xco_date) = xco_cp_time=>date( iv_year  = CONV #( string_date(4) )
                                            iv_month = CONV #( string_date+2(2) )
                                            iv_day   = CONV #( string_date+4(2) ) ).
      CATCH cx_no_check INTO DATA(exception).
        RETURN.
    ENDTRY.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
