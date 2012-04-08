require 'translation_manager'

desc 'Actualiza'
task :update_translations do
  locales={}
  master_locale= TranslationManager::Config::PREFERENCES[:master_locale]
  TranslationManager::Config::PREFERENCES[:locales].each do |locale|
    locales.merge! locale => TranslationManager::OrderedHash.load_from_yml_file(RAILS_ROOT+ "/config/locales/#{locale}.yml")
  end
  locales.each do |locale, yml|
    yml.save_to_yml_file(RAILS_ROOT+ "/config/locales/#{locale}.yml.old")
  end
  locales.select{|l| l!= master_locale}.each do |locale, yml|
    yml = yml.complete_with(locales[master_locale])
    yml.save_to_yml_file(RAILS_ROOT+ "/config/locales/#{locale}.yml")
  end
#  es = TranslationManager::OrderedHash.load_from_yml_file(RAILS_ROOT+ "/config/locales/es.yml")
#  en = TranslationManager::OrderedHash.load_from_yml_file(RAILS_ROOT+ "/config/locales/en.yml")
#  it = TranslationManager::OrderedHash.load_from_yml_file(RAILS_ROOT+ "/config/locales/it.yml")
#
#  en_copy =  en.complete_with(es)
#  en_copy.save_to_yml_file(RAILS_ROOT+ "/config/locales/copia_en.yml")
#  it_copy =  it.complete_with(es)
#  it_copy.save_to_yml_file(RAILS_ROOT+ "/config/locales/copia_it.yml")

end

desc 'Di Hola'
task :hola do
  puts  "Hola", "\n"*5,"Hola"
end