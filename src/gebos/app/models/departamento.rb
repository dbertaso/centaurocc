# encoding: utf-8
class Departamento < ActiveRecord::Base
  
  self.table_name = 'departamento'
  
  attr_accessible  :id,
    :nombre,
    :descripcion,
    :tipo 

  validates :nombre, :presence=> {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :descripcion, :presence=>{
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates_length_of :nombre, :within => 3..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  #{I18n.t('errors.messages.too_long.other')}"
  
  validates_length_of :descripcion, :within => 3..300, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"
  
  validates_uniqueness_of :nombre,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
  
  
 
end



# == Schema Information
#
# Table name: departamento
#
#  id                 :integer         not null, primary key
#  nombre             :string(50)      not null
#  descripcion        :string(300)     not null
#  tipo               :string(1)
#  empresa_sistema_id :integer
#

