CLASS zcl_adv_json_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_json_check IMPLEMENTATION.

  METHOD zif_adv_check~is_valid.

    valid = abap_false.

    DATA(string_json) = CONV string( data ).
    IF  string_json IS INITIAL.
      RETURN.
    ENDIF.
    DATA(json_data) = /ui2/cl_json=>generate(
        json  = string_json
    ).

    IF json_data IS INITIAL.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
