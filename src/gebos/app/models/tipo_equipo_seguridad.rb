# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::TipoEquipoSeguridad
# descripción: Migración a Rails 3
#

class TipoEquipoSeguridad < ActiveRecord::Base

  self.table_name = 'tipo_equipo_seguridad'
  
  attr_accessible :id,
				  :tipo,
				  :descripcion,
				  :activo


  has_many :equipo_seguridad
  
   validates_presence_of :tipo,
    :message => I18n.t('Sistema.Body.Vistas.General.tipo') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
  
  validates_presence_of :descripcion,
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')

   validates_uniqueness_of :tipo,
    :message => I18n.t('Sistema.Body.Vistas.General.tipo') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')
    
    def self.search(search, page, orden)    

    conditions=search
    
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end

# == Schema Information
#
# Table name: tipo_equipo_seguridad
#
#  id          :integer         not null, primary key
#  tipo        :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#

