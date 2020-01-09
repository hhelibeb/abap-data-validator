CLASS zcl_adv_html_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
    ALIASES: is_valid FOR zif_adv_check~is_valid.
    TYPES: BEGIN OF ty_messages,
             type          TYPE string,
             last_line     TYPE i,
             last_column   TYPE i,
             first_column  TYPE i,
             message       TYPE string,
             extract       TYPE string,
             hilite_start  TYPE i,
             hilite_length TYPE i,
           END OF ty_messages.
    TYPES: ty_messages_t TYPE STANDARD TABLE OF ty_messages WITH EMPTY KEY.
    CLASS-DATA: messages TYPE ty_messages_t.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_html_check IMPLEMENTATION.


  METHOD zif_adv_check~is_valid.

*source: https://validator.w3.org/
*make sure that SSL configured and the ABAP server can access w3.org
    TYPES: BEGIN OF t_json1,
             messages TYPE ty_messages_t,
           END OF t_json1.

    DATA: code          TYPE i,
          url           TYPE string VALUE 'https://validator.w3.org/nu/?out=json',
          client        TYPE REF TO if_http_client,
          ssl_id        TYPE ssfapplssl VALUE 'ANONYM',
          error_message TYPE string,
          subrc         TYPE i.

    DATA: original_messages TYPE t_json1.

    valid = abap_false.

    DATA(string_html) = CONV string( data ).
    IF string_html IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR string_html.

    cl_http_client=>create_by_url(
      EXPORTING
        url           = url
        ssl_id        = ssl_id
        proxy_host    = ''
        proxy_service = ''
      IMPORTING
        client        = client ).

    client->request->set_header_field(
       name  = '~server_protocol'
       value = 'POST'
    ).

    client->request->set_header_field(
       name  = '~server_protocol'
       value = 'HTTP/1.1'
    ).

    client->request->set_header_field(
       name  = 'Content-Type'
       value = 'text/html; charset=UTF-8'
    ).

    client->request->set_header_field(
       name  = 'accept-encoding'
       value = 'gzip-8'
    ).
    client->request->set_cdata( CONV string( data ) ).

    client->send( ).

    client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4
    ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(msg).
      client->get_last_error( IMPORTING message = error_message ).
      client->close(
        EXCEPTIONS
          http_invalid_state = 1
          OTHERS             = 2
      ).
      subrc = 4.
      RETURN.
    ENDIF.

    client->response->get_status( IMPORTING code = code ).

    subrc = COND #( WHEN code <> '200' THEN 4 ).  "success

    /ui2/cl_json=>deserialize(
      EXPORTING
        json = client->response->get_cdata( )
      CHANGING
        data = original_messages
    ).

    messages = original_messages-messages.

    subrc = COND #( WHEN line_exists( messages[ type = 'error' ] ) THEN 4 ).

    IF subrc = 0.
      valid = abap_true.
    ENDIF.

    client->close(
      EXCEPTIONS
        http_invalid_state = 1
        OTHERS             = 2
    ).

  ENDMETHOD.
ENDCLASS.
