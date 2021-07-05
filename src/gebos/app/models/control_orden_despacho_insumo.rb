# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ControlOrdenDespachoInsumo
# descripción: Migración a Rails 3 
#


class ControlOrdenDespachoInsumo < ActiveRecord::Base
  
    self.table_name = 'control_orden_despacho_insumo'
  
    attr_accessible :id,
                    :fecha,
                    :archivo,
                    :numero_procesado,
                    :monto_procesado,
                    :entidad_financiera_id,
                    :estatus  
 
  belongs_to :entidad_financiera
  
  def monto_procesado_fm    
      format_fm(monto_procesado)    
  end

  def self.search(search, page, orden)      
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden, :include=>[:entidad_financiera]
  end


end

# == Schema Information
#
# Table name: control_orden_despacho_insumo
#
#  id                    :integer         not null, primary key
#  fecha                 :date            default(Mon, 01 Jan 1900)
#  archivo               :string(100)
#  numero_procesado      :integer         default(0)
#  monto_procesado       :decimal(, )     default(0.0)
#  entidad_financiera_id :integer
#  estatus               :integer
#

