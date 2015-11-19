require_relative 'spec-helper'
require 'open_record'

describe OpenRecord do
  class Adresse
    def initialize(x = nil); @x = x; end
  end

  class Telephone
    def initialize(x = nil); @x = x; end
  end

  let(:adr1) { Adresse.new( "a1" ) }
  let(:tel1) { Telephone.new( "t1" ) }
  let(:tel2) { Telephone.new( "t2" ) }

  let(:p1) {
    OpenRecord.new( nom: "Tremblay" ) {
      a_une Adresse
      a_plusieurs Telephone
    }
  }

  describe "#valide?" do
    it "retourne true quand tout est defini a la creation" do
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
      assert personne.valide?
    end

    it "retourne true si tout valide" do
      p1.adresse = adr1
      p1.telephones = [tel1, tel2]
      assert p1.valide?
    end

    it "retourne false si un champ unique est nil" do
      p1.adresse = adr1
      p1.adresse = nil
      p1.telephones = [tel1, tel2]
      refute p1.valide?
    end

    it "retourne false si un champ unique n'est pas de la bonne classe" do
      p1.adresse = tel1
      p1.telephones = [tel1, tel2]
      refute p1.valide?
    end

    it "retourne false si un champ multiple est []" do
      p1.adresse = adr1
      refute p1.valide?
    end
  end

  describe "#association_invalide" do
    let(:p1) {
      OpenRecord.new( nom: "Tremblay" ) {
        a_une Adresse
        a_plusieurs Telephone
      }
    }

    it "retourne nil si tout est bien valide" do
      p1.adresse = adr1
      p1.telephones = [tel1, tel2]
      p1.association_invalide.must_equal nil
    end

    it "retourne l'association unique lorsqu'invalide" do
      p1.adresse = adr1
      p1.adresse = nil
      p1.telephones = [tel1, tel2]
      p1.association_invalide.must_equal :adresse
    end

    it "retourne l'association multiple lorsqu'invalide" do
      p1.adresse = adr1
      p1.association_invalide.must_equal :telephones
    end
  end

end
