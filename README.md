# abap-data-validator
A data validation tool.

ABAP Data Validator is a tool to simplify data validation process for SAP ABAP development.

Goals:
* General validation interface, which allows complete validation work by one method call.
* Centralize some validation logic, avoid duplicate & inconsistent, decrease maintenance cost.
* Avoid potential dump.

To achieve the goal, ABAP Data Validator has some features
* Built-in validation logic.
* Customizable validation rules.
* Extendable validation program.
* Internal exception handling.

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
- [x] GUID.
- [x] BASE64.
- [x] HTML (experimental).
And validation of mandatory, validate by reference data elements are also supported.

## Usage

### Single field validation 
For every type, ABAP Data Validator has a special check class. You can use static method `is_valid` of check class to validate data just like a built-in function. Example:
```abap
IF zcl_adv_email_check=>is_valid( 'example@github.com' ).
 "do something
ENDIF.
```
Every check class implements the interface `zif_adv_check`, which contains method`is_valid`.
![check classere](https://raw.githubusercontent.com/hhelibeb/abap-data-validator/master/doc/img/uml1.png)

The naming convention of check classes is ZCL_ADV_typename_CHECK.

All classes have unit tests.

### Validation with reference data element
For easy to use, `is_valid` is a quite simple method, that means it can't provide function on validation of quantity and amount type. In order to solve this issue, ABAP Data Validator provide another way to validate data.
```abap
DATA(result) = NEW zcl_adata_validator( )->->validate_by_element(
   data    = '11.0'
   element = 'MENGE_D' "quantity data element name
).
```
Now data elements with below type are supported,
- [x] Date.
- [x] Time.
- [x] Timestamp.
- [x] INT4.
- [x] GUID.
- [x] HEX.
- [x] Packed(including most of the quantity type and amount type).

To keep the check method simple, there is also no exception definition of the method `validate_by_element`. The method handles exceptions internally, and return a result with the result-valid = abap_false, result-type = 'Invalid Type' (fixed value).

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
* Create a new class which implements `zif_adv_check`, and pass the type name & class name to `zcl_adata_validator->constructor`.

Regex example. If you want to check whether the input email is a gmail address, you can assign `gmail\.com$` to `rule-regex`:

```abap
DATA: rules TYPE zcl_adata_validator=>ty_rules_t.

DATA: cases TYPE ty_case_t.

cases = VALUE #(
    ( field3 = 'ZZZ2@gmail.com') "correct, it is a gmail address
    ( field3 = 'ZZZ2@outlook.com') "incorrect, it is not a gmail address
).

rules = VALUE #(
  ( fname = 'FIELD3' user_type = zcl_adata_validator=>c_type_email regex = 'gmail\.com$' regex_msg = 'Only gmail supported')
).
```
Or add a new class, and add it to check config on demand: 
```abap
DATA: check_class_config TYPE zcl_adata_validator=>ty_check_config_t.

check_class_config = VALUE #( ( type = zcl_adata_validator=>c_type_new  class = 'ZCL_NEW_VALIDATOR' ) ).

TRY.
     DATA(result) = NEW zcl_adata_validator( check_class_conifg = check_class_config )->validate(
         rules   = rules
         data    = cases
     ).
CATCH zcx_adv_exception INTO DATA(ex).
    DATA(msg) = ex->get_text( ).
ENDTRY.
 ```
### Configuration 
The configuration is hard coded in `zcl_adata_validator`'s constructor. You can also pass you own configuration into the constructor. It allows you to change the function without modifying the existed program.

```abap
DATA: check_class_config TYPE zcl_adata_validator=>ty_check_config_t.

SELECT * FROM my_config_table INTO TABLE @check_class_config.

TRY.
    DATA(result) = NEW zcl_adata_validator( check_class_conifg = check_class_config )->validate(
        rules   = rules
        data    = cases
    ).
CATCH zcx_adv_exception INTO DATA(ex).
    DATA(msg) = ex->get_text( ).
ENDTRY.

```
Note: Custom config will cover default config.

## Requirment
ABAP Version: 740 SP08 or higher

For ABAP Cloud, there is another release which was contributed by ArneVanH. Please find it on the [Releases page](https://github.com/hhelibeb/abap-data-validator/releases). Refer to issue https://github.com/hhelibeb/abap-data-validator/issues/21 for more details

## Exception
The exception class `zcx_adv_exception` is copied from `zcx_abapgit_exception` for it is easy to use:)

## TODO
Now only date, time and email type are supported. Need to add more check classes.
- [ ] More types.
- [ ] Auto Type detecting.
