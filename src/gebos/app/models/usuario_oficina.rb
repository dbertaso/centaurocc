# encoding: utf-8

#
# autor: Diego Bertaso
# clase: UsuarioOfcina
# descripción: Migración a Rails 3
#
class UsuarioOficina < ActiveRecord::Base

  self.table_name = 'usuario_oficina'

  attr_accessible :usuario_id, :oficina_id, :predeterminada

  belongs_to :usuario
  belongs_to :oficina

  validates_presence_of :usuario, :oficina,
    :message => I18n.t('Sistema.Body.Modelos.Errores_es_requerido')
  validates_uniqueness_of :usuario_id, :scope=>'oficina_id',
    :message => I18n.t('Sistema.Body.Modelos.Errores_ya_existe')

end


# == Schema Information
#
# Table name: usuario_oficina
#
#  id             :integer         not null, primary key
#  usuario_id     :integer         not null
#  oficina_id     :integer         not null
#  predeterminada :boolean         default(FALSE)
#

