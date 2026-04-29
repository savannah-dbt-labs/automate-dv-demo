{%- set yaml_metadata -%}
source_model: 'raw_orders'
derived_columns:
  ORDER_NK: 'ORDERKEY'
  CUSTOMER_NK: 'CUSTOMERKEY'
  PART_NK: 'PARTKEY'
  SUPPLIER_NK: 'SUPPLIERKEY'
  ORDER_LINE_NK: "ORDERKEY || '|' || LINENUMBER || '|' || PARTKEY || '|' || SUPPLIERKEY"
  LOAD_DATE: "TO_DATE('{{ var('load_date') }}')"
  RECORD_SOURCE: '!RAW_ORDERS'
hashed_columns:
  ORDER_PK: 'ORDERKEY'
  CUSTOMER_PK: 'CUSTOMERKEY'
  PART_PK: 'PARTKEY'
  SUPPLIER_PK: 'SUPPLIERKEY'
  LINK_CUSTOMER_ORDER_PK:
    - 'CUSTOMERKEY'
    - 'ORDERKEY'
  LINK_ORDER_LINEITEM_PK:
    - 'ORDERKEY'
    - 'LINENUMBER'
    - 'PARTKEY'
    - 'SUPPLIERKEY'
  ORDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'ORDERSTATUS'
      - 'TOTALPRICE'
      - 'ORDERDATE'
      - 'ORDERPRIORITY'
      - 'CLERK'
      - 'SHIPPRIORITY'
      - 'ORDER_COMMENT'
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'CUSTOMER_NAME'
      - 'CUSTOMER_ADDRESS'
      - 'CUSTOMER_NATION_KEY'
      - 'CUSTOMER_PHONE'
      - 'CUSTOMER_ACCBAL'
      - 'CUSTOMER_MKTSEGMENT'
      - 'CUSTOMER_COMMENT'
      - 'CUSTOMER_NATION_NAME'
      - 'CUSTOMER_REGION_KEY'
      - 'CUSTOMER_NATION_COMMENT'
      - 'CUSTOMER_REGION_NAME'
      - 'CUSTOMER_REGION_COMMENT'
  LINEITEM_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'LINENUMBER'
      - 'QUANTITY'
      - 'EXTENDEDPRICE'
      - 'DISCOUNT'
      - 'TAX'
      - 'RETURNFLAG'
      - 'LINESTATUS'
      - 'SHIPDATE'
      - 'COMMITDATE'
      - 'RECEIPTDATE'
      - 'SHIPINSTRUCT'
      - 'SHIPMODE'
      - 'LINE_COMMENT'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns']) }}
