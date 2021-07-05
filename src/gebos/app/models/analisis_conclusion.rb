# encoding: utf-8
class AnalisisConclusion < ActiveRecord::Base
  
  self.table_name = 'analisis_conclusion'

  has_many :encuestavisita
  
  attr_accessible :id,
                  :numero,
                  :nombre,
                  :activo


  validates_presence_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_presence_of :numero,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  validates_uniqueness_of :numero,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
   validates_length_of :nombre, :within => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} es demasiado corto (mínimo %{count})",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  es demasiado largo (máximo %{count})"
  
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end

end

# == Schema Information
#
# Table name: analisis_conclusion
#
#  id     :integer         not null, primary key
#  numero :integer         not null
#  nombre :string(200)     not null
#  activo :boolean         default(TRUE), not null
#

