# encoding: utf-8

#
# 
# clase: ScoringAceptacion
# descripción: Migración a Rails 3
#

class ScoringAceptacion < ActiveRecord::Base

  self.table_name = 'scoring_aceptacion'

  attr_accessible :id,:scoring,:banda_inferior,:banda_superior

   validates_presence_of :banda_inferior,
    :message => "^ % Banda Inferior es requerido" 
    validates_presence_of :banda_superior,
    :message => "^ % Banda Superior es requerido"
    validates_presence_of :scoring,
    :message => "^ Clasificación Scoring es requerido"

     validates_numericality_of :banda_inferior,
    :message => "^ % Banda Inferior el número es inválido"
     validates_numericality_of :banda_superior,
    :message => "^ % Banda Superior el número es inválido"

 def validate
  if (!self.banda_inferior.nil?)
       if self.banda_inferior < 1
          errors.add(nil, "% Banda Inferior debe ser mayor que cero")
        end
        if self.banda_inferior > 100
          errors.add(nil,"% Banda Inferior debe ser menor o igual a 100")
        end
    unless self.scoring.nil? || self.scoring.empty?
      a = self.scoring[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(nil, "Clasificación Scoring es inválido")
      end
    end
  end


  if (!self.banda_superior.nil?)
       if self.banda_superior < 1
          errors.add(nil, "% Banda Superior debe ser mayor que cero")
        end
        if self.banda_superior > 100
          errors.add(nil,"% Banda Superior debe ser menor o igual a 100")
        end
  end
  if !self.banda_superior.nil? and !self.banda_inferior.nil?
   if self.banda_superior < self.banda_inferior
     errors.add(nil,"% Banda Superior debe ser mayor a % Banda Inferior")
   end
  end


 end

  def banda_inferior_fm    
    unless self.banda_inferior.nil?
      format_fm(self.banda_inferior)
    end
  end

  def banda_superior_fm
    unless self.banda_superior.nil?
      format_fm(self.banda_superior)
    end
  end



end

# == Schema Information
#
# Table name: scoring_aceptacion
#
#  id             :integer         not null, primary key
#  scoring        :string(4)
#  banda_inferior :decimal(16, 2)
#  banda_superior :decimal(16, 2)
#

