def generate_sql(recipe):
    # Extract recipe information
    user_id = "coX6Kd0rjUaDzUYksVyYtBOOiW23"  # Fixed user ID
    title = recipe['title']
    description = recipe['description']
    difficulty = recipe['difficulty']
    total_duration = recipe['total_duration']
    serving_count = recipe['serving_count']

    # Generate SQL for recipes table
    sql_recipe = f"""INSERT INTO recipes (user_id, title, description, difficulty, total_duration, serving_count)\nVALUES ('{user_id}', '{title}', '{description}', '{difficulty}', {total_duration}, {serving_count});"""

    # Generate SQL for ingredients table
    ingredients = recipe['ingredients']
    sql_ingredients = """-- Insert ingredients\n"""
    for ingredient in ingredients:
        sql_ingredients += f"INSERT INTO ingredients (recipe_id, name, quantity, unit, ingredient_id)\n"
        sql_ingredients += f"VALUES ((SELECT id FROM recipes WHERE title = '{title}'), '{ingredient['name']}', {ingredient['quantity']}, '{ingredient['unit']}', {ingredient['ingredient_id']});\n"

    # Generate SQL for steps table
    steps = recipe['steps']
    sql_steps = """-- Insert steps\n"""
    for step in steps:
        sql_steps += f"INSERT INTO steps (recipe_id, description, step_order, time)\n"
        sql_steps += f"VALUES ((SELECT id FROM recipes WHERE title = '{title}'), '{step['description']}', {step['step_order']}, {step['time']});\n"

    # Generate SQL for nutrition table (now includes calories)
    nutrition = recipe['nutrition']
    sql_nutrition = f"""INSERT INTO nutrition (recipe_id, protein, carbs, fat, calories)\nVALUES ((SELECT id FROM recipes WHERE title = '{title}'), {nutrition['protein']}, {nutrition['carbs']}, {nutrition['fat']}, {nutrition['calories']});"""

    # Combine all SQL statements
    sql_script = "\n".join([sql_recipe, sql_ingredients, sql_steps, sql_nutrition])
    return sql_script


