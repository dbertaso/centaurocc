# encoding: utf-8

#
# autor: Diego Bertaso
# clase: EmpresaTransporteMaquinaria
# descripción: Migración a Rails 3
#

class EmpresaTransporteMaquinaria < ActiveRecord::Base

  
  self.table_name = 'empresa_transporte_maquinaria'
  
  attr_accessible :id,
				  :nombre,
				  :direccion,
				  :telefono,
				  :rif,
				  :persona_contacto,
				  :activo,
				  :estado_id,
				  :ciudad_id,
				  :municipio_id,
				  :rif_1,
				  :rif_2,
				  :rif_3

  
  
  has_many :guia_movilizacion_maquinaria
  belongs_to :estado
  belongs_to :municipio
  belongs_to :ciudad 
  
  validates :estado_id, 
  :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.estado') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')  } 
  
  validates :municipio_id, 
  :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.municipio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}  
  
  validates :ciudad_id, 
    :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.ciudad') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')   }
    
  validates :telefono, 
  :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')  }  
  
  validates_uniqueness_of :nombre,
    :message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')  
  
  validates_length_of :direccion, :within => 10..250, :allow_nil => false,
    :too_long => I18n.t('Sistema.Body.General.direccion')  << " " << I18n.t('errors.messages.too_long.other'),
    :too_short => I18n.t('Sistema.Body.General.direccion') << " " << I18n.t('errors.messages.too_short.other')
  
  validates_length_of :nombre, :within => 10..60, :allow_nil => false,
    :too_long => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_long.other'),
    :too_short => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_short.other')
  
  validates_length_of :persona_contacto, :within => 10..60, :allow_nil => false,
    :too_short => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_short.other'),
    :too_long => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_long.other')      
  
  validates_uniqueness_of :rif,
    :message => I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')  
  
  after_initialize :init
  
  def init
    self.activo = true
  end
  
  def rif_1=(valor)
    @rif_1 = valor
  end

  def rif_1
    unless self.rif.nil?
      self.rif.slice(0,1)
    end
  end


  def rif_2=(valor)
    @rif_2 = valor
  end

  def rif_2
    unless self.rif.nil?
      self.rif.slice(2,8)
    end
  end

  def rif_3=(valor)
    @rif_3 = valor
  end

  def rif_3
    unless self.rif.nil?
      self.rif.slice(11,1)
    end
  end

  def valida_rif
    resultado = true
    rif1 = @rif_1 
    rif2 = @rif_2 
    rif3 = @rif_3
    if rif1 == 'V' || rif1 == "J" || rif1 == 'E' || rif1 == 'P' || rif1 == 'G'
      rif8 = ""
      if rif1 == 'V'
        rif8 = "1" << rif2
      end
      if rif1 == "E"
        rif8 = "2" << rif2
      end
      if rif1 == "J"
        rif8 = "3" << rif2
      end
      if rif1 == "P"
        rif8 = "4" << rif2
      end
      if rif1 == "G"
        rif8 = "5" << rif2
      end
      suma = (rif8[8,1].to_i * 2) + (rif8[7,1].to_i * 3) + (rif8[6,1].to_i * 4) + (rif8[5,1].to_i * 5) +
        (rif8[4,1].to_i * 6) + (rif8[3,1].to_i * 7) + (rif8[2,1].to_i * 2) + (rif8[1,1].to_i * 3)  +
        (rif8[0,1].to_i * 4)
      division = suma / 11
      resto = suma - (division.to_i * 11)
      digito = 0
      if resto > 0
        digito = 11 - resto
      else
        digito
      end
      if digito == 10
        digito = 0
      end
      if digito != rif3.to_i
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
        resultado = false
      end
    else
      errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      resultado = false
    end
    return resultado
  end

  before_validation :preparar_rifs

  def preparar_rifs
    self.rif = @rif_1 + '-' + @rif_2 + '-' + @rif_3
    nombre = eliminar_acentos(self.nombre)
    self.nombre = nombre.upcase
    persona_contacto = eliminar_acentos(self.persona_contacto)
    self.persona_contacto = persona_contacto.upcase
  end
  
  validate :validate
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-Z0-9ñÑáÁéÉíÍóÓúÚüÜÇ'., ]+$/]
      if a.nil?
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.direccion.nil? || self.direccion.empty?
      a = self.direccion[/^[a-zA-Z0-9ñÑáÁéÉíÍóÓúÚüÜÇ',. ]+$/]
      if a.nil?
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.General.direccion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.persona_contacto.nil? || self.persona_contacto.empty?
      a = self.persona_contacto[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.telefono.nil? || self.telefono.empty?
      a = self.telefono[/^[0-9]+$/]
      if a.nil?
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Vistas.General.telefono') <<  " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    if (rif =~ /^[J,N,T,V,G][\-]\d{8}[\-]\d$/).nil?
      errors.add(:empresa_transporte_maquinaria,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
    else
      valida_rif
    end
    
  end

  def eliminar(id)
    
    begin
      guia_movilizacion_catalogo = GuiaMovilizacionMaquinaria.count(:conditions=>"empresa_transporte_maquinaria_id = #{id}")      
      if guia_movilizacion_catalogo > 0
        errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Controladores.EmpresaTransporteMaquinaria.FormTitles.form_title_record') << " " << I18n.t('Sistema.Body.Modelos.Configurador.Errores.no_eliminado') )
        return false
      else
        empresa_transporte_maquinaria = EmpresaTransporteMaquinaria.find(id)
        transaction do
          empresa_transporte_maquinaria.destroy
          return true
        end
      end
    rescue
      errors.add(:empresa_transporte_maquinaria, I18n.t('Sistema.Body.Modelos.AlmacenMaquinaria.Errores.item_utilizado'))
      return false
    end
  end
  
  def eliminar_acentos(nombre)
    nombre = nombre.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre
  end
  
  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include=>[:estado,:municipio,:ciudad]
  end
  
  
end


# == Schema Information
#
# Table name: empresa_transporte_maquinaria
#
#  id               :integer         not null, primary key
#  nombre           :string(100)
#  direccion        :string(250)
#  telefono         :string(11)
#  rif              :string(15)
#  persona_contacto :string(60)
#  activo           :boolean
#  estado_id        :integer
#  ciudad_id        :integer
#  municipio_id     :integer
#

