# encoding: utf-8

#
# 
# clase: RecepcionMaquinaria
# descripción: Migración a Rails 3
#

class RecepcionMaquinaria < ActiveRecord::Base

  belongs_to :guia_movilizacion_maquinaria
  belongs_to :usuario
  belongs_to :oficina
  
    self.table_name = 'recepcion_maquinaria'
  
    attr_accessible :id,
                    :guia_movilizacion_maquinaria_id,
                    :cedula_receptor,
                    :fecha_recepcion,
                    :fecha_ingreso,
                    :oficina_id,
                    :observaciones,
                    :usuario_id,
                    :nombe_receptor,
                    :telefono_receptor, 
                    :fecha_recepcion_f, 
                    :hora_llegada, 
                    :hora_llegada_ampm

  
  
  validates :cedula_receptor,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"},
  :numericality =>{:only_integer => true,:allow_nil => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_solo_numeros_sin_decimales')}"}
    
  validates :observaciones,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.observaciones')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
      
  validates :nombe_receptor,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates :telefono_receptor,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
  :numericality =>{:only_integer => true,:allow_nil => true, :message =>"#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Solicitud.Errores.debe_contener_solo_numeros_sin_decimales')}"}
      
  def fecha_recepcion_f=(fecha)
    self.fecha_recepcion = fecha
  end

  def fecha_recepcion_f
    format_fecha(self.fecha_recepcion)
  end
  
  
  def save_new(guia_id, params, oficina_id, usuario_id, error)
    begin
      if error.length > 0
        errors.add(:recepcion_maquinaria, error)
        return false
      end
      guia_catalogo = GuiaCatalogo.find(:all, :conditions => "guia_movilizacion_maquinaria_id = #{guia_id}")
      transaction do
        self.guia_movilizacion_maquinaria_id = guia_id
        self.usuario_id = usuario_id
        self.oficina_id = oficina_id
        self.fecha_recepcion = Time.now
        self.save!
        guia_catalogo.each {|c|
          c.conforme = params[:guia_catalogo]["id_" + c.catalogo_id.to_s]
          c.save!
        }
        return true
      end
      rescue
        return false
    end
  end
  
  def save_edit(params, usuario_id, error)
    begin
      if error.length > 0
        errors.add(:recepcion_maquinaria, error)
        return false
      end
      self.usuario_id = usuario_id
      self.cedula_receptor = params[:recepcion_maquinaria][:cedula_receptor].to_s
      self.nombe_receptor = params[:recepcion_maquinaria][:nombe_receptor].to_s
      self.telefono_receptor = params[:recepcion_maquinaria][:telefono_receptor].to_s
      self.fecha_recepcion_f = params[:recepcion_maquinaria][:fecha_recepcion_f]
      self.hora_llegada = params[:recepcion_maquinaria][:hora_llegada]
      self.hora_llegada_ampm = params[:recepcion_maquinaria][:hora_llegada_ampm]
      self.observaciones = params[:recepcion_maquinaria][:observaciones].to_s
      self.save!
      guia_catalogo = GuiaCatalogo.find(:all, :conditions => "guia_movilizacion_maquinaria_id = #{self.guia_movilizacion_maquinaria_id}")
      transaction do
        guia_catalogo.each {|c|
          c.conforme = params[:guia_catalogo]["id_" + c.catalogo_id.to_s]
          c.save!
        }
        return true
      end
      rescue
        return false
    end
  end
  
end

# == Schema Information
#
# Table name: recepcion_maquinaria
#
#  id                              :integer         not null, primary key
#  guia_movilizacion_maquinaria_id :integer
#  cedula_receptor                 :string(8)
#  fecha_recepcion                 :date            not null
#  fecha_ingreso                   :date
#  oficina_id                      :integer         not null
#  observaciones                   :text
#  usuario_id                      :integer
#  nombe_receptor                  :string(100)     not null
#  telefono_receptor               :string(11)      not null
#  hora_llegada                    :string(5)
#  hora_llegada_ampm               :string(2)
#

