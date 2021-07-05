# encoding: utf-8
#
# autor: Luis Rojas
# clase: EmpresaIntegrantePersona
# descripción: Migración a Rails 3
#
class InstanciaEmpresa < ActiveRecord::Base
  
  self.table_name = 'instancia_empresa'
  
  attr_accessible :id, :descripcion, :activo
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..50, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}

end

# == Schema Information
#
# Table name: instancia_empresa
#
#  id          :integer         not null, primary key
#  descripcion :string(50)      not null
#  activo      :boolean         not null
#

