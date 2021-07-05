# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CuentaBcv
# descripción: Migración a Rails 3
#

class CuentaBcv < ActiveRecord::Base
  
  self.table_name = 'cuenta_bcv'
  
  attr_accessible :id,
				  :entidad_financiera_id,
				  :tipo,
				  :numero,
				  :activo,
          :recaudador
				    
  
  belongs_to :entidad_financiera
  
  validates_presence_of :tipo,
    :message => I18n.t('Sistema.Body.Vistas.General.tipo') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_presence_of  :entidad_financiera_id,
    :message => I18n.t('Sistema.Body.Vistas.General.entidad_financiera') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')

  validates_uniqueness_of :numero,
    :message => I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')

  validates_length_of :numero, :within => 20..20, :allow_nil => true,
  :too_short => I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('errors.messages.too_short.other'),
  :too_long => I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('errors.messages.too_long.other')
  
  validate :validate
  
  def validate
    unless self.numero.nil? || self.numero.empty?
      a = self.numero[/^[0-9]+$/]
      if a.nil?
        errors.add(:cuenta_bcv, I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
  end

  def fecha_apertura_f=(fecha)
    self.fecha_apertura = fecha
  end
  
  
  def tipo_w
    if self.tipo == 'A'
      I18n.t('Sistema.Body.Vistas.General.ahorro')
    else
      I18n.t('Sistema.Body.Vistas.General.corriente')
    end
  end
    
    def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden, :include => [:entidad_financiera]
  end
    
    
end

# == Schema Information
#
# Table name: cuenta_bcv
#
#  id                    :integer         not null, primary key
#  entidad_financiera_id :integer         not null
#  tipo                  :string(1)       not null
#  numero                :string(20)      not null
#  activo                :boolean         default(TRUE)
#  recaudador            :boolean         default(FALSE)
#

