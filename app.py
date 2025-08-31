from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

model = joblib.load("water_potability_model.pkl")
scaler = joblib.load("scaler.pkl")


@app.route("/")
def home():
    return "Water Potability Prediction API is running!"


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    try:
        features = scaler.transform([data["features"]])
        # features = np.array(data["features"]).reshape(1, -1)
        prediction = model.predict(features)
        result = int(prediction[0])
        return jsonify({"potability": result})
    except Exception as e:
        return jsonify({"error": str(e)})


if __name__ == "__main__":
    app.run(debug=True)
