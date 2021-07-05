module ApplicationHelper


  def errors_for(object, message=nil)
    html = ""
    unless object.nil?
      unless object.errors.blank?
        #html << "<div class='errorExplanation'>\n"
        if message.blank?
          html << "\t\t<h2>#{I18n.t('Sistema.Body.Vistas.Form.error_general')} </h2>\n"
        else
          html << "<h2>#{message}</h2>"
        end
        html << "\t\t<ul>\n"
        object.errors.full_messages.each do |error|
          html << "\t\t\t<li>#{error}</li>\n"
        end
        html << "\t\t</ul>\n"
        #html << "\t</div>\n"
      end
    end
    html.html_safe
  end

   def form_loggin(name = nil,controller= nil, action= nil)
      form_tag(:controller=>"#{controller}",:action=>"#{action}") + "
    <table  border ='0'><tr><td vlign='top'><p class='text_menu_contenido'>#{I18n.t('Sistema.Body.Vistas.Login.user')}: </p>
             </td><td><p class='text_menu_contenido'>#{I18n.t('Sistema.Body.Vistas.Login.clave')}: </p></td></tr>
             <tr><td>" +text_field(name, :usuario, :size=>10)+"</td><td>
                     "+password_field(name, :clave, :size=>10)+"</td></tr>
             <tr><td>"+submit_tag(I18n.t('Sistema.Body.Vistas.Login.ingresar'))+"</td></tr>
      </table>
      </form>".html_safe
  end


   def fecha_procesar_dataload(form_name,field_name)
    meses_A1 = {1  => I18n.t('date.month_names')[1]    , 2  => I18n.t('date.month_names')[2], 3 => I18n.t('date.month_names')[3],  4 =>I18n.t('date.month_names')[4],       5  => I18n.t('date.month_names')[5],
                6  => I18n.t('date.month_names')[6]    , 7  => I18n.t('date.month_names')[7],   8 => I18n.t('date.month_names')[8], 9 => I18n.t('date.month_names')[9], 10 => I18n.t('date.month_names')[10],
                11 => I18n.t('date.month_names')[11], 12 => I18n.t('date.month_names')[12]}
    meses_atras = 4
    @fecha            = Time.now
    anio_anterior     = @fecha.year-1
    anio_actual       = @fecha.year
    meses_actual      = @fecha.month.to_i

    meses_faltantes  = []
    meses_anteriores = []
    meses_a          = []
    meses_b          = []

    numero_meses_f = (meses_actual -1 .. 12).to_a
    numero_meses_f.each do |x|
      meses_faltantes <<  meses_A1.to_a.sort[x]
    end
    meses_faltantes  = meses_faltantes.uniq.compact.collect{|x,y| [anio_actual.to_s+'-'+x.to_s , y.to_s+'-'+anio_actual.to_s ] }
    if meses_actual.to_i < meses_atras.to_i
      numero_meses_a = ((12 - (5 - meses_actual)).. 11).to_a
      numero_meses_a.collect{ |x| meses_anteriores << meses_A1.to_a.sort[x]}
      numero_meses_d = (0 .. (4 - (meses_anteriores.size.to_i) )).to_a
      numero_meses_d.collect{ |x| meses_anteriores << meses_A1.to_a.sort[x]}
      meses_a = meses_anteriores.uniq.compact.collect{|x,y| [anio_anterior.to_s+'-'+x.to_s , y.to_s+'-'+anio_anterior.to_s  ] if x.to_i > 8  }
      meses_anteriores.uniq.compact.collect{|x,y|  meses_a << [anio_actual.to_s+'-'+x.to_s , y.to_s+'-'+anio_actual.to_s  ] if x.to_i < 3  }
    else
      numero_meses_c = ((meses_actual.to_i - 4) .. meses_actual).to_a
      numero_meses_c.collect{ |x| puts meses_anteriores << meses_A1.to_a.sort[x - 1]}
      meses_anteriores = meses_anteriores.uniq.compact
      meses_b = meses_anteriores.uniq.compact.collect{|x,y| [anio_actual.to_s+'-'+x.to_s , y.to_s+'-'+anio_actual.to_s ]  }
    end
    meses_anteriores = meses_a + meses_b
     meses = meses_anteriores + meses_faltantes
     select(:tipo,:fecha,meses.compact.uniq.collect{|x,y| [y , x ] }, {:include_blank => false, :prompt=>I18n.t('Sistema.Body.Vistas.Form.seleccionar')},
                                                   {:onchange=>[
                                                    remote_function(:update => "list_form", :url=>{:action=>:list},:with=>"'fecha='+value")+';',
                                                    remote_function(:update => "div_tipo_transaccion", :url => { :action => :actualizar_tipo_transaccion
                                                                                                                 },:with =>"'fecha='+value")+';'],:class=>'select'})
  end



