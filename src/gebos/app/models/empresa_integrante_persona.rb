# encoding: utf-8
#
# autor: Luis Rojas
# clase: EmpresaIntegrantePersona
# descripción: Migración a Rails 3
#
class EmpresaIntegrantePersona < EmpresaIntegrante
  
  self.table_name = 'empresa_integrante'
  
  attr_accessible :id, :persona_id, :empresa_id, :porcentaje_participacion, 
    :cargo, :departamento, :contacto, :type, :empresa_relacionada_id, :instancia_empresa_id

  belongs_to :persona
  
  validates :cargo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('errors.messages.too_long.other')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.cargo')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :departamento, :length => { :in => 3..40, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.departamento')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.departamento')} #{I18n.t('errors.messages.too_long.other')}"}

  validates_uniqueness_of :persona_id, :scope=>:empresa_id,
    :message => " ya existe"
  
end


# == Schema Information
#
# Table name: empresa_integrante
#
#  id                       :integer         not null, primary key
#  persona_id               :integer
#  empresa_id               :integer         not null
#  porcentaje_participacion :float
#  cargo                    :string(40)
#  departamento             :string(40)
#  contacto                 :boolean         default(FALSE)
#  type                     :string(26)      not null
#  empresa_relacionada_id   :integer
#  instancia_empresa_id     :integer
#

