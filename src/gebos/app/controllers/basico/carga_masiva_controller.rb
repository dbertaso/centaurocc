# encoding: utf-8
require 'rubygems'
require 'roo'
#require 'jcode'
#$KCODE = 'u'

class Basico::CargaMasivaController < FormTabsController

  def index
    @feedback=""
  end

  def create
    @conditions = ""
    if params[:accion].to_i == 0
      @msg =""
      @clase =""
      @total = 0
      @feedback=""
      @ids = ''
      @msg = ""
      unless params[:avanzar].nil?
        save(params[:avanzar][:archivo])
      else
        @msg = I18n.t('Sistema.Body.Modelos.Errores.archivo_seleccionar')
      end

      if @msg.length > 0
        @feedback = "<div id=\"errorExplanation\" class=\"errorExplanation\" style=\"text-align: left\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{@msg}</UL></div>".html_safe
      end
      if @ids.length > 0
        @conditions = "catalogo.id in (#{@ids})"
      else
        @conditions = "catalogo.id = 0"
      end
    else
      @conditions = "catalogo.id = 0"
    end
    params['sort'] = "serial"    
    
    @list = Catalogo.search(@conditions, params[:page], params[:sort])
    @total=@list.count
    if @total > 0
      @mensaje = "<div class=\"msg-notice\" id=\"message\" style=\"text-align: center\">#{I18n.t('Sistema.Body.Controladores.CargaMasiva.Etiquetas.actualizar_total')} #{@total} #{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.registros')}</div>".html_safe
    end

  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CargaMasiva.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CargaMasiva.FormTitles.form_title_record')
    @form_title_records = 'Desembolsos'
    @form_entity = 'financiamiento'
    @form_identity_field = 'numero'
    @width_layout = '960'
  end

  def save(archivo)
    name =  archivo.original_filename
    unless name.nil? || name.empty?
      ext  =  name[(name.length - 3),name.length]
      unless ext == 'xls'
        @msg = I18n.t('Sistema.Body.Modelos.Errores.archivo_formato')
        @clase = "error"
      else
        directory = "tmp"
        path = File.join(directory, name)
        File.open(path, "wb") { |f| f.write(archivo.read) }
        xls = Excel.new("#{Rails.root}/#{path}")
        xls.default_sheet = xls.sheets.first
        count = 2
        if xls.last_row.blank? || xls.last_row < 2
          @msg = I18n.t('Sistema.Body.Modelos.Errores.archivo_informacion')
          return
        end
        while xls.last_row >= count
          if xls.cell(count,'A').to_s.nil? || xls.cell(count,'A').to_s.empty?
            @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
          else
            unless xls.cell(count,'A').to_s.length == xls.cell(count,'A').to_i.to_s.length
              @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
            else
              total =  ContratoMaquinariaEquipo.count(:conditions=>"id =#{xls.cell(count,'A').to_i}")
              unless total > 0
                @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
              else
                if xls.cell(count,'B').to_s.nil? || xls.cell(count,'B').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'B').to_s.length == xls.cell(count,'B').to_i.to_s.length
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                  else
                    total =  Clase.count(:conditions=>"id =#{xls.cell(count,'B').to_i}")
                    unless total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                    end
                  end
                end
                if xls.cell(count,'C').to_s.nil? || xls.cell(count,'C').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'C').to_s.length == xls.cell(count,'C').to_i.to_s.length
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                  else
                    total =  MarcaMaquinaria.count(:conditions=>"id =#{xls.cell(count,'C').to_i}")
                    unless total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                    end
                  end
                end
                if xls.cell(count,'D').to_s.nil? || xls.cell(count,'D').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'D').to_s.length == xls.cell(count,'D').to_i.to_s.length
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                  else
                    total =  Modelo.count(:conditions=>"id =#{xls.cell(count,'D').to_i}")
                    unless total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                    end
                  end
                end
                if xls.cell(count,'E').to_s.nil? || xls.cell(count,'E').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'E').to_s.downcase == 'no aplica'
                    total =  Catalogo.count(:conditions=>"serial = '#{xls.cell(count,'E').to_s}' and contrato_maquinaria_equipo_id = #{xls.cell(count,'A').to_i}")
                    if total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} ya se encuentra registrado en la base de datos</Li>"
                    end
                  end
                end
                if xls.cell(count,'F').to_s.nil? || xls.cell(count,'F').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'F').to_s.downcase == 'no aplica'
                    total =  Catalogo.count(:conditions=>"chasis = '#{xls.cell(count,'F').to_s}' and contrato_maquinaria_equipo_id = #{xls.cell(count,'A').to_i}")
                    if total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                    end
                  end
                end
                if xls.cell(count,'G').to_s.nil? || xls.cell(count,'G').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.General.descripcion')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                end
                if xls.cell(count,'H').to_s.nil? || xls.cell(count,'H').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.almacen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  unless xls.cell(count,'H').to_s.length == xls.cell(count,'H').to_i.to_s.length
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.almacen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                  else
                    total =  AlmacenMaquinaria.count(:conditions=>"id =#{xls.cell(count,'H').to_i}")
                    unless total > 0
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.almacen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                    end
                  end
                end
                if xls.cell(count,'M').to_s.nil? || xls.cell(count,'M').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.numero')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                end
                contrato = ContratoMaquinariaEquipo.find(:first, :conditions=>"id = #{xls.cell(count,'A').to_i}")
                if contrato.naturaleza == 'I'
                  if xls.cell(count,'I').to_s.nil? || xls.cell(count,'I').to_s.empty?
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.pais_origen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                  else
                    unless xls.cell(count,'I').to_s.length == xls.cell(count,'I').to_i.to_s.length
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.pais_origen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                    else
                      total =  Pais.count(:conditions=>"id = #{xls.cell(count,'I').to_i}")
                      unless total > 0
                        @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.pais_origen')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')}</Li>"
                      end
                    end
                  end
                  if xls.cell(count,'J').to_s.nil? || xls.cell(count,'J').to_s.empty?
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.fecha_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                  else
                    unless xls.cell(count,'J').to_s.length == 10
                      @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.fecha_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}</Li>"
                    else
                      persona = Persona.new()
                      persona.fecha_nacimiento = xls.cell(count,'J').to_s[6,4] + "-" + xls.cell(count,'J').to_s[3,2] + "-" + xls.cell(count,'J').to_s[0,2]
                      if persona.fecha_nacimiento.nil?
                        @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.fecha_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.fecha_invalida')}</Li>"
                      end
                    end
                  end
                  if xls.cell(count,'K').to_s.nil? || xls.cell(count,'K').to_s.empty?
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.puerto_llegada')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                  end
                  if xls.cell(count,'L').to_s.nil? || xls.cell(count,'L').to_s.empty?
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.Catalogo.Etiquetas.nombre_buque')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                  end
                end
                if xls.cell(count,'N').to_s.nil? || xls.cell(count,'N').to_s.empty?
                  @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.esta_en_blanco')}</Li>"
                else
                  if xls.cell(count,'N').to_s[/^[0-9]*.[0-9]*$/].nil?
                    @msg << "<Li>#{I18n.t('Sistema.Body.Vistas.General.costo')} #{I18n.t('Sistema.Body.Modelos.Errores.en_la_linea')} #{count} #{I18n.t('Sistema.Body.Modelos.Errores.numero_invalido')}</Li>"
                  end
                end
                unless @msg.length > 0
                  catalogo = Catalogo.new
                  catalogo.contrato_maquinaria_equipo_id = xls.cell(count,'A').to_i
                  catalogo.clase_id = xls.cell(count,'B').to_i
                  catalogo.marca_maquinaria_id = xls.cell(count,'C').to_i
                  catalogo.modelo_id = xls.cell(count,'D').to_i
                  if xls.celltype(count,'E').to_s == "float"
                    catalogo.serial = xls.cell(count,'E').to_i.to_s
                  else
                    catalogo.serial = xls.cell(count,'E').to_s
                  end
                  if xls.celltype(count,'F').to_s == "float"
                    catalogo.chasis = xls.cell(count,'F').to_i.to_s
                  else
                    catalogo.chasis = xls.cell(count,'F').to_s
                  end
                  catalogo.descripcion = xls.cell(count,'G').to_s
                  catalogo.almacen_maquinaria_id = xls.cell(count,'H').to_i
                  if contrato.naturaleza == 'I'
                    catalogo.pais_id = xls.cell(count,'I').to_i
                    catalogo.fecha_llegada_f = xls.cell(count,'J').to_s
                    catalogo.puerto_llegada = xls.cell(count,'K').to_s
                    catalogo.nombre_buque = xls.cell(count,'L').to_s
                    catalogo.monto_dolares = xls.cell(count,'N').to_f
                  else
                    catalogo.monto_real = xls.cell(count,'N').to_f
                  end
                  catalogo.numero_factura = xls.cell(count,'M').to_s
                  catalogo.fecha_carga = Time.now
                  catalogo.save!
                  if @ids.length > 0
                    @ids <<  ',' << catalogo.id.to_s
                  else
                    @ids = catalogo.id.to_s
                  end
                end
              end
            end
          end
          count = count + 1
        end
      end
      unless @ids.to_s.length > 0
        unless @msg.length > 0
          @msg = I18n.t('Sistema.Body.Modelos.Errores.archivo_informacion')
        end
      end
    else
      @msg = I18n.t('Sistema.Body.Modelos.Errores.archivo_seleccionar')
    end
  end

end
