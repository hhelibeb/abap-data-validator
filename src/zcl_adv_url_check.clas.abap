CLASS zcl_adv_url_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_URL_CHECK IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

*regex source: https://gist.github.com/dperini/729294
    DATA(url_regex) =
      '^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9][1-9]?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5]))' &&
      '{2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9[:unicode:]][a-z0-9[:unicode:]_-]{0,62})?[a-z0-9[:unicode:]]\.)+(?:[a-z[:unicode:]]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$'.

    DATA(string_url) = CONV string( data ).

    IF NOT contains( val = string_url regex = url_regex ).
      RETURN.
    ENDIF.

    valid = abap_true.

  ENDMETHOD.
ENDCLASS.
