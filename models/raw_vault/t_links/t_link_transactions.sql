{%- set source_model = 'v_stg_transactions' -%}
{%- set src_pk = 'T_LINK_TRANSACTIONS_PK' -%}
{%- set src_fk = ['TRANSACTION_PK', 'ORDER_PK', 'CUSTOMER_PK'] -%}
{%- set src_payload = ['AMOUNT', 'TYPE'] -%}
{%- set src_eff = 'TRANSACTION_DATE' -%}
{%- set src_ldts = 'LOAD_DATE' -%}
{%- set src_source = 'RECORD_SOURCE' -%}

{{ automate_dv.t_link(src_pk=src_pk,
                      src_fk=src_fk,
                      src_payload=src_payload,
                      src_eff=src_eff,
                      src_ldts=src_ldts,
                      src_source=src_source,
                      source_model=source_model) }}
