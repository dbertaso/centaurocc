# encoding: utf-8

class Marca < ActiveRecord::Base

  self.table_name = 'marca'
  
  attr_accessible  :id,
    :nombre,
    :descripcion,
    :activo
  

  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.MarcaMotor.Etiquetas.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}


  validates :descripcion, :presence => {
    :message =>"#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
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
# Table name: marca
#
#  id          :integer         not null, primary key
#  nombre      :string(100)     not null
#  descripcion :string(250)     not null
#  activo      :boolean         default(TRUE), not null
#

