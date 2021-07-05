# encoding: utf-8

#
# autor: Luis Rojas
# clase: GuiaMovilizacionMaquinaria
# descripción: Migración a Rails 3
#

class GuiaMovilizacionMaquinaria < ActiveRecord::Base

  self.table_name = 'guia_movilizacion_maquinaria'
  
  attr_accessible :id,
				  :solicitud_id,
				  :empresa_transporte_maquinaria_id ,
				  :oficina_id,
				  :ci_contacto_1,
				  :ci_contacto_2,
				  :nombre_contacto_1,
				  :nombre_contacto_2,
				  :telefono_contacto_1,
				  :telefono_contacto_2,
				  :fecha_emision,
				  :destino,
				  :unidad_produccion_id,
				  :direccion_destino,
				  :telefono_destino,
				  :estatus,
				  :usuario_id,
				  :numero_guia,
				  :evento,
				  :ci_nacionalidad_1,
				  :ci_nacionalidad_2,
				  :fecha_estimada,
                  :fecha_emision_f,
                  :fecha_estimada_f


  belongs_to :empresa_transporte_maquinaria
  belongs_to :unidad_produccion
  belongs_to :solicitud   
  belongs_to :oficina
  has_many :guia_catalogo

  
  validates  :empresa_transporte_maquinaria_id,
    :presence => {:message => I18n.t('Sistema.Body.Controladores.EmpresaTransporteMaquinaria.FormTitles.form_title_record')<< " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates  :ci_nacionalidad_1,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nacionalidad') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates :ci_nacionalidad_2,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nacionalidad') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates  :ci_contacto_1,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.cedula') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates :ci_contacto_2,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.cedula') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates  :nombre_contacto_1,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates  :telefono_contacto_1,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates  :nombre_contacto_2,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates  :telefono_contacto_2,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
    
#  validates_presence_of  :numero_guia,
#    :message => "Numero de Guía es Requerido"
  
  validates  :fecha_estimada_f,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.Form.fecha') << " " << I18n.t('Sistema.Body.Vistas.Form.estimada') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
#  validates_uniqueness_of :numero_guia,
#    :message => "Numero de guía ya existe"
  
 
  def fecha_emision_f=(fecha)
    self.fecha_emision = fecha
  end
  def fecha_emision_f
    format_fecha(self.fecha_emision)
  end
  def fecha_estimada_f=(fecha)
    self.fecha_estimada = fecha
  end
  def fecha_estimada_f
    format_fecha(self.fecha_estimada)
  end
  
  def destino_f
    if self.destino == 'F'
      return 'Oficina'
    elsif self.destino == 'U'
      return 'Unidad de Producción'
    elsif self.destino == 'O'
      return 'Evento'
    end
  end
  
  validate :validate
  
  def validate
    if (self.destino.nil? || self.destino.to_s.empty?)
      errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Vistas.Form.destino') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido') )
    end
    if self.destino == 'O'
      if self.evento.nil? || self.evento.to_s.empty?
        errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Vistas.Form.evento') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido'))
      end 
      if self.direccion_destino.nil? || self.direccion_destino.to_s.empty?
        errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.General.direccion') << " " << I18n.t('Sistema.Body.Vistas.Form.evento') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido'))
      end
      if self.telefono_destino.nil? || self.telefono_destino.to_s.empty?
        errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.Form.evento') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido'))
      end
    end
