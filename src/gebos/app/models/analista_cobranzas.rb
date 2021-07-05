# encoding: utf-8

#
# autor: Diego Bertaso
# clase: AnalistaCobranzas
# creado con Rails 3
#
class AnalistaCobranzas < ActiveRecord::Base

  self.table_name = 'analista_cobranzas'

  attr_accessible :id,
                  :usuario_id,
                  :estatus,
                  :senal_supervisor,
                  :sector_id,
                  :sub_sector_id,
                  :rubro_id,
                  :sub_rubro_id,
                  :actividad_id,
                  :primer_nombre,
                  :segundo_nombre,
                  :primer_apellido,
                  :segundo_apellido,
                  :letra_cedula,
                  :cedula,
                  :cantidad_cobranzas,
                  :carga_trabajo


  has_many :performance_analista_cobranza
  belongs_to :sector
  belongs_to :sub_sector
  belongs_to :usuario

  validates :usuario_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.usuario')} #{I18n.t('errors.messages.not_an_integer')}"},
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.AnalistaCobranzas.Errores.analista_registrado')}

  validates :cedula, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :message => I18n.t('Sistema.Body.Modelos.Errores.cedula_sin_decimales') },
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.Usuario.Errores.cedula_ya_existe')}

  validates :primer_nombre, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..30, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_nombre_invalido')}
  
  validates :primer_apellido, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 4..30, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.primer_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.primer_apellido_invalido')}
  
  validates :segundo_nombre, :length => { :in => 3..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_nombre')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.segundo_nombre_invalido')}
  
  validates :segundo_apellido, :length => { :in => 4..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.segundo_apellido')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_nombre')}/, :allow_blank =>true, 
    :message => I18n.t('Sistema.Body.Modelos.Errores.segundo_apellido_invalido')}

  validates_presence_of :sector,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}",
    :uniqueness =>{:uniqueness => true, :message => I18n.t('Sistema.Body.Modelos.AnalistaCobranzas.Errores.usuario_ya_registrado')}

  validates_presence_of :sub_sector,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"

  def self.search(search, page, sort)

    paginate  :per_page => @records_by_page, 
              :page => page,
              :conditions => search, 
              :order => sort,
              :include => [:sector, :sub_sector]

  end

  def analista
    unless self.primer_nombre.nil? and self.primer_apellido.nil?
      analista = (self.primer_nombre + " " + self.primer_apellido)
    else
      analista = ''
    end
    return analista
  end

  def eliminar(id)
    begin
      analista = AnalistaCobranzas.find(id)
      transaction do
        analista.destroy
        return true
      end
    rescue
      errors.add(:analista_cobranzas, I18n.t('Sistema.Body.Modelos.AnalistaCobranzas.Errores.analista_utilizado'))
      return false
    end
  end

end

# == Schema Information
#
# Table name: analista_cobranzas
#
#  id                 :integer         not null, primary key
#  usuario_id         :integer         not null
#  estatus            :string(1)       not null
#  senal_supervisor   :boolean         default(TRUE), not null
#  sector_id          :integer
#  sub_sector_id      :integer
#  rubro_id           :integer
#  sub_rubro_id       :integer
#  actividad_id       :integer
#  primer_nombre      :string(30)
#  segundo_nombre     :string(30)
#  primer_apellido    :string(30)
#  segundo_apellido   :string(30)
#  letra_cedula       :string(1)
#  cedula             :integer
#  cantidad_cobranzas :integer         default(0)
#  carga_trabajo      :integer         default(0)
#

