import os
import pandas as pd
import streamlit as st
from joblib import load
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from tienxuly import clean_text, tokenize_stopwords

st.set_page_config(page_title="Dự đoán cảm xúc", layout="wide")
st.title("Dự đoán cảm xúc bình luận")


DATA_PATH = "data_final.xlsx"
SHEET_NAME = "Sheet1"


MODELS = {
    "SVM": "ecommerce_svm_sentiment_model.joblib",
    "Logistic Regression": "ecommerce_logistic_sentiment_model.joblib",
}

# =======================
# Load model + data
# =======================
@st.cache_resource
def load_model(model_path: str):
    return load(model_path)

@st.cache_data
def load_data():
    df = pd.read_excel(DATA_PATH, sheet_name=SHEET_NAME)

    for col in ["final_comment", "label"]:
        if col not in df.columns:
            raise ValueError(f"Thiếu cột '{col}' trong {DATA_PATH}")

    if "comment" not in df.columns:
        df["comment"] = df["final_comment"]

    df["final_comment"] = df["final_comment"].fillna("").astype(str)
    df["comment"] = df["comment"].fillna("").astype(str)
    df["label"] = df["label"].astype(str)
    return df

def preprocess_input(text: str) -> str:
    return (text or "").strip()


if not os.path.exists(DATA_PATH):
    st.error(f"Không thấy file dữ liệu: {DATA_PATH}")
    st.stop()

df = load_data()


st.subheader("Chọn thuật toán")
model_name = st.selectbox("Thuật toán:", list(MODELS.keys()), index=0)
MODEL_PATH = MODELS[model_name]

if not os.path.exists(MODEL_PATH):
    st.error(f"Không thấy file model cho '{model_name}': {MODEL_PATH}")
    st.stop()

model = load_model(MODEL_PATH)

st.divider()


st.subheader("Dự đoán (nhập bình luận)")
user_text = st.text_area(
    "Nhập nội dung bình luận:",
    placeholder="Ví dụ: Sản phẩm tốt, giao hàng nhanh, sẽ ủng hộ lần sau!",
    height=120
)

col1, col2 = st.columns([1, 3])
with col1:
    do_predict = st.button("Dự đoán", type="primary")
with col2:
    st.caption(f"Đang dùng mô hình: **{model_name}**")

if do_predict:
    text = preprocess_input(user_text)
    if not text:
        st.warning("Bạn chưa nhập bình luận.")
    else:
      
        cleaned = clean_text(text)
        final = tokenize_stopwords(cleaned)
        
        if not final.strip():
            st.warning("Bình luận không hợp lệ sau xử lý (chỉ chứa ký tự đặc biệt, không có từ khóa).")
        else:
            pred = model.predict([final])[0]
            
            if pred == "POS":
                sentiment = "POS (Tích cực)"
            elif pred == "NEU":
                sentiment = "NEU (Trung lập)"
            elif pred == "NEG":
                sentiment = "NEG (Tiêu cực)"
            st.success(f"Kết quả dự đoán ({model_name}): **{sentiment}**")

            # Nếu model có predict_proba thì hiển thị xác suất
            # if hasattr(model, "predict_proba"):
            #     proba = model.predict_proba([text])[0]
            #     classes = getattr(model, "classes_", list(range(len(proba))))
            #     proba_df = (
            #         pd.DataFrame({"class": classes, "probability": proba})
            #         .sort_values("probability", ascending=False)
            #         .reset_index(drop=True)
            #     )
            #     st.write("Xác suất theo từng lớp:")
            #     st.dataframe(proba_df, use_container_width=True)

            # st.caption(f"Nội dung dùng để dự đoán: {text}")

st.divider()

# =======================
# Đánh giá trên tập test
# =======================
st.subheader("Đánh giá mô hình trên tập test")

X = df["final_comment"]
y = df["label"]

# Lưu ý: stratify=y để giữ tỉ lệ lớp
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

y_pred = model.predict(X_test)
acc = accuracy_score(y_test, y_pred)

st.write(f"Accuracy ({model_name}): **{acc:.4f}**")

st.subheader("Bảng dự đoán")
test_results = pd.DataFrame({
    "comment": df.loc[X_test.index, "comment"].astype(str),
    "final_comment": X_test.astype(str),
    "true": y_test.values,
    "predict": y_pred
})

st.dataframe(test_results, use_container_width=True)
