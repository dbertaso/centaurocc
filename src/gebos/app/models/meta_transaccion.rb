# encoding: utf-8
class MetaTransaccion < ActiveRecord::Base

  self.table_name = 'meta_transaccion'
  
  attr_accessible  :id,
    :nombre,
    :descripcion
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
end

# == Schema Information
#
# Table name: meta_transaccion
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(250)
#

