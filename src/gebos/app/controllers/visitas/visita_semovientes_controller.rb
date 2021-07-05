# encoding: utf-8
class Visitas::VisitaSemovientesController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :total_inventario_onchange, :total_vacas_onchange ]
  
  def index
  end
	
  def edit
    @visitas = SeguimientoVisita.find(params[:id])
    @semovientes = Semovientes.find_by_seguimiento_visita_id(params[:id])
    if @semovientes.nil?
      @semovientes = Semovientes.new(:seguimiento_visita_id =>params[:id])
    end
    @total_vacas = @semovientes.cantidad_vaca_seca.to_i + @semovientes.cantidad_vaca_ordenio.to_i
    total_vacas_ordenio = (@semovientes.cantidad_vaca_ordenio.to_f/(@semovientes.cantidad_vaca_seca.to_f + @semovientes.cantidad_vaca_ordenio.to_f)*100)
    unless total_vacas_ordenio.nan?
      @total_vacas_ordenio = format_f(total_vacas_ordenio)
    else
      @total_vacas_ordenio = "0,00"
    end
    @total_hembras = (@semovientes.cantidad_vaca_ordenio.to_i + @semovientes.cantidad_vaca_seca.to_i + @semovientes.cantidad_novilla.to_i + @semovientes.cantidad_mauta.to_i + @semovientes.cantidad_becerra.to_i)
    @total_machos = (@semovientes.cantidad_toro.to_i + @semovientes.cantidad_retajo.to_i + @semovientes.cantidad_novillo.to_i + @semovientes.cantidad_maute.to_i + @semovientes.cantidad_becerro.to_i)
    @total_inventario = (@total_hembras.to_i + @total_machos.to_i)

  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end

  def save_edit
    @semovientes = Semovientes.find_by_seguimiento_visita_id(params[:id])
    if @semovientes.nil?
      @semovientes = Semovientes.new(:seguimiento_visita_id =>params[:id])
    end    
    inventario = params[:semovientes]
    success = true
    success &&= @semovientes.validar_inventario(inventario)
    if success
      @semovientes.update_attributes(params[:semovientes])

      if @semovientes.save
        flash[:notice] = I18n.t('Sistema.Body.Controladores.VisitaSemovientes.Messages.semovientes')
        render :update do |page|
          page.redirect_to :action=>'edit', :id=>@semovientes.seguimiento_visita_id, :popup=>params[:popup]
        end
      else
        render :update do |page|
          page.form_error
        end
        return false
      end
    else
      render :update do |page|
        page.form_error
      end
      return false
    end

  end

  def total_vacas_onchange
    cantidad_vaca_seca = (params[:cantidad_vaca_seca])
    cantidad_vaca_ordenio = (params[:cantidad_vaca_ordenio])

    @total_vacas = cantidad_vaca_seca.to_i + cantidad_vaca_ordenio.to_i
    total_vacas_ordenio = (cantidad_vaca_ordenio.to_f/(cantidad_vaca_seca.to_f + cantidad_vaca_ordenio.to_f)*100)
    unless total_vacas_ordenio.nan?
      @total_vacas_ordenio = format_f(total_vacas_ordenio)
    else
      @total_vacas_ordenio = "0,00"
    end
    render :update do |page|
      page.replace_html 'total_vacas_label', "<label><b>#{@total_vacas}</b></label>"
      page.replace_html 'total_vacas_ordenio_label', "<label><b>  #{@total_vacas_ordenio} (%)</b></label>"
    end
    
  end

  def total_inventario_onchange
 
    cantidad_becerra = params[:cantidad_becerra].to_i
    cantidad_becerro = params[:cantidad_becerro].to_i
    cantidad_mauta = params[:cantidad_mauta].to_i
    cantidad_maute = params[:cantidad_maute].to_i
    cantidad_novilla = params[:cantidad_novilla].to_i
    cantidad_novillo = params[:cantidad_novillo].to_i
    cantidad_retajo = params[:cantidad_retajo].to_i
    cantidad_toro = params[:cantidad_toro].to_i
    cantidad_vaca_seca = params[:cantidad_vaca_seca].to_i
    cantidad_vaca_ordenio = params[:cantidad_vaca_ordenio].to_i

    @total_hembras = (cantidad_vaca_ordenio.to_i + cantidad_vaca_seca.to_i + cantidad_novilla.to_i + cantidad_mauta.to_i + cantidad_becerra.to_i)
    @total_machos = (cantidad_toro.to_i + cantidad_retajo.to_i + cantidad_novillo.to_i + cantidad_maute.to_i + cantidad_becerro.to_i)
    @total_inventario = (@total_hembras.to_i + @total_machos.to_i)

    render :update do |page|
      page.replace_html 'total_inventario_label', "<label><b>#{@total_inventario}</b></label>"
      page.replace_html 'total_hembras_label', "<label><b>  #{@total_hembras}</b></label>"
      page.replace_html 'total_machos_label', "<label><b>  #{@total_machos}</b></label>"
    end

  end


  protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSemovientes.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaSemovientes.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaSemovientes.FormTitles.form_title_records')
    @form_entity = 'semovientes'
    @form_identity_field = 'id'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  def fill
    @motivo_visita_list = MotivoVisita.find(:all, :conditions=>'id > 1', :order=>'id')
  end
  def fill_tipo_vacunas
    @tipo_vacunas_select = Vacuna.find(:all, :order=>'descripcion')
  end
end