# encoding: utf-8
#
# autor: Luis Rojas
# clase: Empresa
# descripción: Migración a Rails 3
#

class Empresa < ActiveRecord::Base

  self.table_name = 'empresa'
  
  attr_accessible :id, :nombre,:alias,:rif,:codigo_nacionalidad,:fecha_constitucion,:fecha_inicio_operaciones,:fecha_vencimiento,:capital_suscrito,:capital_pagado,:cantidad_empleados_femeninos,:cantidad_empleados_masculinos,:volumen_facturacion,:tamano,:numero_patente,:numero_sunacop,:web_site,:cantidad_accionistas,:frente,:sector_industrial_id,:producto,:empresa_direccion_id,:clasificacion_siex,:codigo_d3,:nombre_registro_mercantil,:direccion_registro_mercantil,:estado_registro_id,:ciudad_registro_id,:municipio_registro_id,:parroquia_registro_id,:nro_registro_mercantil,:nro_folio_inicial,:nro_folio_final,:nro_protocolo,:nro_tomo,:nro_trimestre,:fecha_registro_mercantil,:anio_registro_mercantil,:objeto_social,:nit,:numero_certificado,:cant_socios_femeninos,:cant_socios_masculinos,:tipo_comunidad,:tipo_empresa_id,:clasificacion_id,:sector_economico_id,:actividad_economica_id,:rama_actividad_economica_id,:uso_calculadora,:uso_maquina_escribir,:uso_computadora,:uso_equipos_especiales,:uso_ninguno,:uso_otro,:descripcion_otro,:numero,:objeto,:cant_miembros,:numero_familias,:numero_viviendas,:cant_productores, :rif_1, :rif_2, :rif_3, :foto_confirmacion, :huella_confirmacion, :capital_suscrito_f, :capital_suscrito_fm, :capital_pagado_f, :capital_pagado_fm, :volumen_facturacion_f, :volumen_facturacion_f, :volumen_facturacion_fm, :fecha_constitucion_f, :fecha_registro_mercantil_f, :fecha_inicio_operaciones_f, :fecha_vencimiento_f

  has_one :cliente_empresa, :dependent => :destroy

  has_many :direcciones, :dependent => :destroy, :class_name=>'EmpresaDireccion'
  has_many :telefonos, :dependent => :destroy, :class_name=>'EmpresaTelefono'
  has_many :integrantes, :dependent => :destroy, :class_name=>'EmpresaIntegrante'
  has_many :emails, :dependent => :destroy, :class_name=>'EmpresaEmail'
  has_many :empresa_direccion
  has_many :registro_mercantil

  belongs_to :sector_economico
  belongs_to :actividad_economica

  validates :rif, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.validar_rif')}/, :allow_blank => true,
    :message => I18n.t('Sistema.Body.Modelos.Empresa.Errores.rif_no_valido')},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.rif')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}

  validates :alias, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..255, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.abreviado')} #{I18n.t('errors.messages.too_long.other')}"}

  validates :nombre, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 3..255, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Bod
    y.General.beneficiario')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('errors.messages.too_long.other')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.nombre')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}", :allow_blank => true}
  
  validates :fecha_constitucion, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.cicom')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.cicom')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.cicom')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_no_posterior')}", :allow_blank => true}

  validates :numero_sunacop, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.cicom')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  #    :format => {:with => /#{I18n.t('Sistema.Body.ExpresionesRegulares.letras_espacio_numero')}/, :allow_blank => true,
  #    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.cicom')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_tener')}"}
  
  validates :cant_miembros, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.miembros')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :numero_familias, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.familias')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :numero_viviendas, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.viviendas')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :cant_productores, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.cantidad')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.productores')} #{I18n.t('Sistema.Body.Vistas.General.beneficiados')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :objeto, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.objeto')} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validate :validate
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page, :conditions => search, :order => sort, :include => [:cliente_empresa]
  end

  def rif_1=(valor)
    @rif_1 = valor
  end

  def rif_1
    self.rif.slice(0,1)
  end

  def rif_2=(valor)
    @rif_2 = valor
  end

  def rif_2
    self.rif.slice(2,8)
  end

  def rif_3=(valor)
    @rif_3 = valor
  end

  def rif_3
    self.rif.slice(11,1)
  end

  def validate

    #Modificación incluida por Diego Bertaso para poder migrar empresas
    #ya que no se disponen de estos datos en el origen de la migración

    #validación formato rif
    if self.codigo_d3.nil?
      if !self.fecha_constitucion.nil? && !self.fecha_inicio_operaciones.nil? && self.fecha_constitucion > self.fecha_inicio_operaciones
        errors.add(:empresa, I18n.t('Sistema.Body.Modelos.Empresa.Errores.fecha_contitucion_mayor_inicio'))
      end
    else
      #Registro de migracion
      #No se realizan validaciones adicionales
    end
    unless self.cant_miembros.nil?
      unless self.cant_miembros > 0
        errors.add(:empresa, I18n.t('Sistema.Body.Modelos.Empresa.Errores.cant_miembros_mayor_0'))
      end
    end
    unless self.numero_familias.nil?
      unless self.numero_familias > 0
        errors.add(:empresa, I18n.t('Sistema.Body.Modelos.Empresa.Errores.num_familias_mayor_0'))
      end
    end
    unless self.numero_viviendas.nil?
      unless self.numero_viviendas > 0
        errors.add(:empresa, I18n.t('Sistema.Body.Modelos.Empresa.Errores.num_viviendas_mayor_0'))
      end
    end
    unless self.cant_productores.nil?
      unless self.cant_productores > 0
        errors.add(:empresa, I18n.t('Sistema.Body.Modelos.Empresa.Errores.cant_productores_mayor_0'))
      end
    end
    self.cant_socios_femeninos = 0 unless !self.cant_socios_femeninos.nil?
    self.cant_socios_masculinos = 0 unless !self.cant_socios_masculinos.nil?
  end
  
  before_validation :antes_validar

  def antes_validar
    self.cant_socios_femeninos = 0 unless !self.cant_socios_femeninos.nil?
    self.cant_socios_masculinos = 0 unless !self.cant_socios_masculinos.nil?
    unless @rif_1.blank? || @rif_2.blank? || @rif_3.blank?
      self.rif = @rif_1 + '-' + @rif_2 + '-' + @rif_3 unless self.rif
    end
  end

  def add_direccion(empresa_direccion)
    direcciones<<empresa_direccion
  end

  def add_integrante(empresa_integrante_tipo, persona, empresa_integrante)
    transaction do
      value = persona.save
      if value == true
        tipo_cliente = TipoCliente.find(:first, :conditions=>"clasificacion = 'N'")
        cliente = Cliente.new
        cliente.type = 'ClientePersona'
        cliente.persona_id = persona.id
        cliente.tipo_cliente_id = tipo_cliente.id
        cliente.save
      end      
      empresa_integrante.persona = persona
      empresa_integrante_tipo.empresa_integrante = empresa_integrante
      if empresa_integrante_tipo.empresa_integrante.class.to_s == 'EmpresaIntegranteEmpresa'
        empresa_relacionada = empresa_integrante_tipo.empresa_integrante.empresa_relacionada
        self.errors.add_errors_with_raise(
          empresa_relacionada.errors) unless empresa_relacionada.save
      else
        persona = empresa_integrante_tipo.empresa_integrante.persona
        self.errors.add_errors_with_raise(
          persona.errors) unless persona.save
      end
      empresa_integrante = empresa_integrante_tipo.empresa_integrante
      self.errors.add_errors_with_raise(
        empresa_integrante.errors) unless self.integrantes << empresa_integrante
      self.errors.add_errors_with_raise(
        empresa_integrante_tipo.errors) unless empresa_integrante_tipo.save
    end
  rescue => detail
    self.errors.add(:empresa, detail.message)
    return false
  end

  after_initialize :antes_iniciar
  
  def antes_iniciar
    self.clasificacion_siex = 'N' unless self.clasificacion_siex
    self.tamano = 'P' unless self.tamano
    self.frente = 'N' unless self.frente
    self.capital_suscrito = 0 unless self.capital_suscrito
    self.capital_pagado = 0 unless self.capital_pagado
    self.cantidad_accionistas = 0 unless self.cantidad_accionistas
    self.volumen_facturacion = 0 unless self.volumen_facturacion
    self.cantidad_empleados_femeninos = 0 unless self.cantidad_empleados_femeninos
    self.cantidad_empleados_masculinos = 0 unless self.cantidad_empleados_masculinos
    self.tipo_empresa_id = 0 unless self.tipo_empresa_id
  end

  def clasificacion_siex_w
    case self.clasificacion_siex
    when 'N'
      return I18n.t('Sistema.Body.Vistas.General.nacional')
    when 'M'
      return I18n.t('Sistema.Body.Vistas.General.mixto')
    end
  end

  def tamano_w
    case self.tamano
    when 'P'
      return I18n.t('Sistema.Body.Vistas.General.pequeña')
    when 'M'
      return I18n.t('Sistema.Body.Vistas.General.mediana')
    when 'G'
      return I18n.t('Sistema.Body.Vistas.General.grande')
    end
  end

  def frente_w
    case self.frente
    when 'N'
      return I18n.t('Sistema.Body.General.no_aplica')
    when 'I'
      return I18n.t('Sistema.Body.Vistas.General.industrial')
    when 'T'
      return I18n.t('Sistema.Body.Vistas.General.turistico')
    when 'S'
      return I18n.t('Sistema.Body.Vistas.General.servicios')
    when 'V'
      return I18n.t('Sistema.Body.Vistas.General.vivienda')
    end
  end

  def comunidad
    case self.tipo_comunidad
    when 'I'
      I18n.t('Sistema.Body.Vistas.General.indigena')
    when 'A'
      I18n.t('Sistema.Body.Vistas.General.afrodescendiente')
    when 'O'
      I18n.t('Sistema.Body.Vistas.General.otro')
    end
  end

  def capital_suscrito_f=(valor)
    self.capital_suscrito = valor.sub(',', '.')
  end

  def capital_suscrito_f
    sprintf('%01.2f', self.capital_suscrito).sub('.', ',') unless self.capital_suscrito.nil?
  end
  def capital_suscrito_fm
    unless self.capital_suscrito.nil?
      valor = sprintf('%01.2f', self.capital_suscrito).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def capital_pagado_f=(valor)
    self.capital_pagado = valor.sub(',', '.')
  end
  def capital_pagado_f
    sprintf('%01.2f', self.capital_pagado).sub('.', ',') unless self.capital_pagado.nil?
  end

  def capital_pagado_fm
    unless self.capital_pagado.nil?
      valor = sprintf('%01.2f', self.capital_pagado).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def volumen_facturacion_f=(valor)
    self.volumen_facturacion = valor.sub(',', '.')
  end

  def volumen_facturacion_f
    sprintf('%01.2f', self.volumen_facturacion).sub('.', ',') unless self.volumen_facturacion.nil?
  end

  def volumen_facturacion_fm
    unless self.volumen_facturacion.nil?
      valor = sprintf('%01.2f', self.volumen_facturacion).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def update_all(params_empresa, params_cliente_empresa)
    self.update_attributes(params_empresa)
    self.cliente_empresa.update_attributes(params_cliente_empresa)
    self.errors.empty? && self.cliente_empresa.errors.empty?
  end

  def fecha_constitucion_f=(fecha)
    self.fecha_constitucion = fecha
  end

  def fecha_constitucion_f
    self.fecha_constitucion.strftime('%d/%m/%Y') unless self.fecha_constitucion.nil?
  end

  def fecha_registro_mercantil_f=(fecha)
    self.fecha_registro_mercantil = fecha
  end

  def fecha_registro_mercantil_f
    self.fecha_registro_mercantil.strftime('%d/%m/%Y') unless self.fecha_registro_mercantil.nil?
  end

  def fecha_inicio_operaciones_f=(fecha)
    self.fecha_inicio_operaciones = fecha
  end

  def fecha_inicio_operaciones_f
    self.fecha_inicio_operaciones.strftime('%d/%m/%Y') unless self.fecha_inicio_operaciones.nil?
  end

  def fecha_vencimiento_f=(fecha)
    self.fecha_vencimiento = fecha
  end

  def fecha_vencimiento_f
    self.fecha_vencimiento.strftime('%d/%m/%Y') unless self.fecha_vencimiento.nil?
  end
  
  after_save :actualizar_numero

  def actualizar_numero
    if self.numero.nil?
      self.numero = 1
      self.save
    end
  end

  def self.tipo_cliente(cliente_id)
    cliente = Cliente.find(cliente_id)
    if cliente.tipo_cliente_id == 1
      return true
    else
      return false
    end
  end

  def valida_rif
    if self.codigo_d3.nil?

      rif1 = @rif_1 unless self.rif
      rif2 = @rif_2 unless self.rif
      rif3 = @rif_3 unless self.rif

      unless rif1 == 'T'  || codigo_d3 != nil
        if rif1 == 'V' || rif1 == "J" || rif1 == 'E' || rif1 == 'P' || rif1 == 'G'
          rif8 = ""
          if rif1 == 'V'
            rif8 = "1" << rif2
          end
          if rif1 == "E"
            rif8 = "2" << rif2
          end
          if rif1 == "J"
            rif8 = "3" << rif2
          end
          if rif1 == "P"
            rif8 = "4" << rif2
          end
          if rif1 == "G"
            rif8 = "5" << rif2
          end

          suma = (rif8[8,1].to_i * 2) + (rif8[7,1].to_i * 3) + (rif8[6,1].to_i * 4) + (rif8[5,1].to_i * 5) +
            (rif8[4,1].to_i * 6) + (rif8[3,1].to_i * 7) + (rif8[2,1].to_i * 2) + (rif8[1,1].to_i * 3)  +
            (rif8[0,1].to_i * 4)

          division = suma / 11
          resto = suma - (division.to_i * 11)
          digito = 0

          if resto > 0
            digito = 11 - resto
          else
            digito
          end
          if digito == 10
            digito = 0
          end
          if digito != rif3.to_i
            errors.add(:empresa,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
          end
        else
          errors.add(:empresa,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
        end
      end
    end

  end
  
  before_save :cambio_mayuscula

  def cambio_mayuscula

    if self.codigo_d3.nil?
      unless self.alias.nil?
        self.alias  = self.alias.gsub('á', 'Á')
        self.alias  = self.alias.gsub('é', 'É')
        self.alias  = self.alias.gsub('í', 'Í')
        self.alias  = self.alias.gsub('ó', 'Ó')
        self.alias  = self.alias.gsub('ú', 'Ú')
        self.alias  = self.alias.upcase
      end
      unless self.nombre.nil?
        self.nombre  = self.nombre.gsub('á', 'Á')
        self.nombre  = self.nombre.gsub('é', 'É')
        self.nombre  = self.nombre.gsub('í', 'Í')
        self.nombre  = self.nombre.gsub('ó', 'Ó')
        self.nombre  = self.nombre.gsub('ú', 'Ú')
        self.nombre = self.nombre.upcase
      end
    end

    if self.codigo_d3.nil?

      rif1 = self.rif.slice(0,1)
      rif2 = self.rif.slice(2,8)
      rif3 = self.rif.slice(11,1)

      unless rif1 == 'T' || codigo_d3 != nil
        if rif1 == 'V' || rif1 == "J" || rif1 == 'E' || rif1 == 'P' || rif1 == 'G'
          rif8 = ""
          if rif1 == 'V'
            rif8 = "1" << rif2
          end
          if rif1 == "E"
            rif8 = "2" << rif2
          end
          if rif1 == "J"
            rif8 = "3" << rif2
          end
          if rif1 == "P"
            rif8 = "4" << rif2
          end
          if rif1 == "G"
            rif8 = "5" << rif2
          end

          suma = (rif8[8,1].to_i * 2) + (rif8[7,1].to_i * 3) + (rif8[6,1].to_i * 4) + (rif8[5,1].to_i * 5) +
            (rif8[4,1].to_i * 6) + (rif8[3,1].to_i * 7) + (rif8[2,1].to_i * 2) + (rif8[1,1].to_i * 3)  +
            (rif8[0,1].to_i * 4)

          division = suma / 11
          resto = suma - (division.to_i * 11)
          digito = 0

          if resto > 0
            digito = 11 - resto
          else
            errors.add(:empresa,I18n.t('Sistema.Body.Modelos.Errores.rif_invalido'))
          end
        end

      end
    end
  end

  def save_new(tipo_cliente_id)
    transaction do
      self.save
      if tipo_cliente_id.blank?
        errors.add(:empresa, "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}")
      end
      if self.errors.count > 0
        raise ActiveRecord::Rollback
      end
    end
    cliente_empresa = ClienteEmpresa.new
    cliente_empresa.tipo_cliente_id = tipo_cliente_id
    cliente_empresa.type = "ClienteEmpresa"
    cliente_empresa.empresa_id = self.id
    cliente_empresa.tipo_cuenta = "C"
    cliente_empresa.fecha_registro = Time.now
    cliente_empresa.save
    return true
  end

  def representante_legal
    return persona = Persona.find(:first,:conditions=>["id in (select ei.persona_id from empresa_integrante ei join empresa e on e.id = ei.empresa_id join empresa_integrante_tipo t on t.empresa_integrante_id = ei.id and t.tipo = 'R' where e.id = #{self.id})"])
  end

end

# == Schema Information
#
# Table name: empresa
#
#  id                            :integer         not null, primary key
#  nombre                        :string(255)     not null
#  alias                         :string(150)
#  rif                           :string(15)
#  codigo_nacionalidad           :string(5)
#  fecha_constitucion            :date
#  fecha_inicio_operaciones      :date
#  fecha_vencimiento             :date
#  capital_suscrito              :float
#  capital_pagado                :float
#  cantidad_empleados_femeninos  :integer(2)
#  cantidad_empleados_masculinos :integer(2)
#  volumen_facturacion           :float
#  tamano                        :string(1)       default("P")
#  numero_patente                :string(15)
#  numero_sunacop                :string(15)
#  web_site                      :string(80)
#  cantidad_accionistas          :integer(2)
#  frente                        :string(1)
#  sector_industrial_id          :integer
#  producto                      :string(500)
#  empresa_direccion_id          :integer
#  clasificacion_siex            :string(1)
#  codigo_d3                     :string(10)
#  nombre_registro_mercantil     :string(80)
#  direccion_registro_mercantil  :string(150)
#  estado_registro_id            :integer
#  ciudad_registro_id            :integer
#  municipio_registro_id         :integer
#  parroquia_registro_id         :integer
#  nro_registro_mercantil        :string(20)
#  nro_folio_inicial             :string(10)
#  nro_folio_final               :string(10)
#  nro_protocolo                 :string(10)
#  nro_tomo                      :string(10)
#  nro_trimestre                 :string(2)
#  fecha_registro_mercantil      :date
#  anio_registro_mercantil       :string(10)
#  objeto_social                 :string(255)
#  nit                           :string(15)
#  numero_certificado            :string(15)
#  cant_socios_femeninos         :integer
#  cant_socios_masculinos        :integer
#  tipo_comunidad                :string(1)
#  tipo_empresa_id               :integer
#  clasificacion_id              :integer
#  sector_economico_id           :integer
#  actividad_economica_id        :integer
#  rama_actividad_economica_id   :integer
#  uso_calculadora               :boolean
#  uso_maquina_escribir          :boolean
#  uso_computadora               :boolean
#  uso_equipos_especiales        :boolean
#  uso_ninguno                   :boolean
#  uso_otro                      :boolean
#  descripcion_otro              :string(250)
#  numero                        :integer
#  objeto                        :text
#  cant_miembros                 :integer
#  numero_familias               :integer
#  numero_viviendas              :integer
#  cant_productores              :integer
#  foto_confirmacion             :boolean         default(FALSE)
#  huella_confirmacion           :boolean         default(FALSE)
#

