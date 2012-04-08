

module TranslationManager
#  def self.included(base)
#    base.extend ClassMethods
#  end
  class Config
      PREFERENCES={
        :locales          => [:es,:en,:it],
        :master_locale    => :es,
        :translate_alert  => " <<TRADUCIR>>"
        }    
  end
  class OrderedHash < ActiveSupport::OrderedHash
    def self.load_from_yml_file(file)
      orderdes_hash= self.new
      lines=[]
      File.open(file, 'r') do |f1|
        while line = f1.gets
          lines << line
        end
      end
#      puts lines
      orderdes_hash.parse_yml_array(lines)[:hash]
    end
    def save_to_yml_file(file)
      File.open(file, 'w') do |f1|
        f1.write self.unparse_yml_array(2)
      end
    end

    # crea una copia del OrderedHash master respetando los Valores de las Keys que existan en el OrderedHash
    def complete_with(master, params={})
      params[:locales]         ||= Config::PREFERENCES[:locales]
      params[:master_locale]   ||= Config::PREFERENCES[:master_locale]
      params[:translate_alert] ||= Config::PREFERENCES[:translate_alert]
      params[:internal_call]   ||=false

      copy = OrderedHash.new
      master.each do |key,value|
        if self.has_key? key or ( !params[:internal_call] and params[:master_locale]==key )
          if value.class == OrderedHash
            if self.has_key? key
              copy.merge! key=>self[key].complete_with(value, :internal_call=>true)
            else
              self_key= self.keys.select{|k| params[:locales].include? k}[0]
              copy.merge! self_key => self[self_key].complete_with(value, :internal_call=>true)
            end
          else
            copy.merge!key=>self[key]
          end
        else
          if value.class == OrderedHash
            copy.merge! key=>OrderedHash.new.complete_with(value, :internal_call=>true)
          else
            copy.merge! key=>"#{value}#{params[:translate_alert]}"
          end
        end


#        if key.class==Symbol
#          if value.class == OrderedHash
#
#            unless value==other[key]
#              value.complete_with(other[key])
#            end
#          else
#
#          end
#        end
      end
      copy
    end

    def unparse_yml_array(spaces_per_tab=1, tabs=nil)
      array     ||= []
      position  ||=0
      tabs      ||= 0
      self.each do |key,value|
        if key.class==Symbol
#          puts value.class
#          puts key
          if value.class == OrderedHash
            array << "#{' '* tabs * spaces_per_tab}#{key}:\n"
            array += value.unparse_yml_array(spaces_per_tab,tabs+1)
          else
            array << %(#{' '* tabs * spaces_per_tab}#{key}: "#{value}"\n)
          end
        elsif key=='blank_line'
          array << "\n"
#          puts 'blank_line'
        elsif key.match /^comemnt_line_(\d*)\z/
          array << value
#          puts "coment #{$1} #{value}"
        else

        end

      end
      array
    end
    def parse_yml_array(array,position=nil,tabs=nil)
      position  ||=-1
      tabs      ||= 0
#      puts "position=#{position}    tabs=#{tabs}"
#      puts array.class, array[1..20]
#      puts array[11],array[11][0],array[11][0].to_int
      c= position
      while c<array.size do
        c+=1
#        puts array[c]
        if array[c].blank?
          self.merge! 'blank_line'=>""
#          puts "linea en blanco"
          next
        end
        if array[c].match /#.*/
          self.merge! "comemnt_line_#{c}"=>array[c]
#          puts "linea #{c} coment"
          next
        end
        if array[c].match /^(\t|\s*)(\w+):\s*"(.*)"\s*\z/
#          puts "*",array[c],$1,$2,$3
          if $1 and $1.size< tabs
            return :line=>c,:hash=>self
          else
            self.merge! $2.to_sym=>$3
#            puts "linea #{c}  #{$2.to_sym} =>#{$3}"
  #          puts "key"
            next
          end
        end
        if array[c].match /^(\t|\s*)(\w+):\s*\z/
          if $1 and $1.size< tabs
#    ##        self.merge! "B#{$1.size}  c=#{c}"=>tabs
            return :line=>c,:hash=>self
          else
#            puts "linea #{c} #{$2.to_sym}    entra"
            answer = OrderedHash.new.parse_yml_array(array,c,$1.size+1)
            self.merge! $2.to_sym =>answer[:hash]
            c = answer[:line]-1 if answer[:line]
#            puts "linea #{c} #{$2.to_sym}    sale   #{hash.size} #{Array(hash).flatten.size}"
            next
          end
        end

#        puts "no mactch"
      end
      return :line=>c,:hash=>self
    end

  end
#  hash = TranslationManager::OrderedHash.load_from_yml_file(RAILS_ROOT+ "/config/locales/es_test.yml")
#  hash.save_to_yml_file(RAILS_ROOT+ "/config/locales/copia_es_test.yml")

end



#class ActiveRecord::Base
#  include TranslationManager
#end















