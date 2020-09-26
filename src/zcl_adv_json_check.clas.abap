CLASS zcl_adv_json_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_JSON_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    DATA(string_json) = CONV string( data ).
    IF string_json IS INITIAL.
      RETURN.
    ENDIF.
    DATA(json_data) = /ui2/cl_json=>generate( json = string_json ).

    IF json_data IS INITIAL.
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
