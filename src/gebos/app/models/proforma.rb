# encoding: utf-8

# autor: Luis Rojas
# clase: Catalogo
# descripción: Migración a Rails 3
#
class Proforma < ActiveRecord::Base
  
  self.table_name = 'proforma'

  attr_accessible :id, :numero, :fecha_emision, :fecha_caduca, :casa_proveedora_id, :fecha_emision_f, :fecha_caduca_f

  has_many :catalogo
  has_many :solicitud_maquinaria
  belongs_to :usuario
  belongs_to :casa_proveedora
  
  validates :numero, :presence => {:message => I18n.t('Sistema.Body.Vistas.General.numero') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.proforma') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :format => {:with => /^[a-zA-Z0-9']+$/, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.proforma')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"},
    :uniqueness => {:message=> I18n.t('Sistema.Body.Vistas.General.numero')<< " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.proforma') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}  
  
  validates :fecha_emision, :presence => {:message => I18n.t('Sistema.Body.Vistas.Form.fecha') << " " << I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.emision') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  validates :fecha_caduca, :presence => {:message => I18n.t('Sistema.Body.Vistas.Form.fecha') << " " << I18n.t('Sistema.Body.Vistas.General.en') << " " << I18n.t('Sistema.Body.Vistas.General.que') << " " << I18n.t('Sistema.Body.Vistas.General.caduca') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}
  
  validates :fecha_emision, 
    :length =>{:in => 10..10, :allow_blank=>true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')}  #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.emision')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"},
    :format => {:with => /^(\d){4}\-(\d){1,2}\-(\d){1,2}$/, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.emision')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"} 
  
  validates :fecha_caduca, 
    :length =>{:in => 10..10, :allow_blank=>true, :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')}  #{I18n.t('Sistema.Body.Vistas.General.en')} #{I18n.t('Sistema.Body.Vistas.General.que')} #{I18n.t('Sistema.Body.Vistas.General.caduca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"},
    :format => {:with => /^(\d){4}\-(\d){1,2}\-(\d){1,2}$/, :allow_blank=>true,
    :message => "#{I18n.t('Sistema.Body.Vistas.Form.fecha')} #{I18n.t('Sistema.Body.Vistas.General.en')} #{I18n.t('Sistema.Body.Vistas.General.que')} #{I18n.t('Sistema.Body.Vistas.General.caduca')} #{I18n.t('Sistema.Body.Modelos.Errores.es_invalida')}"} 
  
  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
             :conditions => search, :order => sort, 
             :select=>'*'
             #:include=>['contrato_maquinaria_equipo','clase', 'modelo', 'marca_maquinaria'],
  end

  def save_new(params)
    begin
      transaction do
        result = self.save
        if result == true
          if params[:ids].blank?
            errors.add(:proforma, "Debe seleccionar al menos una maquinaria.")
            raise ActiveRecord::Rollback
          else
            error = 0
            maquinaria = params[:ids].split(',')
            maquinaria.each {|m|
              unless params[:solicitud_maq]["serial_motor_#{m}"].blank?
                unless params[:solicitud_maq]["serial_motor_#{m}"].downcase == 'no aplica'
                  total = SolicitudMaquinaria.count(:conditions => "id not in (#{m}) and serial_motor = '#{params[:solicitud_maq]["serial_motor_#{m}"]}'")
                  if total > 0
                    errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} '#{params[:solicitud_maq]["serial_motor_#{m}"]}' #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}.")
                    error = 1
                  end
                end
              else
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              end
              if params[:solicitud_maq]["serial_chasis_#{m}"].blank?
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              else
                total = SolicitudMaquinaria.count(:conditions => "serial_chasis = '#{params[:solicitud_maq]["serial_chasis_#{m}"]}'")
                if total > 0
                  errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} '#{params[:solicitud_maq]["serial_chasis_#{m}"]}' #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}.")
                  error = 1
                end
              end
              if params[:solicitud_maq]["costo_#{m}"].blank?
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              else
                unless params[:solicitud_maq]["costo_#{m}"].sub('.','').to_i.to_s == params[:solicitud_maq]["costo_#{m}"].sub('.','')
                  errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')} #{I18n.t('Sistema.Body.Vistas.General.para_alguno_item')}.")
                  error = 1
                end
              end
              if error == 1
                result = false
              else
                  maq = SolicitudMaquinaria.find(m.to_i)
                  maq.serial_motor = params[:solicitud_maq]["serial_motor_#{m}"]
                  maq.serial_chasis = params[:solicitud_maq]["serial_chasis_#{m}"]
                  maq.costo = params[:solicitud_maq]["costo_#{m}"]
                  maq.proforma_id = self.id
                  maq.save!
              end
            }
            if result == false
              raise ActiveRecord::Rollback
            else
              return true
            end
          end
        else
          return false
        end
      end
    rescue Exception => e
      logger.debug "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" + e.message.to_s
      return false
    end
  end
  
  def save_edit(params)
    begin
      transaction do
        self.casa_proveedora_id = params[:proforma][:casa_proveedora_id]
        self.numero = params[:proforma][:numero]
        self.fecha_emision_f = params[:proforma][:fecha_emision_f]
        self.fecha_caduca_f = params[:proforma][:fecha_caduca_f]
        result = self.save
        if result == true
          if params[:ids].nil? || params[:ids].to_s.empty?
            errors.add(:proforma, I18n.t('Sistema.Body.Modelos.Errores.item_seleccion'))
            raise ActiveRecord::Rollback
          else
            error = 0
            maquinaria = params[:ids].split(',')
            maquinaria.each {|m|
              unless params[:solicitud_maq]["serial_motor_#{m}"].nil? || params[:solicitud_maq]["serial_motor_#{m}"].to_s.empty?
                unless params[:solicitud_maq]["serial_motor_#{m}"].downcase == 'no aplica'
                  total = SolicitudMaquinaria.count(:conditions => "id not in (#{m}) and serial_motor = '#{params[:solicitud_maq]["serial_motor_#{m}"]}'")
                  if total > 0
                    errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} '#{params[:solicitud_maq]["serial_motor_#{m}"]}' #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}.")
                    error = 1
                  end
                end
              else
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              end
              if params[:solicitud_maq]["serial_chasis_#{m}"].nil? || params[:solicitud_maq]["serial_chasis_#{m}"].to_s.empty?
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              else
                total = SolicitudMaquinaria.count(:conditions => "id not in (#{m}) and serial_chasis = '#{params[:solicitud_maq]["serial_chasis_#{m}"]}'")
                if total > 0
                  errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} '#{params[:solicitud_maq]["serial_chasis_#{m}"]}' #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}.")
                  error = 1
                end
              end
              if params[:solicitud_maq]["costo_#{m}"].nil? || params[:solicitud_maq]["costo_#{m}"].to_s.empty?
                errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')} #{I18n.t('Sistema.Body.Vistas.General.para_todos_item')}.")
                error = 1
              else
                unless params[:solicitud_maq]["costo_#{m}"].sub('.','').to_i.to_s == params[:solicitud_maq]["costo_#{m}"].sub('.','')
                  errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')} #{I18n.t('Sistema.Body.Vistas.General.para_alguno_item')}.")
                  error = 1
                end
              end
              if error == 1
                raise ActiveRecord::Rollback
              else
                  maq = SolicitudMaquinaria.find(m.to_i)
                  maq.serial_motor = params[:solicitud_maq]["serial_motor_#{m}"]
                  maq.serial_chasis = params[:solicitud_maq]["serial_chasis_#{m}"]
                  maq.costo = params[:solicitud_maq]["costo_#{m}"]
                  maq.proforma_id = self.id
                  result = maq.save
              end
            }
            if result == false
              raise ActiveRecord::Rollback
            else
              SolicitudMaquinaria.find_by_sql("UPDATE solicitud_maquinaria SET proforma_id = null, serial_motor = null, serial_chasis = null, costo = null where proforma_id = #{self.id} and id not in (#{params[:ids][0, params[:ids].length - 1]})")
              return true
            end
          end
        else
          return false
        end
      end
    rescue Exception => e
      return false
    end
  end
  
  def fecha_emision_f=(fecha)
    self.fecha_emision = fecha
  end
  
  def fecha_emision_f
    self.fecha_emision.strftime('%d/%m/%Y') unless self.fecha_emision.nil?
  end
  
  def fecha_caduca_f=(fecha)
    self.fecha_caduca = fecha
  end
  
  def fecha_caduca_f
    self.fecha_caduca.strftime('%d/%m/%Y') unless self.fecha_caduca.nil?
  end

  def eliminar(id)
    begin
      transaction do
        solicitud_maquinaria = SolicitudMaquinaria.find_by_sql("update solicitud_maquinaria set serial_motor = null, serial_chasis = null, costo = null, proforma_id = null where proforma_id = #{id}")
        proforma = Proforma.find(id)
        proforma.destroy
        return true
      end
    rescue
      errors.add(:proforma, "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.proforma')} #{I18n.t('Sistema.Body.Modelos.Errores.no_puede_ser_eliminada')}")
      return false
    end
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
# Table name: proforma
#
#  id                 :integer         not null, primary key
#  numero             :string(30)      not null
#  fecha_emision      :date            not null
#  fecha_caduca       :date            not null
#  usuario_id         :integer         not null
#  solicitud_id       :integer         not null
#  casa_proveedora_id :integer
#

