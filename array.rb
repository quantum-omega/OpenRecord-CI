class Array

  #
  # Selectionne les elements dont le champ id satisfait le critere
  # specifie par le bloc.
  #
  def selectionner_avec( id )
    DBC.check_type( id, Symbol,
                    "** L'argument a selectionner_avec doit etre un symbole" )

    self.select { |item| yield item.send id }
  end

  def method_missing( id, *args, &block )
    nom_methode = "#{id}"
    if nom_methode.start_with?('selectionner_avec')
    then
      avec_quoi = nom_methode[18..-1].to_sym
      return selectionner_avec avec_quoi block
    end
  end
end
