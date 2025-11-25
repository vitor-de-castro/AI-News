# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'rest-client'
require 'json'
require 'open-uri'

categories = ["sport", "technology", "environment", "science", "culture", "business"]


#Fonction pour changer l'url en fonction de la catégorie souhaitée
# Répéter la clé pour le contexte

def url_change(category)
  # Ceci fonctionne pour 'sport', 'technology', 'culture', 'environment', etc.
  url = "https://content.guardianapis.com/#{category.downcase}?api-key=#{NEWS_API_KEY}&show-fields=all&lang=en&page-size=1"
  return url
end

Article.destroy_all
puts "Nettoyage de la base de données"

#Fonction pour recup les articles
  categories.each do |category|
    begin
    10.times do
      get_articles = URI.parse(url_change(category)).read
      data = JSON.parse(get_articles)

      articles = data["response"]["results"]
      articles.each do |art|
        new_article = Article.new(
          title: art["webTitle"],
          content: art["fields"]["bodyText"] || art["fields"]["body"],
          author: art["fields"]["byline"] || "Auteur inconnu",
          date: art["webPublicationDate"]
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
