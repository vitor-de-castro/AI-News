# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'rest-client'
require 'json'
require 'open-uri'

categories = ["sport", "technology", "environment", "science", "culture", "business"]
NEWS_API_KEY = "8cc17b89-5eaa-4c0a-a464-0b8751ef4681"

ENVI = ["enviro1.jpg", "enviro2.jpg", "enviro3.jpg", "enviro4.jpg"]
SPORT = ["bg.jpg", "mainsport.jpg", "sport.jpg", "Sport2.jpg"]
LEISURE = ["leisure1.jpg", "leisure2.jpg", "leisure3.jpg", "leisure4.jpg"]
SCIENCE = ["science1.jpg", "science2.png", "science3.jpg", "science4.jpg"]
TECH = ["Tech1.jpg", "tech2.jpg", "tech3.jpg", "tech4.jpg"]
FINANCE = ["finance1.jpg", "finance2.jpg", "finance3.jpg", "finance4.jpg"]


#Fonction pour changer l'url en fonction de la catégorie souhaitée
# Répéter la clé pour le contexte

def url_change(category, page_number)
  url = "https://content.guardianapis.com/#{category.downcase}?api-key=#{NEWS_API_KEY}&show-fields=all&lang=en&page-size=5&page=#{page_number}"
  return url
end

Article.destroy_all
puts "Nettoyage de la base de données"

#Fonction pour recup les articles
  categories.each do |category|
    begin
    (1..10).each do |page|
      get_articles = URI.parse(url_change(category, page)).read
      data = JSON.parse(get_articles)

      articles = data["response"]["results"]
      articles.each do |art|
        image = ""

        if category == "sport"
          image = SPORT.sample
        elsif category == "technology"
          image = TECH.sample
        elsif category == "environment"
          image = ENVI.sample
        elsif category == "science"
          image = SCIENCE.sample
        elsif category == "culture"
          image = LEISURE.sample
        elsif category == "business"
          image = FINANCE.sample
        end
        puts image
        new_article = Article.new(

          title: art["webTitle"],
          content: art["fields"]["bodyText"] || art["fields"]["body"],
          author: art["fields"]["byline"] || "Auteur inconnu",
          date: art["webPublicationDate"],
          category: category,
          image_url: image

        )
        new_article.save!
      end
      puts "Import terminé ! #{Article.count} articles créés"
      rescue => e
        # Le script affiche l'erreur mais continue l'itération !
        puts "   ERREUR lors du traitement de la catégorie #{category} : #{e.message}"
        next # Passe à la catégorie suivante
      end
    end
  end


#Fonction pour faire appel à l'api et parser

#Fonction pour sauvegarder l'article sur la db
