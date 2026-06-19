from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
from pathlib import Path

app = Flask(__name__)
CORS(app)

# ---------------- LOAD MODEL ----------------
BASE_DIR = Path(__file__).resolve().parent
MODEL_FILE = BASE_DIR / 'model.pkl'

if not MODEL_FILE.exists():
    raise FileNotFoundError(f"Model not found: {MODEL_FILE}")

model = joblib.load(MODEL_FILE)

# ---------------- HOME ----------------
@app.route('/')
def home():
    return "E-Waste ML API Running"

# ---------------- HEALTH ----------------
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "API healthy"})

# ---------------- PREDICT ----------------
@app.route('/predict', methods=['POST'])
def predict():

    try:
        data = request.get_json()

        # ✅ MATCHING YOUR FLUTTER FIELDS
        gdp = float(data['gdpPerCapita'])
        policy = float(data['policyIndex'])
        urban = float(data['urbanizationRate'])
        landfill = float(data['landfillRate'])
        collection = float(data['formalCollectionRate'])
        informal = float(data['informalProcessingPercentage'])

        # ---------------- FEATURES FOR MODEL ----------------
        features = np.array([[gdp, policy, urban, landfill, collection, informal]])

        prediction = model.predict(features)
        recycling_rate = round(float(prediction[0]), 2)

        # ---------------- STATUS ----------------
        if recycling_rate >= 70:
            status = "Excellent Recycling System"
        elif recycling_rate >= 50:
            status = "Moderate Recycling System"
        else:
            status = "Poor Recycling System"

        # ---------------- RECOMMENDATIONS ----------------
        recommendations = []

        if collection < 50:
            recommendations.append("Increase formal collection systems.")

        if landfill > 40:
            recommendations.append("Reduce dependence on landfills.")

        if urban > 75:
            recommendations.append("Improve urban waste management.")

        if informal > 30:
            recommendations.append("Regulate informal recycling sector.")

        # ---------------- RESPONSE ----------------
        return jsonify({
            "predictedRate": recycling_rate,
            "sustainabilityLevel": status,
            "recommendation": " ".join(recommendations),
            "trend": [
                recycling_rate - 10,
                recycling_rate - 5,
                recycling_rate,
                recycling_rate + 3,
                recycling_rate + 5
            ]
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ---------------- RUN APP ----------------
if __name__ == '__main__':
    
    app.run(
    host='0.0.0.0',
    port=5000,
    debug=True
)