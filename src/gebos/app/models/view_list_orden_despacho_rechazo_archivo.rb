# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: ViewListOrdenDespachoRechazoArchivo
# descripción: Migración a Rails 3 
#


class ViewListOrdenDespachoRechazoArchivo < ActiveRecord::Base

    self.table_name = 'view_list_orden_despacho_rechazo_archivo' 
  
    attr_accessible :archivo_historico,
                    :solicitud_id,
                    :numero_historico,
                    :casa_historico,
                    :fecha_liquidacion,
                    :monto_liquidacion,
                    :numero_cuenta_liquidadora,
                    :numero_cuenta_casa_proveedora


public
  def monto_factura_fm    
      format_fm(self.monto_factura)
  end
  
  def fecha_liquidacion_f
    format_fecha(self.fecha_liquidacion)
  end  

  def monto_total_factura_fm    
    format_fm(self.monto_total_factura)
  end

  def monto_solicitado_fm    
      format_fm(self.monto_solicitado)
  end

  def monto_liquidacion_fm
    format_fm(self.monto_liquidacion)
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: view_list_orden_despacho_rechazo_archivo
#
#  archivo_historico             :string(100)
#  tipo                          :string(1)
#  numero                        :integer(8)
#  numero_historico              :string(8)
#  casa_historico                :integer
#  fecha_liquidacion             :date
#  monto_liquidacion             :decimal(16, 2)
#  numero_cuenta_casa_proveedora :string(20)
#  descripcion_error             :string
#  rif                           :string(20)
#  nombre                        :string
#

