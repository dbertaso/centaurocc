# encoding: utf-8

#
# autor: 
# clase: PresupuestoTransferencia
# descripción: Migración a Rails 3
#


class PresupuestoTransferencia < ActiveRecord::Base
  
  self.table_name = 'presupuesto_transferencia'
  
  attr_accessible :id,
                  :rubro_id_origen,
                  :rubro_id_destino,
                  :monto_transferencia,
                  :fecha_registro,
                  :usuario_id,
                  :estado_id_origen,
                  :estado_id_destino,
                  :observaciones_justificacion,
                  :sub_rubro_id_origen,
                  :sub_rubro_id_destino,
                  :programa_id_origen,
                  :programa_id_destino

  
  
  belongs_to :rubro
  belongs_to :sub_rubro
  
  belongs_to :programa
  belongs_to :estado


  validates :monto_transferencia,
        :numericality=>{:only_integer => false, :allow_nil => false,:greater_than=> 0,:message=>"#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('errors.messages.greater_than',:count=>0)}" }
        
  validates :programa_id_origen, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :rubro_id_origen, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
     
  validates :rubro_id_destino, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}     

  validates :sub_rubro_id_origen, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :sub_rubro_id_destino, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
      
  validates :estado_id_origen, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Vistas.General.origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}        
         
  validates :estado_id_destino, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Vistas.Form.destino')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}                
  
           
  validates :observaciones_justificacion, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.justificacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}           

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
  
end



# == Schema Information
#
# Table name: presupuesto_transferencia
#
#  id                          :integer         not null, primary key
#  rubro_id_origen             :integer         not null
#  rubro_id_destino            :integer         not null
#  monto_transferencia         :decimal(16, 2)  not null
#  fecha_registro              :date            not null
#  usuario_id                  :integer         not null
#  estado_id_origen            :integer         not null
#  estado_id_destino           :integer         not null
#  observaciones_justificacion :text
#  sub_rubro_id_origen         :integer
#  sub_rubro_id_destino        :integer
#  programa_id_origen          :integer         default(0), not null
#  programa_id_destino         :integer         default(0), not null
#

