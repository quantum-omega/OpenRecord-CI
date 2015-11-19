require_relative 'spec-helper'
require 'open_record'

describe OpenRecord do
  describe "Definition d'associations" do
    class Adresse
      def initialize(x = nil); @x = x; end
    end

    class Telephone
      def initialize(x = nil); @x = x; end
    end

    let(:adr1) { Adresse.new( "a1" ) }
    let(:tel1) { Telephone.new( "t1" ) }
    let(:tel2) { Telephone.new( "t2" ) }

    describe "#a_un" do
      let(:p1) { OpenRecord.new( nom: "Tremblay" ) { a_une Adresse } }

      it "ajoute les methodes (reader et writer)" do
        assert p1.respond_to?(:adresse)
        assert p1.respond_to?(:adresse=)
      end

      it "definit l'attribut avec une valeur nil par defaut" do
        p1.adresse.must_equal nil
      end

      it "definit correctement le reader et le writer" do
        p1.adresse = adr1
        p1.adresse.must_equal adr1
      end

      it "peut etre appele apres la creation de l'objet" do
        p1.a_un Telephone
        assert p1.respond_to?(:telephone)
        assert p1.respond_to?(:telephone=)
        p1.telephone = tel1
        p1.telephone.must_equal tel1
      end
    end

    describe "#a_plusieurs" do
      let(:p1) { OpenRecord.new( nom: "Tremblay" ) { a_plusieurs Telephone } }

      it "ajoute les methodes (reader et writer) avec un nom au pluriel" do
        assert p1.respond_to?(:telephones)
        assert p1.respond_to?(:telephones=)
      end

      it "definit l'attribut avec une valeur [] par defaut" do
        p1.telephones.must_equal []
      end

      it "definit correctement le reader et le writer" do
        p1.telephones << tel1 << tel2
        p1.telephones.must_equal [tel1, tel2]
        p1.telephones[0].must_equal tel1
        p1.telephones[1].must_equal tel2
      end

      it "peut etre appele apres la creation de l'objet... avec n'importe quelle classe" do
        p1.a_un Fixnum
        assert p1.respond_to?(:fixnum)
        assert p1.respond_to?(:fixnum=)
        p1.fixnum = 12
        p1.fixnum.must_equal 12
      end
    end

    it "permet de definir des attributs et des associations dans l'appel du constructeur" do
      o1, o2, o3 = Object.new, Object.new, Object.new
      personne = OpenRecord.new( nom: "Tremblay", prenom: "Guy" ) do
        a_un Fixnum, 10
        a_un Object, o1
        a_plusieurs Object, o2, o3
      end

      personne.nom.must_equal "Tremblay"
      personne.prenom.must_equal "Guy"
      personne.fixnum.must_equal 10
      personne.object.must_equal o1
      personne.objects.must_equal [o2, o3]
    end
  end

end
