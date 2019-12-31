INTERFACE zif_adv_check
  PUBLIC .

  CONSTANTS: c_interface_name TYPE seoclsname VALUE 'ZIF_ADV_CHECK'.
  CONSTANTS: c_method_name TYPE seocpdname VALUE 'CHECK'.

  CLASS-METHODS: check IMPORTING data         TYPE any
                       RETURNING VALUE(valid) TYPE abap_bool.

ENDINTERFACE.
