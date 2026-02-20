# 📱 TechPulse

<div align="center">
  <h3>A Smart, Personalized Technology News Application</h3>
  <p>Seamlessly delivering curated tech news with AI-powered summaries and translations.</p>
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
  ![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)
</div>

---

## About The Project
**TechPulse** is a modern, personalized news aggregator built with Flutter. Designed for tech enthusiasts, it moves beyond generic news feeds by allowing users to tailor their content based on specific technological interests. 

To break language barriers and save time, TechPulse integrates **Google Gemini AI** to instantly summarize complex articles and provide accurate Arabic translations.

---

## Key Features

### Core Functionality
- **Secure Authentication:** Robust user sign-up and login flows powered by Supabase Auth.

- **Personalized Onboarding:** Users can select specific tech domains to curate their personalized news feed.

- **Cloud Bookmarking:** Easily save and manage favorite articles using Supabase PostgreSQL tables.

- **Smooth Navigation:** Seamless transitions across 5+ dedicated screens (Auth, Interests, Home, Article Details, Bookmarks).

- **Robust Data Handling:** Efficient JSON parsing with structured Dart models and graceful error handling for all network requests.

### Advanced & Extra Features (Creativity)
- **AI-Powered Summarization:** Utilizes the `google_generative_ai` package (Gemini API) to condense lengthy articles into quick, digestible insights.

- **Instant Arabic Translation:** Automatically translates tech summaries into Arabic, making global news accessible to the Arab world.

- **Social Sharing:** Integrated with the `share_plus` package, allowing users to instantly share breaking news or AI summaries with their network.
- **Premium UI/UX:** Features a custom animated Aurora background, sleek floating navigation bars, and intuitive loading states.

---

## Project Architecture & Structure
The codebase is organized using a clean, scalable, and modular architecture to ensure maintainability and readability:

```text
lib/
├── models/      # Data models and JSON serialization (e.g., Article model)
├── screens/     # UI Views (AuthScreen, HomeScreen, ArticleDetailsScreen, etc.)
├── services/    # Business logic and external API calls (NewsService, Supabase logic)
├── theme/       # Application styling, and typography settings
├── utils/       # Colors, constants, and global utilities
├── widgets/     # Reusable UI components (BookmarkButton, Custom AppBars, etc.)
└── main.dart    # The starting point of the program
```

## Screenshoots & UI Desgin
---

## Onborading screens

<img width="2200" height="1500" alt="3" src="https://github.com/user-attachments/assets/5290bd2d-86aa-4d1a-ae4c-7b246fa0dd38" />

---
## Login & Signup & Interests selection screens

<img width="2200" height="1500" alt="Your paragraph text" src="https://github.com/user-attachments/assets/e8f5992c-576d-4b44-b94d-c9298f89146a" />

---
## HomePage & Saved Articles screens

<img width="2200" height="1500" alt="Your paragraph text (1)" src="https://github.com/user-attachments/assets/6f7824ed-ba6f-44a3-82b4-791f7107e5ae" />

---
## Details Screen

<img width="2200" height="1500" alt="6" src="https://github.com/user-attachments/assets/9ed0f34a-daa5-4001-a43d-2a1272edaa7a" />

---
## Scearch & Profile Screens
<img width="2200" height="1500" alt="7" src="https://github.com/user-attachments/assets/81c72f10-c450-4585-a88e-8ad93df064c5" />

---
## 🗄️ Database Schema

The app uses Supabase for a robust backend. Below is a snapshot of the database tables used for storing user data, interests, and bookmarked articles:

<img width="1462" height="682" alt="supabase-schema-ncqicizjtmewpbhkclcq (2)" src="https://github.com/user-attachments/assets/1d16649b-5f1b-4d3e-9cee-a4bb690ae651" />

---
## Getting Started

To run this project locally, follow these steps:
1. **Clone the repository:**
   ```bash
   git clone https://github.com/CS-Abdulaziz/tech-news-app.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
   
3. **Environment Setup (Crucial):**:
   
   Create an api_keys.env file in the root directory. Add your API keys to ensure the app functions correctly (this file is git-ignored for security):

   ```bash
   NEWS_API_KEY = your_news_api_key
   NEWS_API_BASE_url = https://newsapi.org/v2
    
   AI_API_KEY = your_gemini_api_key
    
   SUPABASE_API_KEY = your_supabase_anon_key
   SUPABASE_URL = your_supabase_url
   ```
   
4. **Run the App**:

   ```bash
   flutter run
   ```
---

## Developed By

• Abdulaziz Khamis, Computer Science Student & Aspiring AI Engineer & Flutter developer

• My Linkedin:
  https://www.linkedin.com/in/abdulaziz-al-nomani-229980365/


