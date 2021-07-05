# encoding: utf-8
class Embarcacion < ActiveRecord::Base

  self.table_name = 'embarcacion'

  attr_accessible :id,
    :nombre_embarcacion,
    :matricula,
    :tipo_embarcacion_id,
    :tipo_material_id,
    :es_propia,
    :eslora,
    :manga,
    :puntal,
    :cantidad_tripulantes,
    :uab,
    :autonomia_pesca,
    :proveedor_marino_id,
    :solicitud_id,
    :seguimiento_visita_id,
    :puerto_base,
    :condicion,
    :coordenadas_utm_puerto_base,
    :capacidad_combustible,
    :lugares_pesca,
    :estado_id,
    :municipio_id,
    :parroquia_id,
    :eslora_f, :manga_f, :puntal_f, :uab_f

  belongs_to :solicitud
  belongs_to :seguimiento_visita
  belongs_to :proveedor_marino
  belongs_to :motores
  belongs_to :tipo_material
  belongs_to :tipo_embarcacion
  belongs_to :estado
  belongs_to :municipio
  belongs_to :parroquia
  has_many :motores
  has_many :arte_pesca
  has_many :equipo_seguridad
  has_many :faenas_pesca

  
  validates :es_propia, :inclusion =>{:in=>[true, false], 
    :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.propia_si_no')}
  
  validates :nombre_embarcacion, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.nombre_embarcacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..120, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.nombre_embarcacion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.nombre_embarcacion')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :matricula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.matricula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.matricula')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.matricula')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :eslora, :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.eslora_numerico') }#,
#    :inclusion => { :in => 5..20, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.eslora')} #{I18n.t('errors.messages.inclusion')}"}

  validates :puntal, :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.puntal_numerico') }#,
#    :inclusion => { :in => 0..20, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.puntal')} #{I18n.t('errors.messages.inclusion')}"} 

  validates :manga, :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.manga_numerico') }#,
#    :inclusion => { :in => 0..20, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.manga')} #{I18n.t('errors.messages.inclusion')}"}

  validates :tipo_embarcacion_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.tipo_embarcacion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_material_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.tipo_material')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cantidad_tripulantes, :numericality =>{:numericality => true, :only_integer =>true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.cantidad_tripulante_numerico') }#,
