import os
from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

# Load Warhammer dataset relative to script directory
csv_path = os.path.join(os.path.dirname(__file__), 'warhammer_stats.csv')
df = pd.read_csv(csv_path)

# Normalize column name ('Unit' -> 'Name') if needed
if 'Unit' in df.columns and 'Name' not in df.columns:
    df.rename(columns={'Unit': 'Name'}, inplace=True)

def calculate_efficiency(unit_name):
    # This mimics the logic we used in your midterm
    unit = df[df['Name'] == unit_name].iloc[0]
    
    # Simple "AI" Metric: Effective Wounds per Point
    # (Attacks * Strength * Damage) / Points Cost
    # You can swap this with your actual complex formula
    score = (unit['Attacks'] * unit['Strength'] * unit['Damage']) / unit['Points']
    return score, unit

@app.route('/get_units', methods=['GET'])
def get_units():
    # Send list of unit names to Flutter for the dropdowns
    return jsonify(df['Name'].tolist())

@app.route('/simulate_battle', methods=['POST'])
def simulate():
    data = request.json
    unit_a_name = data['unitA']
    unit_b_name = data['unitB']
    
    score_a, stats_a = calculate_efficiency(unit_a_name)
    score_b, stats_b = calculate_efficiency(unit_b_name)
    
    winner = unit_a_name if score_a > score_b else unit_b_name
    
    return jsonify({
        'winner': winner,
        'score_a': round(score_a, 2),
        'score_b': round(score_b, 2),
        'analysis': f"{winner} is {(score_a/score_b if score_a > score_b else score_b/score_a):.1f}x more cost effective."
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)