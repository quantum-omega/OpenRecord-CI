require_relative 'spec-helper'
require 'open_record'

describe OpenRecord do
  describe "Definition d'attributs" do
    it "ne definit aucun attribut par defaut" do
      personne = OpenRecord.new

      lambda { personne.nom }.must_raise NoMethodError
      refute personne.respond_to? :nom
      refute personne.respond_to?( :nom= )  # (): Pour indentation de ce qui suit
    end

    it "definit implicitement les methodes d'acces lors d'une affectation" do
      personne = OpenRecord.new

      personne.nom = "Tremblay"
      assert personne.respond_to? :nom
      assert personne.respond_to? :nom=
    end

    it "definit correctement les methodes pour lire/ecrire un attribut" do
      personne = OpenRecord.new

      personne.nom = "Tremblay"
      personne.prenom = "Guy"

      personne.nom.must_equal "Tremblay"
      personne.prenom.must_equal "Guy"
    end

    it "definit des methodes pour les attributs lorsque fournis au new" do
      personne = OpenRecord.new( nom: "Tremblay", prenom: "Guy" )
      assert personne.respond_to?(:nom)
      assert personne.respond_to?(:prenom)
    end

    it "definit les valeurs des attributs lorsque fournis au new" do
      personne = OpenRecord.new( nom: "Tremblay", prenom: "Guy" )

      personne.nom.must_equal "Tremblay"
      personne.prenom.must_equal "Guy"
    end

    it "permet de definir les attributs dans le constructeur ou meme dans le bloc" do
      personne = OpenRecord.new( nom: "Tremblay", prenom: "Guy" ) do
        self.age = 57
      end

      personne.nom.must_equal "Tremblay"
      personne.prenom.must_equal "Guy"
      personne.age.must_equal 57
    end
  end

end
