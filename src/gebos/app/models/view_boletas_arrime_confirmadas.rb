# encoding: utf-8
class ViewBoletasArrimeConfirmadas < ActiveRecord::Base
  
  self.table_name = 'view_boletas_arrime_confirmadas'
  
  attr_accessible :boleta_arrime_id, 
    :solicitud_id, 
    :silo_id, 
    :rubro_id, 
    :sub_rubro_id, 
    :actividad_id, 
    :cliente_id, 
    :fecha_confirmacion, 
    :guia_movilizacion, 
    :prestamo_numero, 
    :prestamo_id, 
    :solicitud_numero, 
    :sub_sector_nombre, 
    :sector_nombre, 
    :rubro_nombre, 
    :sub_rubro_nombre, 
    :actividad_nombre, 
    :silo_nombre, 
    :nombre_beneficiario, 
    :cedula,
    :documento_beneficiario, 
    :direccion,
    :primer_nombre_empleado, 
    :segundo_nombre_empleado, 
    :primer_apellido_empleado, 
    :segundo_apellido_empleado, 
    :monto_arrime, 
    :fecha_arrime, 
    :estatus 

  public
  def fecha_arrime_f
    self.fecha_arrime.strftime("%d-%m-%Y") unless fecha_arrime.nil?
  end

  def monto_arrime_fm
    format_fm(self.monto_arrime)
  end

  def fiscal_cosecha
    nombre_fiscal = ''
    nombre_fiscal = self.primer_nombre_empleado + ' ' + self.segundo_nombre_empleado + ' '
    nombre_fiscal << self.primer_apellido_empleado + ' ' + self.segundo_apellido_empleado
  end

  def fecha_instruccion_pago_f
    fecha_instruccion.strftime("%d-%m-%Y")
  end

  def fecha_confirmacion_f
    fecha_confirmacion.strftime("%d-%m-%Y")
  end
  
  def self.search(search, page, sort)
    if search.blank?
    paginate :per_page => @records_by_page, :page => page,
      :order => sort,
      :select=>'*'
    else
      paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
    end
  end
  
end

# == Schema Information
#
# Table name: view_boletas_arrime_confirmadas
#
#  boleta_arrime_id          :integer
#  solicitud_id              :integer
#  silo_id                   :integer
#  rubro_id                  :integer
#  sub_rubro_id              :integer
#  actividad_id              :integer
#  cliente_id                :integer
#  fecha_confirmacion        :date
#  guia_movilizacion         :string(20)
#  prestamo_numero           :integer(8)
#  prestamo_id               :integer
#  solicitud_numero          :integer
#  sub_sector_nombre         :string(100)
#  sector_nombre             :string(100)
#  rubro_nombre              :string(100)
#  sub_rubro_nombre          :string(100)
#  actividad_nombre          :string(150)
#  silo_nombre               :string(45)
#  nombre_beneficiario       :string
#  cedula                    :integer
#  documento_beneficiario    :string
#  direccion                 :text
#  primer_nombre_empleado    :string
#  segundo_nombre_empleado   :string
#  primer_apellido_empleado  :string
#  segundo_apellido_empleado :string
#  monto_arrime              :decimal(16, 2)
#  fecha_arrime              :date
#  estatus                   :string(1)
#

