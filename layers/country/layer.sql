CREATE OR REPLACE FUNCTION layer_country(bbox geometry, zoom_level int, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, class text, name text, name_en text, name_de text, tags hstore, rank int) AS $$
    SELECT osm_id, geometry, class, name, name_en, name_de, tags, rank
    FROM (
    SELECT osm_id, geometry,
        'country'::text as class,
        name, name_en, name_de, tags,
        NULL::int as rank
        FROM (
        -- etldoc: osm_country_polygon_gen8 -> layer_country:z6
        SELECT osm_id, st_difference(geometry, ocean), 
        name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen8
        join lateral (
            select st_collectionextract(st_union(ocean.geometry), 3) as ocean
            from osm_ocean_polygon ocean
            where st_intersects(osm_country_polygon_gen8.geometry, ocean.geometry)
        ) as ocean
        on true
        WHERE zoom_level <= 6 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen7 -> layer_country:z7
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen7
        WHERE zoom_level = 7 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen6 -> layer_country:z8
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen6
        WHERE zoom_level = 8 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen5 -> layer_country:z9
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen5
        WHERE zoom_level = 9 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen4 -> layer_country:z10
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen4
        WHERE zoom_level = 10 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen3 -> layer_country:z11
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen3
        WHERE zoom_level = 11 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen2 -> layer_country:z12
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen2
        WHERE zoom_level = 12 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen1 -> layer_country:z13
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon_gen1
        WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon -> layer_country:z14
        SELECT osm_id, geometry, name, name_en, name_de, tags, NULL::int as scalerank
        FROM osm_country_polygon
        WHERE zoom_level >= 14 AND geometry && bbox
    ) AS country_polygon
    ) AS country_all
    join lateral (
	    select st_collectionextract(st_union(ocean.geometry), 3) as ocean
	    from osm_ocean_polygon ocean
	    where st_intersects(country_all.geometry, ocean.geometry)
    ) as oceans
    on true
$$ LANGUAGE SQL IMMUTABLE;