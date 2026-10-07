# ai/src/routing-risk/export_onnx.py
from __future__ import annotations

import joblib
from pathlib import Path

from skl2onnx import convert_sklearn
from skl2onnx.common.data_types import FloatTensorType

from features import FEATURES

ROOT = Path(__file__).resolve().parents[2]  # ai/
IN_MODEL = ROOT / "models" / "routing-risk.joblib"
OUT_ONNX = ROOT / "models" / "routing-risk.onnx"

def main():
    model = joblib.load(IN_MODEL)

    # IMPORTANT: must match FEATURES length/order
    initial_type = [("float_input", FloatTensorType([None, len(FEATURES)]))]
    onnx_model = convert_sklearn(model, initial_types=initial_type)

    OUT_ONNX.write_bytes(onnx_model.SerializeToString())
    print("✅ exported:", OUT_ONNX)

if __name__ == "__main__":
    main()