# Esta función crea el código del menú en las vistas
  def menu

    #logger.debug "def menu ======> #{session[:menu_string].to_s}"
    #logger.debug "def menu @valid_menu ======> #{@valid_menu.inspect}"

    if session[:menu_string].nil?
      menu_string="var myMenu =[ "
      fill_menu(@valid_menu, menu_string)
      menu_string.concat " ]"
      session[:menu_string] = menu_string
    else

      menu_string = session[:menu_string]
      #logger.debug "Paso por el else =========> #{menu_string}"
    end

  end

  # Esta función crea los errores en las vistas
  def error(id = nil)
    if id
      id = "error_".concat(id)
    else
      id = "error"
    end

    "<div id=\"#{id}\" class=\"errorExplanation\" style=\"display: none\">&nbsp;</div>".html_safe
  end

  def errores
    if flash[:error]
      "<div class=\"errorExplanation\" id=\"errorExplanation\"><h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p>#{flash[:error]}</p></div>".html_safe
    end
  end

  # Esta función crea los mensajes de error en las vistas (funcion mejorada)
  def errores2
    unless flash[:error].nil?
      display = 'block'
      error = errors_for flash[:error]
    else
      display = 'none'
      error = '&nbsp;'
    end
    "<div class=\"errorExplanation\" id=\"errorExplanation\" style=\"display: #{display}; text-align: left\">\n#{error}\n</div>".html_safe

  end



  # Esta función crea los mensajes en las vistas
  def message
    if flash[:notice]
      display = 'block'
      notice = flash[:notice]
    else
      display = 'none'
      notice = '&nbsp;'
    end
    "<div class=\"msg-notice\" id=\"message\" style=\"display: #{display}; text-align: center\">\n#{notice}\n</div>".html_safe
  end

  # Esta función crea los warnings en las vistas
  def warning
    logger.debug "me meti aqueeeeee"
    if flash[:warning]
      display = 'block'
      warning = flash[:warning]
    else
      display = 'none'
      warning = '&nbsp;'
    end
    "<div class=\"msg-warning\" id=\"warning\" style=\"display: #{display}; text-align: center\">\n#{warning}\n</div>".html_safe
  end

  # Esta función crea los mensajes en las vistas de formularios tipo AJAX
  def ajax_message
    "<div class=\"msg-notice\" id=\"message\" style=\"display: none; text-align: center\">&nbsp;</div>".html_safe
  end

  # Crea la paginación en las vistas de los formularios tipo AJAX
  def pagination_links_remote(paginator, action)
    page_options = {:window_size => 1}
    params.delete(:controller);
    pagination_links_each(paginator, page_options) do |n|
      options = {
        :loading =>'image_load()',
        :loaded => 'image_unload()',
        :url => {:action => action, :params => params.merge({:page => n})}
      }
      html_options = {:href => "/" + url_for(:action => action, :params => params.merge({:page => n}))}
      link_to_remote(n.to_s, options, html_options.html_safe)
    end
  end

 # Este ayuda a crear la clase de estilo que utilizan las cabeceras de las
 # listas para ordenar las mismas
  def sort_class_helper(param, style_asc = 'ascendente', style_desc = 'descendente')
    result = "class=\"#{style_asc}\"".html_safe if params[:sort] == param
    result = "class=\"#{style_desc}\"".html_safe if params[:sort] == param + " DESC"
    return result
  end

  # Este ayuda a crear el link que utilizan las cabeceras de las listas
  # para ordenas las mismas
  def sort_link_helper(text, param, action, title = I18n.t('Sistema.Body.General.ordenar_por_este_campo'))
    key = param
    if params[:sort] == param
      title.concat(I18n.t('Sistema.Body.General.de_forma_descendente'))
      key += " DESC"
    else
      title.concat(I18n.t('Sistema.Body.General.de_forma_ascendente'))
    end
    params.delete(:controller);

    options = {
        :loading =>'image_load()',
        :loaded => 'image_unload()',
        :url => {:action => action, :params => params.merge({:sort => key, :page => nil, :method => :get })}

    }
    html_options = {
      :title => title,
      :href => "/" + url_for(:action => action, :params => params.merge({:sort => key, :page => nil, :method => :get}))
    }
    link_to_remote(text, options, html_options)
  end

  # Este método se coloca al lado de los links que deben ser seguros, el parámetro que
  # se le pasa es el nombre de la acción que se va a asegurar
  def vlink(accion)
    if !@usuario.super_usuario
      acciones = []
      for rol in @usuario.roles
        acciones = acciones | rol.acciones
      end
      accion = Accion.find_by_nombre_sistema(accion)
      acciones.find {|rol_opcion_accion| rol_opcion_accion.accion_id == accion.id }
    else
      true
    end
  end

  # Este método crea el links que requieren de autorización
  def alink(opcion_ruta, accion_nombre_sistema, referencia_id, descripcion, url)

    opcion = Opcion.find_by_ruta(opcion_ruta)
    accion = Accion.find_by_nombre_sistema(accion_nombre_sistema)
    opcion_accion = OpcionAccion.find_by_accion_id_and_opcion_id(accion.id, opcion.id)
    mensaje = ''
    if autorizacion = Autorizacion.find(:first, :conditions=>["opcion_accion_id = ? and referencia_id = ? and usuario_id = ?", opcion_accion.id, referencia_id, @usuario.id], :order=>'id desc')
      case autorizacion.estatus
        when 'E'
          if autorizacion.vencida
            mensaje = "<b>#{I18n.t('Sistema.Body.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.vencida')} </b>"
          else
            return "<b>#{I18n.t('Sistema.Body.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.para')} #{accion.nombre} #{I18n.t('Sistema.Body.Modelos.Errores.en_espera_por_aprobacion')} </b>".html_safe
          end
        when 'A'
          if autorizacion.vencida
            mensaje = "<b>#{I18n.t('Sistema.Body.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.aprobada')} #{I18n.t('Sistema.Body.Vistas.General.pero')} #{I18n.t('Sistema.Body.Vistas.General.vencida')} </b>"
          else
            return "<b>#{I18n.t('Sistema.Body.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.aprobada')}</b>  "+
              link_to_remote(accion.nombre,:loading =>'image_load()', :loaded => 'image_unload()', :url => url)
          end
        when 'R'
          mensaje = "<b>#{I18n.t('Sistema.Body.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.rechazada')}</b>"
      end

    end

    mensaje + " " + link_to_remote("#{I18n.t('Sistema.Body.Vistas.General.solicitar')} #{I18n.t('Sistema.Body.Vistas.General.autorizacion')} #{I18n.t('Sistema.Body.Vistas.General.para')} "+accion.nombre,
      :loading =>'image_load()',
      :loaded => 'image_unload()',
      :url => {
      :action => :solicitar_autorizacion,
      :opcion_accion_id => opcion_accion.id,
      :referencia_id=>referencia_id,
      :descripcion=>descripcion})
  end

  # Sirve para transformar un valor booleano en una imagen
  def format_bool(value)
    if value
      image_tag 'activo.gif'
    else
      image_tag 'inactivo.gif'
    end
  end

  # Función que ayuda a crear los calendarios para olas fechas
  def calendar(input_name, button_name)
    render :partial=>'/form/calendar', :locals=>{ :input_name=>input_name, :button_name=>button_name }
  end

  # Función que ayuda a dar formato a los valores tipo float, sin separadores de miles
  def format_float(number)
    number_with_delimiter(number, :delimiter => "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles')}")
  end

  # Función que ayuda a dar formato a los valores tipo float pero con separadores de miles y con 2 decimales
 def format_fm(valor)
    #logger.debug "valor inicial #{valor}"
    if valor.nil?
      valor = 0.00
    end
    unless valor.nil?
      #logger.debug "entro en el unless"
      valor = valor.to_s
      #logger.debug "valor.to_s #{valor}"
      #logger.debug "I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles') #{I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles')}"
      #logger.debug "I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal') #{I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')}"
      #valor = sprintf('%01.2f', valor.to_f).sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal'))
      #logger.debug "valor sprintf #{valor}"
      #logger.debug "valor.to_s.gsub #{valor.to_s.gsub(/#{I18n.t('Sistema.Body.ExpresionesRegulares.formato_numero')}/, "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_grupo_miles')}")}"
      #valor.to_s.gsub(/#{I18n.t('Sistema.Body.ExpresionesRegulares.formato_numero')}/, "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_grupo_miles')}")
      valor = sprintf('%01.2f', valor.to_f).sub('.',',').to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def format_int(valor)
    unless valor.nil?
      valor = valor.to_s
