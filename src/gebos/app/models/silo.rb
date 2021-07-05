# encoding: utf-8
class Silo < ActiveRecord::Base
  
  self.table_name = 'silo'
  
  attr_accessible :id,
    :direccion,
    :estado_id,
    :ciudad_id,
    :municipio_id,
    :persona_contacto,
    :telefono,
    :fax,
    :activo,
    :fecha_registro,
    :rif,
    :nombre,
    :nro_acta,
    :fecha_modificacion,
    :rif_1,
    :rif_2,
    :rif_3,
    :convenio


  belongs_to :estado
  belongs_to :ciudad
  belongs_to :municipio
  has_many :empleado_silo
  has_many :desvio_silo
  
  validates :nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..45, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_puntuacion')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.nombre_invalido')}
 
  validates :direccion, :presence => {
    :message => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..200, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :estado_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :ciudad_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :persona_contacto, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.persona')} #{I18n.t('Sistema.Body.Vistas.General.contacto')} 
                    #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..60, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.General.direccion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.General.direccion')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.General.validar_nombre')}/, :allow_blank =>true, 
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.persona_contacto_invalida')} 
                          #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :telefono, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => "
             #{I18n.t('Sistema.Body.Vistas.General.telefono')} #{I18n.t('Sistema.Body.Modelos.Errores.telefono_sin_decimales')}" },
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_telefono_multi')}/,
    :message => I18n.t('Sistema.Body.Modelos.Errores.telefono_invalido')}
  
  validates :rif_1, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.letra_rif')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :rif_2, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.numero_rif')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :rif_3, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Errores.numero_rif')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates_uniqueness_of :rif,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"
  
  validate :validacion_silo
  
  validate :before_validation
  

  def after_initialize
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
        errors.add(:silo, I18n.t('Sistema.Body.Modelos.Errores.formato_rif_invalido'))
        resultado = false
      end
    else
      errors.add(:silo, I18n.t('Sistema.Body.Modelos.Errores.formato_rif_invalido'))
      resultado = false
    end
    return resultado
  end

  ## Esto no Funciona en Rails 3. Adecuar segun Version
  def before_validation
    self.rif = @rif_1 + '-' + @rif_2 + '-' + @rif_3
  end

  before_save :before_save
  
  def before_save
    unless self.id.nil?
      self.fecha_modificacion = Time.now.strftime("%Y-%m-%d")
    end
  end

  def validacion_silo
    unless self.fax.nil? || self.fax.empty?
      a = self.fax[/#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_telefono_habitacion')}/]
      if a.nil?
        errors.add(:silo, I18n.t('Sistema.Body.Modelos.Errores.fax_invalido'))
      end
    end
    if (rif =~ /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/).nil?
      errors.add(:silo,I18n.t('Sistema.body.Modelos.Errores.formato_rif_invalido'))
    end
    valida_rif
  end

  def eliminar(id)
    begin
      silo = Silo.find(id)
      transaction do
        silo.destroy
        return true
      end
    rescue
      errors.add(:silo, I18n.t('Sistema.Body.Modelos.Errores.item_utilizado'))
      return false
    end
  end
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  


end


# == Schema Information
#
# Table name: silo
#
#  id                 :integer         not null, primary key
#  direccion          :text
#  estado_id          :integer
#  ciudad_id          :integer
#  municipio_id       :integer
#  persona_contacto   :string(60)
#  telefono           :string(15)
#  fax                :string(15)
#  activo             :boolean
#  fecha_registro     :date
#  rif                :string(15)
#  nombre             :string(45)
#  nro_acta           :integer         default(0)
#  fecha_modificacion :date
#  convenio           :boolean         default(FALSE)
#

