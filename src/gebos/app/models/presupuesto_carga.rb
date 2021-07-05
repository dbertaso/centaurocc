# encoding: utf-8

#
# autor: 
# clase: PresupuestoCarga
# descripción: Migración a Rails 3
#

class PresupuestoCarga < ActiveRecord::Base
  
  self.table_name = 'presupuesto_carga'
  
  attr_accessible :id,
                  :rubro_id,
                  :monto_presupuesto,
                  :fecha_registro,
                  :usuario_id,
                  :estado_id,
                  :sub_rubro_id,
                  :programa_id
  
  belongs_to :rubro
  belongs_to :sub_rubro
  
  belongs_to :programa
  belongs_to :estado

  
  
  validates :monto_presupuesto,                
        :numericality=>{:only_integer => false, :allow_nil => false,:greater_than=> 0,:message=>"#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('errors.messages.greater_than',:count=>0)}"  }        
        #:format =>{:with => /^\-{0,1}\d+\.{0,1}\d{0,2}$/, :allow_blank =>false, :message =>"#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
        
        
  validates :programa_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.programa')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :rubro_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :sub_rubro_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_rubro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :estado_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
     
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end


end



# == Schema Information
#
# Table name: presupuesto_carga
#
#  id                :integer         not null, primary key
#  rubro_id          :integer         not null
#  monto_presupuesto :decimal(16, 2)
#  fecha_registro    :date
#  usuario_id        :integer         not null
#  estado_id         :integer         not null
#  sub_rubro_id      :integer
#  programa_id       :integer         default(0), not null
#

