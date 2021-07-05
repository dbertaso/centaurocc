# encoding: UTF-8

#
# autor: Luis Rojas
# clase: SolicitudMaquinaria
# descripción: Migración a Rails 3
#

class SolicitudMaquinaria < ActiveRecord::Base

  self.table_name = 'solicitud_maquinaria'
  
  attr_accessible :id,
				  :tipo_maquinaria_id,
				  :clase_id,
				  :descripcion,
				  :solicitud_id,
				  :cantidad,
          :marca_maquinaria_id,
          :modelo_id


  belongs_to :solicitud
  belongs_to :tipo_maquinaria
  belongs_to :clase
  belongs_to :modelo
  belongs_to :marca_maquinaria
  belongs_to :catalogo
  belongs_to :proforma

  validates_presence_of   :tipo_maquinaria_id, :message => "^ Rubro es requerido"

  validates_presence_of   :clase_id, :message => "^ Tipo es requerido"

  validates_presence_of   :solicitud_id, :message => "^ Trámite es requerido"

  validates_presence_of   :marca_maquinaria_id, :message => "^ Marca es requerido"
  
  validates_presence_of   :modelo_id, :message => "^ Modelo es requerido"

  validates_presence_of   :cantidad, :message => "^ Cantidad es requerido"

  validates_numericality_of :cantidad,
    :only_integer => true, :allow_nil => true,
    :message => "^ Cantidad el número es inválido"
  
  def self.confirmar(maquinaria)
    maquinaria.each{|m|
      if m.cantidad == 1
        catalogo = Catalogo.find(:first, :conditions => "estatus = 'L' and clase_id = #{m.clase_id} and marca_maquinaria_id = #{m.marca_maquinaria_id} and modelo_id = #{m.modelo_id}")
        if catalogo.nil?
          m.estatus = 'P'
        else
          m.estatus = 'I'
          m.catalogo_id = catalogo.id
          catalogo.solicitud_id = m.solicitud_id
          catalogo.estatus = 'R'
          catalogo.save
        end
        m.save
      else
        catalogo = Catalogo.find(:all, :conditions => "estatus = 'L' and clase_id = #{m.clase_id} and marca_maquinaria_id = #{m.marca_maquinaria_id} and modelo_id = #{m.modelo_id}", :limit => m.cantidad)
        corte = false
        catalogo.each{|c|
          if corte == false
            m.estatus = 'I'
            m.catalogo_id = c.id
            c.solicitud_id = m.solicitud_id
            c.estatus = 'R'
            c.save
            m.save
          else
            ma = SolicitudMaquinaria.new
            ma.solicitud_id = m.solicitud_id
            ma.marca_maquinaria_id = m.marca_maquinaria_id
            ma.modelo_id = m.modelo_id
            ma.tipo_maquinaria_id = m.tipo_maquinaria_id
            ma.clase_id = m.clase_id
            ma.cantidad = 1
            ma.catalogo_id = c.id
            ma.estatus = 'I'
            ma.save
            c.solicitud_id = m.solicitud_id
            c.estatus = 'R'
            c.save
          end
          corte = true
        }
        unless catalogo.length == m.cantidad
          total = m.cantidad - catalogo.length
          (1..total).each{|a|
            if m.estatus.class.name == "NilClass"
              m.estatus = 'P'
              m.save
            else
              ma = SolicitudMaquinaria.new
              ma.solicitud_id = m.solicitud_id
              ma.marca_maquinaria_id = m.marca_maquinaria_id
              ma.modelo_id = m.modelo_id
              ma.tipo_maquinaria_id = m.tipo_maquinaria_id
              ma.clase_id = m.clase_id
              ma.cantidad = 1
              ma.estatus = 'P'
              ma.save
            end
          }
        end
      end
    }
    return ''
  end
  
  def self.avanzar(solicitud_id, usuario)
    monto_proforma = SolicitudMaquinaria.sum(:costo, :conditions => "solicitud_id = #{solicitud_id} and estatus = 'P'")
    if monto_proforma.nil?
      monto_proforma = 0
    end
    solicitud = Solicitud.find(solicitud_id)
    if Catalogo.sum(:id, :conditions => "moneda_id <> #{solicitud.moneda_id} and solicitud_id = #{solicitud_id}") > 0
      catalogo = Catalogo.find(:all, :conditions => "moneda_id <> #{solicitud.moneda_id} and solicitud_id = #{solicitud_id}")
      catalogo.each { |c|
        if c.contrato_maquinaria_equipo.naturaleza == 'N'
          convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{solicitud.moneda_id} and moneda_destino_id = #{c.moneda_id}")
          unless convertidor.nil?
            c.monto_real = c.monto_real / convertidor.valor
            c.seguro = c.monto_real * (c.por_seguro / 100)
            c.flete = c.monto_real * (c.por_flete / 100)
            c.monto = c.monto_real + c.seguro + c.flete
            c.moneda_id = solicitud.moneda_id
            c.save
          else
            convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{c.moneda_id} and moneda_destino_id = #{solicitud.moneda_id}")
            unless convertidor.nil?
              c.monto_real = c.monto_real * convertidor.valor
              c.seguro = c.monto_real * (c.por_seguro / 100)
              c.flete = c.monto_real * (c.por_flete / 100)
              c.monto = c.monto_real + c.seguro + c.flete
              c.moneda_id = solicitud.moneda_id
              c.save
            end
          end
        else
          convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{solicitud.moneda_id} and moneda_destino_id = #{c.moneda_id}")
          unless convertidor.nil?
            c.monto_real = c.monto_real * convertidor.valor
            c.seguro = c.monto_real * (c.por_seguro / 100)
            c.flete = c.monto_real * (c.por_flete / 100)
            c.gastos_administrativos = c.monto_real * (c.por_gastos_administrativos / 100)
            c.impuesto = c.monto_real * (c.por_nacionalizacion / 100)
            c.almacenamiento = c.monto_real * (c.por_almacenamiento / 100)
            c.monto = c.monto_real + c.seguro + c.flete + c.gastos_administrativos + c.impuesto + c.almacenamiento
            c.moneda_id = solicitud.moneda_id
            c.save
          else
            convertidor = Convertidor.first(:conditions=> "moneda_origen_id = #{c.moneda_id} and moneda_destino_id = #{solicitud.moneda_id}")
            unless convertidor.nil?
              c.monto_real = c.monto_real * convertidor.valor
              c.seguro = c.monto_real * (c.por_seguro / 100)
              c.flete = c.monto_real * (c.por_flete / 100)
              c.gastos_administrativos = c.monto_real * (c.por_gastos_administrativos / 100)
              c.impuesto = c.monto_real * (c.por_nacionalizacion / 100)
              c.almacenamiento = c.monto_real * (c.por_almacenamiento / 100)
              c.monto = c.monto_real + c.seguro + c.flete + c.gastos_administrativos + c.impuesto + c.almacenamiento
              c.moneda_id = solicitud.moneda_id
              c.save
            end
          end
        end
      }
    end
    monto_inventario = Catalogo.sum(:monto, :conditions => "id in (select catalogo_id from solicitud_maquinaria where solicitud_id = #{solicitud_id} and estatus = 'I')")
    if monto_inventario.nil?
      monto_inventario = 0
    end
    monto_total = monto_proforma + monto_inventario
    begin
      transaction do

        prestamo = Prestamo.find_by_solicitud_id(solicitud_id)
        parametro = ParametroGeneral.find(1)

        # ----------------------------------------------------------------------
        # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
        # Efectuado por Alexander Cioffi 18-04-2012
        # ----------------------------------------------------------------------
        tasa = Tasa.find_by_sub_rubro_id(solicitud.sub_rubro_id)
        @tasa_valor = TasaValor.find_by_sql("Select * from tasa_valor where tasa_id = #{tasa.id} order by id desc LIMIT 1")
        @tasa_valor = @tasa_valor[0]

        if prestamo.nil?
                  
          numero = parametro.numero_prestamo_inicial + 1
          parametro.numero_prestamo_inicial = numero
          parametro.save!

          #condiciones = CondicionesFinanciamiento.find_by_rubro_id(solicitud.rubro_id)

          @producto = Producto.find_by_programa_id_and_sector_id_and_sub_sector_id(solicitud.programa_id, solicitud.sector_id, solicitud.sub_sector_id)

          #tasa = Tasa.find_by_tipo_cliente_id(solicitud.cliente.tipo_cliente_id)

          #@tasa_valor = TasaValor.find_by_tasa_id(tasa.id)

          prestamo = Prestamo.new(:solicitud=>solicitud, :producto=>@producto, :oficina=>solicitud.oficina, :destinatario=>"E")
          #prestamo.tasa_inicial=@tasa_valor.valor

          # ----------------------------------------------------------------------
          # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
          # Efectuado por Alexander Cioffi 18-04-2012
          # ----------------------------------------------------------------------

          prestamo.tasa_inicial = @tasa_valor.valor
          prestamo.tasa_vigente = @tasa_valor.valor
          prestamo.tasa_valor = @tasa_valor.valor
          prestamo.tasa_referencia_inicial = @tasa_valor.valor
          prestamo.tasa_id = tasa.id

          prestamo.monto_inventario=monto_inventario
          prestamo.monto_insumos = monto_proforma
          prestamo.monto_solicitado = monto_total
          prestamo.monto_aprobado = monto_total
          prestamo.save!
        else
          # ----------------------------------------------------------------------
          # Ajuste para ubicar la tasa segun el subrubro y no por el tipo cliente
          # Efectuado por Alexander Cioffi 18-04-2012
          # ----------------------------------------------------------------------

          prestamo.tasa_inicial = @tasa_valor.valor
          prestamo.tasa_vigente = @tasa_valor.valor
          prestamo.tasa_valor = @tasa_valor.valor
          prestamo.tasa_referencia_inicial = @tasa_valor.valor
          prestamo.tasa_id = tasa.id

          prestamo.monto_inventario= monto_inventario
          prestamo.monto_insumos = monto_proforma
          prestamo.monto_aprobado = monto_total
          prestamo.monto_solicitado = monto_total
          prestamo.save!
        end
        sras_primer_ano = 0
        sras_anos_siguen = 0
        factor_mensual_primer_ano = parametro.porcentaje_sras_maquinaria_primer_anno / 1200
        factor_mensual_anos_siguen = parametro.porcentaje_sras_maquinaria_anno_subsiguientes / 1200
        if prestamo.plazo <= 12
          sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
          sras_anos_siguen = 0.00
        end

        if prestamo.plazo > 12
          sras_primer_ano = (prestamo.monto_solicitado * factor_mensual_primer_ano) * 12
          sras_anos_siguen = (prestamo.monto_solicitado * factor_mensual_anos_siguen) * (prestamo.plazo - 12)
        end

        sras_total = sras_primer_ano + sras_anos_siguen

        prestamo.monto_sras_primer_ano = sras_primer_ano
        prestamo.monto_sras_anos_subsiguientes = sras_anos_siguen
        prestamo.monto_sras_total = sras_total
        #-----------------------------------------------------------------
        # Inicio de la Rutina para ajustar el total gastos en el prestamo 
        # Alexander Cioffi 23/03/2012                                     
        #-----------------------------------------------------------------
        @gastos = ProgramaTipoGasto.find_by_programa_id_and_tipo_gasto_id(solicitud.programa_id, 1)
        total_gasto = 0.00
        unless (@gastos.nil?)        
          if @gastos.porcentaje > 0
            monto = ((prestamo.monto_solicitado)*(@gastos.porcentaje/100))
          else
            monto = @gastos.monto_fijo 
          end
          total_gasto = monto
        end
        prestamo.monto_gasto_total = total_gasto.to_f
        #-----------------------------------------------------------------  
        # Fin  de la Rutina para ajustar el total gastos en el prestamo 
        #-----------------------------------------------------------------
        prestamo.monto_banco = 0.0
        prestamo.save!
        solicitud.monto_solicitado =  prestamo.monto_aprobado + prestamo.monto_sras_total + prestamo.monto_gasto_total
        solicitud.monto_aprobado = solicitud.monto_solicitado
        solicitud.conf_maquinaria = true
        solicitud.confirmacion = true
