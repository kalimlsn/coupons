{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('coupons__links') }}
{{ unnest_cte(ref('coupons__links'), '_links', 'collection') }}
select
    _airbyte__links_hashid,
    {{ json_extract_scalar(unnested_column_value('collection'), ['href'], ['href']) }} as href,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('coupons__links') }} as table_alias
-- collection at coupons/_links/collection
{{ cross_join_unnest('_links', 'collection') }}
where 1 = 1
and collection is not null

