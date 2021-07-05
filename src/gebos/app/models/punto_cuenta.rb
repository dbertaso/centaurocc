# encoding: utf-8

#
# 
# clase: PuntoCuenta
# descripción: Migración a Rails 3
#

class PuntoCuenta < ActiveRecord::Base

    self.table_name = 'punto_cuenta'
  
      attr_accessible :id,
                      :asunto,
                      :resumen_ejecutivo,
                      :recomendaciones,
                      :anexo

  #validates_presence_of :punto_numero,  :message => "^ Punto Nro es requerido"

  #validates_presence_of :reunion_numero,  :message => "^ Punto Nro es requerido"

  #validates_presence_of :cantidad_anexos,  :message => "^ Cantidad de Anexos es requerido"

 # validates_presence_of :fecha,
 # :message => "^ Fecha es requerida"


  #validates_presence_of :programa,  :message => "^ Programa es requerido"

  validates :asunto,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.asunto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  validates :resumen_ejecutivo,
    :presence => { :message => I18n.t('Sistema.Body.Vistas.General.resumen') << " " << I18n.t('Sistema.Body.Vistas.General.ejecutivo') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
    
  validates :recomendaciones,
    :presence => { :message => I18n.t('Sistema.Body.Vistas.General.recomendaciones') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

 #validates_numericality_of :cantidad_anexos,   :message => "^ Cantidad de Anexos debe es un campo númericos"

  #   validates_date :fecha,
  # :message => "^ Fecha es inválida (dd/mm/aaaa)", :allow_nil=>false
  

#   validates_length_of :asunto, :within => 0..700, :allow_nil => true,    :too_short => " es demasiado corto (mínimo %d caracteres)",    :too_long => " es demasiado largo (máximo %d caracteres)"
  

#  def fecha_f=(fecha)
#    self.fecha =  fecha
#  end

#  def dirigido_a
#    valor = ""
#    if self.destino == 1
#    valor = "Directorio Ejecutivo"
#    end
#    if self.destino == 2
#    valor = "Presidente"
#    end
#    if self.destino == 3
#    valor = "Comité de Fondos Autónomos"
#    end
#    return valor
#  end

#  def after_create
#    @parametros_generales = ParametroGeneral.find(1)
#    @parametros_generales.incrementar_numeracion_punto_cuenta()
#
#  end
  
#  def fecha_f
#    self.fecha.strftime('%d/%m/%Y') unless self.fecha.nil?
#  end
end

# == Schema Information
#
# Table name: punto_cuenta
#
#  id                :integer         not null, primary key
#  asunto            :text
#  resumen_ejecutivo :text
#  recomendaciones   :text
#  anexo             :text
#

