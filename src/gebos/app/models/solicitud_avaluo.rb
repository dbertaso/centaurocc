# encoding: utf-8

class SolicitudAvaluo < ActiveRecord::Base
  
  self.table_name = 'solicitud_avaluo'
  
  attr_accessible :id,
  :nombre,
  :fecha,
  :valor_avaluo,
  :urbanizacion,
  :calle,
  :casa,
  :numero_apta,
  :piso,
  :punto_referencia,
  :estado_id,
  :municipio_id,
  :parroquia_id,
  :comentario,
  :solicitud_id,
  :solicitud_tipo_garantia_id,
  :estatus,
  :documento_oferta,
  :numero_sudeban,
  :fecha_actualizacion,
  :nombre_perito,
  :fecha_avaluo_f,
  :valor_avaluo_f

  has_many :solicitud_avaluo_mobiliario
  has_many :solicitud_avaluo_inmobiliario
  has_many :solicitud_avaluo_fianza
  has_many :solicitud_avaluo_prenda

  belongs_to :solicitud
  belongs_to :solicitud_tipo_garantia
  belongs_to :estado
  belongs_to :municipio
  belongs_to :parroquia
  
  validates :solicitud_id, :presence => {
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.solicitud')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}
  
  validates :nombre_perito, :presence => { :if => Proc.new {|a| a.documento_oferta == true},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.nombre_perito')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_avaluo, :presence => { :if => Proc.new {|a| a.documento_oferta == true},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.fecha_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :valor_avaluo, :presence => { :if => Proc.new {|a| a.documento_oferta == true},
    :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
    :numericality =>{:numericality => true, :only_integer=>false, :allow_nil => true, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}" }

  validates :fecha_avaluo, :allow_blank =>true,
    :date => {:message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.fecha_avaluo_formato')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}",
    :before => Proc.new { 1.day.from_now.to_date }, :message => "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.fecha_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_posterior_fecha_actual')}"}
  


  def validate
    unless self.valor_avaluo.nil?
      if self.valor_avaluo < 1
        errors.add(:solicitud_avaluo, "#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.valor_avaluo')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_mayor_cero')}")
      end
    end
  end

  def estado_w
    estado = Estado.find(self.estado_id)
    return estado.nombre
  end

  def valor_avaluo_f=(valor)
    self.valor_avaluo = format_valor(valor)
  end
  
  def valor_avaluo_f
    format_f(self.valor_avaluo)
  end

  def fecha_avaluo_f=(fecha)
    self.fecha_avaluo = fecha
  end

  def fecha_avaluo_f
    format_fecha(self.fecha_avaluo)
  end

  def fecha_actualizacion_f
    format_fecha(self.fecha_actualizacion)
  end

  def self.crear_registro(avaluo_propio, avaluo_bandes, solicitud_id, solicitud_tipo_garantia_id)
    begin
      solicitud_avaluo = SolicitudAvaluo.new(avaluo_propio)
      solicitud_tipo_garantia = SolicitudTipoGarantia.find(solicitud_tipo_garantia_id)
      solicitud_avaluo.documento_oferta = true
      if solicitud_tipo_garantia.tipo_garantia.tipo == 'M'
        garantia = SolicitudAvaluoMobiliario.new(avaluo_bandes)
        unless garantia.tipo_documento.nil? || garantia.tipo_documento == 'N'
          solicitud_avaluo.documento_oferta = false
        end
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
        garantia = SolicitudAvaluoInmobiliario.new(avaluo_bandes)
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
        garantia = SolicitudAvaluoFianza.new(avaluo_bandes)
        solicitud_avaluo.documento_oferta = false
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
        garantia = SolicitudAvaluoPrenda.new(avaluo_bandes)
        unless garantia.tipo_documento.nil? || garantia.tipo_documento == 'N'
          solicitud_avaluo.documento_oferta = false
        end
      end
      transaction do
        solicitud_avaluo.solicitud_id = solicitud_id
        solicitud_avaluo.fecha_actualizacion = Time.now
        solicitud_avaluo.solicitud_tipo_garantia_id = solicitud_tipo_garantia_id
        solicitud_avaluo.save!
        garantia.solicitud_avaluo_id = solicitud_avaluo.id
        garantia.save!
        return true
      end
      rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
        errores = ''
        solicitud_avaluo.errors.full_messages.each { |e|
          errores << "<li>" + e + "</li>"
        }
        unless garantia.nil?
          garantia.errors.full_messages.each{ |e|
            errores << "<li>" + e + "</li>"
          }
        end
      return errores
    end
  end

  def self.editar_registro(avaluo_propio, avaluo_bandes, id)
    begin
      solicitud_avaluo = SolicitudAvaluo.find(id)
      solicitud_avaluo.documento_oferta = true
      if solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'M'
        garantia = SolicitudAvaluoMobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ?', solicitud_avaluo.id])
        unless avaluo_bandes[:tipo_documento].nil? || avaluo_bandes[:tipo_documento] == 'N'
          solicitud_avaluo.documento_oferta = false
        end
      elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
        garantia = SolicitudAvaluoInmobiliario.find(:first, :conditions=>['solicitud_avaluo_id = ?', solicitud_avaluo.id])
      elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
        garantia = SolicitudAvaluoFianza.find(:first, :conditions=>['solicitud_avaluo_id = ?', solicitud_avaluo.id])
      elsif solicitud_avaluo.solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
        garantia = SolicitudAvaluoPrenda.find(:first, :conditions=>['solicitud_avaluo_id = ?', solicitud_avaluo.id])
        unless avaluo_bandes[:tipo_documento].nil? || avaluo_bandes[:tipo_documento] == 'N'
          solicitud_avaluo.documento_oferta = false
        end
      end
      transaction do
        solicitud_avaluo.update_attributes(avaluo_propio)
        solicitud_avaluo.save!
        garantia.update_attributes(avaluo_bandes)
        garantia.save!
      end
      rescue
        errores = ''
        solicitud_avaluo.errors.full_messages.each { |e|
          errores << "<li>" + e + "</li>"
        }
        unless garantia.nil?
          garantia.errors.full_messages.each{ |e|
            errores << "<li>" + e + "</li>"
          }
        end
      return errores
    end
  end

  def self.historico_registro(avaluo_propio, avaluo_bandes, id)
    begin
      solicitud_avaluo = SolicitudAvaluo.find(id)
      solicitud_id = solicitud_avaluo.solicitud_id
      solicitud_tipo_garantia_id = solicitud_avaluo.solicitud_tipo_garantia_id
      solicitud_avaluo = SolicitudAvaluo.new(avaluo_propio)
      solicitud_tipo_garantia = SolicitudTipoGarantia.find(solicitud_tipo_garantia_id)
      if solicitud_tipo_garantia.tipo_garantia.tipo == 'M'
        garantia = SolicitudAvaluoMobiliario.new(avaluo_bandes)
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'I'
        garantia = SolicitudAvaluoInmobiliario.new(avaluo_bandes)
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'F'
        garantia = SolicitudAvaluoFianza.new(avaluo_bandes)
      elsif solicitud_tipo_garantia.tipo_garantia.tipo == 'P'
        garantia = SolicitudAvaluoPrenda.new(avaluo_bandes)
      end
      transaction do
        SolicitudAvaluo.update_all("estatus = 'H'", "solicitud_tipo_garantia_id = #{solicitud_tipo_garantia_id}")
        solicitud_avaluo.solicitud_id = solicitud_id
        solicitud_avaluo.fecha_actualizacion = Time.now
        solicitud_avaluo.solicitud_tipo_garantia_id = solicitud_tipo_garantia_id
        solicitud_avaluo.save!
        garantia.solicitud_avaluo_id = solicitud_avaluo.id
        garantia.save!
      end
      rescue
        errores = ''
        solicitud_avaluo.errors.full_messages.each { |e|
          errores << "<li>" + e + "</li>"
        }
        unless garantia.nil?
          garantia.errors.full_messages.each{ |e|
            errores << "<li>" + e + "</li>"
          }
        end
      return errores
    end
  end

  def self.validar_avaluo(id)
    solicitud = Solicitud.find(id)
    error = ""
    if solicitud.avaluo_obra_civil
      unless SolicitudObraCivil.count(:conditions=>['solicitud_id = ?', solicitud.id]) > 0
        error << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.lista_chequeo_completar_informacion')}</li>"
      end
    end
    unless SolicitudRecaudoAvaluo.count(:conditions=>['solicitud_id = ? and revisado = true', solicitud.id]) > 0
      error << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.lista_chequeo_marcar_como_revisado')}</li>"
    end
    unless SolicitudTipoGarantia.count(:conditions=>['solicitud_id = ?', solicitud.id]) > 0
      error << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.informe_agregar_al_menos_una_garantia')}</li>"
    else
      solicitud_tipo_garantia = SolicitudTipoGarantia.find(:all, :conditions=>['solicitud_id = ?', solicitud.id])
      solicitud_tipo_garantia.each { |s|
        unless SolicitudAvaluo.count(:conditions=>['solicitud_tipo_garantia_id = ?', s.id]) > 0
          error << "<li>#{I18n.t('Sistema.Body.Modelos.SolicitudAvaluo.Errores.informe_tipo_garantia_completar_informacion')}</li>"
        end
      }
    end
    if error.length > 0
      return error
    else
      return true
    end
  end

  def ubicacion_f
    str_ubicacion = ''
    str_ubicacion << 'Urbanización: ' << self.urbanizacion unless self.urbanizacion.nil?
    str_ubicacion << ' Calle: ' << self.calle unless self.calle.nil?
    str_ubicacion << ' Casa: ' << self.casa unless self.casa.nil?
    str_ubicacion << ' Apto: ' << self.numero_apta unless self.numero_apta.nil?
    str_ubicacion << ' Piso: ' << self.piso unless self.piso.nil?
    return str_ubicacion
  end

end
# == Schema Information
#
# Table name: solicitud_avaluo
#
#  id                         :integer         not null, primary key
#  nombre_perito              :string(100)
#  fecha_avaluo               :date
#  valor_avaluo               :float
#  urbanizacion               :string(100)
#  calle                      :string(100)
#  casa                       :string(100)
#  numero_apta                :string(20)
#  piso                       :string(20)
#  punto_referencia           :string(50)
#  estado_id                  :integer
#  municipio_id               :integer
#  parroquia_id               :integer
#  comentario                 :text
#  solicitud_id               :integer         not null
#  solicitud_tipo_garantia_id :integer         not null
#  estatus                    :string(1)       default("V"), not null
#  documento_oferta           :boolean
#  numero_sudeban             :string(20)
#  fecha_actualizacion        :datetime        not null
#

