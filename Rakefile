# Differents defauts pour tests a executer, a varier/modifier selon ou
# vous en etes!

task :_default => [:tests_attributs, :tests_associations]
task :_default => [:tests_valide]
task :default => [:tests_array]

task :_default => [:tests]


desc "Tache pour l'ensemble des tests"
task :tests => [:tests_attributs,
                :tests_associations,
                :tests_array,
                :tests_valide,
                 ]

desc "Tache pour les tests des attributs"
task :tests_attributs do
  sh %{ruby open_record_attributs_spec.rb}
end

desc "Tache pour les tests des associations"
task :tests_associations do
  sh %{ruby open_record_associations_spec.rb}
end

desc "Tache pour les tests sur l'extension d'Array"
task :tests_array do
  sh %{ruby array_spec.rb}
end

desc "Tache pour les validations"
task :tests_valide do
  sh %{ruby valide_spec.rb}
end
