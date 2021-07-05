# encoding: utf-8
class FideicomisoMovimientos < ActiveRecord::Base

  self.table_name = 'fideicomiso_movimientos'
  
  attr_accessible :id,
                  :fideicomiso_id,
                  :tipo_movimiento_id,
                  :nro_lote,
                  :fecha_movimiento,
                  :referencia,
                  :justificacion,
                  :saldo_disponible_antes,
                  :monto_operacion,
                  :monto_banco,
                  :monto_insumos,
                  :monto_sras,
                  :monto_gastos,
                  :monto_primer_desembolso,
                  :comision,
                  :saldo_disponible_despues,
                  :usuario_id


  validates :fideicomiso_id, :presence => {
    :message => I18n.t('Sistema.Body.Vistas.General.fideicomiso') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')}

  validates :tipo_movimiento_id, :presence => {
    :message => I18n.t('Sistema.Body.Vistas.ReglaContable.Etiquetas.tipo_movimiento') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  validates :referencia, :presence => {
    :message => I18n.t('Sistema.Body.Vistas.General.referencia') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validates :justificacion, :presence => {
    :message => I18n.t('Sistema.Body.Vistas.General.justificacion') << " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validates :saldo_disponible_antes, 
  :presence => { :message => I18n.t('Sistema.Body.Vistas.General.saldo') << " " << I18n.t('Sistema.Body.Vistas.General.disponible') << " " << I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.antes') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
  :numericality=> {:only_integer => false,:message => I18n.t('Sistema.Body.Vistas.General.saldo') << " " << I18n.t('Sistema.Body.Vistas.General.disponible') << " " << I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.antes') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}

  validates :saldo_disponible_despues, 
  :presence => { :message => I18n.t('Sistema.Body.Vistas.General.saldo') << " " << I18n.t('Sistema.Body.Vistas.General.disponible') << " " << I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.despues') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
  :numericality=> {:only_integer => false,:message => I18n.t('Sistema.Body.Vistas.General.saldo') << " " << I18n.t('Sistema.Body.Vistas.General.disponible') << " " << I18n.t('Sistema.Body.Vistas.ConsultarTransaccion.Etiquetas.despues') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}

  validates :monto_operacion,   
  :numericality=> {:only_integer => false,:message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Vistas.General.operacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}

  
  #validates_date :fecha_creacion, :before=>[Proc.new { 0.day.from_now.to_date }], :before_message=>'^Fecha Apertura debe ser menor que la Fecha Actual'

def self.search(search, page, sort,sel, joins)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>sel,
      :joins=>joins
  end
  
end


# == Schema Information
#
# Table name: fideicomiso_movimientos
#
#  id                       :integer         not null, primary key
#  fideicomiso_id           :integer         not null
#  tipo_movimiento_id       :integer
#  nro_lote                 :integer
#  fecha_movimiento         :datetime
#  referencia               :text
#  justificacion            :text
#  saldo_disponible_antes   :float
#  monto_operacion          :float
#  monto_banco              :float
#  monto_insumos            :float
#  monto_sras               :float
#  monto_gastos             :float
#  monto_primer_desembolso  :float
#  comision                 :float
#  saldo_disponible_despues :float
#  usuario_id               :integer
#

