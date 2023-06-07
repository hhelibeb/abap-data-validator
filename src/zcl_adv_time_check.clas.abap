CLASS zcl_adv_time_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_TIME_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA: string_time TYPE c LENGTH 6.
    string_time = CONV #( data ).

    IF NOT contains( val   = string_time
                     regex = '^\d{6}$' ).
      RETURN.
    ENDIF.

    TRY.
        DATA(time) = xco_cp_time=>time( iv_hour   = CONV #( string_time(2) )
                                        iv_minute = CONV #( string_time+2(2) )
                                        iv_second = CONV #( string_time+4(2) ) ).

      CATCH cx_no_check INTO DATA(exception).
        RETURN.
    ENDTRY.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
