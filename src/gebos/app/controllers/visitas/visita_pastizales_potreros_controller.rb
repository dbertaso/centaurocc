# encoding: utf-8
class Visitas::VisitaPastizalesPotrerosController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :view, :cancel_view, :potreros_onchange, :sistema_riego_onchange ]
  
	def index
		@visitas = SeguimientoVisita.find(params[:id])
    list
	end
	
  def list
    @visita = params[:id]
    @pastizales_potreros = PastizalesPotreros.find_by_seguimiento_visita_id(params[:id])    
    params['sort'] = "nro_lote" unless params['sort']
    
    conditions = "seguimiento_visita_id = #{params[:id]}"
    @list = PastizalesPotreros.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @visita = params[:id]
    fill
    if @tipo_pasto_forraje_list.empty?
      tipo_pasto=0
    else
      tipo_pasto = @tipo_pasto_forraje_list[0].id
    end
    especie_variedad_pasto_fill(tipo_pasto)
    @pastizales_potreros = PastizalesPotreros.new(:seguimiento_visita_id => @visita)
		form_new @pastizales_potreros
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
      @visita = params[:id]
      # generando el nro de lote
      ultimo_lote =  PastizalesPotreros.find_by_sql("select nro_lote from pastizales_potreros where seguimiento_visita_id = #{@visita} order by id desc")
      unless ultimo_lote.empty?
        ultimo_lote = ultimo_lote[0].nro_lote
      else
        ultimo_lote = 0
      end
      nro_lote = ultimo_lote.to_i + 1
      # Fin generación del nro de lote
      valor1 = (params[:pastizales_potreros][:nro_potrero_cerca_electrica].to_i)
      valor2 = (params[:pastizales_potreros][:nro_potrero_cerca_tradicional].to_i)

      @pastizales_potreros = PastizalesPotreros.new(params[:pastizales_potreros])
      @pastizales_potreros.cantidad_potreros = valor1.to_i + valor2.to_i
      @pastizales_potreros.seguimiento_visita_id = @visita
      @pastizales_potreros.nro_lote = nro_lote

      fertilizacion = (params[:pastizales_potreros][:fertilizacion].to_s)
      tipo = (params[:pastizales_potreros][:tipo_fertilizacion_id].to_i)
      descripcion = (params[:pastizales_potreros][:descripcion_fertilizacion].to_s)

      logger.debug "*********"
      logger.debug fertilizacion.to_s
      logger.debug tipo.to_s
      logger.debug descripcion.to_s

      success = true
      success &&= @pastizales_potreros.validar_sist_riego(params,@visita, nro_lote)
      if success
        success &&= @pastizales_potreros.validar_fertilizacion(fertilizacion, tipo, descripcion)
        if success
          form_save_ajaxnew @pastizales_potreros
        else
          render :update do |page|
            page.hide "message"
            page.form_error('form_new')
          end
          return false
        end
      else
        render :update do |page|
          page.hide "message"
          page.form_error('form_new')
        end
        return false
      end
  end
  
  def delete
    logger.debug "DELETE*****"
    @pastizales_potreros = PastizalesPotreros.find(params[:id])
    logger.debug @pastizales_potreros.inspect
    @visitas = SeguimientoVisita.find(@pastizales_potreros.seguimiento_visita_id)
    logger.debug @visitas.inspect
		form_ajaxdelete @pastizales_potreros
  end
  
  def edit
   @pastizales_potreros = PastizalesPotreros.find(params[:id])
    fill
    tipo_pasto = @pastizales_potreros.tipo_pasto_forraje_id
    especie_variedad_pasto_fill(tipo_pasto)
		form_edit @pastizales_potreros
  end

  def save_edit
       @pastizales_potreros = PastizalesPotreros.find(params[:id])
       @visita = SeguimientoVisita.find(@pastizales_potreros.seguimiento_visita_id)
       valor1 = (params[:pastizales_potreros][:nro_potrero_cerca_electrica].to_i)
       valor2 = (params[:pastizales_potreros][:nro_potrero_cerca_tradicional].to_i)

       @pastizales_potreros.cantidad_potreros = valor1.to_i + valor2.to_i

        fertilizacion = (params[:pastizales_potreros][:fertilizacion].to_s)
        tipo = (params[:pastizales_potreros][:tipo_fertilizacion_id].to_i)
        descripcion = (params[:pastizales_potreros][:descripcion_fertilizacion].to_s)

        logger.debug "*********"
        logger.debug fertilizacion.to_s
        logger.debug tipo.to_s
        logger.debug descripcion.to_s

        success = true
        success &&= @pastizales_potreros.validar_sist_riego(params,@visita.id,@pastizales_potreros.nro_lote)
        if success
          success &&= @pastizales_potreros.validar_fertilizacion(fertilizacion, tipo, descripcion)
          if success
            form_save_edit @pastizales_potreros
          else
            render :update do |page|
              page.hide "message"
              page.form_error("row_#{@pastizales_potreros.id}")
            end
            return false
          end
        else
          render :update do |page|
            page.hide "message"
            page.form_error("row_#{@pastizales_potreros.id}")
          end
          return false
        end
  end
  
  def cancel_edit
    @pastizales_potreros = PastizalesPotreros.find(params[:id])
		form_cancel_edit @pastizales_potreros
  end

  def potreros_onchange
    cerca_electrica = (params[:nro_potrero_cerca_electrica])
    cerca_tradicional = (params[:nro_potrero_cerca_tradicional])

    cantidad_potreros = cerca_electrica.to_i + cerca_tradicional.to_i
    render :update do |page|
      page.replace_html 'cantidad_potreros_label', "<label><b>#{cantidad_potreros}</b></label>"
    end
  end

  def sistema_riego_onchange
    cerca_electrica = (params[:nro_potrero_cerca_electrica_sist_riego])
    cerca_tradicional = (params[:nro_potrero_cerca_tradicional_sist_riego])

    cantidad_potreros_sist_riego = cerca_electrica.to_i + cerca_tradicional.to_i
    render :update do |page|
      page.replace_html 'cantidad_potreros_sist_riego_label', "<label><b>#{cantidad_potreros_sist_riego}</b></label>"
    end
  end


  def view
   @pastizales_potreros = PastizalesPotreros.find(params[:id])
	 form_view @pastizales_potreros

  end

  def cancel_view
    @pastizales_potreros = PastizalesPotreros.find(params[:id])
		form_cancel_view @pastizales_potreros
  end

  def tipo_pasto_change
    tipo_pasto = params[:tipo_pasto_forraje_id]
    logger.debug "TIPO PASTO =======>"<< tipo_pasto.to_s
    especie_variedad_pasto_fill(tipo_pasto)

    render :update do |page|
      page.replace_html 'especie_pasto-select', :partial => 'especie_pasto_select'
    end
  end

  protected
  def common
    super
    accion = params[:action]
    if accion =="new" ||accion =="save_new" || accion =="cancel_new" || accion =="index" || accion =="potreros_onchange" || accion =="sistema_riego_onchange" || accion == "tipo_pasto_change"
       @visitas = SeguimientoVisita.find(params[:id])
    else
      @pastizales_potreros = PastizalesPotreros.find(params[:id])
      @visitas = SeguimientoVisita.find(@pastizales_potreros.seguimiento_visita_id)
    end
    @form_title = I18n.t('Sistema.Body.Controladores.PastizalesPotreros.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.PastizalesPotreros.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.PastizalesPotreros.FormTitles.form_title_records')
    @form_entity = 'pastizales_potreros'
    @form_identity_field = 'nro_lote'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
  end

  def fill
    @tipo_pasto_forraje_list = TipoPastoForraje.find(:all, :order=>'id')
  end

  def especie_variedad_pasto_fill(tipo_pasto)
    @especie_variedad_pasto_list = EspecieVariedadPasto.find(:all, :order=>'id',:conditions=>['tipo_pasto_forraje_id=?',tipo_pasto])
  end
end
