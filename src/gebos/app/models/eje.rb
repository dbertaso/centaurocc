# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::Eje
# descripción: Migración a Rails 3
#


class Eje < ActiveRecord::Base

  self.table_name = 'eje'
  
  attr_accessible :id,
				  :nombre


  has_many :municipio

      
validates :nombre, 
  :uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')},
  :presence=>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  
  validate :validate
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(nil, "Nombre es inválido")
      end
    end 
  end 

  
  before_destroy :check_for_municipio
  
  def check_for_municipio
    
    retorno = true   
    
    municipio = Municipio.find_by_eje_id(self.id)    
    unless municipio.nil?
      errors.add(:eje,I18n.t('Sistema.Body.Controladores.Eje.Mensajes.no_se_puede_eliminar_eje')) 
      retorno = false
    end



    return retorno
    
  end



  def after_delete
     redirect_to_index()
  end


  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end


end

# == Schema Information
#
# Table name: eje
#
#  id     :integer         not null, primary key
#  nombre :string(100)
#