#      valor.to_s.gsub(/#{I18n.t('Sistema.Body.ExpresionesRegulares.formato_numero')}/, "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_grupo_miles')}")
      valor.to_s.gsub('.',',')
    end
  end

# Función que ayuda a dar formato a los valores tipo float pero con separadores de miles y con 3 decimales
  def format_fm3(valor)
    unless valor.nil?
      valor = valor.to_s
      # valor = sprintf('%01.3f', valor.to_f).sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal'))
      # valor.to_s.gsub(/#{I18n.t('Sistema.Body.ExpresionesRegulares.formato_numero')}/, "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_grupo_miles')}")
      valor = sprintf('%01.3f', valor.to_f).sub('.',',')
      valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
    end
  end

  def format_f3(valor)
    unless valor.nil?
      valor = valor.to_s
#      valor = sprintf('%01.3f', valor.to_f).sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal'))
      valor = sprintf('%01.3f', valor.to_f).sub('.',',')
    end
  end

  def format_f(valor)
    valor = valor.to_s
#    sprintf('%01.2f', valor.to_f).sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')) unless valor.nil?
    sprintf('%01.2f', valor.to_f).sub('.',',') unless valor.nil?
  end

  def format_p(valor)
    valor = valor.to_s
#    sprintf('%01.2f', valor.to_f).sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles')) unless valor.nil?
    sprintf('%01.2f', valor.to_f).sub(',','.') unless valor.nil?
  end

  def format_valor(valor)

