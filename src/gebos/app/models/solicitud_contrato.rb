# encoding: utf-8

class SolicitudContrato < ActiveRecord::Base
  
  self.table_name = 'solicitud_contrato'
  
  attr_accessible :id,
  :solicitud_id,
  :fecha_recepcion,
  :fecha_notaria,
  :fecha_registro,
  :nombre_archivo
  
  #require 'ftools'
  
  belongs_to :solicitud
  
  validates_presence_of :solicitud_id,
    :message => " es requerido"

  validates_presence_of :nombre_archivo,
    :message => " Archivo es requerido"

  validates :fecha_registro, :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SolicitudContrato.Columnas.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates :fecha_notaria, :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SolicitudContrato.Columnas.fecha_notaria')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates :fecha_recepcion, :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.SolicitudContrato.Columnas.fecha_recepcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    self.fecha_registro.strftime('%d/%m/%Y') unless self.fecha_registro.nil?
  end

  def fecha_notaria_f=(fecha)
    self.fecha_notaria = fecha
  end

  def fecha_notaria_f
    self.fecha_notaria.strftime('%d/%m/%Y') unless self.fecha_notaria.nil?
  end

  def fecha_recepcion_f=(fecha)
    self.fecha_recepcion = fecha
  end

  def fecha_recepcion_f
    self.fecha_recepcion.strftime('%d/%m/%Y') unless self.fecha_recepcion.nil?
  end

  def validate
    logger.debug "SolicitudContrato.validate"
    begin
      #fecha de rec menor o igual a fecha del dia
      if  fecha_recepcion > Date.today
        errors.add('Fecha recepción', "debe ser menor o igual a la fecha actual")
      end

      if  fecha_notaria > Date.today
        errors.add('Fecha notaría', "debe ser menor o igual a la fecha actual")
      end

      #La fecha de notaria debe ser mayor o igual a la fecha de recepción.
      if  fecha_notaria > fecha_recepcion
        errors.add('Fecha notaría', "debe ser menor o igual a la de recepción")
      end

      #La fecha de registro mercantil es opcional. Sin embargo debe ser mayor o igual a la fecha de notaria.
      unless fecha_registro.nil?

        if  fecha_registro > Date.today
          errors.add('Fecha registro', "debe ser menor o igual a la fecha actual")
        end

        if  fecha_registro < fecha_notaria
          errors.add('Fecha registro', "debe ser mayor o igual a la de notaría")
        end
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      return false
    end
  end

  after_commit :generar
  
  def generar upload
    logger.debug 'SolicitudContrato.commit'
    transaction do
      success = true
      success &&= self.save_arch(upload, self.solicitud_id)
      success &&= self.save
    end
  end

#  def save_arch(archivo,solicitud_id)
#    logger.debug 'SolicitudContrato.save_arch'
#    name = archivo['datafile']
#    unless name.class.name == "String"
#      name = name.original_filename
#      ext  =  name[(name.length - 3),name.length].to_s.upcase
#      logger.debug 'Name ' << name.inspect
#      logger.debug 'Ext ' <<ext.inspect
#      if ext == 'PDF'
#        logger.debug 'Archivo pdf'
#        directory = "tmp"
#        path = File.join(directory, name)
#        File.open(path, "wb") { |f| f.write(archivo['datafile'].read) }
#        nombre_archivo = "contrato_" + solicitud_id.to_s + '.pdf'
#        File.mv("#{RAILS_ROOT}/tmp/#{name}", "#{RAILS_ROOT}/public/documentos/consultoria/contratos/#{nombre_archivo}")
#      else
#        logger.debug 'Archivo no es pdf'
#        errors.add('archivo', "El archivo no tiene el formato correcto (pdf)")
#        return false
#      end
#    end
#  end

end

# == Schema Information
#
# Table name: solicitud_contrato
#
#  id              :integer         not null, primary key
#  solicitud_id    :integer         not null
#  fecha_recepcion :date            not null
#  fecha_notaria   :date            not null
#  fecha_registro  :date
#  nombre_archivo  :text
#

