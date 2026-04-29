{%- set source_model = 'v_stg_transactions' -%}
{%- set src_pk = 'TRANSACTION_PK' -%}
{%- set src_hashdiff = 'TRANSACTION_HASHDIFF' -%}
{%- set src_payload = ['ORDER_DATE', 'TRANSACTION_DATE', 'AMOUNT', 'TYPE'] -%}
{%- set src_ldts = 'LOAD_DATE' -%}
{%- set src_source = 'RECORD_SOURCE' -%}

{{ automate_dv.sat(src_pk=src_pk,
                   src_hashdiff=src_hashdiff,
                   src_payload=src_payload,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model=source_model) }}
