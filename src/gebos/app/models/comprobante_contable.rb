# encoding: utf-8

#
# autor: Diego Bertaso
# clase: ComprobanteContable
# descripción: Migración a Rails 3
#
class ComprobanteContable < ActiveRecord::Base

  self.table_name = 'comprobante_contable'
  
  attr_accessible   :id,
                    :fecha_registro,
                    :fecha_comprobante,
                    :fecha_envio,
                    :enviado,
                    :numero_lote_envio,
                    :total_debe,
                    :total_haber,
                    :numero_contabilidad,
                    :unidad_asiento,
                    :prestamo_id,
                    :factura_id,
                    :anio,
                    :transaccion_id,
                    :reversado,
                    :reverso,
                    :comprobante_reverso_id,
                    :comprobante_reversado_id,
                    :referencia,
                    :codigo_transaccion,
                    :estatus
                    
  belongs_to :prestamo
  belongs_to :transaccion_contable
  belongs_to :factura
  belongs_to :transaccion
  belongs_to :comprobante_reverso,
    :foreign_key=>"comprobante_reverso_id", :class_name=>"ComprobanteContable"

  has_many :asientos, :class_name => "AsientoContable", :order=>"id"

  validates :transaccion_contable_id, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.transaccion_contable_id')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"}

  validates :fecha_registro, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                             :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_registro')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates :fecha_comprobante, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_comprobante')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                                :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_comprobante')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates :fecha_envio, :presence => {:message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_envio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"},
                          :date => {:message =>"#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.fecha_envio')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"}

  validates :anio, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.anio')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :numero_lote_envio, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.numero_lote_envio')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :numero_contabilidad, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.numero_contabilidad')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :unidad_asiento, :numericality => {:only_integer => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.unidad_asiento')} #{I18n.t('Sistema.errors.messages_not_an_integer')}"}

  validates :total_debe, :numericality => {:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.total_debe')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  validates :total_haber, :numericality => {:numericality => true,
    :message => "#{I18n.t('Sistema.Body.Modelos.ComprobanteContable.Columnas.total_haber')} #{I18n.t('Sistema.Body.Modelos.Errores.debe_ser_numerico')}"}

  after_initialize :after_initialize

  def self.envio_comprobante(comprobantes,fecha_inicio,fecha_fin,usuario_id)

    result = ''
    total_debe = 0.00
    total_haber = 0.00
    total_diferencia = 0.00
    no_asiento = 0
    conn = ActiveRecord::Base.connection
    parametro = ParametroGeneral.first

    unless parametro.nil?

      #ruta_archivo = parametro.ruta_archivo_comprobante
      nombre ='comprobantes_contables_' + fecha_inicio.gsub("/", "") + "_al_" + fecha_fin.gsub("/", "")
      documento = "#{Rails.public_path}/documentos/contabilidad/#{nombre}.txt"
    end

    begin

      ComprobanteContable.transaction do

        CSV.open(documento,'w+',{:row_sep => "\r\n", :col_sep=>"|"}) do |csv|

          unless comprobantes.length == 0

            comprobantes.each do |comprobante|

              logger.info "Leyendo comprobantes"
              if comprobante.referencia.nil?
                referencia = 'N/A'
              else
                referencia = comprobante.referencia
              end
              referencia.gsub!(',','')
              encabezado = ''
              encabezado = 'E'
              encabezado << ('0' * (15 - comprobante.id.to_s.length)) << comprobante.id.to_s
              encabezado << format_fecha(comprobante.fecha_registro)
              encabezado << format_fecha(comprobante.fecha_comprobante)
              encabezado << referencia
              encabezado << ('0' * (15 - comprobante.total_debe.to_s.length)) << comprobante.total_debe.to_s
              encabezado << ('0' * (15 - comprobante.total_haber.to_s.length)) << comprobante.total_haber.to_s
              diferencia = comprobante.total_debe - comprobante.total_haber
              encabezado << ('0' * (15 - diferencia.to_s.length)) << diferencia.to_s

              asientos = ViewEnvioAsientoContable.where(["comprobante_contable_id = ?", comprobante.id]).order("tipo")

              unless asientos.length == 0


                csv << [encabezado]
                asientos.each do |asiento|
                  detalle = 'D'
                  detalle << asiento.codigo_contable
                  detalle << asiento.auxiliar_contable.to_s
                  detalle << asiento.tipo
                  detalle << ('0' * (15 - asiento.monto.to_s.length)) << asiento.monto.to_s
                  detalle << (' ' * (encabezado.length - detalle.length))
                  csv << [detalle]
                  detalle = ''
                end
              else
                rev = RechazoEnvioComprobante.new
                rev.fecha_comprobante = comprobante.fecha_comprobante
                rev.referencia = referencia
                rev.motivo = I18n.t('Sistema.Body.Modelos.ComprobanteContable.Errores.comprobante_sin_asientos')
                rev.numero = comprobante.id
                rev.total_debe = comprobante.total_debe
                rev.total_haber = comprobante.total_haber
                rev.fecha_proceso = Time.now.strftime("%Y-%m-%d")
                rev.usuario_id = usuario_id
                rev.save
              end     #=======> Fin unless asientos.nil

              # Actualización de enviado al comprobante
              begin
                fecha_envio = Time.now.strftime("%Y-%m-%d")
                oper = conn.execute("update comprobante_contable set enviado = 't', fecha_envio = \'#{fecha_envio}\' where id = #{comprobante.id}")
                total_debe += comprobante.total_debe
                total_haber += comprobante.total_haber
                total_diferencia += diferencia
              rescue
                result = I18n.t('Sistema.Body.Modelos.ComprobanteContable.Errores.fallo_actualizacion_envio_comprobante')
                return result
              end

            end         #=======> Fin comprobantes.each do |comprobante|

            begin

              #Grabación de registro en archivo de control de envio de comprobantes    

              control = ControlEnvioContabilidad.new

              control.fecha_inicio = fecha_inicio
              control.fecha_fin = fecha_fin
              control.file_name = nombre
              control.total_debe = total_debe
              control.total_haber = total_haber
              control.cantidad_envio = comprobantes.length
              control.diferencia = total_diferencia
              control.usuario_id = usuario_id
              control.fecha_proceso = Time.now.strftime("%Y-%m-%d")
              control.save
            rescue => detail
              logger.info "Errores ======> #{control.inspect}"
            end
          else
            rev = RechazoEnvioComprobante.new
            rev.fecha_comprobante = Time.now.strftime("%Y-%m-%d")
            rev.referencia = 'No hay comprobantes'
            rev.motivo = I18n.t 'Sistema.Body.Modelos.ComprobanteContable.Errores.no_existen_comprobantes_en_rango_fechas', :fecha_inicio => fecha_inicio, :fecha_fin => fecha_fin
            rev.numero = 0
            rev.total_debe = 0
            rev.total_haber = 0
            rev.fecha_proceso = Time.now.strftime("%Y-%m-%d")
            rev.usuario_id = usuario_id
            rev.save
            result = I18n.t 'Sistema.Body.Modelos.ComprobanteContable.Errores.no_existen_comprobantes_en_rango_fechas', :fecha_inicio => fecha_inicio, :fecha_fin => fecha_fin
            return result
          end         #=======> Fin unless comprobantes.nil?

        end           #=======> Fin del CSV

      end             #=======> Fin transaction do

    end               # Fin del Begin

    return result

  end                 # Fin del método envio_comprobante

  def self.search(search, page, sort, sql, incluir)

    unless search.nil?
      paginate  :per_page => @records_by_page,
                :page => page,
                :conditions => search,
                :order => sort,
                :include => incluir,
                :select => 'comprobante_contable.*'
    else
      paginate  :per_page => @records_by_page,
                :page => page,
                :order => sort,
                :include => incluir,
                :select => 'comprobante_contable.*'

    end

  end

  def after_initialize
    self.fecha_registro = Time.now unless self.fecha_registro
    self.total_debe = 0.0 unless self.total_debe
    self.total_haber = 0.0 unless self.total_haber
    self.anio = 0 unless self.anio
  end

  def fecha_registro_f=(fecha)
    self.fecha_registro = fecha
  end

  def fecha_registro_f
    self.fecha_registro.strftime('%d/%m/%Y') unless self.fecha_registro.nil?
  end

  def fecha_comprobante_f=(fecha)
    self.fecha_comprobante = fecha
  end

  def fecha_comprobante_f
    self.fecha_comprobante.strftime('%d/%m/%Y') unless self.fecha_comprobante.nil?
  end

  def fecha_envio_f=(fecha)
    self.fecha_envio = fecha
  end

  def fecha_envio_f
    self.fecha_envio.strftime('%d/%m/%Y') unless self.fecha_envio.nil?
  end

  def total_debe_f=(valor)
    self.total_debe = valor.sub(',', '.')
  end

  def total_debe_f
    sprintf('%01.2f', self.total_debe).sub('.', ',') unless self.total_debe.nil?
  end

  def total_debe_fm
    unless self.total_debe.nil?
      valor = sprintf('%01.2f', self.total_debe).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def total_haber_f=(valor)
    self.total_haber = valor.sub(',', '.')
  end

  def total_haber_f
    sprintf('%01.2f', self.total_haber).sub('.', ',') unless self.total_haber.nil?
  end

  def total_haber_fm
    unless self.total_haber.nil?
      valor = sprintf('%01.2f', self.total_haber).sub('.', ',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def self.elimina_comprobante_contable(fecha,transaccion)

    logger.info "Transaccion ====> " << transaccion
    transaction do
      params = {
        :p_codigo_transaccion=>transaccion,
        :p_fecha=>fecha
        }
      execute_sp('elimina_comprobante_contable', params.values_at(
         :p_codigo_transaccion,
         :p_fecha))

    end

  end

  def self.asiento_detalle(id)
    asiento_contable = AsientoContable.all(:conditions => "comprobante_contable_id = #{id}")
    if asiento_contable.nil?
      asiento_contable = []
    end
    return asiento_contable
  end

end



# == Schema Information
#
# Table name: comprobante_contable
#
#  id                       :integer         not null, primary key
#  fecha_registro           :date            not null
#  fecha_comprobante        :date            not null
#  fecha_envio              :date
#  enviado                  :boolean         default(FALSE)
#  numero_lote_envio        :integer
#  total_debe               :float
#  total_haber              :float
#  numero_contabilidad      :integer
#  unidad_asiento           :integer
#  prestamo_id              :integer
#  factura_id               :integer
#  anio                     :integer
#  transaccion_id           :integer
#  reversado                :boolean         default(FALSE)
#  reverso                  :boolean         default(FALSE)
#  comprobante_reverso_id   :integer
#  comprobante_reversado_id :integer
#  referencia               :text
#  estatus                  :string(1)
#  transaccion_contable_id  :integer         not null
#

