CLASS zcl_adv_time_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_time_check IMPLEMENTATION.
  METHOD zif_adv_check~check.

    valid = abap_false.

    DATA(string_time) = CONV string( data ).

    IF NOT contains( val = string_time regex = '^\d{6}$').
      RETURN.
    ENDIF.

    DATA(time) = CONV uzeit( string_time ).

    CALL FUNCTION 'TIME_CHECK_PLAUSIBILITY'
      EXPORTING
        time                      = time
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