#    valor.sub(I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal'), I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles'))
    valor.sub(',','.')

  end

  #Función para colocar separador de miles a números enteros

  def format_sep(valor)
#    valor.to_s.gsub(/#{I18n.t('Sistema.Body.ExpresionesRegulares.formato_numero')}/, "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_grupo_miles')}")
    valor.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end

# Función que ayuda a dar formato a los valores tipo date pero con separadores / (%d/%m/%Y)
  def format_fecha(valor)
    valor.strftime(I18n.t('time.formats.gebos_short')) unless valor.nil?
  end

  #Función que ayuda a dar formato a los valores tipo Time pero con : (%I:%M:%S, %p)
  def format_hora(valor)
    valor.strftime(I18n.t('time.formats.gebos_time_short')) unless valor.nil?
  end

  #Función que ayuda a dar formato a los valores tipo Time pero con : (%I:%M:%S, %p)
  def format_hora_arrime(valor)
    valor.strftime(I18n.t('time.formats.hora_corta_arrime')) unless valor.nil?
  end

# Función que ayuda a dar formato a los valores tipo date (long) pero con separadores / (%d de %b de %Y a las %H:%M:%S)
  def format_fecha_larga(valor)
    valor.strftime(I18n.t('time.formats.gebos_large')) unless valor.nil?
  end

