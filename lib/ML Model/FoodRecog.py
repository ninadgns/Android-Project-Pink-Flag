from clarifai.client.model import Model
from flask import Flask, request, jsonify
from flask_cors import CORS

# Your PAT (Personal Access Token)
PAT = "8d791a58ddeb4ed0a1b57df02fa4fadc"

# Model URL
model_url = "https://clarifai.com/clarifai/main/models/food-item-recognition"

# Initialize the Clarifai model
model = Model(url=model_url, pat=PAT)

# Initialize Flask app
app = Flask(__name__)
CORS(app)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get the image file from the request
        image_file = request.files['image']
        image_bytes = image_file.read()

        # Perform prediction using image bytes
        model_prediction = model.predict_by_bytes(image_bytes, input_type="image")

        # Extract prediction data
        predictions = [
            {"name": concept.name, "value": round(concept.value, 2)}
            for concept in model_prediction.outputs[0].data.concepts
        ]

        return jsonify(predictions)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
