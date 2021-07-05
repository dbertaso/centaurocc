# encoding: UTF-8

class Region < ActiveRecord::Base

  self.table_name = 'region'
  
  attr_accessible :id,
				  :pais_id,
				  :nombre
				  
  belongs_to :pais
  has_many :estado
  has_many :solicitud
  has_many :sucursal_casa_proveedora

        
  validates :nombre, 
    :uniqueness =>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')},
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
    
  
  validates :pais_id, 
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.pais') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}


  before_destroy :check_for_estado
  
  def check_for_estado
    
    retorno = true
    
    estado = Estado.find_by_region_id(self.id)    
    unless estado.nil?
      errors.add(:region,I18n.t('Sistema.Body.Controladores.Region.Mensajes.no_se_puede_eliminar_region')) 
      retorno = false
    end
    
    
    return retorno
    
  end


  validate :validate
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:region, I18n.t('Sistema.Body.Modelos.Actividad.Errores.nombre_invalido'))
      end
    end 
  end
  
  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end

# == Schema Information
#
# Table name: region
#
#  id      :integer         not null, primary key
#  pais_id :integer         not null
#  nombre  :string(40)      not null
#

