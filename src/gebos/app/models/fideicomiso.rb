# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Fideicomiso
# descripción: Migración a Rails 3
#




class Fideicomiso < ActiveRecord::Base

self.table_name = 'fideicomiso'

attr_accessible :id,
                :entidad_financiera_id,
                :programa_id,
                :fecha_creacion,
                :fecha_ultima_actualizacion,
                :porcentaje,
                :monto_disponible,
                :subcuenta_banco,
                :subcuenta_insumos,
                :subcuenta_sras,
                :subcuenta_gastos,
                :activo,
                :numero_fideicomiso
   
validates :entidad_financiera_id, :presence => {
:message => I18n.t('Sistema.Body.Vistas.General.entidad_financiera') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerida')}

validates :programa_id, :presence => {
:message => I18n.t('Sistema.Body.Vistas.General.programa') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')}


validates :porcentaje,     
:numericality=> {:only_integer => false,:message => "#{I18n.t('Sistema.Body.Vistas.General.porcentaje')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
:presence => { :message => I18n.t('Sistema.Body.Vistas.General.porcentaje') << " " << I18n.t('Sistema.Body.Modelos.Errores.municipio_requerido')},
:inclusion =>{:in=>0..100, :message => "#{I18n.t('Sistema.Body.Vistas.General.porcentaje')} #{I18n.t('errors.messages.inclusion')}"}  
  

validates :numero_fideicomiso,     
:numericality=> {:only_integer => true,:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.fideicomiso')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"}


  #ojo se quito no sirve en rails 3 validates_date :fecha_creacion,
  # :message => "^Fecha Apertura es inválida (dd/mm/aaaa)"

  #ojo se quito no sirve en rails 3  validates_date :fecha_creacion, :before=>[Proc.new { 0.day.from_now.to_date }], :before_message=>'^Fecha Apertura debe ser menor que la Fecha Actual'

  def entidad_financiera_text
    EntidadFinanciera.find(self.entidad_financiera_id).nombre
  end

  def programa_text
    Programa.find(self.programa_id).nombre
  end
  
  def fecha_creacion_f
    format_fecha(self.fecha_creacion)
  end
  
   def fecha_creacion_f=(fecha)
    self.fecha_creacion = fecha
  end
  
  def porcentaje_f    
      format_fm(self.porcentaje)
  end

  def porcentaje_f=(valor)
    self.porcentaje = format_f(valor)
  end
  
end


# == Schema Information
#
# Table name: fideicomiso
#
#  id                         :integer         not null, primary key
#  entidad_financiera_id      :integer         not null
#  programa_id                :integer         not null
#  fecha_creacion             :date
#  fecha_ultima_actualizacion :date
#  porcentaje                 :float
#  monto_disponible           :float
#  subcuenta_banco            :float
#  subcuenta_insumos          :float
#  subcuenta_sras             :float
#  subcuenta_gastos           :float
#  activo                     :boolean         default(FALSE)
#  numero_fideicomiso         :string(20)
#

