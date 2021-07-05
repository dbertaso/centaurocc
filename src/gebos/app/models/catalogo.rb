# encoding: utf-8
#
# autor: Luis Rojas
# clase: Catalogo
# descripción: Migración a Rails 3
#

class Catalogo < ActiveRecord::Base
  
  
  self.table_name = 'catalogo'

  attr_accessible :id,
				  :descripcion,
				  :chasis,
				  :serial,
				  :estatus,
				  :fecha_carga,
				  :fecha_reserva,
				  :fecha_aprobado,
				  :fecha_entregado,
				  :contrato_maquinaria_equipo_id,
				  :solicitud_id,
				  :clase_id,
				  :pais_id,
				  :puerto_llegada,
				  :movilizado,
				  :nombre_buque,
				  :fecha_llegada,
				  :numero_factura,
				  :flete,
				  :seguro,
				  :por_seguro,
				  :por_flete,
				  :monto_dolares,
				  :gastos_administrativos,
				  :impuesto,
				  :almacenamiento,
				  :monto_real,
				  :imputaciones_maquinaria_id,
				  :almacen_maquinaria_id,
          :almacen_maquinaria_sucursal_id,
				  :codigo,
				  :marca_maquinaria_id,
				  :modelo_id,
				  :operativo,
				  :con_fallas,
				  :falta_mantenimiento,
				  :observaciones,
				  :monto, :monto_f, :monto_real_f, :fecha_llegada_f, :moneda_id, :moneda_f,
          :por_gastos_administrativos, :por_nacionalizacion, :por_almacenamiento
  
  
  has_many :guia_catalogo
  belongs_to :contrato_maquinaria_equipo
  belongs_to :clase
  belongs_to :pais
  belongs_to :solicitud 
  belongs_to :almacen_maquinaria
  belongs_to :almacen_maquinaria_sucursal
  belongs_to :modelo  
  belongs_to :marca_maquinaria
  belongs_to :solicitud_maquinaria
  
  validates   :contrato_maquinaria_equipo_id,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :clase_id, 
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :almacen_maquinaria_id,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.almacen')} #{I18n.t('Sistema.Body.Vistas.General.maquinaria')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :serial,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}"}

  validates   :chasis,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}"}
  
  validates   :descripcion,
  :presence => { :message => "#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :modelo_id,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :marca_maquinaria_id,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates   :numero_factura,
  :presence => { :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_numero')}/, 
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.factura')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}"}
    
  validates_numericality_of :monto_real, :allow_nil => true, :only_integer => false,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}", :unless => Proc.new {|a| a.monto_real.nil? }
  
  validate :validate
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, 
             :joins => "INNER JOIN clase ON clase.id = catalogo.clase_id
                INNER JOIN tipo_maquinaria ON tipo_maquinaria.id = clase.tipo_maquinaria_id
                INNER JOIN contrato_maquinaria_equipo ON contrato_maquinaria_equipo.id = catalogo.contrato_maquinaria_equipo_id
                INNER JOIN modelo ON modelo.id = catalogo.modelo_id
                INNER JOIN marca_maquinaria ON marca_maquinaria.id = catalogo.marca_maquinaria_id",
             :select=>'catalogo.serial, catalogo.chasis, catalogo.monto, 
                       catalogo.estatus, catalogo.id as id, catalogo.clase_id, 
                       catalogo.modelo_id, catalogo.contrato_maquinaria_equipo_id, contrato_maquinaria_equipo.nombre,
                       catalogo.marca_maquinaria_id, catalogo.moneda_id '
  end
  
    
  def self.search_especial(search, page, sort,join,select)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, 
             :joins => join,
             :select=>select
             #:include=>['contrato_maquinaria_equipo','clase', 'modelo', 'marca_maquinaria'],
  end
  
  def self.search_especial_include(search, page, sort,join,select)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, 
             :joins => join,
             :select=>select,
             :include=>['contrato_maquinaria_equipo','clase']
  end
  
  def validate
    unless self.puerto_llegada.nil? || self.puerto_llegada.empty?
      a = self.puerto_llegada[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
      if a.nil?
        errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.puerto_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}")
      end
    end
    unless self.movilizado.nil? || self.movilizado.empty?
      a = self.movilizado[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
      if a.nil?
        errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.movilizado_a')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}")
      end
    end
    unless self.nombre_buque.nil? || self.nombre_buque.empty?
      a = self.nombre_buque[/#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio')}/]
      if a.nil?
        errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.nombre_buque')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener_especiales')}")
      end
    end
    unless self.contrato_maquinaria_equipo_id.nil? || self.contrato_maquinaria_equipo_id.to_s.empty?
      contrato = ContratoMaquinariaEquipo.find(self.contrato_maquinaria_equipo_id)
      if contrato.naturaleza == 'I'
        if self.pais_id.nil? || self.pais_id.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.pais_origen')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.fecha_llegada.nil? || self.fecha_llegada.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.fecha_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.puerto_llegada.nil? || self.puerto_llegada.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.puerto_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.nombre_buque.nil? || self.nombre_buque.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.nombre_buque')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        end
        if self.monto_dolares.nil? || self.monto_dolares.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.monto_dolares')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        else
          unless self.monto_dolares > 0
            errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.monto_dolares')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
          end
        end
      else
        if self.monto_real.nil? || self.monto_real.to_s.empty?
          errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
        else
          unless self.monto_real > 0
            errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
          end
        end
      end
      unless self.serial.nil? || self.serial.to_s.empty?
        unless self.serial.to_s.downcase == 'no aplica'
          if self.new_record?
            total = Catalogo.count(:conditions => "contrato_maquinaria_equipo_id = #{self.contrato_maquinaria_equipo_id} and lower(serial) = lower('#{self.serial}')")
          else
            total = Catalogo.count(:conditions => "contrato_maquinaria_equipo_id = #{self.contrato_maquinaria_equipo_id} and lower(serial) = lower('#{self.serial}') and id not in (#{self.id})")
          end
          if total > 0
            errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}")
          end
        end
      end
      unless self.chasis.nil? || self.chasis.to_s.empty?
        unless self.chasis.to_s.downcase == 'no aplica'
          if self.new_record?
            total = Catalogo.count(:conditions => "contrato_maquinaria_equipo_id = #{self.contrato_maquinaria_equipo_id} and lower(chasis) = lower('#{self.chasis}')")
          else
            total = Catalogo.count(:conditions => "contrato_maquinaria_equipo_id = #{self.contrato_maquinaria_equipo_id} and lower(chasis) = lower('#{self.chasis}') and id not in (#{self.id})")
          end
          if total > 0
            errors.add(:catalogo, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}")
          end
        end
      end
    end
  end
  
  before_save :antes_de_guardar
  
  def antes_de_guardar
    imputaciones = ImputacionesMaquinaria.find(:first, :order => 'id desc')
    if self.contrato_maquinaria_equipo.naturaleza == 'N'
      self.seguro = self.monto_real * (self.por_seguro / 100.0)
      self.flete = self.monto_real * (self.por_flete / 100.0)
      self.monto = self.monto_real + self.seguro + self.flete
    else
      parametro_general = ParametroGeneral.find(:first)
      self.monto_real = self.monto_dolares * parametro_general.valor_dolar
      self.seguro = self.monto_real * (self.por_seguro / 100.0)
      self.flete = self.monto_real * (self.por_flete / 100.0)
      self.gastos_administrativos = self.monto_real * (self.por_gastos_administrativos / 100.0)
      self.impuesto = self.monto_real * (self.por_nacionalizacion / 100.0)
      self.almacenamiento = self.monto_real * (self.por_almacenamiento / 100.0)
      self.monto = self.monto_real + self.seguro + self.flete + self.gastos_administrativos + self.impuesto + self.almacenamiento
    end
    self.imputaciones_maquinaria_id = imputaciones.id
  end
  
  after_save :despues_de_guardar
  
  def despues_de_guardar
    if self.codigo.nil? || self.codigo.to_s.empty?
      catalogo = Catalogo.find(:first, :conditions => "codigo > 0", :order => "codigo desc")
      if catalogo.nil?
        self.codigo = 1
      else
        self.codigo = catalogo.codigo + 1
      end
      self.save
    end
  end

  def getstatus
    estatus = ""
    case self.estatus
      when 'L'
        estatus = "Libre"
      when 'A'
        estatus = "Aprobado"
      when 'R'
        estatus = "Reservado"
      when 'E'
        estatus = "Entregado"
    end
    return  estatus
  end

  def monto_f=(valor)
    self.monto = format_valor(valor)
  end

  def monto_f
    format_fm(self.monto)
  end
  
  def monto_real_f=(valor)
    self.monto_real = format_valor(valor)
  end

  def monto_real_f
    format_fm(self.monto_real)
  end
  
  def fecha_llegada_f=(fecha)
      self.fecha_llegada = fecha
  end
  
  def monto_c(solicitud_id)
    solicitud = Solicitud.find(solicitud_id)
    moneda_id = solicitud.moneda_id
    unless moneda_id == self.moneda_id
      convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{moneda_id} and moneda_destino_id = #{self.moneda_id}")
      unless convertidor.nil?
        return "#{sprintf('%01.2f',(self.monto / convertidor.valor)).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")}  #{solicitud.moneda.abreviatura}"
      else
        convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{self.moneda_id} and moneda_destino_id = #{moneda_id}")
        unless convertidor.nil?
          return "#{sprintf('%01.2f',(self.monto * convertidor.valor)).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")}  #{solicitud.moneda.abreviatura}"
        else
          return "0,00 #{solicitud.moneda.abreviatura}"
        end
      end
    else
      return "#{sprintf('%01.2f',(self.monto)).sub('.', ',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")} #{solicitud.moneda.abreviatura}"
    end
  end

  def fecha_llegada_f
    format_fecha(self.fecha_llegada)
  end
  
  def self.getSolicitud(id)
    solicitud = Solicitud.find(id)
    return solicitud.numero
  end
  
  def moneda_f
    if self.moneda_id.blank?
      return Moneda.first(:conditions => "id = #{ParametroGeneral.first.moneda_id}").abreviatura
    else
      return Moneda.first(:conditions => "id = #{self.moneda_id}").abreviatura
    end  
  end

