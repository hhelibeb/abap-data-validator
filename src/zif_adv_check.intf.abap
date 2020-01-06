INTERFACE zif_adv_check
  PUBLIC .

  CONSTANTS: c_interface_name TYPE seoclsname VALUE 'ZIF_ADV_CHECK'.
  CONSTANTS: c_method_name TYPE seocpdname VALUE 'IS_VALID'.

  CLASS-METHODS: "! <p class="shorttext synchronized" lang="en"></p>
                 "!
                 "! @parameter data data to be validated| <p class="shorttext synchronized" lang="en"></p>
                 "! @parameter valid if 'X', valid| <p class="shorttext synchronized" lang="en"></p>
                 is_valid IMPORTING data         TYPE simple
                          RETURNING VALUE(valid) TYPE abap_bool.

ENDINTERFACE.
