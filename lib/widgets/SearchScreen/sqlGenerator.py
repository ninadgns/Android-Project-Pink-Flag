def generate_sql(recipe):
    # Extract recipe information
    user_id = recipe['user_id']
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
        sql_ingredients += f"INSERT INTO ingredients (recipe_id, name, quantity, unit)\n"
        sql_ingredients += f"VALUES ((SELECT id FROM recipes WHERE title = '{title}'), '{ingredient['name']}', {ingredient['quantity']}, '{ingredient['unit']}');\n"

    # Generate SQL for steps table
    steps = recipe['steps']
    sql_steps = """-- Insert steps\n"""
    for step in steps:
        sql_steps += f"INSERT INTO steps (recipe_id, description, step_order, time)\n"
        sql_steps += f"VALUES ((SELECT id FROM recipes WHERE title = '{title}'), '{step['description']}', {step['step_order']}, {step['time']});\n"

    # Generate SQL for nutrition table
    nutrition = recipe['nutrition']
    sql_nutrition = f"""INSERT INTO nutrition (recipe_id, protein, carbs, fat)\nVALUES ((SELECT id FROM recipes WHERE title = '{title}'), {nutrition['protein']}, {nutrition['carbs']}, {nutrition['fat']});"""

    # Combine all SQL statements
    sql_script = "\n".join([sql_recipe, sql_ingredients, sql_steps, sql_nutrition])
    return sql_script

# Example recipe data array
recipes_data = [
    # Dinner Recipes
    {
        'user_id': 'arGdJFbNP1ddYa6QYlJPs0tHhgl2',
        'title': 'Kosha Mangsho',
        'description': 'A slow-cooked, spicy Bengali mutton curry perfect for dinner.',
        'difficulty': 'Medium',
        'total_duration': 90,
        'serving_count': 4,
        'ingredients': [
            {'name': 'Mutton', 'quantity': 1, 'unit': 'kg'},
            {'name': 'Onion', 'quantity': 3, 'unit': 'pieces'},
            {'name': 'Ginger', 'quantity': 2, 'unit': 'tablespoons'},
            {'name': 'Garlic', 'quantity': 4, 'unit': 'cloves'},
            {'name': 'Cumin Powder', 'quantity': 2, 'unit': 'teaspoons'},
            {'name': 'Turmeric Powder', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Red Chili Powder', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Mustard Oil', 'quantity': 4, 'unit': 'tablespoons'},
            {'name': 'Salt', 'quantity': 1, 'unit': 'teaspoon'},
        ],
        'steps': [
            {'description': 'Marinate mutton with turmeric, chili powder, and salt.', 'step_order': 1, 'time': 30},
            {'description': 'Heat mustard oil and fry onions, ginger, and garlic.', 'step_order': 2, 'time': 15},
            {'description': 'Add mutton and cook until browned.', 'step_order': 3, 'time': 15},
            {'description': 'Simmer with water until mutton is tender.', 'step_order': 4, 'time': 30},
        ],
        'nutrition': {
            'protein': 40,
            'carbs': 10,
            'fat': 25,
        }
    },
    # Drinks
    {
        'user_id': 'arGdJFbNP1ddYa6QYlJPs0tHhgl2',
        'title': 'Aam Panna',
        'description': 'A refreshing raw mango drink with a tangy and sweet taste.',
        'difficulty': 'Easy',
        'total_duration': 15,
        'serving_count': 4,
        'ingredients': [
            {'name': 'Raw Mango', 'quantity': 2, 'unit': 'pieces'},
            {'name': 'Sugar', 'quantity': 3, 'unit': 'tablespoons'},
            {'name': 'Black Salt', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Cumin Powder', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Mint Leaves', 'quantity': 10, 'unit': 'leaves'},
            {'name': 'Water', 'quantity': 500, 'unit': 'ml'},
        ],
        'steps': [
            {'description': 'Boil raw mangoes and remove the skin.', 'step_order': 1, 'time': 10},
            {'description': 'Blend mango pulp with sugar, salt, cumin powder, and mint.', 'step_order': 2, 'time': 5},
            {'description': 'Add water and serve chilled.', 'step_order': 3, 'time': 0},
        ],
        'nutrition': {
            'protein': 1,
            'carbs': 25,
            'fat': 0,
        }
    },
    # Desserts
    {
        'user_id': 'arGdJFbNP1ddYa6QYlJPs0tHhgl2',
        'title': 'Sandesh',
        'description': 'A soft and melt-in-your-mouth Bengali dessert made with paneer and sugar.',
        'difficulty': 'Easy',
        'total_duration': 30,
        'serving_count': 6,
        'ingredients': [
            {'name': 'Paneer', 'quantity': 250, 'unit': 'grams'},
            {'name': 'Sugar', 'quantity': 50, 'unit': 'grams'},
            {'name': 'Cardamom Powder', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Pistachios', 'quantity': 10, 'unit': 'pieces'},
        ],
        'steps': [
            {'description': 'Mash paneer until smooth.', 'step_order': 1, 'time': 10},
            {'description': 'Cook paneer with sugar until the mixture thickens.', 'step_order': 2, 'time': 10},
            {'description': 'Shape the mixture into small discs and garnish with pistachios.', 'step_order': 3, 'time': 10},
        ],
        'nutrition': {
            'protein': 8,
            'carbs': 15,
            'fat': 5,
        }
    },
    # Snacks
    {
        'user_id': 'arGdJFbNP1ddYa6QYlJPs0tHhgl2',
        'title': 'Pyaaji',
        'description': 'Crispy onion fritters, a favorite Bengali evening snack.',
        'difficulty': 'Easy',
        'total_duration': 20,
        'serving_count': 4,
        'ingredients': [
            {'name': 'Onion', 'quantity': 2, 'unit': 'pieces'},
            {'name': 'Besan (Gram Flour)', 'quantity': 100, 'unit': 'grams'},
            {'name': 'Green Chili', 'quantity': 2, 'unit': 'pieces'},
            {'name': 'Cumin Seeds', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Salt', 'quantity': 1, 'unit': 'teaspoon'},
            {'name': 'Oil', 'quantity': 200, 'unit': 'ml'},
        ],
        'steps': [
            {'description': 'Slice onions and mix with besan, chili, cumin, and salt.', 'step_order': 1, 'time': 5},
            {'description': 'Add water to form a thick batter.', 'step_order': 2, 'time': 5},
            {'description': 'Deep-fry small portions of the batter until golden brown.', 'step_order': 3, 'time': 10},
        ],
        'nutrition': {
            'protein': 5,
            'carbs': 20,
            'fat': 15,
        }
    }
]


# Generate SQL scripts for all recipes
for recipe_data in recipes_data:
    sql_script = generate_sql(recipe_data)
    print(sql_script)