#        solicitud.monto_solicitado =  monto_total + prestamo.monto_gasto_total + prestamo.monto_sras_total
#        solicitud.monto_aprobado = solicitud.monto_solicitado
        solicitud.save!
        if solicitud.estatus_id == 10006
          solicitud.estatus_id = 10003
          solicitud.save!
          estatus_id_inicial = 10006
          estatus_id_final = solicitud.estatus_id
          ControlSolicitud.create(
            :solicitud_id=>solicitud.id,
            :estatus_id=>estatus_id_final,
            :usuario_id=>usuario.id,
            :fecha => Time.now,
            :estatus_origen_id => estatus_id_inicial,
            :accion => 'Avanzar')
        else
          solicitud.save!
        end
        if monto_proforma > 0
          proforma = SolicitudMaquinaria.find(:all, :conditions => "solicitud_id = #{solicitud_id} and estatus = 'P'")
          unidad = UnidadMedida.find(:first,:conditions=>"trim(lower(nombre))='unidad'")
          if unidad.nil?
              unidad = UnidadMedida.new
              unidad.nombre='UNIDAD'
              unidad.abreviatura='Uni'
              unidad.save!
          end           
          proforma.each {|p|
            plan = PlanInversion.new
            plan.solicitud_id = solicitud_id
            plan.estado_nombre = solicitud.oficina.ciudad.estado.nombre
            plan.oficina_nombre = solicitud.oficina.nombre
            plan.sector_nombre = solicitud.sector.nombre
            plan.sub_sector_nombre = solicitud.sub_sector.nombre
            plan.rubro_nombre = p.tipo_maquinaria.descripcion
            plan.sub_rubro_nombre = p.tipo_maquinaria.descripcion
            plan.partida_nombre = p.clase.nombre
            plan.item_nombre = p.clase.nombre
            plan.actividad_nombre = p.clase.nombre
            plan.unidad_medida_id = unidad.id
            plan.numero_desembolso = 1
            plan.costo_real = p.costo
            plan.monto_financiamiento = p.costo
            plan.cantidad = 1
            plan.tipo_item = 'I'
            plan.serial_motor = p.serial_motor
            plan.serial_chasis = p.serial_chasis
            plan.casa_proveedora_id = p.proforma.casa_proveedora_id
            plan.save
          }
        end
      end
      return ""
    rescue Exception => e
      logger.info "Excepcion =======> #{e.inspect}"
      return "error"
    end
  end

  #  def self.confirmar(solicitud_id, ruta)
  #    total_catalogo = Catalogo.count(:conditions=>"solicitud_id = #{solicitud_id}")
  #    unless total_catalogo > 0
  #      return "<li>Debe asignar al menos una maquinaria, equipo e implemento al trámite. </li>"
  #    else
  #      total_catalogo = Catalogo.count(:conditions=>"estatus is null and solicitud_id = #{solicitud_id}")
  #      unless total_catalogo > 0
  #        return "<li>Debe todas las maquinarias para poder confirmar al trámite. </li>"
  #      else
  #        solicitud = Solicitud.find(solicitud_id)
  #        solicitud.conf_maquinaria = true
  #        solicitud.save
  #        return ''
  #      end
  #    end
  #  end
  
  def estatus_w
    if self.estatus == 'P'
      return 'ProForma'
    elsif self.estatus == 'I'
      return 'Inventario'
    end
  end
  
end

# == Schema Information
#
# Table name: solicitud_maquinaria
#
#  id                  :integer         not null, primary key
#  tipo_maquinaria_id  :integer         not null
#  clase_id            :integer         not null
#  solicitud_id        :integer         not null
#  cantidad            :integer         not null
#  marca_maquinaria_id :integer
#  modelo_id           :integer
#  catalogo_id         :integer
#  proforma_id         :integer
#  estatus             :string(1)
#  serial_motor        :string(50)
#  serial_chasis       :string(50)
#  costo               :float
#

