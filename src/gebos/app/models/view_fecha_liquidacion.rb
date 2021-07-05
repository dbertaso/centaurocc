# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewFechaLiquidacion
# descripcion: Migracion a Rails 3



class ViewFechaLiquidacion < ActiveRecord::Base

  self.table_name = 'view_fecha_liquidacion'
  
attr_accessible :oficina_id,
                :beneficiario,
                :email,
                :cedula_rif,
                :solicitud_id,
                :nro_tramite,
                :control,
                :fecha_liquidacion,
                :nro_prestamo,
                :prestamo_id,
                :tipo_cliente_id,
                :entidad_financiera_id,
                :banco,
                :cod_swift,
                :tipo_cuenta,
                :numero_cuenta,
                :unidad_produccion_id,
                :ciudad_id,
                :ciudad,
                :estado_id,
                :estado,
                :sector_id,
                :sector,
                :rubro,
                :rubro_id,
                :ciclo,
                :nombre,
                :desembolso_id,
                :numero_desembolso,
                :estatus_desembolso_id,
                :estatus_id,
                :monto_solicitado,
                :monto_liquidar,
                :monto_banco,
                :monto_liquidado,
                :sub_rubro_nombre,
                :sub_rubro_id,
                :actividad_nombre,
                :actividad_id,
                :fecha_liquidacion_f,
                :moneda_id,
                :moneda
  
  
  
  public


  def monto_solicitado_f
    format_fm(self.monto_solicitado)
  end

   def monto_liquidar_f
    format_fm(self.monto_liquidar)
  end

  def fecha_liquidacion_f
    format_fecha(self.fecha_liquidacion)
  end

  def monto_solicitado_fm
    format_fm(self.monto_solicitado)
  end

  def monto_liquidar_fm
    format_fm(self.monto_liquidar)
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_fecha_liquidacion
#
#  oficina_id            :integer
#  beneficiario          :string
#  email                 :string(80)
#  cedula_rif            :string
#  solicitud_id          :integer
#  nro_tramite           :integer
#  control               :boolean
#  fecha_liquidacion     :date
#  nro_prestamo          :integer(8)
#  prestamo_id           :integer
#  tipo_cliente_id       :integer
#  entidad_financiera_id :integer
#  banco                 :string(80)
#  cod_swift             :string(12)
#  tipo_cuenta           :string(1)
#  numero_cuenta         :string(20)
#  unidad_produccion_id  :integer
#  ciudad_id             :integer
#  ciudad                :string(40)
#  estado_id             :integer
#  estado                :string(40)
#  sector_id             :integer
#  sector                :string(100)
#  rubro                 :string(100)
#  rubro_id              :integer
#  ciclo                 :integer
#  nombre                :string(50)
#  desembolso_id         :integer
#  numero_desembolso     :integer
#  estatus_desembolso_id :integer
#  estatus_id            :integer
#  monto_solicitado      :decimal(16, 2)
#  monto_liquidar        :decimal(16, 2)
#  monto_banco           :decimal(16, 2)
#  monto_liquidado       :decimal(16, 2)
#  sub_rubro_nombre      :string(100)
#  sub_rubro_id          :integer
#  actividad_nombre      :string(150)
#  actividad_id          :integer
#  moneda_id             :integer
#  moneda                :text
#

