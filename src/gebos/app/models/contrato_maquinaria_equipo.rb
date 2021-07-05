# encoding: UTF-8

class ContratoMaquinariaEquipo < ActiveRecord::Base

  self.table_name = 'contrato_maquinaria_equipo'
  
      attr_accessible :id,
					  :fecha_contrato,
					  :numero_contrato,
					  :nombre,
					  :rif,
					  :naturaleza,
					  :descripcion,
					  :fecha_contrato_f

  has_many :catalogo

  validates :nombre, 
   :presence=> {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.empresa') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
   :uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Vistas.General.empresa') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}
  
  validates :numero_contrato, 
  :presence=> {:message => I18n.t('Sistema.Body.Vistas.General.nro') << " " << I18n.t('Sistema.Body.Vistas.Form.convenio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
  :uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.nro') << " " << I18n.t('Sistema.Body.Vistas.Form.convenio') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}
  
  validates :naturaleza, 
  :presence=> {:message => I18n.t('Sistema.Body.Vistas.General.naturaleza') << " " << I18n.t('Sistema.Body.Vistas.General.del') << " " << I18n.t('Sistema.Body.Vistas.Form.convenio') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}
  
  validates :descripcion, 
  :presence=> {:message => I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validates :rif, 
  :presence=> {:message => I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
  :uniqueness=>{:message => I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}


  def fecha_contrato_f
    format_fecha(self.fecha_contrato)
  end
  
  def fecha_contrato_f=(fecha)
    self.fecha_contrato = fecha
  end


  #nop funcinona en rails 3
  #validates_date :fecha_contrato,
  #  :message => "^ Fecha del Convenio es inválida (dd/mm/aaaa)",
  #  :before => Proc.new { 0.day.from_now.to_date}, :before_message => 'no puede ser posterior a la fecha actual'
  
  #validates :fecha_contrato,
  #  :date => {:message => I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida'),
  #            :before => Proc.new { 0.day.from_now.to_date }, :message => I18n.t('Sistema.Body.Modelos.Errores.fecha_no_posterior')}

  
  validate :validate
  
  def validate
    unless self.rif.nil?
      if self.rif.length > 11
        valida_rif(self.rif)
      elsif self.rif.length == 0
      else
        errors.add(:contrato_maquinaria_equipo,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[0-9\-a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:contrato_maquinaria_equipo, I18n.t('Sistema.Body.Vistas.General.nombre') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
    unless self.descripcion.nil? || self.descripcion.empty?
      a = self.descripcion[/^[0-9\-a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:contrato_maquinaria_equipo, I18n.t('Sistema.Body.Vistas.Form.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida'))
      end
    end
    unless self.numero_contrato.nil? || self.numero_contrato.empty?
      a = self.numero_contrato[/^[0-9\-a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:contrato_maquinaria_equipo, I18n.t('Sistema.Body.Vistas.General.nro') << " " << I18n.t('Sistema.Body.Vistas.Form.contrato') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
    end
  end
  
  def valida_rif(rif)

      rif1 = rif[0, 1]
      rif2 = rif[2, 8]
      rif3 = rif[11, 1]
      
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
          errors.add(:contrato_maquinaria_equipo,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
        end
      else
        errors.add(:contrato_maquinaria_equipo,I18n.t('Sistema.Body.Vistas.General.rif') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido'))
      end
  end


  def self.search(search, page, orden)    

    conditions=search  
  
    logger.info "Conditions ===> " << conditions.to_s
    paginate :per_page=>@records_by_page, :page=>page, :conditions=>conditions, :order=>orden
  end



end

# == Schema Information
#
# Table name: contrato_maquinaria_equipo
#
#  id              :integer         not null, primary key
#  fecha_contrato  :date
#  numero_contrato :string(30)      not null
#  nombre          :string(255)     not null
#  rif             :string(12)
#  naturaleza      :string(1)
#  descripcion     :text
#

