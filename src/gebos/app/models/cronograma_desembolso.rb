# encoding: utf-8

#
# autor: Diego Bertaso
# clase: CronogramaDesembolso
# descripción: Migración a Rails 3
#
class CronogramaDesembolso < ActiveRecord::Base

  self.table_name = 'cronograma_desembolso'

  attr_accessible :id,
                  :rubro_id,
                  :numero_desembolso,
                  :dias

  belongs_to :rubro

  validates :rubro,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_numericality_of :dias, :only_integer => true,
    :message => I18n.t('Sistema.Body.Modelos.CronogramaDesembolso.tiempo_invalido')

  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end

  def valida_eliminar_desembolso(id,rubro_id)
    success = true
    ultimo_desembolso =  CronogramaDesembolso.find_by_sql("select id, numero_desembolso from cronograma_desembolso where rubro_id = #{rubro_id} order by id desc")

    ultimo_desembolso = ultimo_desembolso[0]

    unless (ultimo_desembolso.id.to_i == id.to_i)
      errors.add(:cronograma_desembolso ,I18n.t('Sistema.Body.Modelos.CronogramaDesembolso.Errores.imposible_eliminar'))
      success = false
    end
    return success
  end

end



# == Schema Information
#
# Table name: cronograma_desembolso
#
#  id                :integer         not null
#  rubro_id          :integer         not null
#  numero_desembolso :integer         not null
#  dias              :integer
#