# Example recipe data array
recipes = [
    {
        "user_id": "coX6Kd0rjUaDzUYksVyYtBOOiW23",
        "title": "Egg Bhurji",
        "description": "A quick and delicious Indian scrambled eggs dish.",
        "difficulty": "Easy",
        "total_duration": 15,
        "serving_count": 2,
        "ingredients": [
            {"ingredient_id": 43, "name": "Egg", "quantity": 4, "unit": "pieces"},
            {"ingredient_id": 3, "name": "Onion", "quantity": 1, "unit": "pieces"},
            {"ingredient_id": 6, "name": "Tomato", "quantity": 1, "unit": "pieces"},
            {"ingredient_id": 8, "name": "Green Chili", "quantity": 2, "unit": "pieces"},
            {"ingredient_id": 30, "name": "Turmeric Powder", "quantity": 0.5, "unit": "tsp"},
            {"ingredient_id": 42, "name": "Oil", "quantity": 1, "unit": "tbsp"},
            {"ingredient_id": 25, "name": "Salt", "quantity": 1, "unit": "tsp"}
        ],
        "steps": [
            {"step_order": 1, "description": "Heat oil in a pan and sauté onions.", "time": 5},
            {"step_order": 2, "description": "Add tomatoes, green chilies, and spices. Cook for 5 minutes.", "time": 5},
            {"step_order": 3, "description": "Break eggs into the pan and scramble them until cooked.", "time": 5}
        ],
        "nutrition": {"protein": 14, "carbs": 5, "fat": 10, "calories": 180}  # Falls under diet_id: d04
    },
    {
        "user_id": "coX6Kd0rjUaDzUYksVyYtBOOiW23",
        "title": "Mutton Korma",
        "description": "A rich and flavorful slow-cooked mutton curry.",
        "difficulty": "Hard",
        "total_duration": 120,
        "serving_count": 4,
        "ingredients": [
            {"ingredient_id": 2, "name": "Mutton", "quantity": 500, "unit": "grams"},
            {"ingredient_id": 3, "name": "Onion", "quantity": 2, "unit": "pieces"},
            {"ingredient_id": 4, "name": "Garlic", "quantity": 6, "unit": "cloves"},
            {"ingredient_id": 5, "name": "Ginger", "quantity": 1, "unit": "inch piece"},
            {"ingredient_id": 16, "name": "Ghee", "quantity": 3, "unit": "tbsp"},
            {"ingredient_id": 28, "name": "Cloves", "quantity": 2, "unit": "pieces"},
            {"ingredient_id": 27, "name": "Cardamom", "quantity": 2, "unit": "pieces"},
            {"ingredient_id": 25, "name": "Salt", "quantity": 1, "unit": "tsp"}
        ],
        "steps": [
            {"step_order": 1, "description": "Heat ghee and fry onions until golden.", "time": 10},
            {"step_order": 2, "description": "Add garlic, ginger, and spices. Cook for 5 minutes.", "time": 5},
            {"step_order": 3, "description": "Add mutton and slow cook for 1.5 hours.", "time": 90}
        ],
        "nutrition": {"protein": 42, "carbs": 8, "fat": 30, "calories": 500}  # Doesn't fit any diet criteria
    },
    {
        "user_id": "coX6Kd0rjUaDzUYksVyYtBOOiW23",
        "title": "Dal Tadka",
        "description": "A classic Indian lentil dish with a tempering of spices.",
        "difficulty": "Medium",
        "total_duration": 45,
        "serving_count": 3,
        "ingredients": [
            {"ingredient_id": 20, "name": "Moong Dal", "quantity": 200, "unit": "grams"},
            {"ingredient_id": 3, "name": "Onion", "quantity": 1, "unit": "pieces"},
            {"ingredient_id": 6, "name": "Tomato", "quantity": 1, "unit": "pieces"},
            {"ingredient_id": 41, "name": "Cumin Seeds", "quantity": 1, "unit": "tsp"},
            {"ingredient_id": 42, "name": "Oil", "quantity": 1, "unit": "tbsp"},
            {"ingredient_id": 25, "name": "Salt", "quantity": 1, "unit": "tsp"}
        ],
        "steps": [
            {"step_order": 1, "description": "Boil moong dal until soft.", "time": 30},
            {"step_order": 2, "description": "Heat oil, add cumin seeds, onions, and tomatoes. Sauté for 10 minutes.", "time": 10},
            {"step_order": 3, "description": "Mix the tempering with dal and simmer for 5 minutes.", "time": 5}
        ],
        "nutrition": {"protein": 10, "carbs": 35, "fat": 5, "calories": 250}  # Falls under diet_id: d05
    },
    {
        "user_id": "coX6Kd0rjUaDzUYksVyYtBOOiW23",
        "title": "Vegetable Stir Fry",
        "description": "A quick and healthy vegetable stir fry.",
        "difficulty": "Easy",
        "total_duration": 20,
        "serving_count": 2,
        "ingredients": [
            {"ingredient_id": 76, "name": "Broccoli", "quantity": 100, "unit": "grams"},
            {"ingredient_id": 72, "name": "Capsicum", "quantity": 50, "unit": "grams"},
            {"ingredient_id": 73, "name": "Beans", "quantity": 50, "unit": "grams"},
            {"ingredient_id": 42, "name": "Oil", "quantity": 1, "unit": "tbsp"},
            {"ingredient_id": 25, "name": "Salt", "quantity": 1, "unit": "tsp"}
        ],
        "steps": [
            {"step_order": 1, "description": "Heat oil in a pan and sauté vegetables.", "time": 10},
            {"step_order": 2, "description": "Add salt and stir fry for another 5 minutes.", "time": 5}
        ],
        "nutrition": {"protein": 5, "carbs": 15, "fat": 7, "calories": 150}  # Falls under diet_id: d01
    },
    {
        "user_id": "coX6Kd0rjUaDzUYksVyYtBOOiW23",
        "title": "Paneer Butter Masala",
        "description": "A creamy and rich paneer dish in a tomato-based gravy.",
        "difficulty": "Medium",
        "total_duration": 45,
        "serving_count": 3,
        "ingredients": [
            {"ingredient_id": 37, "name": "Paneer", "quantity": 200, "unit": "grams"},
            {"ingredient_id": 6, "name": "Tomato", "quantity": 2, "unit": "pieces"},
            {"ingredient_id": 3, "name": "Onion", "quantity": 1, "unit": "pieces"},
            {"ingredient_id": 15, "name": "Mustard Oil", "quantity": 1, "unit": "tbsp"},
            {"ingredient_id": 16, "name": "Ghee", "quantity": 1, "unit": "tbsp"},
            {"ingredient_id": 25, "name": "Salt", "quantity": 1, "unit": "tsp"}
        ],
        "steps": [
            {"step_order": 1, "description": "Blend tomatoes and onions to make a smooth puree.", "time": 10},
            {"step_order": 2, "description": "Cook the puree with spices for 15 minutes.", "time": 15},
            {"step_order": 3, "description": "Add paneer cubes and cook for another 10 minutes.", "time": 10}
        ],
        "nutrition": {"protein": 18, "carbs": 12, "fat": 22, "calories": 350}  # Falls under diet_id: d02
    }
]




# Generate SQL scripts for all recipes
for recipe in recipes:
    sql = generate_sql(recipe)
    print(sql)

