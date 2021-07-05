# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::SucursalCasaProveedora
# descripción: Migración a Rails 3
#


class SucursalCasaProveedora < ActiveRecord::Base


  self.table_name = 'sucursal_casa_proveedora'

  attr_accessible :id,
				  :nombre,
				  :ciudad_id,
				  :parroquia_id,
				  :region_id,
				  :municipio_id,
				  :persona_contacto,
				  :email_persona_contacto,
				  :edificio,
				  :numero,
				  :casa_proveedora_id,
				  :avenida,
				  :urbanizacion,
				  :piso,
				  :telefono1,
				  :telefono2,
				  :telefono3,
				  :telefono4,
				  :tipo_telefono1,
				  :tipo_telefono2,
				  :tipo_telefono3,
				  :tipo_telefono4,
				  :es_express

  belongs_to :casa_proveedora 

  belongs_to :region
  belongs_to :ciudad
  belongs_to :municipio
  belongs_to :parroquia


  #validates_presence_of :casa_proveedora_id
  #validates_length_of :nombre, :within => 1..300, :allow_nil => false

  

  validates_presence_of :region_id, :message=> I18n.t('Sistema.Body.Vistas.General.region') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')
  validates_presence_of :ciudad_id, :message=>I18n.t('Sistema.Body.Vistas.General.ciudad') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')
  validates_presence_of :municipio_id, :message=>I18n.t('Sistema.Body.Vistas.General.municipio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
  validates_presence_of :parroquia_id, :message=> I18n.t('Sistema.Body.Vistas.General.parroquia') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')
  validates_presence_of :nombre, :message=>I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.la') << " " << I18n.t('Sistema.Body.Vistas.General.sucursal') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
  validates_presence_of :piso, :message=> I18n.t('Sistema.Body.Vistas.General.piso') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_requerido')
  validates_presence_of :persona_contacto, :message=>I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')

  
  validates_length_of :persona_contacto, :within => 4..150, :allow_nil => false,
  :too_long => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " <<  I18n.t('errors.messages.too_short').to_s
  
  
  validates_length_of :email_persona_contacto, :within => 0..50, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.email') << " " << I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.email') << " " << I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " <<  I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :edificio, :within => 0..50, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.edificio') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.edificio') << " " <<  I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :avenida, :within => 0..90, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.avenida') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.avenida') << " " << I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :urbanizacion, :within => 0..90, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.urbanizacion') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.urbanizacion') << " " << I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :telefono1, :within => 0..20, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.telefono') << " 1 " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.telefono') << " 1 " << I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :telefono2, :within => 0..20, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.telefono') << " 2 " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.telefono') << " 2 " << I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :telefono3, :within => 0..20, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.telefono') << " 3 " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.telefono') << " 3 " << I18n.t('errors.messages.too_short').to_s
  
  
  
  validates_length_of :telefono4, :within => 0..20, :allow_nil => true,
  :too_long => I18n.t('Sistema.Body.Vistas.General.telefono') << " 4 " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.telefono') << " 4 " << I18n.t('errors.messages.too_short').to_s  
  
  
  
  validates_length_of :piso, :within => 1..3, :allow_nil => false,
  :too_long => I18n.t('Sistema.Body.Vistas.General.piso') << " " << I18n.t('errors.messages.too_long').to_s,
  :too_short => I18n.t('Sistema.Body.Vistas.General.piso') << " " << I18n.t('errors.messages.too_short').to_s
  
  

validate :validate

before_destroy :before_destroy

  def before_destroy
    
    retorno = true    
    
    facturas_con_sucursal = FacturaOrdenDespacho.find_by_sucursal_casa_proveedora_id(self.id)    
    unless facturas_con_sucursal.nil?
      errors.add(:sucursal_casa_proveedora,I18n.t('Sistema.Body.Modelos.Errores.no_se_puede_eliminar_sucursal_casa_proveedora')) 
      retorno = false
    end
    
    return retorno
    
  end



def validate
    unless self.email_persona_contacto.nil? || self.email_persona_contacto.empty?
      result = self.email_persona_contacto[/^[0-9a-z_\-\.]+@[0-9a-z\-\.]+\.[a-z]{2,4}$/i]
      if result.nil?
        errors.add(:sucursal_casa_proveedora,I18n.t('Sistema.Body.Vistas.General.email') << " " << I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora, I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.la') << " " << I18n.t('Sistema.Body.Vistas.General.sucursal') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.persona_contacto.nil? || self.persona_contacto.empty?
      a = self.persona_contacto[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora,I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.urbanizacion.nil? || self.urbanizacion.empty?
      a = self.urbanizacion[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora, I18n.t('Sistema.Body.Vistas.General.urbanizacion')<< " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.avenida.nil? || self.avenida.empty?
      a = self.avenida[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora, I18n.t('Sistema.Body.Vistas.General.avenida') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.edificio.nil? || self.edificio.empty?
      a = self.edificio[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora, I18n.t('Sistema.Body.Vistas.General.edificio') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.numero.nil? || self.numero.empty?
      a = self.numero[/^[a-zA-Z0-9\-' ]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora,I18n.t('Sistema.Body.Vistas.General.numero') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.piso.nil? || self.piso.to_s.empty?
      a = self.piso[/^[0-9PphHbB]+$/]
      if a.nil?
        errors.add(:sucursal_casa_proveedora, I18n.t('Sistema.Body.Vistas.General.piso') << " "<< I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
  end



  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include => [:region]
  end






end



# == Schema Information
#
# Table name: sucursal_casa_proveedora
#
#  id                     :integer         not null, primary key
#  nombre                 :string(300)     not null
#  ciudad_id              :integer
#  parroquia_id           :integer
#  region_id              :integer
#  municipio_id           :integer
#  persona_contacto       :string(150)
#  email_persona_contacto :string(50)
#  edificio               :string(150)
#  numero                 :string(10)
#  casa_proveedora_id     :integer         not null
#  avenida                :string(90)
#  urbanizacion           :string(90)
#  piso                   :string(3)
#  telefono1              :string(20)
#  telefono2              :string(20)
#  telefono3              :string(20)
#  telefono4              :string(20)
#  tipo_telefono1         :string(1)       default("O")
#  tipo_telefono2         :string(1)       default("O")
#  tipo_telefono3         :string(1)       default("O")
#  tipo_telefono4         :string(1)       default("O")
#  es_express             :boolean         default(FALSE)
#

