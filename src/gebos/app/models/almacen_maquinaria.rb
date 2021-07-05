# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AlmacenMaquinaria
# descripción: Migración a Rails 3
#

class AlmacenMaquinaria < ActiveRecord::Base

  self.table_name = 'almacen_maquinaria'

  attr_accessible :id,
                  :nombre,
                  :direccion,
                  :telefono_1,
                  :telefono_2,
                  :persona_contacto,
                  :rif,
                  :activo,
                  :estado_id,
                  :ciudad_id,
                  :municipio_id,
                  :rif_1,
                  :rif_2,
                  :rif_3

  has_many :catalogo
  belongs_to :estado
  belongs_to :municipio
  belongs_to :ciudad

  validates  :nombre,
    :presence => { :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_apellido_requerido')}

  validates :direccion,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates  :telefono_1,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} 1 #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :persona_contacto,
    :presence => { :message => "#{I18n.t('Sistema.Body.General.persona')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.contacto')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  validates :estado_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :municipio_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :ciudad_id,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}"}

  

  validates :nombre,
    :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates_length_of :direccion, :within => 0..250, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('es.errors.message.too_long')}",
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('es.errors.message.too_short')}"

  validates_length_of :nombre, :within => 0..60, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('es.errors.message.too_long')}",
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('es.errors.message.too_short')}"


  validates_length_of :persona_contacto, :within => 0..60, :allow_nil => false,
    :too_long => "#{I18n.t('Sistema.Body.General.persona')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.contacto')} #{I18n.t('es.errors.message.too_long')}",
    :too_short => "#{I18n.t('Sistema.Body.General.persona')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.contacto')} #{I18n.t('es.errors.message.too_short')}"

  

  validates_uniqueness_of :rif,
    :message => I18n.t('Sistema.Body.Modelos.Errores.ya_existe')


  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end

  after_initialize :initi

  def initi
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
        errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
        resultado = false
      end
    else
      errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
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
        errors.add(:almacen_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.nombre_apellido_invalido'))
      end
    end
    unless self.direccion.nil? || self.direccion.empty?
      a = self.direccion[/^[a-zA-Z0-9ñÑáÁéÉíÍóÓúÚüÜÇ',. ]+$/]
      if a.nil?
        errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.General.direccion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.persona_contacto.nil? || self.persona_contacto.empty?
      a = self.persona_contacto[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:almacen_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.persona_contacto_invalida'))
      end
    end
    unless self.telefono_1.nil? || self.telefono_1.empty?
      a = self.telefono_1[/^[0-9]+$/]
      if a.nil?
        errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.Vistas.General.telefono')<< " 1 " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.telefono_2.nil? || self.telefono_2.empty?
      a = self.telefono_2[/^[0-9]+$/]
      if a.nil?
        errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.Vistas.General.telefono') << " 2 " <<I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    if (rif =~ /^[J,N,T,V,G][\-]\d{8}[\-]\d$/).nil?
      errors.add(:almacen_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.rif_invalido') << ", " << I18n.t('Sistema.Body.Modelos.Errores.formato_rif_invalido'))
    else
      valida_rif
    end
    
  end

  def eliminar(id)
    begin
      catalogo = Catalogo.count(:conditions=>"almacen_maquinaria_id = #{id}")
      logger.info "Catalogo ========> #{catalogo.inspect}"
      if catalogo > 0
        errors.add(:almacen_maquinaria,I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title_record') << " " << I18n.t('Sistema.Body.Modelos.Errores.usado_catalogo'))
        return false
      else
        almacen_maquinaria = AlmacenMaquinaria.find(id)
        transaction do
          almacen_maquinaria.destroy
          return true
        end
      end
    rescue
      errors.add(:almacen_maquinaria, I18n.t('Sistema.Body.Controladores.AlmacenMaquinaria.FormTitles.form_title_record') << " " <<I18n.t('Sistema.Body.Modelos.Errores.usado'))
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


end

# == Schema Information
#
# Table name: almacen_maquinaria
#
#  id                            :integer         not null, primary key
#  nombre                        :string(60)
#  direccion                     :string(250)
#  telefono_1                    :string(11)
#  telefono_2                    :string(11)
#  persona_contacto              :string(60)
#  rif                           :string(15)
#  activo                        :boolean
#  estado_id                     :integer
#  ciudad_id                     :integer
#  municipio_id                  :integer
#  contrato_maquinaria_equipo_id :integer
#

