# encoding: utf-8

#
# autor: Luis Rojas
# clase: PerformanceCobranzas
# creado con Rails 3
#

class PerformanceAnalistaCobranza < ActiveRecord::Base
  
  self.table_name = 'performance_analista_cobranza'
  
  attr_accessible :id,
                  :analista_cobranzas_id,
                  :fecha, 
                  :fecha_f,
                  :cantidad_intentos,
                  :cantidad_contactos,
                  :cantidad_contactos_exitosos,
                  :cantidad_promesas_pago,
                  :porcentaje_contactos, 
                  :porcentaje_contactos_f,
                  :porcentaje_contactos_exitosos, 
                  :porcentaje_contactos_exitosos_f,
                  :porcentaje_promesas_pago, 
                  :porcentaje_promesas_pago_f,
                  :cantidad_email_enviados,
                  :cantidad_sms_enviados

  belongs_to :analista_cobranzas

  def fecha_f
    format_fecha(self.fecha)
  end

  def self.listado(id, fdesde, fhasta)
    return PerformanceAnalistaCobranza.find(:all, :conditions=> "analista_cobranzas_id = #{id} and fecha >= '#{fdesde}' and fecha <= '#{fhasta}'", :order => 'fecha')
  end

  def porcentaje_contactos_f
      format_f((self.cantidad_contactos.to_f / self.cantidad_intentos.to_f) * 100)
  end

  def porcentaje_promesas_pago_f
    format_f(self.porcentaje_promesas_pago)
  end

  def porcentaje_contactos_exitosos_f
    format_f((self.cantidad_contactos_exitosos.to_f / self.cantidad_contactos.to_f) * 100)
  end

  def self.totales(analista_cobranzas_id, fdesde, fhasta)
    return PerformanceAnalistaCobranza.find_by_sql("select sum(cantidad_intentos) as tcantidad_intentos, sum(cantidad_contactos) as tcantidad_contactos, sum(cantidad_contactos_exitosos) as tcantidad_contactos_exitosos, sum(cantidad_promesas_pago) as tcantidad_promesas_pago,sum(porcentaje_contactos) as tporcentaje_contactos, sum(porcentaje_contactos_exitosos) as tporcentaje_contactos_exitosos, sum(porcentaje_promesas_pago) as tporcentaje_promesas_pago, sum(cantidad_email_enviados) as tcantidad_email_enviados, sum(cantidad_sms_enviados) as tcantidad_sms_enviados from performance_analista_cobranza where analista_cobranzas_id = #{analista_cobranzas_id} and fecha >= '#{fdesde}' and fecha <= '#{fhasta}'")
  end

  def self.porcentajes(analista_cobranzas_id)
    if analista_cobranzas_id.nil?
      total_telecobranzas = Telecobranzas.count(:conditions => "senal_compromiso = true")
      telecobranzas_cumplidas = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('A', 'V', 'R') and c.monto_pago <= c.monto_efectivamente_pago where t.senal_compromiso = true")
      telecobranzas_cumplidas_parcial = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('A', 'V', 'R') and c.monto_pago > c.monto_efectivamente_pago where t.senal_compromiso = true")
      telecobranzas_incumplidas = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('N') where t.senal_compromiso = true")
      monto_comprometido = CompromisoPago.sum(:monto_pago, :conditions => "estatus in ('A', 'V', 'R')")
      monto_pago = CompromisoPago.sum(:monto_efectivamente_pago, :conditions => "estatus in ('A', 'V', 'R')")
    else
      total_telecobranzas = Telecobranzas.count(:conditions => "senal_compromiso = true and gestion_cobranzas_id in (select id from gestion_cobranzas where analista_cobranza_id = #{analista_cobranzas_id})")
      telecobranzas_cumplidas = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id and analista_cobranza_id = #{analista_cobranzas_id} join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('A', 'V', 'R') and c.monto_pago <= c.monto_efectivamente_pago where t.senal_compromiso = true")
      telecobranzas_cumplidas_parcial = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id and analista_cobranza_id = #{analista_cobranzas_id} join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('A', 'V', 'R') and c.monto_pago > c.monto_efectivamente_pago where t.senal_compromiso = true")
      telecobranzas_incumplidas = Telecobranzas.find_by_sql("SELECT COUNT(*) as total FROM telecobranzas t join gestion_cobranzas g on t.gestion_cobranzas_id = g.id and analista_cobranza_id = #{analista_cobranzas_id} join compromiso_pago c on c.telecobranzas_id = t.id and c.estatus in ('N') where t.senal_compromiso = true")
      monto_comprometido = CompromisoPago.sum(:monto_pago, :conditions => "estatus in ('A', 'V', 'R') and telecobranzas_id in (select t.id from telecobranzas t join gestion_cobranzas g on g.id = t.gestion_cobranzas_id and g.analista_cobranza_id = #{analista_cobranzas_id})")
      monto_pago = CompromisoPago.sum(:monto_efectivamente_pago, :conditions => "estatus in ('A', 'V', 'R') and telecobranzas_id in (select t.id from telecobranzas t join gestion_cobranzas g on g.id = t.gestion_cobranzas_id and g.analista_cobranza_id = #{analista_cobranzas_id})")
    end
    unless telecobranzas_cumplidas[0].total.to_f > 0 && total_telecobranzas > 0
      porcentaje_cumplidas = 0.0
    else
      porcentaje_cumplidas = (telecobranzas_cumplidas[0].total.to_f / total_telecobranzas) * 100
    end
    unless telecobranzas_cumplidas_parcial[0].total.to_f > 0 && total_telecobranzas > 0
      porcentaje_cumplidas_parcial = 0.0
    else
      porcentaje_cumplidas_parcial = (telecobranzas_cumplidas_parcial[0].total.to_f / total_telecobranzas) * 100
    end
    unless telecobranzas_incumplidas[0].total.to_f > 0 && total_telecobranzas > 0
      porcentaje_incumplidas = 0.0
    else
      porcentaje_incumplidas = (telecobranzas_incumplidas[0].total.to_f / total_telecobranzas) * 100
    end
    if monto_comprometido.blank?
      monto_comprometido = 0.0
    end
    if monto_pago.blank?
      monto_pago = 0.0
    end
    if monto_pago.blank? || monto_comprometido.blank?
      porcentaje_recuperacion = 0.0
    else
      porcentaje_recuperacion = (monto_pago / monto_comprometido) * 100
    end
    return [format_fm(porcentaje_cumplidas), format_fm(porcentaje_cumplidas_parcial), format_fm(porcentaje_incumplidas), format_fm(monto_comprometido), format_fm(monto_pago), format_fm(porcentaje_recuperacion)]
  end
  
end
# == Schema Information
#
# Table name: performance_analista_cobranza
#
#  id                            :integer         not null, primary key
#  analista_cobranzas_id         :integer         not null
#  fecha                         :date
#  cantidad_intentos             :integer         default(0), not null
#  cantidad_contactos            :integer         default(0), not null
#  cantidad_contactos_exitosos   :integer         default(0), not null
#  cantidad_promesas_pago        :integer         default(0), not null
#  porcentaje_contactos          :decimal(5, 2)   default(0.0), not null
#  porcentaje_contactos_exitosos :decimal(5, 2)   default(0.0), not null
#  porcentaje_promesas_pago      :decimal(5, 2)   default(0.0), not null
#  cantidad_email_enviados       :integer         default(0), not null
#  cantidad_sms_enviados         :integer         default(0), not null
#