# Función que ayuda a dar formato a los valores tipo date (inverted) pero con separadores / (%Y/%m/%d)
  def format_fecha_inv(valor)
    valor.strftime(I18n.t('time.formats.gebos_inverted')) unless valor.nil?
  end

# Función que ayuda a dar formato a los valores tipo date (inverted) pero con separadores - (%Y-%m-%d)
  def format_fecha_inv2(valor)
    valor.strftime(I18n.t('time.formats.gebos_inverted2')) unless valor.nil?
  end


# Función que ayuda a dar formato a los valores tipo date para la hora en formato corto %I:%M:%S %p
  def format_hora_corta(valor)
    valor.strftime(I18n.t('time.formats.hora_corta')) unless valor.nil?
  end

# Función que ayuda a dar formato a los valores tipo date para la hora en formato corto militar (%H%M%S)
  def format_hora_corta_militar(valor)
    valor.strftime(I18n.t('time.formats.hora_militar_corta')) unless valor.nil?
  end

  #funcion que retorna la fecha en el formato de busqueda aaaa-mm-dd dependiendo del tipo de idioma que se tenga
  def format_fecha_conversion(fecha)
    unless fecha.to_s ==''

      if I18n.locale.to_s=="es" || I18n.locale.to_s=="fr" || I18n.locale.to_s=="ar" || I18n.locale.to_s=="cs" || I18n.locale.to_s=="da" || I18n.locale.to_s=="de" || I18n.locale.to_s=="fi" || I18n.locale.to_s=="hu" || I18n.locale.to_s=="it" || I18n.locale.to_s=="ru" ||  I18n.locale.to_s=="nl" || I18n.locale.to_s=="pl" || I18n.locale.to_s=="pt" || I18n.locale.to_s=="sl" || I18n.locale.to_s=="sv"
        fecha_busqueda = fecha[6,4].to_s + '-' + fecha[3,2].to_s + '-' + fecha[0,2].to_s
      elsif I18n.locale.to_s=="ja"
        fecha_busqueda = fecha[0,4].to_s + '-' + fecha[5,2].to_s + '-' + fecha[8,2].to_s
      else
        fecha_busqueda = fecha[6,4].to_s + '-' + fecha[0,2].to_s + '-' + fecha[3,2].to_s
      end

    else
      fecha_busqueda = ""
    end
  end


# Función que se utiliza para mostrar un número con formato al lado de un campo de entrada
  def display_number(number, name)

    #logger.debug "NUMBER, NAME " << number.to_s << ", " << name.to_s
    number = 0 if number.nil?
    html=''
    html='<span id="' + name + '_display">' + number_with_delimiter(number, delimiter: "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_miles')}", separator: "#{I18n.t('Sistema.Body.ExpresionesRegulares.separador_decimal')}",precision:2) + "</span>"
    html.html_safe
  end

  private
# Ayuda a crear el menú del sistema, esta es llamada por menu
  def fill_menu(menus, menu_string)
    pass = false
    menus.each do |menu|
      if pass
        menu_string.concat ","
      else
        pass=true
      end
