 
DECLARE
    breakfast_cursor REFCURSOR;
    lunch_cursor REFCURSOR;
    dinner_cursor REFCURSOR;
    current_recipe RECORD;
BEGIN
    -- Create temporary tables for each meal type with prioritized recipes
    CREATE TEMP TABLE breakfast_recipes AS
    SELECT ar.recipe_id, ar.recipe_name, ar.recipe_tag,
           ROW_NUMBER() OVER (
               ORDER BY 
                   CASE 
                       WHEN ar.recipe_tag = 'Breakfast' THEN 0
                       WHEN ar.recipe_tag = 'Drinks' THEN 1
                       WHEN ar.recipe_tag = 'Snacks' THEN 2
                       ELSE 3
                   END,
                   random()
           ) as recipe_order
    FROM get_applicable_recipes(user_id_input) ar
    WHERE ar.recipe_tag IN ('Breakfast', 'Drinks', 'Snacks', 'Dessert', 'Desserts');

    CREATE TEMP TABLE lunch_recipes AS
    SELECT ar.recipe_id, ar.recipe_name, ar.recipe_tag,
           ROW_NUMBER() OVER (
               ORDER BY 
                   CASE 
                       WHEN ar.recipe_tag = 'Lunch' THEN 0
                       WHEN ar.recipe_tag = 'Snacks' THEN 2
                       WHEN ar.recipe_tag = 'Dinner' THEN 1
                       WHEN ar.recipe_tag = 'Drinks' THEN 4
                       ELSE 3
                   END,
                   random()
           ) as recipe_order
    FROM get_applicable_recipes(user_id_input) ar
    WHERE ar.recipe_tag IN ('Lunch', 'Dinner', 'Drinks', 'Snacks', 'Dessert', 'Desserts');

    CREATE TEMP TABLE dinner_recipes AS
    SELECT ar.recipe_id, ar.recipe_name, ar.recipe_tag,
           ROW_NUMBER() OVER (
               ORDER BY 
                   CASE 
                       WHEN ar.recipe_tag = 'Lunch' THEN 4
                       WHEN ar.recipe_tag = 'Snacks' THEN 2
                       WHEN ar.recipe_tag = 'Dinner' THEN 0
                       WHEN ar.recipe_tag = 'Drinks' THEN 3
                       ELSE 1
                   END,
                   random()
           ) as recipe_order
    FROM get_applicable_recipes(user_id_input) ar
    WHERE ar.recipe_tag IN ('Lunch', 'Dinner', 'Drinks', 'Snacks', 'Dessert', 'Desserts');

    -- Create temporary table for final meal plan
    CREATE TEMP TABLE meal_plan (
        slot_number INTEGER,
        recipe_id UUID,
        recipe_name TEXT,
        recipe_tag TEXT
    );

    -- Open cursors for each meal type
    OPEN breakfast_cursor FOR 
        SELECT br.recipe_id, br.recipe_name, br.recipe_tag 
        FROM breakfast_recipes br
        ORDER BY br.recipe_order;

    OPEN lunch_cursor FOR 
        SELECT lr.recipe_id, lr.recipe_name, lr.recipe_tag 
        FROM lunch_recipes lr
        ORDER BY lr.recipe_order;

    OPEN dinner_cursor FOR 
        SELECT dr.recipe_id, dr.recipe_name, dr.recipe_tag 
        FROM dinner_recipes dr
        ORDER BY dr.recipe_order;

    -- Fill breakfast slots (slots 1, 4, 7, 10, 13, 16, 19)
    FOR slot IN 1..21 BY 3 LOOP
        FETCH breakfast_cursor INTO current_recipe;
        -- If we reached the end, reopen the cursor
        IF NOT FOUND THEN
            CLOSE breakfast_cursor;
            OPEN breakfast_cursor FOR 
                SELECT br.recipe_id, br.recipe_name, br.recipe_tag 
                FROM breakfast_recipes br
                ORDER BY br.recipe_order;
            FETCH breakfast_cursor INTO current_recipe;
        END IF;

        INSERT INTO meal_plan (slot_number, recipe_id, recipe_name, recipe_tag)
        VALUES (slot, current_recipe.recipe_id, current_recipe.recipe_name, current_recipe.recipe_tag);
    END LOOP;

    -- Fill lunch slots (slots 2, 5, 8, 11, 14, 17, 20)
    FOR slot IN 2..21 BY 3 LOOP
        FETCH lunch_cursor INTO current_recipe;
        -- If we reached the end, reopen the cursor
        IF NOT FOUND THEN
            CLOSE lunch_cursor;
            OPEN lunch_cursor FOR 
                SELECT lr.recipe_id, lr.recipe_name, lr.recipe_tag 
                FROM lunch_recipes lr
                ORDER BY lr.recipe_order;
            FETCH lunch_cursor INTO current_recipe;
        END IF;

        INSERT INTO meal_plan (slot_number, recipe_id, recipe_name, recipe_tag)
        VALUES (slot, current_recipe.recipe_id, current_recipe.recipe_name, current_recipe.recipe_tag);
    END LOOP;

    -- Fill dinner slots (slots 3, 6, 9, 12, 15, 18, 21)
    FOR slot IN 3..21 BY 3 LOOP
        FETCH dinner_cursor INTO current_recipe;
        -- If we reached the end, reopen the cursor
        IF NOT FOUND THEN
            CLOSE dinner_cursor;
            OPEN dinner_cursor FOR 
                SELECT dr.recipe_id, dr.recipe_name, dr.recipe_tag 
                FROM dinner_recipes dr
                ORDER BY dr.recipe_order;
            FETCH dinner_cursor INTO current_recipe;
        END IF;

        INSERT INTO meal_plan (slot_number, recipe_id, recipe_name, recipe_tag)
        VALUES (slot, current_recipe.recipe_id, current_recipe.recipe_name, current_recipe.recipe_tag);
    END LOOP;

    -- Close cursors
    CLOSE breakfast_cursor;
    CLOSE lunch_cursor;
    CLOSE dinner_cursor;

    -- Return the final meal plan
    RETURN QUERY
    SELECT 
        CASE (mp.slot_number - 1) / 3
            WHEN 0 THEN 'Day-1'
            WHEN 1 THEN 'Day-2'
            WHEN 2 THEN 'Day-3'
            WHEN 3 THEN 'Day-4'
            WHEN 4 THEN 'Day-5'
            WHEN 5 THEN 'Day-6'
            WHEN 6 THEN 'Day-7'
        END,
        CASE (mp.slot_number - 1) % 3
            WHEN 0 THEN 'Breakfast'
            WHEN 1 THEN 'Lunch'
            WHEN 2 THEN 'Dinner'
        END,
        mp.recipe_id,
        mp.recipe_name
    FROM meal_plan mp
    ORDER BY mp.slot_number;
    
    -- Clean up temporary tables
    DROP TABLE breakfast_recipes;
    DROP TABLE lunch_recipes;
    DROP TABLE dinner_recipes;
    DROP TABLE meal_plan;
END;
