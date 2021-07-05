# encoding: utf-8

class RecaudosAvaluosInspecciones < ActiveRecord::Base
  
  self.table_name = 'recaudos_avaluos_inspecciones'
  
  attr_accessible :id,
    :descripcion,
    :obras_civiles 


  validates :descripcion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 8..500, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.descripcion')}  #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}
  
 

  def get_obras_civiles
    valor = self.obras_civiles

    if valor
      retorno = "Sí"
    else
      retorno = "No"
    end

    return retorno

  end

end

# == Schema Information
#
# Table name: recaudos_avaluos_inspecciones
#
#  id            :integer         not null, primary key
#  descripcion   :string(500)
#  obras_civiles :boolean
#

