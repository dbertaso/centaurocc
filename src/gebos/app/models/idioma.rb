# encoding: utf-8
class Idioma < ActiveRecord::Base

  self.table_name = 'idioma'
  
  attr_accessible   :id, 
                    :nombre, 
                    :bandera, 
                    :nemonico, 
                    :activo 
                    
  #validates_format_of :bandera, :with => %r{\.(png|jpg|jpeg|gif)$}i, :message => "Formato de archivo de bandera no permitido"
  

  def validates_upload_file(archivo,valor)
    
    begin
      transaction do
      name =  archivo.nil? ? nil : archivo[:datafile].original_filename.to_s
    if valor=="1"     
        
        unless name.nil? || name.empty?
          ext  =  name.to_s.downcase[(name.length - 4),name.length]
          unless (ext == '.png' || ext == '.jpg' || ext == '.jpeg' || ext == '.gif')            
            errors.add(:idioma, "#{I18n.t('Sistema.Body.Vistas.Idioma.Mensajes.error_archivo_bandera')}")            
            return true
          end
        end
      
      
    else
      unless name.nil? || name.empty?
          ext  =  name.to_s.downcase[(name.length - 4),name.length]
          if ext != '.yml'             
            errors.add(:idioma, "#{I18n.t('Sistema.Body.Vistas.Idioma.Mensajes.error_archivo_yml')}")            
            return true
          elsif recorrido(Idioma.find(:all),name)
            errors.add(:idioma, "#{I18n.t('Sistema.Body.Vistas.Idioma.Mensajes.error_archivo_nombre_yml')}")            
            return true
          end
        end
    end
    return false

    end # do transaction

    end  #begin

    
  end
  
  def recorrido(arreglo,nombre)
  arreglo.each{ |a|
  if a.nemonico+".yml" == nombre.to_s.downcase
    return false
  end
  }
  return true
  end
  
  
  def save_archivo(upload,ruta)
    begin
      transaction do
        name = upload['datafile'].original_filename.to_s
        directory = ruta
        # create the file path
        path = File.join(directory, name.to_s.downcase)
        # write the file
        File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
        #end
      end # do transaction
        rescue Exception => x
            errors.add(:idioma, I18n.t('Sistema.Body.Vistas.Idioma.Mensajes.error_carga_archivo'))            
        return false
    end  #begin
  return true
  end
  
  
  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end                  
                    
end

# == Schema Information
#
# Table name: idioma
#
#  id       :integer         not null, primary key
#  nombre   :string(200)
#  bandera  :string(200)
#  nemonico :string(2)
#  activo   :boolean
#

