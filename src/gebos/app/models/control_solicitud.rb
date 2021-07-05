# encoding: utf-8
class ControlSolicitud < ActiveRecord::Base

  self.table_name = 'control_solicitud'
  
  attr_accessible :id,
                  :fecha,
                  :estatus_id,
                  :solicitud_id,
                  :usuario_id,
                  :estatus_origen_id,
                  :comentario,
                  :accion

  belongs_to :solicitud
  belongs_to :usuario
  
  #validates_presence_of :solicitud, 
  #  :message => " es requerido"
  
  validates  :solicitud,
    :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.solicitud')}  #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}
  
  def fecha_f
    format_fecha(self.fecha)
  end

  def self.create_new(solicitud_id, estatus_id, usuario_id, accion, estatus_origen_id, comentario)
    ControlSolicitud.find_by_sql('INSERT INTO control_solicitud ("accion", "solicitud_id", "comentario", "estatus_id", "usuario_id", "estatus_origen_id") VALUES(' + "'#{accion}'" + ",#{solicitud_id}, '#{comentario}', #{estatus_id}, #{usuario_id}, #{estatus_origen_id})")
    return true
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort
  end
  
  
end

# == Schema Information
#
# Table name: control_solicitud
#
#  id                :integer         not null, primary key
#  fecha             :datetime        not null
#  estatus_id        :integer         not null
#  solicitud_id      :integer         not null
#  usuario_id        :integer         not null
#  estatus_origen_id :integer
#  comentario        :string(1800)
#  accion            :string(50)
#

