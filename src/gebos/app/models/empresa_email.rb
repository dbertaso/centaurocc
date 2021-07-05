# encoding: utf-8
#
# autor: Luis Rojas
# clase: EmpresaEmail
# descripción: Migración a Rails 3

class EmpresaEmail < ActiveRecord::Base
  
  self.table_name = 'empresa_email'
  
  attr_accessible :id, :email, :empresa_id, :tipo, :facebook, :twitter

  belongs_to :empresa
  
  validates :email, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..80, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_correo')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.correo_electronico')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  validates :facebook, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_facebook')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.facebook')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
 
  validates :twitter, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_twitter')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.twitter')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end
  
  after_initialize :after_initialize
  
  def after_initialize    
    self.tipo = 'P' unless self.tipo
  end
  
  def tipo_nombre
    case self.tipo
    when 'P'
      I18n.t('Sistema.Body.Vistas.General.principal')
    when 'A'
      I18n.t('Sistema.Body.Vistas.General.administrativo')
    when 'T'
      I18n.t('Sistema.Body.Vistas.General.otro')
    end
  end
end

# == Schema Information
#
# Table name: empresa_email
#
#  id         :integer         not null, primary key
#  email      :string(80)      not null
#  empresa_id :integer         not null
#  tipo       :string(1)       not null
#  facebook   :string(80)
#  twitter    :string(80)
#