end

# == Schema Information
#
# Table name: catalogo
#
#  id                              :integer         not null, primary key
#  descripcion                     :text
#  chasis                          :string(30)
#  serial                          :string(30)
#  estatus                         :string(1)       default("L")
#  fecha_carga                     :date            not null
#  fecha_reserva                   :date
#  fecha_aprobado                  :date
#  fecha_entregado                 :date
#  contrato_maquinaria_equipo_id   :integer         not null
#  solicitud_id                    :integer
#  clase_id                        :integer         not null
#  pais_id                         :integer
#  puerto_llegada                  :string(200)
#  movilizado                      :string(250)
#  nombre_buque                    :string(200)
#  fecha_llegada                   :date
#  numero_factura                  :string(20)
#  flete                           :float
#  seguro                          :float
#  por_seguro                      :float
#  por_flete                       :float
#  monto_dolares                   :float
#  gastos_administrativos          :float
#  impuesto                        :float
#  almacenamiento                  :float
#  monto_real                      :float
#  imputaciones_maquinaria_id      :integer
#  almacen_maquinaria_id           :integer
#  codigo                          :integer
#  marca_maquinaria_id             :integer
#  modelo_id                       :integer
#  operativo                       :boolean         default(TRUE)
#  con_fallas                      :boolean         default(FALSE)
#  falta_mantenimiento             :boolean         default(FALSE)
#  observaciones                   :text
#  monto                           :decimal(16, 2)
#  por_gastos_administrativos      :float
#  por_nacionalizacion             :float
#  por_almacenamiento              :float
#  almacen_maquinaria_sucursal_id  :integer
#  usuario_ultima_actualizacion_id :integer
#  usuario_asignacion_id           :integer
#  moneda_id                       :integer
#

