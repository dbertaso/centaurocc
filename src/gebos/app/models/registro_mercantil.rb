# encoding: utf-8

#
# autor: Luis Rojas
# clase: RegistroMercantil
# descripción: Migración a Rails 3
#
class RegistroMercantil < ActiveRecord::Base

  self.table_name = 'registro_mercantil'
  
  attr_accessible :id,
    :tipo,
    :fecha_registro,
    :numero,
    :nro_tomo,
    :nro_protocolo,
    :nombre_registro,
    :estado_id,
    :ciudad_id,
    :duracion_empresa,
    :fecha_vencimiento,
    :fecha_cierre,
    :capital_suscrito,
    :capital_pagado,
    :nro_folio_inicial,
    :nro_folio_final,
    :nro_trimestre,
    :nro_anno,
    :empresa_id,
    :persona_id,
    :tipo_documento_id,
    :tenencia_unidad_produccion_id,
    :unidad_produccion_id,
    :municipio_id,
    :fecha_registro_f,
    :create_new
  
  
  belongs_to :estado
  belongs_to :ciudad
  belongs_to :empresa
  belongs_to :unidad_produccion
  belongs_to :tipo_documento
  belongs_to :tenencia_unidad_produccion
  belongs_to :municipio

  validates :unidad_produccion_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.unidad_produccion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :tipo_documento_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.documento_propiedad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :tenencia_unidad_produccion_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tenencia_tierra')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_registro, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :allow_blank => true,
    :before => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}
  
  validates :numero, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.solo_numeros')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :nombre_registro, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :estado_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.estado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :ciudad_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.ciudad')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :municipio_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.municipio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :fecha_vencimiento, :date => {:message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_vencimiento_junta')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :allow_blank => true,
    :after => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_vencimiento_junta')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_anterior_fecha_actual')}"}

  validates :fecha_cierre, :date => {:message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_cierre_ejercicio')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :allow_blank => true,
    :after => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.General.fecha_cierre_ejercicio')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_anterior_fecha_actual')}"}

  validates :capital_suscrito, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.capital_suscrito')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  
  validates :capital_pagado, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.capital_pagado')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :nro_folio_inicial, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.folio_inicial')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :nro_folio_final, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.folio_final')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  
  validates :nro_trimestre, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.trimestre')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validates :nro_anno, :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.año_del_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  
  validates :nro_protocolo, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.solo_numeros')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_protocolo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}
  
  validates :nro_tomo, :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.solo_numeros')}/, :allow_blank => true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero_tomo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}"}

  validate :validate
  
  def validate
    unless self.nro_trimestre.nil? || self.nro_trimestre.empty?
      if self.nro_trimestre.to_i > 4 || self.nro_trimestre.to_i < 1
        errors.add(:registro_mercantil, "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.trimestre')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_estar_1_4')}")
      end
    end
    unless self.capital_suscrito.nil?
      unless self.capital_pagado.nil?
        unless self.capital_suscrito > self.capital_pagado
          errors.add(:registro_mercantil, "#{I18n.t('Sistema.Body.Vistas.General.capital_suscrito')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_al')} #{I18n.t('Sistema.Body.Vistas.General.capital_pagado')}")
        end
      end
    end
    unless self.fecha_vencimiento.nil?
      unless self.fecha_registro.nil?
        unless self.fecha_vencimiento > self.fecha_registro
          errors.add(:registro_mercantil, "#{I18n.t('Sistema.Body.Vistas.General.fecha_vencimiento_junta')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_a_la')} #{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')}")
        end
      end
    end
    unless self.nro_anno.nil?
      if self.nro_anno.to_i > Time.now.year
        errors.add(:registro_mercantil, "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.año_del_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_mayor_al_año_actual')}.")
      end
    end
    if self.tipo == 'C' || self.tipo == 'P' || self.tipo == 'T'
      unless self.unidad_produccion_id.nil? || self.estado_id.nil?
        unidad_produccion = UnidadProduccion.find(self.unidad_produccion_id)
        unless unidad_produccion.estado_id == self.estado_id
          cliente = Cliente.find(unidad_produccion.cliente_id)
          if cliente.es_pescador == true && cliente.type.to_s == "ClienteEmpresa"
            msj = "#{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.comunidad_pesquera')}"
          elsif cliente.es_pescador == true && cliente.type.to_s == "ClientePersona"
            msj = "#{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.Vistas.General.puerto_base')}"
          else
            msj = "#{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.unidad_produccion')}"
          end
          errors.add(:registro_mercantil, "#{I18n.t('Sistema.Body.Modelos.Errores.estado_registro_debe_ser_igual_estado')} #{msj}.")
        end
      end
    end
  end
  
  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    format_fecha(self.fecha_registro)
  end

  def fecha_vencimiento_f=(fecha)
    self.fecha_vencimiento = fecha
  end

  def fecha_vencimiento_f
    format_fecha(self.fecha_vencimiento)
  end

  def fecha_cierre_f=(fecha)
    self.fecha_cierre = fecha
  end

  def fecha_cierre_f
    format_fecha(self.fecha_cierre)
  end

  def capital_suscrito_f=(valor)
    format_p(self.capital_suscrito)
  end

  def capital_suscrito_f
    format_f(self.capital_suscrito)
  end

  def capital_pagado_f=(valor)
    format_p(self.capital_pagado)
  end

  def capital_pagado_f
    format_f(self.capital_pagado)
  end

  def create_new(params, cliente_id, tipo_cliente)
    if tipo_cliente == 'J'
      self.empresa_id = cliente_id
    else
      self.persona_id = cliente_id
    end
    
    unless self.nro_folio_inicial.nil?
      if self.nro_folio_inicial.empty?
        self.nro_folio_inicial = nil
      end
    end
    unless self.nro_folio_final.nil?
      if self.nro_folio_final.empty?
        self.nro_folio_final = nil
      end
    end
    unless self.nro_trimestre.nil?
      if self.nro_trimestre.empty?
        self.nro_trimestre = nil
      end
    end
    unless self.nro_anno.nil?
      if self.nro_anno.empty?
        self.nro_anno = nil
      end
    end
    self.save
  end

  def edit_record(parametros)
    self.update_attributes(parametros)
    #self.save
  end
  
  def self.search(search, page, orden)
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end


# == Schema Information
#
# Table name: registro_mercantil
#
#  id                            :integer         not null, primary key
#  tipo                          :string(1)       not null
#  fecha_registro                :date            not null
#  numero                        :string(20)      not null
#  nro_tomo                      :string(20)
#  nro_protocolo                 :string(20)
#  nombre_registro               :string(80)
#  estado_id                     :integer
#  ciudad_id                     :integer
#  duracion_empresa              :integer
#  fecha_vencimiento             :date
#  fecha_cierre                  :date
#  capital_suscrito              :float
#  capital_pagado                :float
#  nro_folio_inicial             :string(20)
#  nro_folio_final               :string(20)
#  nro_trimestre                 :string(1)
#  nro_anno                      :string(20)
#  empresa_id                    :integer
#  persona_id                    :integer
#  tipo_documento_id             :integer
#  tenencia_unidad_produccion_id :integer
#  unidad_produccion_id          :integer
#  municipio_id                  :integer
#

