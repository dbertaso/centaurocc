# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoEspecieAcuicultura
# descripción: Migración a Rails 3
#

class TipoEspecieAcuicultura < ActiveRecord::Base
  
  self.table_name = 'tipo_especie_acuicultura'
  
  attr_accessible :id,
				  :nombre,
				  :descripcion,
				  :activo
  
  has_many :unidad_produccion_condicion_acuicultura

  validates_presence_of :nombre, 
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
    
  validates_presence_of :descripcion, 
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')
  
  
  validates_length_of :nombre, :within => 1..40, :allow_nil => false,
    :too_short => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_short.other'),
  :too_long => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_long.other')
      
  validates_length_of :descripcion, :within => 1..300, :allow_nil => false,
    :too_short => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('errors.messages.too_short.other'),
  :too_long => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('errors.messages.too_long.other')
      
  validates_uniqueness_of :nombre, 
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')

  def self.search(search, page, orden)    

    conditions=search
    
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end


# == Schema Information
#
# Table name: tipo_especie_acuicultura
#
#  id          :integer         not null, primary key
#  nombre      :text            not null
#  descripcion :text            not null
#  activo      :boolean         default(TRUE), not null
#

