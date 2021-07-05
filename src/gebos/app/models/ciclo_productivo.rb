# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: CicloProductivo
# descripción: Migración a Rails 3

class CicloProductivo < ActiveRecord::Base

  self.table_name = 'ciclo_productivo'

  attr_accessible :id,
                  :nombre,
                  :descripcion,
                  :mes_inicio,
                  :mes_fin,
                  :activo

  
  
  has_many :acta_silo
  has_many :actividad


  validates :mes_inicio,
    :presence => {:message => I18n.t('datetime.prompts.month') << " " << I18n.t('Sistema.Body.Vistas.Form.inicio') << " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  validates :mes_fin,
    :presence => {:message => I18n.t('datetime.prompts.month') << " " << I18n.t('Sistema.Body.Vistas.Form.fin')<< " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}

  validates :nombre,
    :presence => {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('Sistema.Body.Modelos.Errores.es_requerido')},
    :uniqueness=> {:message => I18n.t('Sistema.Body.Vistas.General.nombre') << " " <<I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}

  validates :descripcion,
    :presence => {:message => I18n.t('Sistema.Body.General.descripcion') << " " << I18n.t('Sistema.Body.Modelos.Errores.es_requerida')}

  validate :validate
  
  def validate
    unless self.nombre.nil? || self.nombre.empty?
      a = self.nombre[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:ciclo_productivo, I18n.t('Sistema.Body.Vistas.General.nombre')  << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalido') )
      end
    end
    unless self.descripcion.nil? || self.descripcion.empty?
      a = self.descripcion[/^[a-zA-ZñÑáÁéÉíÍóÓúÚüÜÇ' ]+$/]
      if a.nil?
        errors.add(:ciclo_productivo, I18n.t('Sistema.Body.General.descripcion')  << " " << I18n.t('Sistema.Body.Modelos.Errores.es_invalida') )
      end
    end
    logger.debug "clase ---------------------------------------- " + self.mes_inicio.class.name + " " + self.mes_fin.class.name
    total = 0
    unless self.mes_inicio.nil?
      unless self.mes_fin.nil?
        if self.mes_inicio > self.mes_fin
          meses = "0"
          for i in self.mes_inicio..12
            meses = meses + ",#{i}"
          end
          for i in 1..self.mes_fin
            meses = meses + ",#{i}"
          end
          if self.id.to_s.empty?
            total = CicloProductivo.count(:conditions=>["(mes_inicio in (#{meses}) or mes_fin in (#{meses}))"])
          else
            total = CicloProductivo.count(:conditions=>["id not in (#{self.id}) and (mes_inicio in (#{meses}) or mes_fin in (#{meses}))"])
          end
          if self.activo == true
            mes = Time.now.mon
            activo = CicloProductivo.count(:conditions=>["#{mes} in (#{meses})"])
            unless activo > 0
              errors.add(:ciclo_productivo, I18n.t('Sistema.Body.Modelos.CicloProductivo.Errores.no_puede_activar_ciclo'))
            end
          end
        else
          if self.id.to_s.empty?
            total = CicloProductivo.count(:conditions=>["(#{self.mes_inicio} >= mes_inicio and mes_fin >= #{self.mes_inicio}) or (#{self.mes_fin} >= mes_inicio and mes_fin >= #{self.mes_fin})"])
          else
            total = CicloProductivo.count(:conditions=>["id not in (#{self.id}) and ((#{self.mes_inicio} >= mes_inicio and mes_fin >= #{self.mes_inicio}) or (#{self.mes_fin} >= mes_inicio and mes_fin >= #{self.mes_fin}))"])
          end
          if self.activo == true
            mes = Time.now.mon
            unless mes >= self.mes_inicio and self.mes_fin >= mes
              errors.add(:ciclo_productivo, I18n.t('Sistema.Body.Modelos.CicloProductivo.Errores.no_puede_activar_ciclo'))
            end
          end
        end
      end
    end
    #    if self.mes_inicio > self.mes_fin
    #      errors.add(nil, "La fecha fin debe ser mayor a la fecha de inicio.")
    #    end
    #    if self.id.to_s.empty?
    #      total = CicloProductivo.count(:conditions=>["(#{self.mes_inicio} >= mes_inicio and mes_fin >= #{self.mes_inicio}) or (#{self.mes_fin} >= mes_inicio and mes_fin >= #{self.mes_fin})"])
    #    else
    #      total = CicloProductivo.count(:conditions=>["id not in (#{self.id}) and ((#{self.mes_inicio} >= mes_inicio and mes_fin >= #{self.mes_inicio}) or (#{self.mes_fin} >= mes_inicio and mes_fin >= #{self.mes_fin}))"])
    #    end
    if total > 0
      errors.add(:ciclo_productivo, I18n.t('Sistema.Body.Modelos.CicloProductivo.Errores.rangos_ya_incluidos'))
    end
  end

  after_save :after_save
  
  def after_save
    if self.activo == true
      CicloProductivo.find_by_sql("UPDATE ciclo_productivo SET activo = false WHERE id not in (#{self.id})")
    end
  end

  def mes_inicio_w
    case self.mes_inicio
    when 1
      I18n.t('date.month_names')[1]
    when 2
      I18n.t('date.month_names')[2]
    when 3
      I18n.t('date.month_names')[3]
    when 4
      I18n.t('date.month_names')[4]
    when 5
      I18n.t('date.month_names')[5]
    when 6
      I18n.t('date.month_names')[6]
    when 7
      I18n.t('date.month_names')[7]
    when 8
      I18n.t('date.month_names')[8]
    when 9
      I18n.t('date.month_names')[9]
    when 10
      I18n.t('date.month_names')[10]
    when 11
      I18n.t('date.month_names')[11]
    when 12
      I18n.t('date.month_names')[12]
    end
  end

  def mes_fin_w
    case self.mes_fin
    when 1
      I18n.t('date.month_names')[1]
    when 2
      I18n.t('date.month_names')[2]
    when 3
      I18n.t('date.month_names')[3]
    when 4
      I18n.t('date.month_names')[4]
    when 5
      I18n.t('date.month_names')[5]
    when 6
      I18n.t('date.month_names')[6]
    when 7
      I18n.t('date.month_names')[7]
    when 8
      I18n.t('date.month_names')[8]
    when 9
      I18n.t('date.month_names')[9]
    when 10
      I18n.t('date.month_names')[10]
    when 11
      I18n.t('date.month_names')[11]
    when 12
      I18n.t('date.month_names')[12]
    end
  end

  def self.meses
    return [[I18n.t('date.month_names')[1],1],[I18n.t('date.month_names')[2],2],[I18n.t('date.month_names')[3],3],[I18n.t('date.month_names')[4],4],[I18n.t('date.month_names')[5],5],[I18n.t('date.month_names')[6],6],[I18n.t('date.month_names')[7],7],[I18n.t('date.month_names')[8],8],[I18n.t('date.month_names')[9],9],[I18n.t('date.month_names')[10],10],[I18n.t('date.month_names')[11],11],[I18n.t('date.month_names')[12],12]]
  end

  #def self.create(parametros, historico)
  #  #@gbox2000
  #  logger.info"XXX-CREATE-PARAMETROS!!===================================>>>>"<<parametros.inspect
  #  logger.info"XXX-CREATE-HISTORICO!!===================================>>>>"<<historico.inspect
  #    begin
  #      ciclo_productivo = CicloProductivo.new(parametros)
  #      logger.info"XXX-ENTRO-BEGIN-NEW-CICLO-!!==============================>>"<<ciclo_productivo.inspect
  #      historico_ciclo = HistoricoCiclo.new(historico)
  #      logger.info"XXX-ENTRO-BEGIN-NEW-HIST-!!==============================>>"<<historico_ciclo.inspect
  #      transaction do
  #        ciclo_productivo.save!
  #        historico_ciclo.ciclo_productivo_id = ciclo_productivo.id
  #        historico_ciclo.save!
  #        return true
  #      end
  #    rescue
  #      errores = ''
  #      ciclo_productivo.errors.each { |e|
  #        errores << "<li>" + e[1] + "</li>"
  #      }
  #      unless historico_ciclo.nil?
  #        historico_ciclo.errors.each{ |e|
  #          errores << "<li>" + e[1] + "</li>"
  #        }
  #      end
  #      return errores
  #
  #    end
  #  end


  def self.search(search, page, sort)
    paginate :per_page => @records_by_page, :page => page,
      :conditions => search, :order => sort
  end



end

# == Schema Information
#
# Table name: ciclo_productivo
#
#  id          :integer         not null, primary key
#  nombre      :string(50)      not null
#  descripcion :string(250)     not null
#  mes_inicio  :integer
#  mes_fin     :integer
#  activo      :boolean         default(TRUE)
#

