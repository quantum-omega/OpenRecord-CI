require_relative 'spec-helper'
require 'open_record'
require 'array'

describe Array do
  let(:p1) { OpenRecord.new( nom: "Tremblay", prenom: "Guy" ) }
  let(:p2) { OpenRecord.new( nom: "David", prenom: "Anne-Marie" ) }
  let(:p3) { OpenRecord.new( nom: "Durocher", prenom: "Nellie" ) }

  describe "#selectionner_avec" do
    it "retourne [] si aucun element ne satisfait le critere" do
      [p1, p2, p3].
        selectionner_avec(:nom) { |x| x == "Hudon" }.
        must_equal []
    end

    it "selectionne selon le champ X lorsque X est un argument explicite" do
      [p1, p2, p3].
        selectionner_avec(:nom) { |x| x =~ /^D/ }.
        must_equal [p2, p3]
    end
  end

  describe "#selectionner_avec_XXX" do
    it "selectionne selon le champ X lorsqu'implicite via nom de methode" do
      [p1, p2, p3].
        selectionner_avec_nom { |x| x =~ /^D/ }.
        must_equal [p2, p3]
    end

    it "souleve une exception si le champ de selection n'est pas defini" do
      lambda { [p1].selectionner_avec_date { |x| x } }.
        must_raise NoMethodError
    end
  end
end
