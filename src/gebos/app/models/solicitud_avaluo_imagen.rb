# encoding: utf-8

class SolicitudAvaluoImagen < ActiveRecord::Base

  self.table_name = 'solicitud_avaluo_imagen'
  
  attr_accessible :id,
    :nombre_imagen,
    :nombre_real,
    :solicitud_tipo_garantia_id,
    :referencia 

  
  belongs_to :solicitud_tipo_garantia

  validates :solicitud_tipo_garantia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudTipoGarantia.Errores.solicitud_tipo_garantia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :nombre_imagen, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  

  validates :nombre_real, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluoImagen.Errores.nombre_real')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}  


  def validates_upload_file(archivo)
 
    name =  archivo.nil? ? nil : archivo[:datafile].original_filename.to_s
    
    unless name.nil? || name.empty?
      ext  =  name.to_s.downcase[(name.length - 4),name.length]
      unless (ext == '.png' || ext == '.jpg' || ext == '.jpeg' || ext == '.gif')            
        #CAMBIAR EL MENSAJE ESTA MALO
        errors.add(:solicitud_avaluo_imagen, "#{I18n.t('Sistema.Body.Vistas.GestionarGarantia.Mensajes.tipo_archivo_incorrecto')}")            
        return true
      end
    end

    return false
    
  end
  
  
  def save_archivo(upload, ruta, tipo_garantia_id)
   
    begin
      transaction do
        count = SolicitudAvaluoImagen.count("nombre_imagen = 'sol#{tipo_garantia_id}' and nombre_real = '#{upload['datafile'].original_filename.to_s}' and referencia = '#{upload['referencia'].to_s}'")
        solicitud_avaluo_imagen = SolicitudAvaluoImagen.new
        solicitud_avaluo_imagen.nombre_imagen = 'sol'+tipo_garantia_id
        solicitud_avaluo_imagen.nombre_real = upload['datafile'].original_filename.to_s
        solicitud_avaluo_imagen.referencia = upload['referencia'].to_s
        solicitud_avaluo_imagen.solicitud_tipo_garantia_id = tipo_garantia_id
        
        if solicitud_avaluo_imagen.save
          name = upload['datafile'].original_filename.to_s
          name = solicitud_avaluo_imagen.nombre_imagen.to_s+'.' + name
          directory = ruta
          # create the file path
          path = File.join(directory, name.to_s.downcase)
          # write the file
          File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
          #end
        
          return true
        else
          errores = ''
          unless solicitud_avaluo_imagen.nil?
            solicitud_avaluo_imagen.errors.full_messages.each{ |e|
              errores << "<li>" + e + "</li>"
            }
          end
          return errores
        end
      end # do transaction
      
    rescue Exception => x
      errors.add(:idioma, I18n.t('Sistema.Body.Vistas.Idioma.Mensajes.error_carga_archivo'))            
      return false
    end  #begin
    #return true
  end
  

  def self.crear_registro(nombre_imagen, nombre_real, solicitud_tipo_garantia_id,referencia)
    solicitud_avaluo_imagen = SolicitudAvaluoImagen.new
    solicitud_avaluo_imagen.nombre_imagen = nombre_imagen
    solicitud_avaluo_imagen.nombre_real = nombre_real
    solicitud_avaluo_imagen.referencia = referencia
    solicitud_avaluo_imagen.solicitud_tipo_garantia_id = solicitud_tipo_garantia_id
    if solicitud_avaluo_imagen.save
      return solicitud_avaluo_imagen.id
    else
      errores = ''
      unless solicitud_avaluo_imagen.nil?
        solicitud_avaluo_imagen.errors.full_messages.each{ |e|
          errores << "<li>" + e + "</li>"
        }
      end
      return errores
    end
  end

  def self.update_nombre_archivo(id, nombre_archivo)
    solicitud_avaluo_imagen = SolicitudAvaluoImagen.find(id)
    solicitud_avaluo_imagen.nombre_imagen = nombre_archivo
    solicitud_avaluo_imagen.save
  end

end


# == Schema Information
#
# Table name: solicitud_avaluo_imagen
#
#  id                         :integer         not null, primary key
#  nombre_imagen              :string(50)      not null
#  nombre_real                :string(100)     not null
#  solicitud_tipo_garantia_id :integer         not null
#  referencia                 :text
#

