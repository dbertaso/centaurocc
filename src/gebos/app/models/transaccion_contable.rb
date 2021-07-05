# encoding: utf-8

#
# autor: Diego Bertaso
# clase: TransaccionContable
# descripción: Migración a Rails 3
#

class TransaccionContable < ActiveRecord::Base
  
  self.table_name = 'transaccion_contable'
  
  attr_accessible :id,
                  :nombre,
                  :descripcion
                  
  has_many :reglas_contables, :class_name=>"ReglaContable"
  
  before_destroy :before_destroy
  
  validates :nombre, :presence => {
  :message => "#{I18n.t('Sistema.Body.Vistas.TransaccionContable.Etiquetas.nombre_transaccion_contable')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
  :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.TransaccionContable.Etiquetas.nombre_transaccion_contable')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
  :length => { :in => 1..50, :allow_blank => true,
  :too_short => "#{I18n.t('Sistema.Body.Vistas.TransaccionContable.Etiquetas.nombre_transaccion_contable')} es demasiado corto (mínimo %d)",
  :too_long => "#{I18n.t('Sistema.Body.Vistas.TransaccionContable.Etiquetas.nombre_transaccion_contable')}  es demasiado largo (máximo %d)"},
  :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.TransaccionContable.Etiquetas.nombre_transaccion_contable')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}"}

  validates :descripcion,
  :format =>{:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero_otro')}/, :allow_blank =>true, :message =>"#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
  :length => { :in => 1..50, :allow_blank => true,
  :too_short => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')} es demasiado corto (mínimo %d)",
  :too_long => "#{I18n.t('Sistema.Body.Vistas.Form.descripcion')}  es demasiado largo (máximo %d)"}

 
  def before_destroy
  
    retorno = true
    
    logger.info "ID =======> #{self.id.inspect}"
    regla_contable = ReglaContable.find_by_transaccion_contable_id(self.id)
    
    logger.info "Regla Contable ==========> #{regla_contable.inspect}  ---- #{regla_contable.class.to_s}"
    if !regla_contable.nil?
      errors.add(t('Sistema.Body.Modelos.TransaccionContable.Errores.no_se_puede_eliminar_registro'))
      logger.info "Errorres ========> #{self.errors.full_messages}"
      retorno = false
    end
    
    return retorno
    
  end

  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort,
      :select=>'transaccion_contable.*'
  end
end



# == Schema Information
#
# Table name: transaccion_contable
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(250)
#

