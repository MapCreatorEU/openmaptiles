-- etldoc: layer_country[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_country |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_country(bbox geometry, zoom_level int, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, name_en text, name_de text) AS $$
    SELECT osm_id, geometry, name, name_en, name_de
    FROM (
    SELECT osm_id, geometry,
        COALESCE(NULLIF(boundary, ''), NULLIF(leisure, '')) AS class,
        name, name_en, name_de, tags,
        NULL::int as rank
        FROM (
        -- etldoc: osm_country_polygon_gen8 -> layer_country:z6
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen8
        WHERE zoom_level = 6 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen7 -> layer_country:z7
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen7
        WHERE zoom_level = 7 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen6 -> layer_country:z8
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen6
        WHERE zoom_level = 8 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen5 -> layer_country:z9
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen5
        WHERE zoom_level = 9 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen4 -> layer_country:z10
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen4
        WHERE zoom_level = 10 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen3 -> layer_country:z11
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen3
        WHERE zoom_level = 11 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen2 -> layer_country:z12
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen2
        WHERE zoom_level = 12 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon_gen1 -> layer_country:z13
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon_gen1
        WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_country_polygon -> layer_country:z14
        SELECT osm_id, geometry, name, name_en, name_de
        FROM osm_country_polygon
        WHERE zoom_level >= 14 AND geometry && bbox
    ) AS country_polygon

    UNION ALL
    SELECT osm_id, geometry_point AS geometry,
        name, name_en, name_de
        FROM (
        -- etldoc: osm_country_polygon_gen8 -> layer_country:z6
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen8
        WHERE zoom_level = 6 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen7 -> layer_country:z7
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen7
        WHERE zoom_level = 7 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen6 -> layer_country:z8
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen6
        WHERE zoom_level = 8 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen5 -> layer_country:z9
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen5
        WHERE zoom_level = 9 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen4 -> layer_country:z10
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen4
        WHERE zoom_level = 10 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen3 -> layer_country:z11
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen3
        WHERE zoom_level = 11 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen2 -> layer_country:z12
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen2
        WHERE zoom_level = 12 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon_gen1 -> layer_country:z13
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon_gen1
        WHERE zoom_level = 13 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_country_polygon -> layer_country:z14
        SELECT osm_id, geometry_point, name, name_en, name_de
        FROM osm_country_polygon
        WHERE zoom_level >= 14 AND geometry_point && bbox
    ) AS country_point
    ) AS country_all;
$$ LANGUAGE SQL IMMUTABLE;
