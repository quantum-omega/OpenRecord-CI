class Array

  #
  # Selectionne les elements dont le champ id satisfait le critere
  # specifie par le bloc.
  #
  def selectionner_avec( id )
    DBC.check_type( id, Symbol,
                    "** L'argument a selectionner_avec doit etre un symbole" )

    nil
  end

  def method_missing( id, *args, &block )
    nom_methode = "#{id}"


    raise NoMethodError, "Methode non-definie `#{id}' pour #{self}", caller(1)
  end
end
