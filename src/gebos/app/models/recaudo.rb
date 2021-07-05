# encoding: utf-8
class Recaudo < ActiveRecord::Base
  
  self.table_name = 'recaudo'
  
  attr_accessible :id, :nombre, :descripcion, :activo, :obligatorio,
    :tipo_cliente_id, :fecha_actualizacion, :sector_id, :sub_sector_id
  
  belongs_to :tipo_cliente
  belongs_to :programa
  belongs_to :sector_economico
  belongs_to :seccion
  belongs_to :sector
  belongs_to :sub_sector
  has_many :pre_chequeo_recaudo
  has_many :solicitud_recaudo

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validates :descripcion, :presence => {:message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}", :allow_blank => true}
  
  validates :tipo_cliente_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo_cliente')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :sector_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :sub_sector_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.sub_sector')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
    
  validates_length_of :nombre, :within => 2..90, :allow_blank => true
      
  validates_length_of :descripcion, :within => 2..300, :allow_blank => true
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort,
             :include => ['tipo_cliente', 'sector', 'sub_sector']
  end
      
#  validates_uniqueness_of :nombre,
#    :message => " ya existe"

end

# == Schema Information
#
# Table name: recaudo
#
#  id                  :integer         not null, primary key
#  nombre              :string(90)      not null
#  descripcion         :string(300)     not null
#  activo              :boolean         default(TRUE)
#  obligatorio         :boolean         default(FALSE)
#  tipo_cliente_id     :integer
#  fecha_actualizacion :date
#  sector_id           :integer
#  sub_sector_id       :integer
#

