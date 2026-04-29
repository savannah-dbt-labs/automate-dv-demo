{%- set source_model = 'v_stg_orders' -%}
{%- set src_pk = 'LINK_ORDER_LINEITEM_PK' -%}
{%- set src_hashdiff = 'LINEITEM_HASHDIFF' -%}
{%- set src_payload = ['LINENUMBER', 'QUANTITY', 'EXTENDEDPRICE', 'DISCOUNT', 'TAX', 'RETURNFLAG', 'LINESTATUS', 'SHIPDATE', 'COMMITDATE', 'RECEIPTDATE', 'SHIPINSTRUCT', 'SHIPMODE', 'LINE_COMMENT'] -%}
{%- set src_ldts = 'LOAD_DATE' -%}
{%- set src_source = 'RECORD_SOURCE' -%}

{{ automate_dv.sat(src_pk=src_pk,
                   src_hashdiff=src_hashdiff,
                   src_payload=src_payload,
                   src_ldts=src_ldts,
                   src_source=src_source,
                   source_model=source_model) }}
