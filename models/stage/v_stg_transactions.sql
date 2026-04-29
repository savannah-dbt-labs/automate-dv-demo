{%- set yaml_metadata -%}
source_model: 'raw_transactions'
derived_columns:
  TRANSACTION_NK: 'TRANSACTION_NUMBER'
  ORDER_NK: 'ORDER_ID'
  CUSTOMER_NK: 'CUSTOMER_ID'
  LOAD_DATE: "TO_DATE('{{ var('load_date') }}')"
  RECORD_SOURCE: '!RAW_TRANSACTIONS'
hashed_columns:
  TRANSACTION_PK: 'TRANSACTION_NUMBER'
  ORDER_PK: 'ORDER_ID'
  CUSTOMER_PK: 'CUSTOMER_ID'
  T_LINK_TRANSACTIONS_PK:
    - 'TRANSACTION_NUMBER'
    - 'ORDER_ID'
    - 'CUSTOMER_ID'
  TRANSACTION_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'ORDER_DATE'
      - 'TRANSACTION_DATE'
      - 'AMOUNT'
      - 'TYPE'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns']) }}
