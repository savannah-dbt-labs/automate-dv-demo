# dbt Style Guide

This project follows a Data Vault-oriented structure built on Snowflake and AutomateDV. The goal of this guide is consistency with the code already in the repo.

## Project layout

Put models in the layer that matches their role:

- `models/raw_stage/` for source-aligned raw extraction models
- `models/stage/` for hashed and derived stage views used by the vault
- `models/raw_vault/hubs/` for hub models
- `models/raw_vault/links/` for link models
- `models/raw_vault/sats/` for satellite models
- `models/raw_vault/t_links/` for transactional link models
- `models/schema.yml` for shared source definitions

Follow the paths configured in `dbt_project.yml`:

- models live in `models/`
- analysis files live in `analysis/`
- macros live in `macros/`
- tests live in `tests/`

## Naming conventions

Use names that make the layer obvious.

### Raw stage models

Raw stage models use the `raw_` prefix:

- `raw_orders`
- `raw_inventory`
- `raw_transactions`

These models are thin transforms over `source()` data and should stay close to the source entities they represent.

### Stage models

Stage models use the `v_stg_` prefix:

- `v_stg_orders`
- `v_stg_inventory`
- `v_stg_transactions`

These models prepare Data Vault-ready columns, including:

- derived business keys
- record source fields
- effective dates
- hashed primary keys
- hashdiffs

### Raw vault models

Use the standard Data Vault prefixes:

- `hub_` for hubs
- `link_` for links
- `t_link_` for transactional links
- satellite models should use a `sat_` prefix

Examples already in the repo:

- `hub_order`
- `hub_customer`
- `link_customer_order`
- `link_order_lineitem`
- `t_link_transactions`

## SQL style

### General formatting

Match the current repo style:

- write SQL keywords in uppercase
- put `SELECT` columns one per line
- use short table aliases like `a`, `b`, `c` when working directly with source tables
- keep joins and predicates on their own lines
- use `AS` for renamed columns
- prefer simple, readable statements over heavily nested SQL

Example shape used in this repo:

```sql
SELECT
    a.COL1 AS BUSINESS_COL1,
    b.COL2 AS BUSINESS_COL2
FROM {{ source('some_source', 'SOME_TABLE') }} AS a
LEFT JOIN {{ source('some_source', 'OTHER_TABLE') }} AS b
    ON a.ID = b.ID
```

### dbt conventions

Always:

- use `{{ source() }}` for source tables
- use `{{ ref() }}` for dbt dependencies
- avoid hardcoded database object references when the object is managed in dbt
- keep transformations layer-appropriate instead of collapsing everything into one model

### Warehouse-facing column naming

This project uses uppercase column names in SQL models, especially in `raw_stage` and `stage`:

- `ORDERKEY`
- `CUSTOMER_KEY`
- `ORDER_PK`
- `LOAD_DATE`
- `RECORD_SOURCE`

When adding columns to these layers, keep the uppercase convention.

## Jinja style

This repo uses compact Jinja assignment blocks and AutomateDV macros.

### Variable assignment

Use whitespace-controlled Jinja for local variables:

```jinja
{%- set source_model = "v_stg_orders" -%}
{%- set src_pk = "ORDER_PK" -%}
```

### YAML-in-Jinja metadata blocks

For stage models, define metadata in a YAML block and parse it with `fromyaml`:

```jinja
{%- set yaml_metadata -%}
source_model: 'raw_orders'
derived_columns:
  CUSTOMER_KEY: 'CUSTOMERKEY'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
```

Keep these blocks organized by concept:

- `source_model`
- `derived_columns`
- `hashed_columns`
- other macro inputs only when needed

### AutomateDV macro calls

Use named arguments and keep long macro calls vertically aligned for readability:

```jinja
{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
```

Apply the same pattern for `stage`, `hub`, `link`, and other AutomateDV macros.

## Model configuration and materialization

Follow the folder-level defaults in `dbt_project.yml` instead of repeating config in each model unless there is a clear exception:

- `raw_stage`: `view`
- `stage`: `view`
- `raw_vault`: `incremental`

Folder tags are also defined centrally and should be preserved:

- `raw`
- `stage`
- `raw_vault`
- `hub`
- `link`
- `satellite`
- `t_link`

If a model needs custom config, keep the override minimal and document why.

## Sources

Define sources in YAML under `models/schema.yml` unless there is a strong reason to split them.

Current source style in this repo:

- one top-level `sources:` block
- uppercase physical table names
- explicit database and schema
- schema parameterized with project vars where needed

Example pattern:

```yaml
sources:
  - name: tpch_sample
    database: SNOWFLAKE_SAMPLE_DATA
    schema: TPCH_SF{{ var('tpch_size', 10) }}
    tables:
      - name: ORDERS
```

## YAML style

For dbt YAML files:

- use two-space indentation
- keep names lowercase for dbt resource names unless they represent physical warehouse objects
- use `data_tests:` rather than legacy `tests:`
- colocate model documentation with the relevant resources when model-level YAML is added

## Variables and literals

This project uses vars for runtime configuration, for example:

- `load_date`
- `tpch_size`

When a value is environment- or run-specific, prefer a project var over hardcoding it repeatedly.

For date literals in this repo, the established pattern is:

```sql
TO_DATE('{{ var('load_date') }}')
```

## What good looks like in this repo

A clean model in this project usually does three things well:

1. sits in the right layer
2. follows the naming pattern for that layer
3. keeps Data Vault metadata explicit and readable

If you are unsure where new logic belongs, prefer:

- `raw_stage` for source cleanup and renaming
- `stage` for derived columns and hashed keys
- `raw_vault` for vault structures generated through AutomateDV

## Don’t drift from the existing style

Avoid introducing mixed conventions like:

- lowercase column aliases in stage models
- `stg_` naming when this repo uses `v_stg_`
- inline one-off config where folder config already exists
- hardcoded table references instead of `source()` or `ref()`
- non-Data Vault naming for vault models

Consistency matters more than personal preference here. Match the repo first.
