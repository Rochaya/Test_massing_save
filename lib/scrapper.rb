require 'nokogiri'
require 'open-uri'
require 'json'

class ScrapperMails

    def initialize
        @ville_email_array = []
    end

    def get_ville
        region_page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
        ville_name_array = region_page.xpath("//a[contains(@class, 'lientxt')]/text()").map {|x| x.to_s.downcase.gsub(" ", "-") }
        return ville_name_array
    end

    def get_email (ville_names)
        for i in 0...ville_names.length
            ville_page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/95/#{ville_names[i]}.html"))
            @ville_email_array << ville_page.xpath("//html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]/text()").to_s
        end
        return @ville_email_array
    end

    def save_as_JSON(email_ville_result)
        File.open("../db/emails.json", "w") do |f|
            f.write(JSON.pretty_generate(email_ville_result))
        end
    end

    def perform
        ville_names = get_ville
        get_email(ville_names)
        email_ville_result = Hash[ville_names.zip(@ville_email_array)]
        save_as_JSON(email_ville_result)
    end
end

ScrapperMails.new.perform