#encoding: utf-8
class Mision < ActiveRecord::Base
  
  self.table_name = 'mision'
  
  attr_accessible :id,
    :nombre,
    :descripcion,
    :activo 

  has_many :solicitud
  
  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..60, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => " #{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"}


  def nombre_f=(nombre)
    self.nombre = nombre.upcase
  end
    
  def nombre_f
    self.nombre.upcase unless self.nombre.nil?
  end

  def before_save
    self.descripcion = self.descripcion.upcase unless self.descripcion.nil?
  end
    
end

# == Schema Information
#
# Table name: mision
#
#  id          :integer         not null, primary key
#  nombre      :string(60)      not null
#  descripcion :string(100)     not null
#  activo      :boolean         not null
#

