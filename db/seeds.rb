# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'rest-client'
require 'json'
require 'open-uri'

categories = ["sports", "technology", "health", "science", "entertainment", "business"]


NEWS_API_KEY = "b878c6fd89b64f04b240f60f689bc52d"

#Fonction pour changer l'url en fonction de la catégorie souhaitée
def url_change(categories)
  if categories == "sports"
    url = "https://newsapi.org/v2/top-headlines?category=sports&language=en&apiKey=#{NEWS_API_KEY}"
  elsif categories == "technology"
    url = "https://newsapi.org/v2/top-headlines?category=technology&language=en&apiKey=#{NEWS_API_KEY}"
  elsif categories == "health"
    url = "https://newsapi.org/v2/top-headlines?category=health&language=en&apiKey=#{NEWS_API_KEY}"
  elsif categories == "science"
    url = "https://newsapi.org/v2/top-headlines?category=science&language=en&apiKey=#{NEWS_API_KEY}"
  elsif categories == "entertainment"
    url = "https://newsapi.org/v2/top-headlines?category=entertainment&language=en&apiKey=#{NEWS_API_KEY}"
  elsif categories == "business"
    url = "https://newsapi.org/v2/top-headlines?category=business&language=en&apiKey=#{NEWS_API_KEY}"
  end
end

Article.destroy_all
puts "Nettoyage de la base de données"

#Fonction pour recup les articles
  categories.each do |category|
    10.times do
      get_articles = URI.parse(url_change(category)).read
      article = JSON.parse(get_articles)

      articles = article["articles"]
      puts articles[0]
      new_article = Article.new(
        title: article["title"],
        content: article["description"],
        author: article["author"] || "Auteur inconnu",
        date: Faker::Date.between(from: 600.days.ago, to: Date.today),
        category: category
      )
      new_article.save
    end
  end

puts "Import terminé ! #{Article.count} articles créés"

#Fonction pour faire appel à l'api et parser

#Fonction pour sauvegarder l'article sur la db