#      menu_string.concat "[null, '#{I18n.t('Sistema.Body.Menu.' + menu.nombre + '')}', '#{menu.opcion.ruta_real}', '_self', ''"
      if (menu.tiene_opcion)
        menu_string.concat "[null, '#{I18n.t('Sistema.Body.Menu.menu' + menu.menu_id.to_s + '')}', '#{menu.opcion.ruta_real}', '_self', ''"
      else
        menu_string.concat "[null, '#{I18n.t('Sistema.Body.Menu.menu' + menu.menu_id.to_s + '')}', '', '_self', ''"
        if menu.children
          menu_string.concat ","
          fill_menu(menu.children, menu_string)
        end
      end
      menu_string.concat "]"
    end
  end

  def estatus_prestamo(estatus)
    case estatus
      when 'S'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_solicitud')
      when 'D'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.en_espera_por_desembolsos')
      when 'V'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente')
      when 'E'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vencido')
      when 'F'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_reestructuracion') #Reestructuración Financiera
      when 'A'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado_ampliacion') #Reestructuración Financiera
      when 'L'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.litigio')
      when 'C'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.cancelado')
      when 'P'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente') # En el periodo de gracia de la mora
      when 'J'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica') # Condición especial incluida para reestructuracion
      when 'H'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.vigente_demorado')
      when 'K'
        I18n.t('Sistema.Body.Modelos.Prestamo.Estatus.castigado')
      when  "P"
        I18n.t('Sistema.Body.EstatusPrestamo.cambio_estatus')
     end
  end

  def fuente_recursos_helper(id)

    unless id < 1
      case id

      when 1
        I18n.t('Sistema.Body.Institucion.fondas')
      when 2
        I18n.t('Sistema.Body.Institucion.agro')
      when 3
        I18n.t('Sistema.Body.Institucion.fondafa')
      end
    end
  end

  
  def nombre_plazo_helper(plazo)
  
    unless plazo == "0"
      unless plazo.nil?
        if plazo == 'C'
          I18n.t('Sistema.Body.TipoPlazo.corto')
        else
          I18n.t('Sistema.Body.TipoPlazo.largo')
        end
      end
    end
    
  end
  
  def nombre_reestructurado_helper(r)

     case r

       when 'N'
         I18n.t('Sistema.Body.TipoFinanciamiento.normal')
       when 'R'
         I18n.t('Sistema.Body.TipoFinanciamiento.reestructurado')
     end

  end

  def nombre_monto_helper(t)

    case t

    when "MP"
       I18n.t('Sistema.Body.Montos.monto_transaccion')

    when "MC"
      I18n.t('Sistema.Body.Montos.capital')

    when "IO"
      I18n.t('Sistema.Body.Montos.interes_ordinario')

    when "ID"
      I18n.t('Sistema.Body.Montos.interes_diferido')

    when "IM"
      I18n.t('Sistema.Body.Montos.interes_mora')

    when "MD"

       I18n.t('Sistema.Body.Montos.monto_desembolso')

    when "MG"

      I18n.t('Sistema.Body.Montos.monto_gasto')
      
    when "MS"

      I18n.t('Sistema.Body.Montos.monto_sras')

    when "ME"

      I18n.t('Sistema.Body.Montos.monto_excedente')
      
    when "MB"

      I18n.t('Sistema.Body.Montos.monto_boleta')
    end

  end

  def modalidad_pago_helper(m)

    unless m.nil?
      case m

        when 'A'

          I18n.t('Sistema.Body.ModalidadPago.arrime')

        when 'D'
          I18n.t('Sistema.Body.ModalidadPago.domicializacion')

        when 'O'
          I18n.t('Sistema.Body.ModalidadPago.taquilla')

        when 'R'

          I18n.t('Sistema.Body.ModalidadPago.deposito')          

        when 'X'
          I18n.t('Sistema.Body.General.no_aplica')
          
        when 'Z'
          I18n.t('Sistema.Body.ModalidadPago.devengo')

      end
      
    end

  end

  def obtiene_accion(estatus_id)

    accion = ConfiguracionAvance.first(:conditions=>["estatus_origen_id = ?",estatus_id]).accion
    return accion
  end
end
