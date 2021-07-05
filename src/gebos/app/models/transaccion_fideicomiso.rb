# encoding: utf-8

#
# autor: 
# clase: TransaccionFideicomiso
# descripción: Migración a Rails 3
#

class TransaccionFideicomiso < ActiveRecord::Base

  self.table_name = 'transaccion_fideicomiso'
  
  attr_accessible :id,
                  :fecha,
                  :usuario_id,
                  :estado_id,
                  :sector_id,
                  :sub_sector_id,
                  :rubro_id,
                  :cantidad_solicitudes,
                  :monto_banco,
                  :monto_insumo,
                  :monto_sras,
                  :monto_total,
                  :solicitud_id,  
                  :monto_gastos_admin
  
  
  belongs_to :usuario
 
  
  validates :usuario_id, :presence => {:message => "#{I18n.t('Sistema.Body.Controladores.Usuario.FormTitles.form_title_record')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :cantidad_solicitudes, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.solicitudes')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  validates :monto_banco, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.monto')} #{I18n.t('Sistema.Body.Vistas.General.banco')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :monto_insumo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamo.Etiquetas.monto_insumos')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :monto_sras, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.ConsultaPrestamoFactura.Etiquetas.monto_sras')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :monto_total, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.ConsultaCuentaProyectado.Etiquetas.monto_total')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :solicitud_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  def self.create_new(usuario_id,estado_id,sector_id,sub_sector_id,rubro_id,solicitud_id,cantidad_solicitudes,monto_banco,monto_insumo,monto_sras,monto_total)
    ControlSolicitud.find_by_sql('INSERT INTO transaccion_fideicomiso (usuario_id,estado_id,sector_id,sub_sector_id,rubro_id,solicitud_id,cantidad_solicitudes,monto_banco,monto_insumo,monto_sras,monto_total) VALUES(' + "'#{usuario_id}'" + ",#{estado_id}, '#{sector_id}', '#{sub_sector_id}', '#{rubro_id}', #{solicitud_id}, #{cantidad_solicitudes}, #{monto_banco}, #{monto_insumo}, #{monto_sras}, #{monto_total})")
    return true
  end
  
  
  def self.search(search, page, orden)    
    conditions=search      
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end
  
  def moneda_f(solicitud_id)
    cantidad = Solicitud.count(:conditions=> "id = #{solicitud_id}")
    if cantidad > 0
      solicitud = Solicitud.find(solicitud_id)
      return solicitud.moneda.nombre
    else
      return ''
    end
  end
  
  #usuario_id,estado_id,rubro_id,solicitud_id,cantidad_solicitudes,monto_banco,monto_insumo,monto_sras,monto_total
    
end

# == Schema Information
#
# Table name: transaccion_fideicomiso
#
#  fecha                :datetime        not null
#  usuario_id           :integer
#  estado_id            :integer
#  sector_id            :integer
#  sub_sector_id        :integer
#  rubro_id             :integer
#  cantidad_solicitudes :integer
#  monto_banco          :float           default(0.0), not null
#  monto_insumo         :float           default(0.0), not null
#  monto_sras           :float           default(0.0), not null
#  monto_total          :float           default(0.0), not null
#  solicitud_id         :text
#  id                   :integer         not null, primary key
#  monto_gastos_admin   :float           default(0.0), not null
#

