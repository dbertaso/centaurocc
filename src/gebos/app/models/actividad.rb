# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Actividad
# descripción: Migración a Rails 3
#

class Actividad < ActiveRecord::Base

  self.table_name = 'actividad'

  attr_accessible :nombre,
                  :descripcion,
                  :activo,
                  :codigo_d3,
                  :paquete,
                  :paquetizado,
                  :sub_rubro_id,
                  :ciclo_productivo_id,
                  :codigo,
                  :plazo_ciclo

  has_many :configurador
  has_many :recaudo_siniestro
  has_many :solicitud_rubro_solicitado
  has_many :condiciones_financiamiento
  has_many :detalle_precio_gaceta
  has_many :solicitud_rubro_sugerido
  has_many :acta_silo
  has_many :desvio_silo
  has_many :partida
  has_many :actividad_oficina
  belongs_to :ciclo_productivo
  belongs_to :sub_rubro
  has_many :solicitud
  has_many :boleta_arrime

  validates :nombre, 
            :presence => { 
              :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
            :uniqueness => {    
              :scope => [:sub_rubro_id],
              :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}",
              :if => Proc.new { |act| act.codigo_d3.nil?}},
              :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/,
                :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
                    
  validates :codigo, :numericality => { 
                      :greater_than=>0, :only_integer=> true,
                        :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.greater_than')}"},
            :presence => { 
              :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
            :uniqueness => {:scope => [:sub_rubro_id],
              :message => "#{I18n.t('Sistema.Body.Vistas.General.codigo')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}


  validates :descripcion, 
              :length => {
                :within => 0..300, :allow_nil => false,
                :too_long => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_long.other')}",
                :too_short => "#{I18n.t('Sistema.Body.Form.descripcion')} #{I18n.t('es.errors.message.too_short.other')}"}

  after_initialize :after_initialize
  before_save :before_save
  
  def after_initialize
    self.activo = true if self.new_record?
  end

  def before_save
    sub_rubro = SubRubro.find(self.sub_rubro_id)
    sub_sector = SubSector.find(sub_rubro.rubro.sub_sector_id)
    if sub_sector.nemonico == 'VE'
      if self.ciclo_productivo_id.nil?
        errors.add(:actividad, I18n.t('Sistema.Body.Modelos.Actividad.Errores.debe_seleccionar_ciclo_productivo'))
        return false
      end
    end

  end


  def self.search(search, page, sort)

    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort

  end

  def eliminar(id)
    begin
      partida = Partida.count(:conditions=>"actividad_id = #{id}")
      if partida > 0
        errors.add(:actividad, "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.usado_partida')}")
        return false
      else
        actividad = Actividad.find(id)
        transaction do
          actividad.destroy
          return true
        end
      end
    rescue
      errors.add(:actividad, "#{I18n.t('Sistema.Body.Vistas.General.actividad')} #{I18n.t('Sistema.Body.Modelos.Errores.usado')}")
      return false
    end

  end

end




# == Schema Information
#
# Table name: actividad
#
#  id                  :integer         not null, primary key
#  nombre              :string(150)     not null
#  descripcion         :string(300)     not null
#  activo              :boolean         default(TRUE)
#  codigo_d3           :integer
#  paquete             :boolean         default(FALSE)
#  paquetizado         :boolean         default(FALSE)
#  ciclo_productivo_id :integer
#  codigo              :integer         default(0)
#  sub_rubro_id        :integer
#  plazo_ciclo         :string(1)
#

