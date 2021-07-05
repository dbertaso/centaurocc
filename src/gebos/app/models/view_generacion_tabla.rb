# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewGeneracionTabla
# descripción: Migración a Rails 3
#


class ViewGeneracionTabla < ActiveRecord::Base

  belongs_to :prestamo

  self.table_name = 'view_generacion_tabla'
  
    attr_accessible :oficina_id,
                    :beneficiario,
                    :email,
                    :cedula_rif,
                    :solicitud_id,
                    :nro_tramite,
                    :control,
                    :fecha_liquidacion,
                    :fecha_liquidacion_f,
                    :nro_prestamo,
                    :prestamo_id,
                    :monto_sras,
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
                    :monto_insumos,
                    :oficina_nombre,
                    :sub_sector_id,
                    :sub_rubro_id,
                    :actividad_id,
                    :subrubro,
                    :actividad,
                    :programa_id,
                    :programa,
                    :moneda_id,
                    :moneda



  def monto_solicitado_fm
    format_fm(self.monto_solicitado)
  end

  def monto_solicitado_f
    format_fm(self.monto_solicitado)
  end

  def fecha_liquidacion_f
    format_fecha(self.fecha_liquidacion)
  end

  def monto_desembolso_fm    
      format_fm(self.monto_liquidar)
  end

  def monto_sras_fm

    if primer_desembolso?
      monto = self.monto_sras unless self.monto_sras.nil?
    else
      monto = 0.00
    end

    format_fm(monto)

  end

  def monto_desembolso_f
    format_fm(self.monto_liquidar)
  end

  def monto_por_desembolsar_fm
    unless self.monto_banco.nil? || self.monto_liquidado.nil? || self.monto_liquidar.nil?
      monto = (self.monto_banco - self.monto_liquidado - self.monto_liquidar)
      format_fm(monto)
    end
  end

  def monto_insumos_fm

    if primer_desembolso?      
        format_fm(self.monto_insumos)
    else
      format_fm("0")
    end
  
  
  end

  def primer_desembolso?

    plan_pago = PlanPago.find_by_prestamo_id_and_activo(self.prestamo_id, true)

    if plan_pago.nil?
        return true
    else
        return false
    end

  end

  def monto_total_desembolso_fm

    # Este método suma el sras al monto del desembolso si es el primer desembolso

    if self.primer_desembolso?

      unless self.monto_liquidar.nil? || self.monto_sras.nil? || self.monto_insumos.nil?
        monto = (self.monto_liquidar + self.monto_sras + self.monto_insumos)
        format_fm(monto)
      end

    else
      unless self.monto_liquidar.nil?
        format_fm(self.monto_liquidar)
      end

    end

  end


  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_generacion_tabla
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
#  monto_sras            :decimal(16, 2)
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
#  monto_insumos         :decimal(16, 2)
#  oficina_nombre        :string(80)
#  sub_sector_id         :integer
#  sub_rubro_id          :integer
#  actividad_id          :integer
#  subrubro              :string(100)
#  actividad             :string(150)
#  moneda_id             :integer
#  moneda                :text
#

