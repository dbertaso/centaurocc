# encoding: utf-8

#
#
# clase: Factura
# autor: Diego Bertaso
# descripción: Migración a Rails 3
#

class Factura < ActiveRecord::Base

  self.table_name = 'factura'

  attr_accessible :id,
                  :numero,
                  :fecha,
                  :fecha_realizacion,
                  :fecha_contable,
                  :pago_cliente_id,
                  :desembolso_id,
                  :prestamo_id,
                  :tipo,
                  :monto,
                  :proceso_nocturno,
                  :prestamo_modificacion_id,
                  :remanente_por_aplicar,
                  :analista,
                  :comentario_analista,
                  :estado,
                  :sector_economico,
                  :distincion_cobranza,
                  :codigo_contable,
                  :consultoria_juridica,
                  :estado_geografico,
                  :abono_capital,
                  :tipo_cartera_id,
                  :recuperaciones,
                  :pago_capital,
                  :pago_interes,
                  :pago_mora,
                  :monto_banco,
                  :monto_sras,
                  :monto_insumos,
                  :monto_inventario,
                  :monto_gastos,
                  :pago_al_dia,
                  :fecha_f,
                  :fecha_realizacion_f

  belongs_to :desembolso
  belongs_to :prestamo
  belongs_to :pago_cliente
  belongs_to :prestamo_modificacion
  belongs_to :tipo_cartera

  validates :numero,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_contable,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.Form.contable')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :prestamo,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.prestamo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :numero,
    :uniqueness => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :fecha,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  validates :fecha_contable,
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.Form.contable')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}"}

  def pago_prestamo
    pago_prestamo = PagoPrestamo.find_by_pago_cliente_id(self.pago_cliente_id)
  end


  def self.search(search, page, sort)

    unless search.nil?
      paginate  :per_page => @records_by_page, :page => page,
                :conditions => search, :order => sort, :include=>[:desembolso]
    else
      paginate  :per_page => @records_by_page, :page => page,
                :order => sort, :include=>[:desembolso]

    end

  end

  def monto_cheques

    monto_cheque = 0.00

    if !self.pago_cliente.cheques.nil?

      for cheque in self.pago_cliente.cheques

        monto_cheque += cheque.monto
      end
    end

    return monto_cheque

  end

  def pago_capital_migracion_f
    format_f(self.pago_capital)
  end

  def pago_capital_migracion_fm

    format_fm(self.pago_capital)
  end

  def pago_interes_migracion_f
    format_f(self.pago_interes)
  end

  def pago_interes_migracion_fm

    format_fm(self.pago_interes)
  end

  def pago_mora_migracion_f
    format_f(self.pago_mora)
  end

  def pago_mora_migracion_fm

    format_fm(self.pago_mora)
  end

  def monto_banco_fm

    format_fm(self.monto_banco)
  end

  def monto_inventario_fm

    format_fm(self.monto_inventario)

  end

  def monto_sras_fm

    format_fm(self.monto_sras)

  end

  def monto_gastos_fm

    format_fm(self.monto_gastos)

  end

  def monto_insumos_fm

    format_fm(self.monto_insumos)
  end

  def monto_cheques_f
    format_f(self.monto_cheques)
  end

  def monto_cheques_fm
    format_fm(self.monto_cheques)
  end

  def tipo_w
    case self.tipo
      when 'A'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.abono_capital')
      when 'C'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.cancelacion_anticipada')
      when 'R'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.pago_arrime')
      when 'D'

        unless self.desembolso.nil?

          case self.desembolso.tipo_cheque 
            when 'F'
              I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.desembolso_cheque')
            when 'G'
              I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.desembolso_cheque_gerencia')
            else
              I18n.t('Sistema.Body.Modelos.Desembolso.TipoCheque.desembolso_transferencia_cuenta')
          end
        else
           I18n.t('Sistema.Body.Vistas.General.insumos')
        end

      when 'M'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.maquinaria')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.pago_ordinario')
      when 'E'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.abono_extraordinario')
      when 'W'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.cancelacion_reestructuracion')
      when 'X'
        I18n.t('Sistema.Body.Modelos.Factura.Tipo.creacion_reestructuracion')
    end
  end

  def after_initialize
    self.fecha = Time.new unless self.fecha
    self.fecha_contable = Time.new unless self.fecha_contable

  end
  def fecha_f=(fecha)
    self.fecha = fecha
  end

  def fecha_f
    format_fecha(self.fecha)
  end
  def fecha_realizacion_f=(fecha)
    self.fecha_realizacion = fecha
  end

  def fecha_realizacion_f
    format_fecha(self.fecha_realizacion)
  end
  def monto_f=(valor)
    self.monto = format_valor(valor)
  end

  def monto_f
    format_f(self.monto)
  end

  def monto_fm

    format_fm(self.monto)
  end

  def abono_capital_f=(valor)
    self.abono_capital = valor.sub(',', '.')
  end

  def abono_capital_f
    format_f(self.abono_capital)
  end

  def abono_capital_fm
    format_fm(self.abono_capital)
  end

  def remanente_por_aplicar_f
    format_f(self.remanente_por_aplicar)
  end

  def  remanente_por_aplicar_fm

    format_fm(self.remanente_por_aplicar)
  end

  def  monto_desembolso_fm
    unless self.desembolso.nil?

      format_fm_(self.desembolso.monto)
    end
  end

  def distincion_cobranza_d

    if self.distincion_cobranza == 'REZ'
      return I18n.t('Sistema.Body.Modelos.Factura.Distincion.rezagada')
    else
      return I18n.t('Sistema.Body.Modelos.Factura.Distincion.mes')
    end

  end

end



# == Schema Information
#
# Table name: factura
#
#  id                       :integer         not null, primary key
#  numero                   :integer         default(0)
#  fecha                    :date            not null
#  fecha_realizacion        :date
#  fecha_contable           :date
#  pago_cliente_id          :integer
#  desembolso_id            :integer
#  prestamo_id              :integer         not null
#  tipo                     :string(1)       default("D")
#  monto                    :decimal(16, 2)  default(0.0)
#  proceso_nocturno         :boolean         default(FALSE)
#  prestamo_modificacion_id :integer
#  remanente_por_aplicar    :decimal(16, 2)  default(0.0)
#  analista                 :string(50)
#  comentario_analista      :text
#  estado                   :string(20)
#  sector_economico         :string(50)
#  distincion_cobranza      :string(3)
#  codigo_contable          :string(10)      default("000.000")
#  consultoria_juridica     :boolean         default(FALSE)
#  estado_geografico        :string(20)      default("AMAZONAS INI")
#  abono_capital            :decimal(16, 2)  default(0.0)
#  tipo_cartera_id          :integer         default(1)
#  recuperaciones           :boolean         default(FALSE)
#  pago_capital             :decimal(16, 2)  default(0.0)
#  pago_interes             :decimal(16, 2)  default(0.0)
#  pago_mora                :decimal(16, 2)  default(0.0)
#  monto_banco              :decimal(16, 2)
#  monto_sras               :decimal(16, 2)
#  monto_insumos            :decimal(16, 2)
#  monto_inventario         :decimal(16, 2)  default(0.0)
#  monto_gastos             :decimal(16, 2)  default(0.0), not null
#  pago_al_dia              :boolean         default(FALSE), not null
#

