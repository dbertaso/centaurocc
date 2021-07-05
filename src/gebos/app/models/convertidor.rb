# encoding: utf-8
#
# autor: Luis Rojas
# clase: Convertidor
# descripción: Creado en Rails 3

class Convertidor < ActiveRecord::Base
  
  self.table_name = 'convertidor'
  
  attr_accessible :id, :moneda_origen_id, :moneda_destino_id, :valor, :origen, :destino, :valor_f

  validates :moneda_origen_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.moneda')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :moneda_destino_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.Programa.Columnas.moneda')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :valor, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.valor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality => {:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.valor')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :allow_blank => true}
   
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
  def origen
    moneda = Moneda.first(:conditions=> "id = #{self.moneda_origen_id}")
    return moneda.nombre
  end
  
  def destino
    moneda = Moneda.first(:conditions=> "id = #{self.moneda_destino_id}")
    return moneda.nombre
  end
  
  def origen_destino
    origen = Moneda.first(:conditions=> "id = #{self.moneda_origen_id}")
    destino = Moneda.first(:conditions=> "id = #{self.moneda_destino_id}")
    return "#{origen.nombre} #{I18n.t('Sistema.Body.Vistas.General.a')} #{destino.nombre}"
  end
  
  def valor_f=(valor)
    self.valor = format_valor(valor)
  end

  def valor_f
    format_fm(self.valor)
  end
  
end
# == Schema Information
#
# Table name: convertidor
#
#  id                :integer         not null, primary key
#  moneda_origen_id  :integer         not null
#  moneda_destino_id :integer         not null
#  valor             :float           not null
#

