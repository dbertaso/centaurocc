# encoding: utf-8
#
# autor: Luis Rojas
# clase: CuentaBancaria
# descripción: Migración a Rails 3
#

class CuentaBancaria < ActiveRecord::Base
  
  self.table_name = 'cuenta_bancaria'
  
  attr_accessible :id,
    :numero,
    :tipo,
    :fecha_apertura,
    :entidad_financiera_id,
    :agencia_bancaria_id,
    :cliente_id,
    :activo
  
  has_many :historico_cambio_cuenta
  belongs_to :cliente
  belongs_to :entidad_financiera
  #, :tipo
  validates :numero, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :length => { :in => 20..20, :allow_blank => true,
    :too_short => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('errors.messages.too_short.other')}",
    :too_long => "#{I18n.t('Sistema.Body.Vistas.General.numero')}  #{I18n.t('errors.messages.too_long.other')}"},
    :numericality => {:numericality => true, :allow_blank => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalido')}"},
    :uniqueness =>{:uniqueness => true, :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}"}
  validates :tipo, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :entidad_financiera_id, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  validates :fecha_apertura,:presence => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.apertura')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :date => {:message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.apertura')} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}",
    :allow_blank => true,
    :before => Proc.new { 0.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.apertura')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}

  def fecha_apertura_f=(fecha)
    self.fecha_apertura = fecha
  end
  
  def fecha_apertura_f
    format_fecha(self.fecha_apertura)
  end
  
  def tipo_w
    if self.tipo == 'A'
      I18n.t('Sistema.Body.Vistas.General.ahorros')
    else
      I18n.t('Sistema.Body.Vistas.General.corriente')
    end
  end
  
  validate :validate
  
  def validate
    total = CuentaBancaria.count(:conditions => "cliente_id = #{self.cliente_id}")
    if total > 1
      errors.add(:cuenta_bancaria, I18n.t('Sistema.Body.Modelos.Errores.beneficiario_ya_posee_cuenta'))
    end
  end

  def create_new(parametros, id, tipo_cliente, id_usuario)
    # lo que estaba originalmente
    self.tipo = parametros[:tipo]
    self.numero = parametros[:numero]
    self.entidad_financiera_id = parametros[:entidad_financiera_id]
    self.agencia_bancaria_id = parametros[:agencia_bancaria_id]
    self.fecha_apertura_f = parametros[:fecha_apertura_f]
    self.activo = parametros[:activo]
    if tipo_cliente == 'E'
      empresa = Empresa.find(id)
      self.cliente_id = empresa.cliente_empresa.id
    else
      persona = Persona.find(id)
      self.cliente_id = persona.cliente_persona.id
    end
    val=self.save
    # fin lo que estaba originalmente
    if val
      @historico_cambio_cuenta= HistoricoCambioCuenta.new
      @historico_cambio_cuenta.cuenta_id=self.id
      @historico_cambio_cuenta.usuario_id=id_usuario
      @historico_cambio_cuenta.tipo_cuenta_actual = parametros[:tipo]
      @historico_cambio_cuenta.numero_cuenta_actual = parametros[:numero]
      @historico_cambio_cuenta.entidad_financiera_id_actual = parametros[:entidad_financiera_id]
      @historico_cambio_cuenta.activo_actual = parametros[:activo]
      @historico_cambio_cuenta.fecha_modificacion_actual = Time.now
      if tipo_cliente == 'E'
        empresa = Empresa.find(id)
        @historico_cambio_cuenta.empresa_id = empresa.cliente_empresa.id
      else
        persona = Persona.find(id)
        @historico_cambio_cuenta.persona_id = persona.cliente_persona.id
      end

      @historico_cambio_cuenta.fecha_apertura=self.fecha_apertura.strftime('%Y-%m-%d') unless self.fecha_apertura.nil?
      @historico_cambio_cuenta.save
    end
    return val
  end

  def edit_record(parametros,observaciones,id_session,id_cuenta,id_persona_empresa,tipo_cliente,comentario)

    @cuenta_bancaria = CuentaBancaria.find(id_cuenta)   
    #self.id=parametros[:"id"]
    self.activo=parametros[:"activo"]
    self.entidad_financiera_id=parametros[:"entidad_financiera_id"].to_i
    self.tipo=parametros[:"tipo"].to_s
    self.numero=parametros[:"numero"]
    self.fecha_apertura_f=parametros[:"fecha_apertura_f"]
    #self.update_attributes(parametros)
    if self.valid?

      if comentario.strip == "" 
        errors.add(:cuenta_bancaria, "Debe agregar una observación para proceder con la modificación")
        val=false
      else
        #antes solo estaba esto
        #self.update_attributes(parametros)
        val=self.save
        # solo estaba esto fin
      end

    else

      if comentario.strip == "" 
        errors.add(:cuenta_bancaria, "Debe agregar una observación para proceder con la modificación")
      end
      val=false
    end

    if val

      @historico_cambio_cuenta= HistoricoCambioCuenta.new
      @historico_cambio_cuenta.tipo_cuenta_actual = parametros[:tipo]
      @historico_cambio_cuenta.numero_cuenta_actual = parametros[:numero]
      @historico_cambio_cuenta.entidad_financiera_id_actual = parametros[:entidad_financiera_id]
      @historico_cambio_cuenta.fecha_modificacion_actual= Time.now
      #nuevo
      @historico_cambio_cuenta.activo_actual = parametros[:activo]
      @historico_cambio_cuenta.activo_ultima_modificacion = @cuenta_bancaria.activo
      #nuevo fin
      @historico_cambio_cuenta.fecha_apertura = HistoricoCambioCuenta.find_by_cuenta_id_and_observaciones(id_cuenta,'').fecha_apertura.strftime('%Y-%m-%d') unless HistoricoCambioCuenta.find_by_cuenta_id_and_observaciones(id_cuenta,'').fecha_apertura.nil? unless HistoricoCambioCuenta.find_by_cuenta_id_and_observaciones(id_cuenta,'').nil?
      @historico_cambio_cuenta.usuario_id =id_session
      @historico_cambio_cuenta.observaciones = observaciones
      @historico_cambio_cuenta.entidad_financiera_id_ultima_modificacion = @cuenta_bancaria.entidad_financiera_id
      @historico_cambio_cuenta.tipo_cuenta_ultima_modificacion = @cuenta_bancaria.tipo
      @historico_cambio_cuenta.numero_cuenta_ultima_modificacion = @cuenta_bancaria.numero
      
      fecha=parametros[:fecha_apertura_f]
        
      unless fecha.to_s==""
        @historico_cambio_cuenta.fecha_ultima_modificacion =fecha[6,4]+"-"+fecha[3,2]+"-"+fecha[0,2]  
      end
      #ojo con esta
      @historico_cambio_cuenta.cuenta_id=@cuenta_bancaria.id
        
      if tipo_cliente == 'E'
        empresa = Empresa.find(id_persona_empresa) 
        @historico_cambio_cuenta.empresa_id  = empresa.cliente_empresa.id
      else
        persona = Persona.find(id_persona_empresa)
        @historico_cambio_cuenta.persona_id  = persona.cliente_persona.id
      end
      @historico_cambio_cuenta.save
    end
    return val
  end

  def self.view(cliente_id, tipo)
    cuenta = CuentaBancaria.find(:first, :conditions=>['cliente_id = ?', cliente_id])
    unless cuenta.nil?
      if tipo == 'N'
        return cuenta.numero
      elsif tipo == 'T'
        return cuenta.tipo_w
      elsif tipo == 'B'
        return cuenta.entidad_financiera.nombre
      end
    else
      return ''
    end
  end
  
  def self.search(search, page, orden)    
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>search, :order=>orden
  end
  
end

# == Schema Information
#
# Table name: cuenta_bancaria
#
#  id                    :integer         not null, primary key
#  numero                :string(20)      not null
#  tipo                  :string(1)       not null
#  fecha_apertura        :date
#  entidad_financiera_id :integer         not null
#  agencia_bancaria_id   :integer
#  cliente_id            :integer         not null
#  activo                :boolean         default(TRUE), not null
#

