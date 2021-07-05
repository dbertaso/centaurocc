# encoding: UTF-8
class VocacionTierra < ActiveRecord::Base
      
  self.table_name = 'vocacion_tierra'
  
  attr_accessible :id,
				  :nombre,
				  :descripcion,
				  :activo
      
  validates_uniqueness_of :nombre, 
  :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')


  validates_presence_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
    
    
  validates_presence_of :descripcion,
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')

  def self.search(search, page, orden)    

    conditions=search
    
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end

end


# == Schema Information
#
# Table name: vocacion_tierra
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(FALSE)
#

