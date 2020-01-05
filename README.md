# abap-data-validator
A data validation tool.

ABAP Data Validator is a tool to simplify data validation process for SAP ABAP development.

Features and Goals:
* General input/output.
* Customizable validation rules.
* Extendable validation program.
* Centralize some validation logic.

## Type list
ABAP Data Validator supports validations for types below (updating),
- [x] Date.
- [x] Time.
- [x] Timestamp.
- [x] Email.
- [x] INT4.
- [x] REGEX string.
- [x] URL.
- [x] JSON.
- [x] HEX.
- [x] IMEI.

## Usage

### Single field validation 
Every check class implements the interface `zif_adv_check`. You can use static method `zif_adv_check~is_valid` to validate data just like a built-in function. Example:
```abap
IF zcl_adv_email_check=>zif_adv_check~is_valid( 'example@github.com' ).
 "do something
ENDIF.
```
Or with aliases:
```abap
IF zcl_adv_email_check=>is_valid( 'example@github.com' ).
 "do something
ENDIF.
```
All classes have unit tests.

### Internal table validation
Class `zcl_adata_validator` provides a general validation method `validate`. 
```abap
TRY.
    DATA(result) = NEW zcl_adata_validator( )->validate(
         rules   = my_rules
         data    = uploaded_data
     ).
  CATCH zcx_adv_exception INTO DATA(ex).
    DATA(msg) = ex->get_text( ).
ENDTRY.    
```
`zcl_adata_validator` calls check methods internally according to the exporting rules and returns the result.

### Rules customization
By the parameter RULES, you can customize the validation.
```abap
DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

rules = VALUE #(
  ( fname = 'FIELD1' required = abap_true  initial_or_empty = abap_false  user_type = zcl_adata_validator=>c_type_date )
  ( fname = 'FIELD2' required = abap_false initial_or_empty = abap_true   user_type = zcl_adata_validator=>c_type_date )
  ( fname = 'FIELD3' required = abap_true  initial_or_empty = abap_false  user_type = zcl_adata_validator=>c_type_email )
).
```
### Extend validation for special type
There are two ways to extend the validation:
* Pass regular expression by RULES-REGEX.
* Create a new class which implements `zif_adv_check`, and add the type name & class name in `zcl_adata_validator->constructor`.

Regex example. If you want to check whether the input email is a gmail address, you can assign `gmail\.com$` to `rule-regex`:

```abap
DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

DATA: cases TYPE ty_case_t.

cases = VALUE #(
    ( field3 = 'ZZZ2@gmail.com') "correct
    ( field3 = 'ZZZ2@gmail.com.cn') "incorrect
).

rules = VALUE #(
  ( fname = 'FIELD3' user_type = zcl_adata_validator=>c_type_email regex = 'gmail\.com$' regex_msg = 'Only gmail supported')
).
```
Or add a new class, and add it to check config on demand: 
```abap
METHOD constructor.

  check_config = VALUE #(
    ( type = zcl_adata_validatorn=>c_type_new  class = 'ZCL_ADV_NEWTYPE_CHECK'  message = 'Invalid value for field &.  ')
  ).

ENDMETHOD.
 ```
### Configuration 
The configuration is hard coded in `zcl_adata_validator`'s constructor, but you can redefine the constructor to retrieve configuration from database tables or other source. It allows you to change the function without modifying the existed program.

### Requirment
ABAP Version: 740 sp08 or higher

## Exception
The exception class `zcx_adv_exception` is copied from `zcx_abapgit_exception` for it is easy to use:)

## TODO
Now only date, time and email type are supported. Need to add more check classes.
- [ ] More types.
- [ ] Auto Type detecting.
