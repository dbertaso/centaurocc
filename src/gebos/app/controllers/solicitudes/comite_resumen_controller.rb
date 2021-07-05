# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Solicitudes::ComiteResumenController
# descripción: Migración a Rails 3
#

class Solicitudes::ComiteResumenController < FormTabsController

   skip_before_filter :set_charset, :only=>[:reseteo_combos,:numero_sesion_search, :subsector_search, :rubro_search, :decision_comite_nacional]

   layout 'form_basic'

   require 'spreadsheet'
   #require 'spreadsheet'
   include Spreadsheet
   require "htmldoc"
   #require "htmldoc-rails"

  def generar_punto_cuenta
  end

  def index
    @estado = Estado.find(:all, :order => 'nombre')
    fill_filtros
  end

  def list
    @comite_id   = params[:comite][0]
    @tipo_comite=params[:tipo_comite][0]

    unless params[:estado_id].nil?
      unless params[:estado_id][0].to_s==''
          estado_id = params[:estado_id][0].to_s
          estado = Estado.find(estado_id)
          conditions = " #{conditions}  AND estado.id = " + estado_id      
		      @form_search_expression << "Estado es igual '#{estado.nombre}'"
      end
    end

    unless params[:sector_id].nil?
      unless params[:sector_id][0].to_s==''
          sector_id = params[:sector_id][0].to_s
          sector = Sector.find(sector_id)
          conditions = " #{conditions}  AND  sector.id = " + sector_id      
		      @form_search_expression << "Sector es igual '#{sector.nombre}'"
      end
    end

    unless params[:subsector_id].nil?
      unless params[:subsector_id][0].to_s==''
          subsector_id = params[:subsector_id][0].to_s
          subsector = SubSector.find(subsector_id)
          conditions = " #{conditions}  AND  sub_sector.id = " + subsector_id      
		      @form_search_expression << "Sub Sector es igual '#{subsector.nombre}'"
      end
    end

    unless params[:rubro_id].nil?
      unless params[:rubro_id][0].to_s==''
          rubro_id = params[:rubro_id][0].to_s
          rubro = Rubro.find(rubro_id)
          conditions = " #{conditions}  AND  rubro.id = " + rubro_id      
		      @form_search_expression << "Rubro es igual '#{rubro.nombre}'"
      end
    end
    @moneda = Moneda.find(ParametroGeneral.first.moneda_id)
    sql="select 
              distinct sector.id as sector_id,sector.nombre as sector_nombre,
              sub_sector.id as subsector_id,sub_sector.nombre as subsector_nombre,
              rubro.id as rubro_id,rubro.nombre as rubro_nombre,
              estado.id as estado_id,estado.nombre as estado_nombre
        from 
              comite_decision_historico cdh
                inner join solicitud on solicitud.id=cdh.solicitud_id
                inner join oficina on solicitud.oficina_id=oficina.id
                inner join ciudad on ciudad.id=oficina.ciudad_id
                inner join estado on estado.id=ciudad.estado_id
                inner join rubro on rubro.id=solicitud.rubro_id
                inner join sector on sector.id=solicitud.sector_id
                inner join sub_sector on sub_sector.id=solicitud.sub_sector_id
        where
                cdh.decision is not null and solicitud.moneda_id = #{@moneda.id}
                and cdh.tipo_comite='#{@tipo_comite}'
                and cdh.comite_id=#{@comite_id}
                #{conditions}
  union
        select 
                distinct sector.id as sector_id,sector.nombre as sector_nombre,
                sub_sector.id as subsector_id,sub_sector.nombre as subsector_nombre,
                rubro.id as rubro_id,rubro.nombre as rubro_nombre,
                estado.id as estado_id,estado.nombre as estado_nombre
        from
                comite_decision_historico_total cdht
                  inner join solicitud on solicitud.id=cdht.solicitud_id
                  inner join oficina on solicitud.oficina_id=oficina.id
                  inner join ciudad on ciudad.id=oficina.ciudad_id
                  inner join estado on estado.id=ciudad.estado_id
                  inner join rubro on rubro.id=solicitud.rubro_id
                  inner join sector on sector.id=solicitud.sector_id
                  inner join sub_sector on sub_sector.id=solicitud.sub_sector_id
        where
                cdht.decision is not null and solicitud.moneda_id = #{@moneda.id}
                and cdht.tipo_comite='#{@tipo_comite}'
                and cdht.comite_id=#{@comite_id}
                #{conditions}
  order by 
            sector_nombre asc, subsector_nombre asc, rubro_nombre asc
        "
    @conditions = conditions
    @list=ComiteDecisionHistorico.find_by_sql(sql)
    @nro_instancia=!params[:comite].nil? ? @nro_instancia=Comite.find(params[:comite])[0].numero : ''
    form_list
  end

  #################################################################
  # Genera resumen de decisiones por solicitud de una sesion (EXCEL)
  #################################################################
  def generar_resumen_decision_excel
    @ciudad = Ciudad.find(:first, :conditions=>['ciudad.id=?',Oficina.find(session[:oficina]).ciudad_id.to_s],:include=>:estado)
    estado=@ciudad.estado.nombre.to_s
    nombre_oficina=Oficina.find(session[:oficina]).nombre.to_s
    comite_id = params[:comite_id]
    @comite = Comite.find comite_id
    tipo_comite=params[:tipo_comite].to_s
    condicion= tipo_comite=='e' ? " comite_estadal_id=#{comite_id} and decision_comite_estadal is not null " : " comite_id=#{comite_id} and decision_comite_nacional is not null "
    solicitudes=Solicitud.find(:all,:conditions=>condicion)
    numero_sesion = @comite.numero
    fecha_apertura= @comite.fecha_apertura.day.to_s << "-" << @comite.fecha_apertura.month.to_s << "-" << @comite.fecha_apertura.year.to_s
    fecha_archivo=Time.now
    nombre_archivo=tipo_comite=='e' ? I18n.t('Sistema.Body.Vistas.General.estadal') : I18n.t('Sistema.Body.Vistas.General.nacional')
    nombre_archivo = "ResumenInstanciaAprobacion#{nombre_archivo}_" << fecha_archivo.day.to_s << "-" << fecha_archivo.month.to_s << "-" << fecha_archivo.year.to_s
    workbook = Excel.new("#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls")
    sheet = workbook.add_worksheet("#{I18n.t('Sistema.Body.Vistas.General.resumen')} #{I18n.t('Sistema.Body.Vistas.General.instancia')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.aprobacion')}")

    format_header_1=Format.new(:pattern_fg_color=>:silver,:pattern=>5,:align=>"merge",:border_color=>"silver",:vertical_align=>:bottom,:bold=>true,:border=>true)
    format_header_2=Format.new(:pattern_fg_color=>:silver,:pattern=>5,:align=>"merge",:border_color=>"silver",:vertical_align=>:top,:bold=>true,:border=>true)
    sheet.write(0, 0, [(I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.FormTitles.form_title_record')).upcase, "", "", "","","","",""], format_header_1)
    titulo= params[:tipo_comite].to_s=='e' ? (I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.Mensajes.form_title')).upcase : (I18n.t('Sistema.Body.Controladores.InstanciaComiteEstadal.Mensajes.form_title_nacional')).upcase
    sheet.write(1,0,[titulo, "", "", "","","","",""], format_header_2)
    sheet.row(0).height=40
    sheet.row(1).height=40


    format_sesion=Format.new(:pattern_fg_color=>:silver,:pattern=>5,:horizontal_align=>:left,:align=>:left,:border_color=>"black",:vertical_align=>:center,:bold=>true)
    format_sesion.border=true
    sheet.write(0,8,["#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.sesion')}:  #{numero_sesion}"],format_sesion)

    format_fecha=Format.new(:pattern_fg_color=>:silver,:pattern=>5,:horizontal_align=>:left,:align=>:left,:border_color=>"black",:vertical_align=>:center,:bold=>true)
    format_fecha.border=true
    sheet.write(1,8,["#{I18n.t('Sistema.Body.Vistas.Form.fecha')}:              #{fecha_apertura}"],format_fecha)

    if tipo_comite=='e'
      format_edo_ofc=Format.new(:bold=>true,:align=>"merge",:border_color=>"black",'left' => 10,:pattern => 10,:color=>'white')
      format_edo_ofc.border=true
      sheet.write(2,0,["#{I18n.t('Sistema.Body.Vistas.General.estado')}:   #{estado}","","",""],format_edo_ofc)
      sheet.write(2,4,["#{I18n.t('Sistema.Body.Vistas.General.oficina')}:   #{nombre_oficina}","","","",""],format_edo_ofc)
    end

    format_resultado = Format.new(:border=>true,:align=>"merge",:bold=>true,:color=>:gray,:size=>11,:pattern_fg_color => :silver,:pattern => 4)
    sheet.row(3).height=20
    sheet.row(4).height=20
    sheet.write(3,0,[(I18n.t('Sistema.Body.Vistas.General.resultado')<<" " <<I18n.t('Sistema.Body.Vistas.General.de') << " " << I18n.t('Sistema.Body.Vistas.General.comite')).upcase,"","","","","","","",""],format_resultado)

    format_titulo=Format.new(:bold=>true,:align=>:center)
    sheet.write(4, 0, I18n.t('Sistema.Body.Vistas.General.nombres') << " " << I18n.t('Sistema.Body.Vistas.General.y') << " " << I18n.t('Sistema.Body.Vistas.General.apellidos'),format_titulo)
    sheet.write(4, 1, I18n.t('Sistema.Body.Vistas.General.cedula') << " / " << I18n.t('Sistema.Body.Vistas.General.rif'),format_titulo)
    sheet.write(4, 2, I18n.t('Sistema.Body.Vistas.Form.nro_tramite'),format_titulo)
    sheet.write(4, 3, I18n.t('Sistema.Body.Vistas.General.rubro'),format_titulo)
    sheet.write(4, 8, I18n.t('Sistema.Body.Modelos.ImputacionesMaquinaria.Columnas.observacion'),format_titulo)
    sheet.write(4, 5, [I18n.t('Sistema.Body.Vistas.General.decision'),"",""],Format.new(:align=>:merge,:bold=>true))
    sheet.write(5, 5, I18n.t('Sistema.Body.Vistas.General.aprobado'),format_titulo)
    sheet.write(5, 6, I18n.t('Sistema.Body.General.rechazado'),format_titulo)
    sheet.write(5, 7, I18n.t('Sistema.Body.General.diferido'),format_titulo)
    sheet.write(4, 4, I18n.t('Sistema.Body.Vistas.General.monto'),format_titulo)
    sheet.write(5, 4, I18n.t('Sistema.Body.Vistas.General.solicitado'),format_titulo)
    sheet.column(0).width = 30
    sheet.column(1).width = 20
    sheet.column(2).width = 12
    sheet.column(3).width = 25
    sheet.column(4).width = 15
    sheet.column(5).width = 15
    sheet.column(6).width = 15
    sheet.column(7).width = 15
    sheet.column(8).width = 30

    sheet.row(3).height=15
    sheet.row(4).height=15

    format_monto   =Format.new(:number_format => '0.0',:align=>:right)
    format_decision=Format.new(:align=>:center)
    format_cedula  =Format.new(:align=>:right)

    row=6

    for linea in solicitudes
      nombre=linea.cliente.class.to_s=='ClienteEmpresa' ? linea.cliente.empresa.nombre : linea.cliente.persona.nombre_corto
      cedula=linea.cliente.class.to_s=='ClienteEmpresa' ? linea.cliente.empresa.rif : linea.cliente.persona.cedula
      sheet.write(row,0,nombre)
      sheet.write(row,1,cedula,format_cedula)
      sheet.write(row,2,linea.numero)
      sheet.write(row,3,linea.rubro.nombre)
      sheet.write(row,4,linea.monto_solicitado,format_monto)
      if tipo_comite=='e'
        sheet.write(row,5,linea.decision_comite_estadal=='A' ? '√' : '',format_decision)
        sheet.write(row,6,linea.decision_comite_estadal=='R' ? '√' : '',format_decision)
        sheet.write(row,7,linea.decision_comite_estadal=='D' ? '√' : '',format_decision)
        sheet.write(row,8,linea.comentario_comite_estadal)
      else
        sheet.write(row,5,linea.decision_comite_nacional=='A' ? '√' : '',format_decision)
        sheet.write(row,6,linea.decision_comite_nacional=='R' ? '√' : '',format_decision)
        sheet.write(row,7,linea.decision_comite_nacional=='D' ? '√' : '',format_decision)
        sheet.write(row,8,linea.comentario_comite_nacional)
      end
      row += 1
    end
 
    row += 2
    sheet.row(row).height=20
    sheet.write(row,0,[(I18n.t('Sistema.Body.Vistas.General.panel')<<" " <<I18n.t('Sistema.Body.Vistas.General.de')<<" "<< I18n.t('Sistema.Body.Vistas.ParametroGeneral.Separadores.firmas')).upcase,"","","","","","","",""],format_resultado)
    row += 1

    format_panel=Format.new(:align=>"merge")
    format_panel.border=true

    sheet.write(row,0,["  ",""],format_panel)
    sheet.write(row,2,["  ","",""],format_panel)
    sheet.write(row,4,["  ","",""],format_panel)
    sheet.write(row,7,["  ",""],format_panel)
    sheet.row(row).height=40
    workbook.write "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"
    send_file "#{Rails.root}/public/documentos/xls/#{nombre_archivo}.xls"
  end

  ################################################
  # Genera el punto de cuenta de la sesion (PDF)
  ################################################
  def generar_resumen_sesion
    #add_variables_to_assigns
    @comite=Comite.find(:first)    
    htmldoc_env = "HTMLDOC_NOCGI=TRUE;export HTMLDOC_NOCGI"     
    generator = IO.popen("#{htmldoc_env};htmldoc -t pdf --path  \".;#{request.protocol}#{request.env["HTTP_HOST"]}\" --fontsize 12 --webpage -", "w+")
    #logger.debug "Lo que hace " << "#{Rails.root}/app/views/solicitudes/comite_resumen/generar_punto_cuenta.html.erb -" << generator.inspect.to_s
    #generator.puts render_to_string(:template => 'solicitudes/comite_resumen/generar_punto_cuenta.html.erb')
    
    #@left_sidebar= render_to_string(:template => 'solicitudes/comite_resumen/generar_punto_cuenta.html.erb', :layout => false)

    @left_sidebar= render_to_string('solicitudes/comite_resumen/generar_punto_cuenta.html.erb', :layout => false,:format => "html.erb")
    
    logger.debug "Esto da " << @left_sidebar.inspect.to_s
    @left_sidebar=@left_sidebar.gsub("\"","'")
    @left_sidebar=@left_sidebar.gsub("\n","")
    logger.debug "Esto da despues " << @left_sidebar.inspect.to_s
    #{}"#{Rails.root}"/app/assets/images/logo_fondas_2.png
    #generator.puts "<table width='100%'>  <tr>    <td><img src='/assets/logo_fondas_2.png'/></td>    <td>      <table>         <tr  align='center'>          <td><font size='2px'><b>TRANSLATION MISSING: EN.SISTEMA.BODY.VISTAS.GENERAL.ACTA OF APPROVAL OF</b></font></td>        </tr>        <tr align='center'>          <td><font size='2px'><b>COMMITTEE ESTADAL OF FUNDING</b></font></td>        </tr>      </table>    </td>  </tr></table><br/><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>      <td width='85%'></td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>DAY</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>MONTH</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>YEAR</font>      </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='85%'>      <font align='center' size='1px'><b>&nbsp;&nbsp;&nbsp;No. of Session:</b></font>&nbsp;&nbsp;&nbsp;      <font align='center' size='2px'><b><i>4-2009</i></b></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>9</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2012</i></font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td width='30%' align='left'>      <font  size='1px'>        &nbsp;&nbsp;&nbsp;<b>State:</b>&nbsp;      </font>      <font size='1px'>        Distrito Capital      </font>    </td>    <td width='30%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Office:</b></font>      <font size='1px'>        Fondas Principal      </font>    </td>    <td width='40%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Coordinator of Office:</b></font>      <font size='1px'>        Jose Osorio      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.asunto:</b></font><br/>      <font size='1.5px'>        ok<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.resumen Executive:</b></font><br/>      <font size='1.5px'>        ok        <br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.recomendaciones:</b></font><br/>      <font size='1.5px'>        ok<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.anexos:</b></font><br/>      <font size='1.5px'>        ok<br/><br/>      </font>    </td>  </tr></table><!-- NEED 10 --><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='50%' colspan='3' valign='top' bgcolor='#dcdcdc'><font size='0.5px'>&nbsp;&nbsp;&nbsp;<b>VB translation missing: en.Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica</b></font></td>    <td width='50%' colspan='3' align='center' bgcolor='#dcdcdc'><font size='0.5px'><b>Is submitted to <br/>National Finance Committee</b></font></td>  </tr>  <tr>    <td colspan='3' height='100px' valign='top'><font size='0.2px'>&nbsp;&nbsp;&nbsp;<b>Firm and Stamp</b></font></td>  </tr>  <tr>    <td width='50%' colspan='3' valign='top' align='center'><font size='0.5px'><b>Integral Finance Manager</b></font></td>    <td width='50%' colspan='3' align='center' align='center'><font size='0.5px'><b>President</b></font></td>  </tr></table><table border='0' align='right' width='100%'>  <tr>    <td width='40%'>&nbsp;</td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>translation missing: en.Sistema.Body.Controladores.Usuario.FormTitles.form_title_record:</b></font>      <font size='1.5px'>Administradordel Sistema</font>    </td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>translation missing: en.Sistema.Body.Vistas.Usuario.Imprimir.fecha_impresion:</b></font>      <font size='1.5px'>02/22/2013:16hr  </font>    </td>  </tr></table>" #@left_sidebar.to_s
    #generator.puts "<link href='/assets/menu.css?body=1' media='all' rel='stylesheet' type='text/css' /><link href='/assets/main.css?body=1' media='all' rel='stylesheet' type='text/css' /><link href='/assets/calendar_date_select.css?body=1' media='all' rel='stylesheet' type='text/css' /><table width='100%'>  <tr>    <td>Imagen aqui</td>    <td>      <table>         <tr  align='center'>          <td><font size='2px'><b>TRANSLATION MISSING: EN.SISTEMA.BODY.VISTAS.GENERAL.ACTA OF APPROVAL OF</b></font></td>        </tr>        <tr align='center'>          <td><font size='2px'><b>COMMITTEE ESTADAL OF FUNDING</b></font></td>        </tr>      </table>    </td>  </tr></table><br/><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>      <td width='85%'></td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>DAY</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>MONTH</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>YEAR</font>      </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='85%'>      <font align='center' size='1px'><b>&nbsp;&nbsp;&nbsp;No. of Session:</b></font>&nbsp;&nbsp;&nbsp;      <font align='center' size='2px'><b><i>5-2009</i></b></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>15</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2012</i></font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td width='30%' align='left'>      <font  size='1px'>        &nbsp;&nbsp;&nbsp;<b>State:</b>&nbsp;      </font>      <font size='1px'>        Distrito Capital      </font>    </td>    <td width='30%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Office:</b></font>      <font size='1px'>        Fondas Principal      </font>    </td>    <td width='40%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Coordinator of Office:</b></font>      <font size='1px'>        Jose Osorio      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.asunto:</b></font><br/>      <font size='1.5px'>        mazucar@fondas.gob.ve<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.resumen Executive:</b></font><br/>      <font size='1.5px'>        mazucar@fondas.gob.ve        <br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.recomendaciones:</b></font><br/>      <font size='1.5px'>        mazucar@fondas.gob.ve<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>translation missing: en.Sistema.Body.Vistas.General.anexos:</b></font><br/>      <font size='1.5px'>        mazucar@fondas.gob.ve<br/><br/>      </font>    </td>  </tr></table><!-- NEED 10 --><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='50%' colspan='3' valign='top' bgcolor='#dcdcdc'><font size='0.5px'>&nbsp;&nbsp;&nbsp;<b>VB translation missing: en.Sistema.Body.Modelos.Prestamo.Estatus.consultoria_juridica</b></font></td>    <td width='50%' colspan='3' align='center' bgcolor='#dcdcdc'><font size='0.5px'><b>Is submitted to <br/>National Finance Committee</b></font></td>  </tr>  <tr>    <td colspan='3' height='100px' valign='top'><font size='0.2px'>&nbsp;&nbsp;&nbsp;<b>Firm and Stamp</b></font></td>  </tr>  <tr>    <td width='50%' colspan='3' valign='top' align='center'><font size='0.5px'><b>Integral Finance Manager</b></font></td>    <td width='50%' colspan='3' align='center' align='center'><font size='0.5px'><b>President</b></font></td>  </tr></table><table border='0' align='right' width='100%'>  <tr>    <td width='40%'>&nbsp;</td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>translation missing: en.Sistema.Body.Controladores.Usuario.FormTitles.form_title_record:</b></font>      <font size='1.5px'>Administradordel Sistema</font>    </td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>translation missing: en.Sistema.Body.Vistas.Usuario.Imprimir.fecha_impresion:</b></font>      <font size='1.5px'>02/22/2013:17hr  </font>    </td>  </tr></table>"
    generator.puts @left_sidebar.to_s
    #generator.puts "<link href='/assets/menu.css?body=1' media='all' rel='stylesheet' type='text/css' /><link href='/assets/main.css?body=1' media='all' rel='stylesheet' type='text/css' /><link href='/assets/calendar_date_select.css?body=1' media='all' rel='stylesheet' type='text/css' /><table width='100%'>  <tr>    <td><img src='/assets/icono_pdf.gif'/></td>    <td>      <table>         <tr  align='center'>          <td><font size='2px'><b>ACTA DE APROBACIóN DEL</b></font></td>        </tr>        <tr align='center'>          <td><font size='2px'><b>COMITé ESTADAL DE FINANCIAMIENTO</b></font></td>        </tr>      </table>    </td>  </tr></table><br/><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>      <td width='85%'></td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>DIA</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>MES</font>      </td>      <td width='5%' bgcolor='#dcdcdc' align='center'>        <font size='0.1px'>AñO</font>      </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='85%'>      <font align='center' size='1px'><b>&nbsp;&nbsp;&nbsp;Nro. de Sesión:</b></font>&nbsp;&nbsp;&nbsp;      <font align='center' size='2px'><b><i>305-2009</i></b></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>10</i></font>    </td>    <td width='5%' align='center'>      <font align='center' size='0.3px'><i>2013</i></font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td width='30%' align='left'>      <font  size='1px'>        &nbsp;&nbsp;&nbsp;<b>Estado:</b>&nbsp;      </font>      <font size='1px'>        Sucre      </font>    </td>    <td width='30%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Oficina:</b></font>      <font size='1px'>        Oficina Sucre      </font>    </td>    <td width='40%' align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Coordinador de Oficina:</b></font>      <font size='1px'>        Celia Marin      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Asunto:</b></font><br/>      <font size='1.5px'>        dfg<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Resumen Ejecutivo:</b></font><br/>      <font size='1.5px'>        d        <br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Recomendaciones:</b></font><br/>      <font size='1.5px'>        dfg<br/><br/>      </font>    </td>  </tr></table><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr height='20px'>    <td align='left'>      <font size='1px'>&nbsp;&nbsp;&nbsp;<b>Anexos:</b></font><br/>      <font size='1.5px'>        <br/><br/>      </font>    </td>  </tr></table><!-- NEED 10 --><table border='1' bordercolor='#CCCCCC'  cellspacing='' cellpadding='0' align='right' width='100%'>  <tr>    <td width='50%' colspan='3' valign='top' bgcolor='#dcdcdc'><font size='0.5px'>&nbsp;&nbsp;&nbsp;<b>VB Consultoría Jurídica</b></font></td>    <td width='50%' colspan='3' align='center' bgcolor='#dcdcdc'><font size='0.5px'><b>Se somete a consideración del <br/>Comité Nacional de Financiamiento</b></font></td>  </tr>  <tr>    <td colspan='3' height='100px' valign='top'><font size='0.2px'>&nbsp;&nbsp;&nbsp;<b>Firma y Sello</b></font></td>  </tr>  <tr><td width='50%' colspan='3' valign='top' align='center'><font size='0.5px'><b>Gerente de Financiamiento Integral</b></font></td>    <td width='50%' colspan='3' align='center' align='center'><font size='0.5px'><b>Presidente(a)</b></font></td>  </tr></table><table border='0' align='right' width='100%'>  <tr>    <td width='40%'>&nbsp;</td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>Usuario:</b></font>      <font size='1.5px'>YUSBELISOLIVERO</font>    </td>    <td width='30%' align='right' valign='buttom'>      <font size='1.5px'><b>Fecha de Impresión :</b></font>      <font size='1.5px'>14/10/2013:10hr  </font>    </td>  </tr></table>"
    #render_to_string(:template => 'solicitudes/comite_resumen/generar_punto_cuenta.html.erb')
    #"#{Rails.root}/app/views/solicitudes/comite_resumen/generar_punto_cuenta.html.erb" 
    #"solicitudes/comite_resumen/generar_punto_cuenta.html"
    generator.close_write    
    send_data(generator.read, :filename => "ResumenInstanciaAprobacion.pdf", :type =>  "application/pdf")    


  end

  ##########################################################
  # Genera el detalle de Financiamiento de una sesion (PDF)
  ##########################################################
  def generar_detalle_financiamiento
    #add_variables_to_assigns
    htmldoc_env = "HTMLDOC_NOCGI=TRUE;export HTMLDOC_NOCGI"
    generator = IO.popen("#{htmldoc_env};htmldoc -t pdf --path  \".;#{request.protocol}#{request.env["HTTP_HOST"]}\" --fontsize 12 --left 30   --footer / --right 30 --size '216x315mm'  --webpage -", "w+")
    @left_sidebar= render_to_string('solicitudes/comite_resumen/generar_detalle_financiamiento.html.erb', :layout => false,:format => :html)
    generator.puts @left_sidebar.to_s
    generator.close_write
    send_data(generator.read, :filename => "DetalleFinanciamiento.pdf", :type =>  "application/pdf")
  end

  def numero_sesion_search
    tipo_comite=params[:tipo_comite]
    filtro= tipo_comite=='e' ?  " and cdh.oficina_id=#{session[:oficina].to_s} " : " "
	  filtro_total = tipo_comite=='e' ?  " and cdht.oficina_id=#{session[:oficina].to_s} " : " "
    sql="select distinct comite.id, comite.numero
        from comite_decision_historico cdh
        inner join comite on comite.id=cdh.comite_id
        where tipo_comite='#{tipo_comite}'
        and comite.vigente=false
        and cdh.decision is not null
        #{filtro}
        union
        select distinct comite.id, comite.numero
        from comite_decision_historico_total cdht
        inner join comite on comite.id=cdht.comite_id
        where tipo_comite='#{tipo_comite}'
        and comite.vigente=false
        and cdht.decision is not null
        #{filtro_total}
        order by id desc "
    @numero_sesion=Comite.find_by_sql(sql)
    render :update do |page|
      page.hide 'subsector-search'
      page.hide 'tr_rubro_search'
      if @numero_sesion.nil? or @numero_sesion.empty?
        page.hide 'numero-sesion'
      else
        page.show 'numero-sesion'
        page.show 'tr_numero_sesion'
      end
      page.replace_html 'numero-sesion', :partial=> 'numero_sesion_search'
      page.hide 'imagen_cargando'
    end
  end

  def subsector_search
    if !params[:id].nil? && !params[:id].empty?
      @subsector = SubSector.find(:all, :conditions=>["activo=true and sector_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre")
      @rubro = []
      render :update do |page|
        page.show 'subsector-search'
        page.show 'label-subsector-search'
        page.hide 'rubro-search'
        page.hide 'label-rubro-search'
        page.replace_html 'subsector-search', :partial => 'subsector_search'
        if @subsector.nil?
          page.hide 'label-subsector-search'
          page.hide 'subsector-search'
        else
          page.show 'label-subsector-search'
          page.show 'subsector-search'
        end
        page.hide 'imagen_cargando_subsector'
      end
    else
      render :update do |page|
        page.hide 'subsector-search'
        page.hide 'label-subsector-search'
        page.hide 'rubro-search'
        page.hide 'label-rubro-search'
        page.hide 'imagen_cargando_subsector'
      end
    end
  end

  def rubro_search
     if !params[:id].nil? && !params[:id].empty?
        @rubro = Rubro.find(:all, :conditions=>["activo=true and sub_sector_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
        render :update do |page|
          if @rubro.nil?
          else
            page.replace_html 'rubro-search', :partial => 'rubro_search'
            page.show 'rubro-search'
            page.show 'label-rubro-search'
          end
          page.hide 'imagen_cargando_rubro'
        end
     else
       render :update do |page|
          page.hide 'rubro-search'
          page.hide 'label-rubro-search'
          page.hide 'imagen_cargando_rubro'
       end
     end
  end

  
  def reseteo_combos
    tipo_comite=params[:tipo_comite]    
    @sector=Sector.find(:all,:conditions=>"activo=true",:order=>"nombre")
    if tipo_comite!='e'
    @estado=Estado.find(:all,:order=>"nombre")
    end
    render :update do |page|
      page.hide 'tr_subsector_search'
      page.hide 'subsector-search'
      page.hide 'tr_rubro_search'
      page.show 'numero-sesion'
      page.show 'tr_numero_sesion'            
      page.hide 'imagen_cargando'
      page.replace_html 'label-sector-search', :partial => 'sector_search'
      page.replace_html 'label-estado-search', :partial => 'estado_search' if tipo_comite!='e'
      page.show 'label-sector-search'            
    end

    
  end

  def decision_comite_nacional
    render :update do |page|
      page.replace_html 'decision-comite-nacional', :partial => 'decision_comite_nacional'
    end
  end

  def resumen_comite_solicitud
    @solicitud = Solicitud.find(params[:solicitud_id])
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Vistas.ComiteNacional.Mensajes.generico_mensaje')#'Directorio de Comité Estadal/Nacional de Financiamiento'
    @form_title_record   = "#{I18n.t('Sistema.Body.Vistas.General.resumen')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.instancias')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.aprobacion')}"#'Resumen de Instancias de Aprobación'
    @form_identity_field = 'numero'
    @width_layout        = '1150'
  end

  def fill_filtros
    @sector       = Sector.find(:all, :conditions=>"activo=true",:order=>'nombre')
    @estado       = Estado.find(:all, :order=>'nombre')
    @numero_sesion= Comite.find(:all,:select=>"id,numero")
    @subsector    = []
    @rubro        = []
  end

end
