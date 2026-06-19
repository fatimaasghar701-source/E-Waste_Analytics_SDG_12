# data_science_project

### SDG 12 E-Waste Analytics and Recycling Prediction System

This project is an end-to-end Data Science and Mobile Application Development solution designed to support United Nations Sustainable Development Goal (SDG) 12: Responsible Consumption and Production. The system focuses on analyzing global e-waste management trends and predicting recycling performance using Machine Learning techniques.

The project utilizes a comprehensive e-waste dataset containing environmental, economic, and waste management indicators such as GDP per capita, urbanization rate, landfill rate, formal collection rate, and recycling rate. A complete data science pipeline was implemented, including data cleaning, preprocessing, feature engineering, exploratory data analysis (EDA), outlier detection, encoding, and feature scaling. Various visualizations were created to uncover patterns, trends, and relationships among variables, providing valuable insights into factors affecting e-waste recycling efficiency.

For predictive analytics, multiple machine learning models were trained and evaluated using regression techniques. Model performance was assessed using standard evaluation metrics such as Mean Absolute Error (MAE), Mean Squared Error (MSE), Root Mean Squared Error (RMSE), and R² Score. The best-performing model was selected and exported for deployment.

To make the model accessible through a real-world application, a Flask-based REST API was developed. The API receives environmental and socio-economic indicators as input, processes them through the trained machine learning model, and returns the predicted recycling rate along with sustainability assessments and recommendations. The backend also includes error handling, validation mechanisms, and cross-origin support for seamless integration with external applications.

The system is designed to integrate with a Flutter-based mobile application, enabling users to explore e-waste statistics, visualize sustainability trends, and generate recycling predictions through an intuitive and interactive interface. By combining data science, machine learning, and mobile development, this project demonstrates how technology can be leveraged to support sustainable waste management practices and informed decision-making.

 Technologies Used

* Python
* Pandas
* NumPy
* Scikit-learn
* Flask
* Flask-CORS
* Joblib
* Matplotlib
* Jupyter Notebook
* Flutter
* Git & GitHub

This project serves as a practical example of applying machine learning and software engineering principles to address real-world environmental challenges while promoting responsible consumption and production practices under SDG 12.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
