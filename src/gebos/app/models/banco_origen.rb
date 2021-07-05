# encoding: utf-8
class BancoOrigen < ActiveRecord::Base
  
  self.table_name = 'banco_origen'
  attr_accessible  :id,
				   :nombre
  
  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')

  validates_presence_of :nombre,
      :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validate :validate 
  
  
  def self.nombre(id)
    banco_origen = BancoOrigen.find(id)
    return banco_origen.nombre
  end
  
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚ ]+$/]
      if a.nil?
        errors.add(:banco_origen, I18n.t('Sistema.Body.Modelos.Actividad.Errores.nombre_invalido'))
      end
    end
  end

end

# == Schema Information
#
# Table name: banco_origen
#
#  id     :integer         not null, primary key
#  nombre :string(40)
#

