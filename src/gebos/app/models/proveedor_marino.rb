# encoding: utf-8

#
# autor: Luis Rojas
# clase: RolComite
# descripción: Migración a Rails 3
#

class ProveedorMarino < ActiveRecord::Base
  
  self.table_name = 'proveedor_marino'
  
  attr_accessible :id, :nombre, :direccion, :rif, :propia, :asociado_fondas

  belongs_to :embarcacion
  belongs_to :motores
  belongs_to :arte_pesca

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}

  validates :direccion, :presence => {:message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, 
    :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates_length_of :nombre, :within => 3..150, :allow_blank => true
    
  validates_length_of :direccion, :within => 3..300, :allow_blank => true
  
  validate :validate
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end

  def validate
    if self.rif[/^[J,N,T,V,G][\-]\d{8}[\-]\d$/].nil?
      errors.add(:rif,I18n.t('Sistema.Body.Modelos.Errores.rif_formato_invalido'))
    else
      rif = self.rif.split('-')

      rif1 =  rif[0]
      rif2 =  rif[1]
      rif3 =  rif[2]


        if rif1 == 'V' || rif1 == "J" || rif1 == 'E' || rif1 == 'P' || rif1 == 'G'
          rif8 = ""
          if rif1 == 'V'
            rif8 = "1" << rif2
          end
          if rif1 == "E"
            rif8 = "2" << rif2
          end
          if rif1 == "J"
            rif8 = "3" << rif2
          end
          if rif1 == "P"
            rif8 = "4" << rif2
          end
          if rif1 == "G"
            rif8 = "5" << rif2
          end

          suma = (rif8[8,1].to_i * 2) + (rif8[7,1].to_i * 3) + (rif8[6,1].to_i * 4) + (rif8[5,1].to_i * 5) +
            (rif8[4,1].to_i * 6) + (rif8[3,1].to_i * 7) + (rif8[2,1].to_i * 2) + (rif8[1,1].to_i * 3)  +
            (rif8[0,1].to_i * 4)

          division = suma / 11
          resto = suma - (division.to_i * 11)
          digito = 0

          if resto > 0
            digito = 11 - resto
          else
            digito
          end
          if digito == 10
            digito = 0
          end
          if digito != rif3.to_i
            errors.add(:rif,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
          end
        else
          errors.add(:rif,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
        end
      end
    end

end



# == Schema Information
#
# Table name: proveedor_marino
#
#  id              :integer         not null, primary key
#  nombre          :text            not null
#  direccion       :text            not null
#  rif             :string(12)
#  propia          :boolean         not null
#  asociado_fondas :boolean         default(FALSE)
#

