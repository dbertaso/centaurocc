# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Basico::CasaProveedora
# descripción: Migración a Rails 3
#
class CasaProveedora < ActiveRecord::Base
  
  self.table_name = 'casa_proveedora'
  
  attr_accessible  :nombre,
				   :rif,
				   :descripcion,
				   :persona_contacto,
				   :email_contacto,
				   :enlace_internet,
				   :telefono_oficina,
				   :telefono_celular,
				   :telefono_fax,
				   :codigo_postal,
				   :avenida,
				   :edificio,
				   :piso,
				   :numero,
				   :activo,
				   :ciudad_id,
				   :municipio_id,
				   :parroquia_id,
				   :tipo_pago,
				   :tipo_cuenta,
				   :numero_cuenta,
				   :fecha_convenio,
				   :estado_id,
				   :entidad_financiera_id,
				   :anticipo,
				   :pagos,
				   :disponible,
				   :pago_contra_anticipo_id,
				   :fecha_convenio_f               
  
  has_many :sucursal_casa_proveedora
  has_many :proforma
  
  belongs_to :estado
  belongs_to :cuidad
  belongs_to :municipio  
  belongs_to :parroquia
  belongs_to :entidad_financiera
  
  
  validates :municipio_id, 
   :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.municipio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates :ciudad_id, 
      :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.ciudad') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates :parroquia_id, 
   :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.parroquia') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validates  :rif, 
    :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}, 
    :uniqueness => {:message=> I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')} 
  
  validates :telefono_oficina,
    :presence => { :message => I18n.t('Sistema.Body.Vistas.General.telefono')<<" "<<I18n.t('Sistema.Body.Vistas.General.oficina') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates :codigo_postal, 
   :presence => {:message => I18n.t('Sistema.Body.Vistas.General.codigo') << " " << I18n.t('Sistema.Body.Vistas.General.postal') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates :tipo_pago, 
   :presence => {:message => I18n.t('Sistema.Body.Vistas.General.forma') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.pago') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates :descripcion, 
   :presence => {:message=> I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates :avenida, 
    :presence => {:message=> I18n.t('Sistema.Body.Vistas.General.avenida') << " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validates_numericality_of :anticipo, :message => I18n.t('Sistema.Body.Vistas.Form.anticipo') << " " << I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')

  validates_inclusion_of :anticipo, :in => 0..1000000000, :message => I18n.t('Sistema.Body.Vistas.General.anticipo') << " " << I18n.t('Sistema.Body.Modelos.CasaProveedora.Errores.rango_anticipo')  
  
  validates_length_of :persona_contacto, :within => 6..100, :allow_nil => false,
   :too_long => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_long.other'),
   :too_short => I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('errors.messages.too_short.other')  

  validates_length_of :nombre, :within => 6..100, :allow_nil => false,
   :too_long => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_long.other'),
   :too_short => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('errors.messages.too_short.other')    

  validates_length_of :numero_cuenta, :is => 20, :if => Proc.new{|o| o.tipo_pago.to_i==1 }, :message => I18n.t('Sistema.Body.Vistas.General.nro') << " " << I18n.t('Sistema.Body.Vistas.General.cuenta') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida')

  validates_presence_of :entidad_financiera_id, :if => Proc.new{|o| o.tipo_pago.to_i==1 }, :message => I18n.t('Sistema.Body.Vistas.General.banco') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_presence_of :tipo_cuenta, :if => Proc.new{|o| o.tipo_pago.to_i==1 }, :message=> I18n.t('Sistema.Body.Vistas.General.tipo') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.cuenta') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')  
  

# validacion para la fecha, cuando permite nil, en caso contrario hay que quitarle a la expresion regular en * con sus respectivos parentisis
  

#(\d){4}\-(\d){1,2}\-(\d){1,2}

  validates :fecha_convenio, 
	:length =>{:in => 10..10, :allow_blank=>true, :message => "sssss #{I18n.t('Sistema.Body.Vistas.Form.fecha')}  #{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"},
    :format => {:with => /^(\d){4}\-(\d){1,2}\-(\d){1,2}$/, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')}  #{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"} 

  validate :validate    

  def fecha_convenio_f=(fecha)
    self.fecha_convenio = fecha
  end

  def fecha_convenio_f
    format_fecha(self.fecha_convenio)    
  end

  def validate
    unless self.email_contacto.nil? || self.email_contacto.empty?
      result = self.email_contacto[/^[0-9a-z_\-\.]+@[0-9a-z\-\.]+\.[a-z]{2,4}$/i]
      if result.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.email')<< " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.persona_contacto.nil? || self.persona_contacto.empty?
      a = self.persona_contacto[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.persona') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.rif.nil? || self.rif.empty?
      self.valida_rif(self.rif)
    end
    unless self.descripcion.nil? || self.descripcion.empty?
      a = self.descripcion[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    
    unless self.avenida.nil? || self.avenida.empty?
      a = self.avenida[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.avenida') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end    
    unless self.edificio.nil? || self.edificio.empty?
      a = self.edificio[/^[0-9a-zA-Z°;:,.\/ñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.edificio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.numero.nil? || self.numero.empty?
      a = self.numero[/^[a-zA-Z0-9\-' ]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.piso.nil? || self.piso.to_s.empty?
      a = self.piso[/^[0-9PphHbB]+$/]
      if a.nil?
        errors.add(:casa_proveedora, I18n.t('Sistema.Body.Vistas.General.piso') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
  end
  
  def valida_rif(rif)
    if rif.length == 12
      rif1 = rif[0,1]
      rif2 = rif[2,8]
      rif3 = rif[11,1]

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
          errors.add(:casa_proveedora,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
        end
      else
        errors.add(:casa_proveedora,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    else
      errors.add(:casa_proveedora,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
    end
  end
  
  
  before_destroy :check_for_sucursal
  
  def check_for_sucursal
    
    retorno = true
    
    sucursal = SucursalCasaProveedora.find_by_casa_proveedora_id(self.id)    
    unless sucursal.nil?
      errors.add(:casa_proveedora,I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title') << " " << I18n.t('Sistema.Body.Modelos.Errores.usado_sucursal')) 
      retorno = false
    end
    
    facturas_con_casa = FacturaOrdenDespacho.find_by_casa_proveedora_id(self.id)    
    unless facturas_con_casa.nil?
      errors.add(:casa_proveedora,I18n.t('Sistema.Body.Controladores.CasaProveedora.FormTitles.form_title') << " " << I18n.t('Sistema.Body.Modelos.Errores.no_se_puede_eliminar_casa_proveedora')) 
      retorno = false
    end
    
    
    
    # Esto detiene el destroy del form_controller. Ejm: tratar de eliminar una embarcacion que tiene motores, artes de pesca, equipos de seguridad, faenas de pesca.
    return retorno
    
  end

  
  
  
  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include => [:estado]
  end
  
end

# == Schema Information
#
# Table name: casa_proveedora
#
#  id                      :integer         not null, primary key
#  nombre                  :string(100)     not null
#  rif                     :string(20)      not null
#  descripcion             :string(300)
#  persona_contacto        :string(100)     not null
#  email_contacto          :string(100)
#  enlace_internet         :string(100)
#  telefono_oficina        :string(12)      not null
#  telefono_celular        :string(12)
#  telefono_fax            :string(12)
#  codigo_postal           :string(8)       not null
#  avenida                 :string(300)     not null
#  edificio                :string(100)
#  piso                    :string(3)
#  numero                  :string(10)
#  activo                  :boolean         default(TRUE)
#  ciudad_id               :integer         not null
#  municipio_id            :integer         not null
#  parroquia_id            :integer         not null
#  tipo_pago               :string(1)       not null
#  tipo_cuenta             :string(1)
#  numero_cuenta           :string(20)
#  fecha_convenio          :date
#  estado_id               :integer
#  entidad_financiera_id   :integer
#  anticipo                :decimal(16, 2)  default(0.0)
#  pagos                   :decimal(16, 2)  default(0.0)
#  disponible              :decimal(16, 2)  default(0.0)
#  pago_contra_anticipo_id :integer
#