#    unless self.numero_guia.nil? || self.numero_guia.to_s.empty?
#      a = self.numero_guia[/^[a-zA-ZñÑ0-9\/-]+$/]
#      if a.nil?
#        errors.add(nil, "Numero de Guía es inválido")
#      end
#    end
    unless self.nombre_contacto_1.nil? || self.nombre_contacto_1.to_s.empty?
      a = self.nombre_contacto_1[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:guia_movilizacion_maquinaria,I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.y') << " " << I18n.t('Sistema.Body.Vistas.General.apellido') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.nombre_contacto_2.nil? || self.nombre_contacto_2.to_s.empty?
      a = self.nombre_contacto_2[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:guia_movilizacion_maquinaria,I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.y') << " " << I18n.t('Sistema.Body.Vistas.General.apellido') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    if self.destino.to_s == 'O'
      unless self.evento.nil? || self.evento.to_s.empty?
        a = self.evento[/^[a-zA-Z0-9ñÑáÁéÉíÍóÓúÚüÜÇ'.,; ]+$/]
        if a.nil?
          errors.add(:guia_movilizacion_maquinaria,I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.y') << " " << I18n.t('Sistema.Body.Vistas.General.apellido') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
        end
      end
    end
    unless self.direccion_destino.nil? || self.direccion_destino.to_s.empty?
      a = self.direccion_destino[/^[a-zA-Z0-9ñÑáÁéÉíÍóÓúÚüÜÇ'°.,; ]+$/]
      if a.nil?
        errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.y') << " " << I18n.t('Sistema.Body.Vistas.General.apellido') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    tel1 = self.telefono_contacto_1.to_s.split('')
    tel2 = self.telefono_contacto_2.to_s.split('')
    unless (tel1[0].to_i == 0 and (tel1[1].to_i == 4 or tel1[1].to_i == 2))
      errors.add(:guia_movilizacion_maquinaria,I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.General.primer') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
    end
    unless (tel2[0].to_i == 0 and (tel2[1].to_i == 4 or tel2[1].to_i == 2))
      errors.add(:guia_movilizacion_maquinaria,I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.General.segundo') << " " << I18n.t('Sistema.Body.Vistas.General.contacto') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
    end
    if self.destino == 'O'
      telf_d = self.telefono_destino.to_s.split('')
      unless (telf_d[0].to_i == 0 and (telf_d[1].to_i == 4 or telf_d[1].to_i == 2))
        errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Vistas.General.telefono') << " " << I18n.t('Sistema.Body.Vistas.Form.destino') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
  end
 
  def self.create(guia_movilizacion_maquinaria, maqui)
    begin
      guia = ''
      guia_movilizacion = GuiaMovilizacionMaquinaria.new(guia_movilizacion_maquinaria)
      cat = maqui.to_s.split(',')
      transaction do
        guia_movilizacion.save!
        cat.each{ |a|
          guia = GuiaCatalogo.new
          guia.catalogo_id = a
          guia.guia_movilizacion_maquinaria_id = guia_movilizacion.id
          guia.save!
        }
        return guia_movilizacion
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      errores = ''
      guia_movilizacion.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      #      unless guia.errors.nil?
      #        guia.errors.each{ |e|
      #          errores << "<li>" + e[1] + "</li>"
      #        }
      #      end
      return errores.html_safe
    end
  end


  def self.update(guia_movilizacion_maquinaria, maqui, id)
    cat = maqui.to_s.split(',')
    begin
      guia = ''
      guia_movilizacion = GuiaMovilizacionMaquinaria.find(id)
      transaction do
        begin
          value = guia_movilizacion.update_attributes(guia_movilizacion_maquinaria)
          if !value
            errores = ''
            guia_movilizacion.errors.full_messages.each { |g|
              errores << "<li>" + g + "</li>"
            }
            return errores.html_safe
          end
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.join("\n")
        end
        begin
          if value
            GuiaCatalogo.find_by_sql("DELETE FROM guia_catalogo where guia_movilizacion_maquinaria_id=#{guia_movilizacion.id}")
            guia = GuiaCatalogo.find_all_by_guia_movilizacion_maquinaria_id(guia_movilizacion.id)
            if guia.length > 0
              errores = ''
              GuiaCatalogo.errors.full_messages.each { |g|  
                errores << "<li>" + I18n.t('Sistema.Body.Modelos.Errores.no_se_pudo_actualizar') + " " + I18n.t('Sistema.Body.Vistas.General.la') + " " + I18n.t('Sistema.Body.Vistas.General.guia') + "</li>"
              }
              return errores.html_safe
            else
              begin
                cat.each{ |a|
                  guia = GuiaCatalogo.new
                  guia.catalogo_id = a
                  guia.guia_movilizacion_maquinaria_id = id
                  guia.save!
                }
              rescue Exception => e
                logger.error e.message
                logger.error e.backtrace.join("\n")
                if guia.errors.length > 0
                  guia.errors.full_messages.each{ |e|
                    errores << "<li>" + e + "</li>"
                  }
                  return errores.html_safe
                end
              end
            end
          end 
        rescue Exception => e
        end
        return guia_movilizacion
      end
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      errores = ''
      guia_movilizacion.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores.html_safe
    end
  end
  
  def self.delete(id)
    guia_movilizacion = GuiaMovilizacionMaquinaria.find(id)
    if guia_movilizacion.estatus == 'E'
      begin
        transaction do
          begin
            GuiaCatalogo.find_by_sql("DELETE FROM guia_catalogo where guia_movilizacion_maquinaria_id=#{guia_movilizacion.id}")
          rescue Exception => e
            guia_movilizacion.errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_eliminado') + " " + I18n.t('Sistema.Body.Vistas.General.la') + " " + I18n.t('Sistema.Body.Vistas.General.guia'))
          end 
          begin
            value = guia_movilizacion.destroy
            if !value
              guia_movilizacion.errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_eliminado') + " " + I18n.t('Sistema.Body.Vistas.General.la') + " " + I18n.t('Sistema.Body.Vistas.General.guia'))
            end
          rescue Exception => e
            logger.error e.message
            logger.error e.backtrace.join("\n")
          end
        end
      end
    else
      guia_movilizacion.errors.add(:guia_movilizacion_maquinaria, I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_eliminado') + " " + I18n.t('Sistema.Body.Vistas.General.la') + " " + I18n.t('Sistema.Body.Vistas.General.guia'))
    end
  end

  
  
  def self.validate_almacen(maqui)    
    id = ''
    maqui.each{|a| 
     id << a+ ',' 
    }
    id = id[0,id.length-1]    
    errores = ''
    if (maqui.nil? || maqui.empty?)  
      errores << "<li>" + I18n.t('Sistema.Body.Modelos.Solicitud.Errores.seleccionar_al_menos') + " " + I18n.t('Sistema.Body.Vistas.General.una') + " " + I18n.t('Sistema.Body.Vistas.General.maquinaria') + "</li>"
      return errores.html_safe
    end
    unless (maqui.nil? || maqui.empty?)
      catalogo = Catalogo.count( :conditions=>"id in (#{id})", :select=>"distinct(almacen_maquinaria_id)")
      if catalogo > 1
        errores << "<li>" + I18n.t('Sistema.Body.Modelos.Stock_Maquinaria.Errores.no_puede_agregar_maquinarias_diferentes') + "</li>"
        return errores.html_safe
      end
    end
    return true
  end
  
  before_save :antes_de_guardar
  
  def antes_de_guardar
    nombre_contacto_1 = eliminar_acentos(self.nombre_contacto_1)
    self.nombre_contacto_1 = nombre_contacto_1.upcase
    nombre_contacto_2 = eliminar_acentos(self.nombre_contacto_2)
    self.nombre_contacto_2 = nombre_contacto_2.upcase
    if self.destino.to_s == 'O' 
      evento = eliminar_acentos(self.evento)
      self.evento = evento.upcase
    end
  end
  
  after_save :despues_de_guardar
  
  def despues_de_guardar
    if self.numero_guia.nil? || self.numero_guia.empty?
      guia = GuiaMovilizacionMaquinaria.find(:first, :conditions => "length(numero_guia) > 0", :order => "id desc")
      numero = guia.numero_guia.to_s
      numero = numero.split("/")[2].to_i + 1
      if numero.to_s.length == 1
        numero = "000#{numero}" 
      elsif numero.to_s.length == 2
        numero = "00#{numero}" 
      elsif numero.to_s.length == 3
        numero = "0#{numero}" 
      end
      self.numero_guia = Time.now.strftime('%Y/%m') + "/#{numero}"
      self.save
    end    
  end
  
  def self.enviar(id)
    guia_movilizacion = GuiaMovilizacionMaquinaria.find(id)    
    guia_movilizacion.estatus='T'
    value = guia_movilizacion.save    
    if !value
      errores = ''            
      guia_movilizacion.errors.full_messages.each { |e|
        errores << "<li>" + e + "</li>"
      }
      return errores.html_safe
    end
    return true
  end
  
  def eliminar_acentos(nombre)
    nombre = nombre.to_s
    nombre.downcase!
    nombre.gsub!(/[á|Á]/,'a')
    nombre.gsub!(/[é|É]/,'e')
    nombre.gsub!(/[í|Í]/,'i')
    nombre.gsub!(/[ó|Ó]/,'o')
    nombre.gsub!(/[ú|Ú]/,'u')
    return nombre
  end
  
end

# == Schema Information
#
# Table name: guia_movilizacion_maquinaria
#
#  id                               :integer         not null, primary key
#  solicitud_id                     :integer
#  empresa_transporte_maquinaria_id :integer
#  oficina_id                       :integer
#  ci_contacto_1                    :string(10)
#  ci_contacto_2                    :string(10)
#  nombre_contacto_1                :string(60)
#  nombre_contacto_2                :string(60)
#  telefono_contacto_1              :string(11)
#  telefono_contacto_2              :string(11)
#  fecha_emision                    :date
#  destino                          :string(1)
#  unidad_produccion_id             :integer
#  direccion_destino                :string(250)
#  telefono_destino                 :string(11)
#  estatus                          :string(1)
#  usuario_id                       :integer
#  numero_guia                      :string(20)
#  evento                           :string(60)
#  ci_nacionalidad_1                :string(1)
#  ci_nacionalidad_2                :string(1)
#  fecha_estimada                   :date
#

