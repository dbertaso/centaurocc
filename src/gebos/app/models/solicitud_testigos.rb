# encoding: utf-8

#
# 
# clase: SolicitudTestigos
# descripción: Migración a Rails 3
#

class SolicitudTestigos < ActiveRecord::Base

  self.table_name = 'solicitud_testigos' 
  
  attr_accessible :id,:solicitud_id,:nombre_testigo,:cedula_testigo

  

  validates :nombre_testigo, :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre')<< " " <<I18n.t('Sistema.Body.Vistas.General.del')<< " " << I18n.t('Sistema.Body.General.testigo') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}  
  
  validates :cedula_testigo, :presence => {:message => I18n.t('Sistema.Body.Vistas.General.cedula')<< " " <<I18n.t('Sistema.Body.Vistas.General.del')<< " " << I18n.t('Sistema.Body.General.testigo') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  before_create :antes_creacion
  
  def antes_creacion
    
    @testigos=SolicitudTestigos.count(:conditions=>"solicitud_id =#{self.solicitud_id}")
    
    if @testigos.to_i > 2
      
      errors.add(:solicitud_testigos, I18n.t('Sistema.Body.Controladores.SolicitudTestigos.Mensajes.maximo_tres_testigos'))
      return false
    end
  end

  validate :validate
  
  def validate
    if self.nombre_testigo.to_s.strip!=''
      rtsul =  SolicitudTestigos.find_by_sql("select * from solicitud_testigos where solicitud_id = #{self.solicitud_id} and upper(cedula_testigo) = upper('#{self.cedula_testigo}')")            
      unless rtsul.length == 0
          errors.add(:solicitud_testigos, self.nombre_testigo.to_s << " <strong>(#{self.cedula_testigo.upcase})</strong> #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')} #{I18n.t('Sistema.Body.Vistas.General.como')} #{I18n.t('Sistema.Body.General.testigo')}.")
      end    
    end
  
  end
end



# == Schema Information
#
# Table name: solicitud_testigos
#
#  id             :integer         not null, primary key
#  solicitud_id   :integer         not null
#  nombre_testigo :text
#  cedula_testigo :text            not null
#

