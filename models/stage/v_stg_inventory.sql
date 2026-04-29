{%- set yaml_metadata -%}
source_model: 'raw_inventory'
derived_columns:
  PART_NK: 'PARTKEY'
  SUPPLIER_NK: 'SUPPLIERKEY'
  LOAD_DATE: "TO_DATE('{{ var('load_date') }}')"
  RECORD_SOURCE: '!RAW_INVENTORY'
hashed_columns:
  PART_PK: 'PARTKEY'
  SUPPLIER_PK: 'SUPPLIERKEY'
  LINK_PART_SUPPLIER_PK:
    - 'PARTKEY'
    - 'SUPPLIERKEY'
  PART_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'PART_NAME'
      - 'PART_MFGR'
      - 'PART_BRAND'
      - 'PART_TYPE'
      - 'PART_SIZE'
      - 'PART_CONTAINER'
      - 'PART_RETAILPRICE'
      - 'PART_COMMENT'
  SUPPLIER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'SUPPLIER_NAME'
      - 'SUPPLIER_ADDRESS'
      - 'SUPPLIER_NATION_KEY'
      - 'SUPPLIER_PHONE'
      - 'SUPPLIER_ACCTBAL'
      - 'SUPPLIER_COMMENT'
      - 'SUPPLIER_NATION_NAME'
      - 'SUPPLIER_NATION_COMMENT'
      - 'SUPPLIER_REGION_KEY'
      - 'SUPPLIER_REGION_NAME'
      - 'SUPPLIER_REGION_COMMENT'
  INVENTORY_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'AVAILQTY'
      - 'SUPPLYCOST'
      - 'PART_SUPPLY_COMMENT'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata_dict['source_model'],
                     derived_columns=metadata_dict['derived_columns'],
                     hashed_columns=metadata_dict['hashed_columns']) }}
