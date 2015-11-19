require_relative 'dbc'

class OpenRecord
  #
  # Cree un objet avec les attributs indiques et, si un bloc est
  # specifie, avec les associations indiquees.
  #
  def initialize( attributs = Hash.new, &block )
    attributs.keys.each do |nom_attribut|
      definir_reader_et_writer( nom_attribut )
      set_attribut nom_attribut, attributs[nom_attribut]
    end
    @validations = Hash.new
    instance_eval( &block ) if block_given?
    self
  end

  def get_attribut( nom_attribut )
    DBC.require nom_attribut.class == Symbol &&
      nom_attribut.to_s != /=$/

    instance_variable_get "@#{nom_attribut}"
  end

  def set_attribut( nom_attribut, valeur )
    DBC.require nom_attribut.class == Symbol &&
      nom_attribut.to_s != /=$/

    instance_variable_set "@#{nom_attribut}", valeur
  end
  private :get_attribut, :set_attribut

  #
  # Definit le setter/getter lors d'une premiere affectation.
  #
  def method_missing( id, *args )
    DBC.require id.class == Symbol

    id_string = "#{id}"
    if id_string =~ /=$/
      # C'est un appel de la forme "os.champ = ..."
      id = id_string.chop.to_sym
      definir_reader_et_writer( id )
      set_attribut id, args[0]
    else
      raise NoMethodError, "Methode non-definie `#{id}' pour #{self}", caller(1)
    end
  end

  #
  # Ajoute les deux methodes (getter et setter) pour un attribut ou
  # une association.
  #
  def definir_reader_et_writer( id )
    DBC.require( id.class == Symbol && id.to_s !~ /=$/,
                 "*** Un attribut ou association doit etre defini via un symbole simple: id = #{id}" )

    define_singleton_method id do
      get_attribut id
    end

    define_singleton_method "#{id}=" do |x|
      set_attribut id, x
    end
  end

  def definir_reader_et_writer_autre_facon( id )
    DBC.require( id.class == Symbol && id.to_s !~ /=$/,
                 "*** Un attribut ou association doit etre defini via un symbole simple: id = #{id}" )

    instance_eval "def #{id}
      @#{id}
    end"

    instance_eval "def #{id}=( x )
      @#{id} = x
    end"

  end

  private :definir_reader_et_writer


  #
  # Ajout d'une association unique.
  #
  def a_une( klass, arg = nil )
    DBC.require( klass.class == Class,
                 "*** L'argument a a_une doit etre une classe:
                      klass = #{klass} (.class = #{klass.class}) " )

    association = klass.to_s.downcase.to_sym

    definir_reader_et_writer( association )
    set_attribut association, arg

    # Validation: ne doit pas etre nil et doit etre de la bonne classe.
    @validations[association] = lambda do
      (a = get_attribut association) &&
      a.kind_of?( klass )
    end

    self
  end

  alias :a_un :a_une

  #
  # Ajout d'une association multiple.
  #
  def a_plusieurs( klass, *args )
    DBC.require( klass.class == Class,
                 "*** L'argument a a_plusieurs doit etre une classe:
                      klass = #{klass} (.class = #{klass.class}) " )

    association = (klass.to_s.downcase + "s").to_sym

    definir_reader_et_writer( association )
    set_attribut association, args

    # Validation: doit avoir un ou plusieurs elements et etre de la bonne classe.
    @validations[association] = lambda do
      (a = get_attribut association) &&
        a.size >= 1 &&
        a.all? { |x| x.kind_of? klass }
    end

    self
  end

  alias :a_un_ou_plusieurs :a_plusieurs

  #
  # Est-ce que toutes les associations sont definies correctement?
  #
  def valide?
    !association_invalide
  end

  #
  # Retourne le nom d'une association qui n'est pas definie
  # correctement, s'il en existe une, sinon nil.
  #
  # Utile pour le debogage, pour comprendre pourquoi un objet n'est
  # pas valide?.
  #
  def association_invalide
    @validations.keys.detect do |nom_association|
      !@validations[nom_association].call
    end
  end

end
