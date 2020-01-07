CLASS zcl_adv_guid_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_guid_check IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

    valid = abap_false.

    DATA(string_email) = CONV string( data ).

*https://stackoverflow.com/questions/7905929/how-to-test-valid-uuid-guid
    IF NOT contains( val = string_email regex = '^[0-9A-F]{12}[0-5][0-9A-F]{3}[089AB][0-9A-F]{15}$' ).
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
