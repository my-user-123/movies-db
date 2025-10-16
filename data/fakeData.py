import pandas as pd
import random
from faker import Faker
import numpy as np

fake = Faker()
random.seed(42)
np.random.seed(42)

# Constants for larger dataset
NUM_LANGUAGES = 10
NUM_GENRES = 12
NUM_COMPANIES = 50
NUM_USERS = 1000
NUM_MOVIES = 2000
NUM_RATINGS = 10000

# 1. languages.csv
language_names = list(set([fake.language_name() for _ in range(NUM_LANGUAGES)]))
languages = pd.DataFrame({
    "language_id": range(1, NUM_LANGUAGES + 1),
    "language_name": language_names
})

# 2. genres.csv
genre_names = list(set([fake.word().capitalize() for _ in range(NUM_GENRES)]))
genres = pd.DataFrame({
    "genre_id": range(1, NUM_GENRES + 1),
    "genre_name": genre_names
})

# 3. production_companies.csv
production_companies = pd.DataFrame({
    "company_id": range(1, NUM_COMPANIES + 1),
    "company_name": [fake.company() for _ in range(NUM_COMPANIES)],
    "country": [fake.country() for _ in range(NUM_COMPANIES)]
})

# 4. users.csv
users = pd.DataFrame({
    "user_id": range(1, NUM_USERS + 1),
    "username": [fake.user_name() for _ in range(NUM_USERS)],
    "signup_date": [fake.date_between(start_date="-5y", end_date="today") for _ in range(NUM_USERS)],
    "country": [fake.country() for _ in range(NUM_USERS)]
})

# 5. movies.csv
movies = pd.DataFrame({
    "movie_id": range(1, NUM_MOVIES + 1),
    "title": [fake.sentence(nb_words=3).replace(".", "") for _ in range(NUM_MOVIES)],
    "release_year": [random.randint(1990, 2023) for _ in range(NUM_MOVIES)],
    "duration_minutes": [random.randint(80, 180) for _ in range(NUM_MOVIES)],
    "language_id": [random.choice(languages['language_id']) for _ in range(NUM_MOVIES)],
    "budget": [random.randint(1_000_000, 200_000_000) for _ in range(NUM_MOVIES)],
    "revenue": [random.randint(5_000_000, 1_500_000_000) for _ in range(NUM_MOVIES)],
})

# 6. movie_genres.csv (many-to-many)
movie_genres = pd.DataFrame([
    {"movie_id": movie_id, "genre_id": genre_id}
    for movie_id in movies["movie_id"]
    for genre_id in random.sample(genres["genre_id"].tolist(), random.randint(1, 3))
])

# 7. movie_companies.csv (many-to-many)
movie_companies = pd.DataFrame([
    {"movie_id": movie_id, "company_id": company_id}
    for movie_id in movies["movie_id"]
    for company_id in random.sample(production_companies["company_id"].tolist(), random.randint(1, 3))
])

# 8. ratings.csv
ratings = pd.DataFrame({
    "rating_id": range(1, NUM_RATINGS + 1),
    "movie_id": [random.choice(movies["movie_id"]) for _ in range(NUM_RATINGS)],
    "user_id": [random.choice(users["user_id"]) for _ in range(NUM_RATINGS)],
    "rating_value": [round(random.normalvariate(6.8, 1.5), 1) for _ in range(NUM_RATINGS)],
    "rating_date": [fake.date_between(start_date="-3y", end_date="today") for _ in range(NUM_RATINGS)],
})
ratings["rating_value"] = ratings["rating_value"].clip(1, 10)

# Save all CSVs
languages.to_csv("languages.csv", index=False)
genres.to_csv("genres.csv", index=False)
production_companies.to_csv("production_companies.csv", index=False)
users.to_csv("users.csv", index=False)
movies.to_csv("movies.csv", index=False)
movie_genres.to_csv("movie_genres.csv", index=False)
movie_companies.to_csv("movie_companies.csv", index=False)
ratings.to_csv("ratings.csv", index=False)

print("✅ All CSV files generated!")

