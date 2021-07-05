# encoding: utf-8

#
# 
# clase: Cliente
# descripción: Migración a Rails 3
#

class Cliente < ActiveRecord::Base

  self.table_name = 'cliente'

  attr_accessible :id,:tipo_cliente_id,:persona_id,:empresa_id,:type,:entidad_financiera_id,:tipo_cuenta,:numero_cuenta,:codigo_d3,:migrado_d3,:nro_expediente,:agencia_bancaria_id,:moroso,:reestructurado,:viable, :es_pescador


  belongs_to :tipo_cliente
  belongs_to :entidad_financiera
  belongs_to :agencia_bancaria
  belongs_to :persona
  belongs_to :empresa
  has_many :antecedentes, :dependent => :destroy, :class_name=>'ClienteAntecedente'
  has_many :cuenta_bancaria
  has_many :unidad_produccion
  has_many :desvio_silo
  
  validates :tipo_cliente, :presence => {:message => "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  def nombre
    if self.class.to_s=='ClientePersona'
      self.persona.nombre_completo
    else
      self.empresa.nombre
    end
  end

  def identificador
    if self.class.to_s == 'ClientePersona'
      self.persona.cedula
    else
      self.empresa.rif
    end
  end

  def cedula_rif
    if self.class.to_s == 'ClientePersona'
      self.persona.cedula_nacionalidad + '-' + self.persona.cedula.to_s
    else
      self.empresa.rif
    end
  end
  
  def sector_economico

    sector = nil
    if self.class.to_s=='ClientePersona'

      sector = self.persona.sector_economico_id
    else
      sector = self.empresa.sector_economico_id
    end
    return sector
  end

  def fecha_registro_f
    self.fecha_registro.strftime('%d/%m/%Y') unless self.fecha_registro.nil?
  end

#  def entidad_financiera
#
#    entidad = nil
#
#    cuenta = CuentaBancaria.find_by_cliente_id(self.solicitud.cliente_id)
#
#    entidad = cuenta.entidad_financiera_id unless entidad.nil?
#
#    return entidad
#
#  end

  def direccion_correspondencia
    dir = nil
    if self.class.to_s=='ClientePersona'
      dir = self.persona.direcciones.find_by_correspondencia(true)
      dir = self.persona.direcciones.find_by_tipo('H') if dir.nil?
      dir = self.persona.direcciones.find_by_tipo('O') if dir.nil?
      dir = self.persona.direcciones.find_by_tipo('T') if dir.nil?
    else
      dir = self.empresa.direcciones.find_by_correspondencia(true)
      dir = self.empresa.direcciones.find_by_tipo('P') if dir.nil?
      dir = self.empresa.direcciones.find_by_tipo('S') if dir.nil?
      dir = self.empresa.direcciones.find_by_tipo('L') if dir.nil?
      dir = self.empresa.direcciones.find_by_tipo('D') if dir.nil?
      dir = self.empresa.direcciones.find_by_tipo('O') if dir.nil?
    end
    return dir
  end

  def telefonos_contacto
    tels = self.persona.telefonos if  self.class.to_s=='ClientePersona'
    tels = self.empresa.telefonos if  self.class.to_s=='ClienteEmpresa'
    str = ''
    previo = false
    tels.each do |tel|
      str << 'Fax: ' << tel.to_s if tel.fax?
      str <<  tel.to_s unless tel.fax?
      str << ' / ' if previo
      previo = true;
    end
    return str
  end

  def before_create
    
#    ultimo_expediente =Cliente.find_by_sql("select * from cliente order by nro_expediente desc limit 1").first
#    if ultimo_expediente
#      self.nro_expediente = ultimo_expediente.nro_expediente + 1
#    else
#      self.nro_expediente = 999999
#    end

  end

  def before_save
    if self.new_record?
      self.fecha_registro = Time.now
    end
  end

  def validate
    if !self.numero_cuenta.nil? && !self.numero_cuenta.empty?
      if self.numero_cuenta.match(/\d{20}/).nil?
        errors.add(nil, "El Número de Cuenta debe estar conformado por 20 números")        
      end
    end
  end
  def numero_cuenta_1=(valor)
    @numero_cuenta_1 = valor
  end
  def numero_cuenta_1
    self.numero_cuenta.slice(0,4) unless self.numero_cuenta.nil?
  end
  
  def numero_cuenta_2=(valor)
    @numero_cuenta_2 = valor
  end
  def numero_cuenta_2
    self.numero_cuenta.slice(4,4) unless self.numero_cuenta.nil?
  end
  
  def numero_cuenta_3=(valor)
    @numero_cuenta_3 = valor
  end
  def numero_cuenta_3  
    self.numero_cuenta.slice(8,2) unless self.numero_cuenta.nil?
  end 
  
  def numero_cuenta_4=(valor)
    @numero_cuenta_4 = valor 
  end
  def numero_cuenta_4  
    self.numero_cuenta.slice(10,10) unless self.numero_cuenta.nil?
  end  
   
  def tipo_cuenta_w
    case self.tipo_cuenta
      when 'A'
        return I18n.t('Sistema.Body.Vistas.General.ahorro')
      when 'C'
        return I18n.t('Sistema.Body.Vistas.General.corriente')
    end
  end
  def before_validation
    
    if (!@numero_cuenta_1.nil?&&!@numero_cuenta_1.empty?) ||
    (!@numero_cuenta_2.nil?&&!@numero_cuenta_2.empty?)||
    (!@numero_cuenta_3.nil?&&!@numero_cuenta_3.empty?)||
    (!@numero_cuenta_4.nil?&&!@numero_cuenta_4.empty?)
      self.numero_cuenta = @numero_cuenta_1.to_s + @numero_cuenta_2.to_s + @numero_cuenta_3.to_s + @numero_cuenta_4.to_s
    end
  end

  def cantidad_solicitudes
    return Solicitud.count(:conditions=>['cliente_id = ? ',self.id])
  end
 


end


# == Schema Information
#
# Table name: cliente
#
#  id                    :integer         not null, primary key
#  tipo_cliente_id       :integer
#  persona_id            :integer
#  empresa_id            :integer
#  type                  :string(15)      not null
#  entidad_financiera_id :integer
#  tipo_cuenta           :string(1)       default("C")
#  numero_cuenta         :string(20)
#  codigo_d3             :string(10)
#  migrado_d3            :boolean         default(FALSE)
#  nro_expediente        :integer         default(0)
#  agencia_bancaria_id   :integer
#  moroso                :boolean         default(FALSE), not null
#  reestructurado        :boolean         default(FALSE), not null
#  viable                :boolean         default(TRUE), not null
#  es_pescador           :boolean         default(FALSE), not null
#  fecha_registro        :date
#

