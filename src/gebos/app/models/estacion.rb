# encoding: utf-8
class Estacion < ActiveRecord::Base
  
  self.table_name = 'estacion'

  attr_accessible :id, 
    :nombre,
    :ip_address,
    :mac_address,
    :oficina_departamento_id,
    :tipo_estacion_id,
    :activo

  belongs_to :oficina_departamento
  has_and_belongs_to_many :roles, :class_name=>'Rol', :join_table=>'rol_estacion'

  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..50, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}

  validates :oficina_departamento, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Estacion.Errores.oficina_departamento')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ip_address, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Estacion.Errores.ip_address')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 7..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Estacion.Errores.ip_address')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Estacion.Errores.ip_address')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message =>"#{I18n.t('Sistema.Body.Modelos.Estacion.Errores.ip_address')} #{I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}"}
 
  

  def oficina_id
    oficina_departamento.oficina_id unless oficina_departamento.nil?
  end
  
  def oficina_id=(oficina_id)
  end

end

# == Schema Information
#
# Table name: estacion
#
#  id                      :integer         not null, primary key
#  nombre                  :string(50)      not null
#  ip_address              :string(20)
#  mac_address             :string(20)
#  oficina_departamento_id :integer         not null
#  tipo_estacion_id        :integer
#  activo                  :boolean         default(TRUE)
#

