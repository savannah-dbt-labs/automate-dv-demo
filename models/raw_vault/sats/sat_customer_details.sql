{%- set source_model = 'v_stg_orders' -%}
{%- set src_pk = 'CUSTOMER_PK' -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF' -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_ADDRESS', 'CUSTOMER_NATION_KEY', 'CUSTOMER_PHONE', 'CUSTOMER_ACCBAL', 'CUSTOMER_MKTSEGMENT', 'CUSTOMER_COMMENT', 'CUSTOMER_NATION_NAME', 'CUSTOMER_REGION_KEY', 'CUSTOMER_NATION_COMMENT', 'CUSTOMER_REGION_NAME', 'CUSTOMER_REGION_COMMENT'] -%}
{%- set src_ldts = 'LOAD_DATE' -%}
{%- set src_source = 'RECORD_SOURCE' -%}

{{ automate_dv.sat(src_pk=src_pk,
                   src_hashdiff=src_hashdiff,
                   src_payload=src_payload,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model=source_model) }}
