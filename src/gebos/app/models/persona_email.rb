# encoding: utf-8

#
# 
# clase: PersonaEmail
# descripción: Migración a Rails 3
#

class PersonaEmail < ActiveRecord::Base

  self.table_name = 'persona_email'
  
  attr_accessible :id,
				  :email,
				  :tipo,
				  :persona_id,
				  :facebook,
				  :twitter
  
  belongs_to :persona
  
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
        
  validates :email, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..100, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')}  #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /^[0-9a-z_\-\.]+@[0-9a-z\-\.]+\.[a-z]{2,4}$/i, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :facebook, :format => {:with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+.)+[a-z]{2,})$/, :allow_blank => true,
    :message => "Facebook #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :twitter, :format => {:with => /^@|#((?:[-a-zA-Z0-9]?.)+[\w]{2,})$/, :allow_blank => true,
    :message => "Twitter #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
            
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+.)+[a-z]{2,})$/i, :message=>"^Correo-e no es válido"
 
  
  def after_initialize    
#    self.tipo = 'R' unless self.tipo
  end
  
  def tipo_nombre
    case self.tipo
    when 'R'
      I18n.t('Sistema.Body.Vistas.General.trabajo')
    when 'P'
      I18n.t('Sistema.Body.Vistas.General.personal')
    when 'T'
      I18n.t('Sistema.Body.Vistas.General.otro')
    end
  end

  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end

end

# == Schema Information
#
# Table name: persona_email
#
#  id         :integer         not null, primary key
#  email      :string(80)      not null
#  tipo       :string(1)       not null
#  persona_id :integer         not null
#  facebook   :string(80)
#  twitter    :string(80)
#

