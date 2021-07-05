# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewListOrdenDespachoConsulta
# descripción: Migración a Rails 3 
#


class ViewListOrdenDespachoConsulta < ActiveRecord::Base


self.table_name = 'view_list_orden_despacho_consulta'

  
    attr_accessible :prestamo,
                    :cliente_id,
                    :numero_factura,
                    :nombre,
                    :no_va,
                    :cedula_rif,
                    :numero,
                    :solicitud_id,
                    :orden_despacho_id,
                    :rubro,
                    :estatus,
                    :estatus_tramite_id,
                    :monto_solicitado,
                    :sub_sector,
                    :estatus_id,
                    :oficina_id,
                    :sector,
                    :sector_id,
                    :sub_sector_id,
                    :rubro_id,
                    :codigo_visita,
                    :fecha_visita,
                    :monto,
                    :fecha_orden,
                    :actividad_id,
                    :sub_rubro_id



public
  def monto_fm    
      format_fm(self.monto)    
  end
  
  def monto_total_factura_fm    
      format_fm(self.monto_total_factura)          
  end
  
  def oficina_nombre
    Oficina.find(self.oficina_id).nombre
  end
  
  
  def fecha_visita_f
    format_fecha(self.fecha_visita)
  end  

  def fecha_orden_f
    format_fecha(self.fecha_orden)
  end  

  def sumatoria_monto_total_factura_fm(orden_id)
    
    unless orden_id.nil?
      
      sentencia="select sum(fact.monto_factura)
                    from factura_orden_despacho fact
                    inner join orden_despacho_detalle ord_det on fact.orden_despacho_detalle_id=ord_det.id
                    inner join orden_despacho ord on ord_det.orden_despacho_id =ord.id
                    LEFT JOIN solicitud sol ON ord.solicitud_id = sol.id
                    left JOIN cliente cli ON sol.cliente_id = cli.id
                    LEFT JOIN empresa emp ON cli.empresa_id = emp.id
                    LEFT JOIN persona per ON cli.persona_id = per.id
                    LEFT JOIN empresa_direccion emp_dir ON emp.id = emp_dir.empresa_id
                    left JOIN persona_direccion per_dir ON per.id = per_dir.persona_id
                    left JOIN persona per_int ON per_int.id=(select persona_id from empresa_integrante,empresa_integrante_tipo where empresa_integrante.empresa_id=emp.id and empresa_integrante_tipo.empresa_integrante_id = empresa_integrante.id and empresa_integrante_tipo.tipo = 'R')
                    join casa_proveedora casa on fact.casa_proveedora_id=casa.id
                    join sucursal_casa_proveedora sucu on fact.sucursal_casa_proveedora_id=sucu.id
                    where fact.monto_factura>0 and fact.emitida=true and fact.confirmada=true and orden_despacho_id=#{orden_id}"
      
      
      format_fm(FacturaOrdenDespacho.find_by_sql(sentencia)[0].sum.to_f)
      
    end
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end


end

# == Schema Information
#
# Table name: view_list_orden_despacho_consulta
#
#  prestamo           :integer
#  cliente_id         :integer
#  numero_factura     :string(20)
#  nombre             :string
#  no_va              :text
#  cedula_rif         :string
#  numero             :text
#  solicitud_id       :integer
#  orden_despacho_id  :integer
#  rubro              :string(100)
#  estatus            :text
#  estatus_tramite_id :integer
#  monto_solicitado   :float
#  sub_sector         :string(100)
#  estatus_id         :integer
#  oficina_id         :integer
#  sector             :string(100)
#  sector_id          :integer
#  sub_sector_id      :integer
#  rubro_id           :integer
#  codigo_visita      :string(30)
#  fecha_visita       :date
#  monto              :decimal(16, 2)
#  fecha_orden        :date
#  actividad_id       :integer
#  sub_rubro_id       :integer
#  moneda_id          :integer
#

