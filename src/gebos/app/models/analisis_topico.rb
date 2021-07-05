# encoding: utf-8
class AnalisisTopico < ActiveRecord::Base

  self.table_name = 'analisis_topico'

  attr_accessible  :id,
				   :nombre,
				   :descripcion,
				   :activo
  
  

  validates_presence_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_presence_of :descripcion,
    :message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')

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
# Table name: analisis_topico
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(FALSE), not null
#