#    :inclusion => { :in => 1..1000, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.cantidad_tripulante')} #{I18n.t('errors.messages.inclusion')}"}

  validates :autonomia_pesca, :numericality =>{:numericality => true, :only_integer =>true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.autonomia_pesca_nemurico') }#,
#    :inclusion => { :in => 1..10000, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.autonomia_pesca')} #{I18n.t('errors.messages.inclusion')}"}

  validates :estado_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :municipio_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
   
  validates :parroquia_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.parroquia')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :capacidad_combustible, :numericality =>{:numericality => true, :only_integer =>true, :message => I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.capacidad_combustible_numerico') }
    
  validates :condicion, :length => { :in => 3..20, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.condicion')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :puerto_base, :length => { :in => 1..180, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.puerto_base')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.puerto_base')}  #{I18n.t('errors.messages.too_long.other')}"}
  
  validates :coordenadas_utm_puerto_base, :length => { :in => 1..80, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Embarcacion.Columnas.coordenadas_utm_puerto_base')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Embarcacion.Columnas.coordenadas_utm_puerto_base')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :lugares_pesca, :length => { :in => 1..120, :allow_blank => false,
    :too_short => "#{I18n.t('Sistema.Body.Embarcacion.Columnas.lugares_pesca')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Embarcacion.Columnas.lugares_pesca')}  #{I18n.t('errors.messages.too_long.other')}"}

  validates :capacidad_combustible, :inclusion =>{:in=>1..10000, :message => "#{I18n.t('Sistema.Body.Modelos.Embarcacion.Columnas.capacidad_combustible')} #{I18n.t('errors.messages.inclusion')}"}
  
  #FIN BLOQUE VALIDACION#
  def eslora_f=(valor)
    self.eslora = format_valor(valor)
  end

  def eslora_f
    format_f(self.eslora)
  end

  def eslora_fm
    format_fm(self.eslora)
  end

  def manga_f=(valor)
    self.manga = format_valor(valor)
  end

  def manga_f
    format_f(self.manga)
  end

  def manga_fm
    format_fm(self.manga)
  end

  def puntal_f=(valor)
    self.puntal = format_valor(valor)
  end

  def puntal_f
    format_f(self.puntal)
  end
  
  def puntal_fm
    format_fm(self.puntal)
  end
    
  def uab_f=(valor)
    self.uab = format_valor(valor)
  end
  
  def uab_f
    format_f(self.uab)
  end
  
  def uab_fm
    format_fm(self.uab)
  end

  #Esto es una validacion para los nuevos formularios

  def capacidad_combustible_f=(valor)
    self.capacidad_combustible = format_valor(valor)
  end

  def capacidad_combustible_f
    format_f(self.capacidad_combustible)
  end

  def capacidad_combustible_fm
    format_fm(self.capacidad_combustible)
  end

  before_create :crear

  #def before_create
  def crear

    retorno = true
    
    nombres = Embarcacion.find_by_nombre_embarcacion(self.nombre_embarcacion)
    
    unless nombres.nil?
     
      errors.add(:embarcacion, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.nombre_embarcacion_existe'))
      retorno = false
     
    end
    
    matriculas = Embarcacion.find_by_matricula(self.matricula)
    
    unless matriculas.nil?
      if matriculas.matricula!="#{I18n.t('Sistema.Body.Controladores.Embarcacion.Etiquetas.no_aplica')}"
        errors.add(:embarcacion, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.matricula_existe'))
        retorno = false
      end
    end

    return retorno

  end


  before_destroy :eliminar
  #def before_destroy
  
  def eliminar  
    retorno = true
    motores = Motores.find_by_embarcacion_id(self.id)
    unless motores.nil?
      errors.add(:motores, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.embarcacion_contiene_motor'))
      retorno = false
    end
    
    arte_pesca = ArtePesca.find_by_embarcacion_id(self.id)
    unless arte_pesca.nil?
      errors.add(:arte_pesca, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.embarcacion_contiene_arte'))
      retorno = false
    end
    
    equipo_seguridad = EquipoSeguridad.find_by_embarcacion_id(self.id)
    unless equipo_seguridad.nil?
      errors.add(:equipo_seguridad, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.embarcacion_contiene_equipo_seguridad'))
      retorno = false
    end
    
    faenas_pesca = FaenasPesca.find_by_embarcacion_id(self.id)
    unless faenas_pesca.nil?
      errors.add(:faena_pesca, I18n.t('Sistema.Body.Modelos.Embarcacion.Errores.embarcacion_contiene_faena'))
      retorno = false
    end
    # Esto detiene el destroy del form_controller. Ejm: tratar de eliminar una embarcacion que tiene motores, artes de pesca, equipos de seguridad, faenas de pesca.
    return retorno
  end
  

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'*'
  end

end




# == Schema Information
#
# Table name: embarcacion
#
#  id                          :integer         not null, primary key
#  nombre_embarcacion          :string(120)
#  matricula                   :string(20)
#  tipo_embarcacion_id         :integer
#  tipo_material_id            :integer
#  es_propia                   :boolean
#  eslora                      :decimal(16, 2)
#  manga                       :decimal(16, 2)
#  puntal                      :decimal(16, 2)
#  cantidad_tripulantes        :integer
#  uab                         :decimal(16, 2)
#  autonomia_pesca             :integer
#  proveedor_marino_id         :integer
#  solicitud_id                :integer
#  seguimiento_visita_id       :integer
#  puerto_base                 :string(180)
#  condicion                   :string(20)
#  coordenadas_utm_puerto_base :string(80)
#  capacidad_combustible       :float
#  lugares_pesca               :string(120)
#  estado_id                   :integer
#  municipio_id                :integer
#  parroquia_id                :integer
#

