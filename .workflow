name: California Housing MLOps Pipeline

on:
  push:
    branches:
      - main
    paths:
      - 'preprocessing/automate_housing_california.py'
      - 'preprocessing/Eksperimen_California_Housing.py'
      - 'california_housing_data/california_housing.csv'
      - 'docker-compose.yml'
  workflow_dispatch:

jobs:
  pipeline:
    runs-on: ubuntu-latest

    steps:
    - name: 🔄 Checkout Repository
      uses: actions/checkout@v4

    - name: 🐍 Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.10'

    - name: 📦 Install Dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pandas scikit-learn joblib matplotlib mlflow prometheus-client

    - name: ⚙️ Jalankan Preprocessing
      run: |
        echo "🚀 Menjalankan preprocessing..."
        python preprocessing/automate_housing_california.py

    - name: 🧠 Jalankan Eksperimen ML
      run: |
        echo "🤖 Menjalankan eksperimen model..."
        python preprocessing/Eksperimen_California_Housing.py

    - name: 🐳 Build Docker Compose
      run: |
        echo "🔧 Build Docker Compose..."
        docker compose build

    - name: 🚀 Jalankan Docker Compose (MLflow + Prometheus)
      run: |
        echo "🏗️ Menjalankan seluruh stack monitoring..."
        docker compose up -d
        echo "Menunggu 15 detik agar service siap..."
        sleep 15
        docker ps -a

    - name: 💾 Commit Hasil Preprocessing
      run: |
        git config --global user.name 'GitHub Actions Bot'
        git config --global user.email 'github-actions-bot@github.com'
        # pastikan folder preprocessing sesuai di repo
        git add california_housing_data/processed/
        
        if git status --porcelain | grep -q "processed/"; then
          git commit -m "Auto: Update hasil preprocessing California Housing"
          git push https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }} HEAD:main
        else
          echo "✅ Tidak ada perubahan data preprocessing."
        fi
