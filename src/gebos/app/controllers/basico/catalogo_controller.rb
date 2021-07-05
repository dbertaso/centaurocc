# encoding: UTF-8
#
# autor: Luis Rojas
# clase: Basico::CatalogoController
# descripción: Migración a Rails 3
#
class Basico::CatalogoController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:contrato_change, :clase_search, :new, :almacen_search, :clase_form]

  layout 'form_basic'

  def index
    @tipo_maquinaria            = TipoMaquinaria.find(:all)
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
    @clase                      = []
    @marca = MarcaMaquinaria.find(:all, :conditions=>"activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    @meneda_activa = ParametroGeneral.first.moneda_id
    @dolar = Convertidor.first(:conditions => "moneda_destino_id = #{@meneda_activa}").valor
    @valor = "index"
    #list
  end

  def clase_search
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
    else
      @clase = []
    end
    render :update do |page|
      page.replace_html 'clase-search', :partial => 'clase_search'
      page.show 'clase-search'
    end
  end
  
  def clase_form
    if !params[:id].nil? && !params[:id].empty?
      @clase = Clase.find(:all, :conditions=>["tipo_maquinaria_id = ?", params[:id].to_s],:order=>"nombre",:select=>"id,nombre,activo")
    else
      @clase = []
    end
    render :update do |page|
      page.replace_html 'clase-form', :partial => 'clase_form'
      page.show 'clase-form'
    end
  end
  
  def almacen_search
    if !params[:id].nil? && !params[:id].empty?
      @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(:all, :conditions=>["activo = true and almacen_maquinaria_id = ?", params[:id].to_s],:order=>"nombre")
      render :update do |page|
        page.replace_html 'almacen-search', :partial => 'almacen_search'
        page.show 'almacen-search'
      end
    else
      render :update do |page|
        @almacen_maquinaria_sucursal = []
        page.replace_html 'almacen-search', :partial => 'almacen_search'
        page.show 'almacen-search'
      end
    end
  end
	
  def contrato_search
    unless params[:id].nil? || params[:id].empty?
      @almacen_maquinaria = AlmacenMaquinaria.find(:all, :conditions=>["contrato_maquinaria_equipo_id = ?", params[:id]], :order => "nombre")
      render :update do |page|
        page.replace_html 'contrato-search', :partial => 'contrato_search'
        page.show 'contrato-search'
      end
    else
      render :update do |page|
        @clase = []
        page.replace_html 'clase-search', :partial => 'clase_search'
        page.show 'clase-search'
      end
    end
  end
  
  def list
    
    @condition = "catalogo.estatus <> 'E' "
    params['sort'] = "contrato_maquinaria_equipo.nombre" unless params['sort']
    if @valor.nil?
      unless params.nil?
        unless params[:contrato_maquinaria_equipo_id][0].blank?
          contrato = ContratoMaquinariaEquipo.find(params[:contrato_maquinaria_equipo_id][0])
          @condition = "#{@condition} and catalogo.contrato_maquinaria_equipo_id = #{contrato.id} "
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.convenio')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{contrato.nombre}'"
        end

        unless params[:tipo_maquinaria_id][0].blank?
          tipo_maquinaria = TipoMaquinaria.find(params[:tipo_maquinaria_id][0])
          @condition = "#{@condition} and catalogo.clase_id in (select id from clase where tipo_maquinaria_id = #{tipo_maquinaria.id}) "
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.rubro')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{tipo_maquinaria.descripcion}'"
        end

        unless params[:clase_id][0].blank?
          clase = Clase.find(params[:clase_id][0])
          @condition = "#{@condition} and catalogo.clase_id = #{clase.id} "
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.tipo')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{clase.nombre}'"
        end

        unless params[:marca_id][0].blank?
          marca = MarcaMaquinaria.find(params[:marca_id][0])
          @condition = "#{@condition} and marca_maquinaria_id = #{marca.id} "
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.marca')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{marca.nombre}'"
        end

        unless params[:modelo_id][0].blank?
          modelo = Modelo.find(params[:modelo_id][0])
          @condition = "#{@condition} and modelo_id = #{modelo.id} "
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.modelo')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{modelo.nombre}'"
        end

        unless params[:serial][0].blank?
          @condition = "#{@condition} and lower(catalogo.serial) like '%#{params[:serial][0].strip.downcase}%'"
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.motor')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:serial][0]}'"
        end

        unless params[:chasis][0].blank?
          @condition = "#{@condition} and lower(catalogo.chasis) like '%#{params[:chasis][0].strip.downcase}%'"
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.General.serial')} #{I18n.t('Sistema.Body.Vistas.General.chasis')} #{I18n.t('Sistema.Body.Vistas.General.contenga')} '#{params[:chasis][0]}'"
        end

        unless params[:estatus][0].blank?
          @condition = "#{@condition} and catalogo.estatus = '#{params[:estatus][0]}' "
          case params[:estatus][0]
          when 'L'
            estatus = I18n.t('Sistema.Body.Vistas.General.libre')
          when 'R'
            estatus = I18n.t('Sistema.Body.Vistas.General.reservado')
          when 'E'
            estatus = I18n.t('Sistema.Body.Vistas.General.entregado')
          end 
          @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Form.estatus')} #{I18n.t('Sistema.Body.General.es')} #{I18n.t('Sistema.Body.Vistas.General.igual')} '#{estatus}'"
        end
      end
    end

    @list = Catalogo.search(@condition, params[:page], params[:sort])
    @total=@list.count
      
    form_list
  end
  
  def new
    @tipo_maquinaria_list       = TipoMaquinaria.find(:all)
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)
    @clase                      = []
    @catalogo                   = Catalogo.new
    @almacen_maquinaria         = AlmacenMaquinaria.find(:all, :order => "nombre")
    @marca = MarcaMaquinaria.find(:all, :conditions => "activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @moneda = Moneda.find(:all, :conditions => "activo = true", :order => "nombre")
    @moneda_activa = ParametroGeneral.first.moneda_id
    @catalogo.seguro = 0.0
    @catalogo.flete = 0.0
    @catalogo.gastos_administrativos = 0.0
    @catalogo.impuesto = 0.0
    @catalogo.almacenamiento = 0.0
    @catalogo.monto = 0
    @catalogo.id = 0
    @almacen_maquinaria_sucursal = []
    @view_contrato = false
    render :update do |page|
      page.form_reset
      page.replace_html 'form_new', :partial => 'new'
      page.hide 'button_new'
      page.show 'form_new'
    end
  end
  
  def save_new
    @catalogo             = Catalogo.new(params[:catalogo])
    @catalogo.fecha_carga = Time.now
    @catalogo.usuario_ultima_actualizacion_id = @usuario.id
    if @catalogo.save
		  render :update do |page|
		    message = "#{I18n.t('Sistema.Body.Vistas.General.el').capitalize} #{I18n.t('Sistema.Body.Vistas.General.item')} #{I18n.t('Sistema.Body.Controladores.Mensaje.creacion')}"
  			page.hide 'error'
        page.hide 'form_new'
        page.insert_html :top, 'list_body' , :partial => 'row', :locals => { :even_odd => 0 }
        page.visual_effect :highlight, "row_#{@catalogo.id}", :duration => 0.6
        page.show 'button_new'
        page.replace_html 'message', message
        page.show 'message'
  		end
    else
      render :update do |page|
		    page.form_error 'form_new'
        page.<< "varEnviado = false;"
      end
    end        
  end
  
  def contrato_change
    @imputaciones = ImputacionesMaquinaria.find(:first, :order => 'id desc')
    unless params[:contrato_id].nil? || params[:contrato_id].empty?
      contrato_maquinaria = ContratoMaquinariaEquipo.find(params[:contrato_id])
#      @almacen_maquinaria = AlmacenMaquinaria.find(:all, :conditions=>["contrato_maquinaria_equipo_id = ?", contrato_maquinaria.id], :order => "nombre")
      @naturaleza = contrato_maquinaria.naturaleza
      @pais = Pais.find(:all)
      @catalogo                   = Catalogo.new
      @catalogo.seguro = 0.0
      @catalogo.flete = 0.0
      @catalogo.gastos_administrativos = 0.0
      @catalogo.impuesto = 0.0
      @catalogo.almacenamiento = 0.0
      @catalogo.monto = 0.0
      @catalogo.monto_real = 0.0
      @catalogo.id = params[:id]
      render :update do |page|
        if @naturaleza == 'I'
          page.replace_html 'contrato-select', :partial => 'contrato_select'
          page.show 'contrato-select' 
        else
          page.hide 'contrato-select'
        end
        page.replace_html 'imputaciones-select', :partial => 'imputaciones'
#        page.replace_html 'contrato-search', :partial => 'contrato_search'
#        page.show 'contrato-search'
        page.show 'imputaciones-select'
      end
    else
#      @almacen_maquinaria = []
      render :update do |page|
        page.replace_html 'contrato-search', :partial => 'contrato_search'
#        page.show 'contrato-search'
        page.hide 'contrato-select'
        page.hide 'imputaciones-select'
      end
    end
  end

  def edit
    @imputaciones = ImputacionesMaquinaria.find(:first, :order => 'id desc')
    @tipo_maquinaria_list       = TipoMaquinaria.find(:all)
    @contrato_maquinaria_equipo = ContratoMaquinariaEquipo.find(:all)       
    @clase                      = Clase.find(:all)
    @pais                       = Pais.find(:all)
    @catalogo                   = Catalogo.find(params[:id])
    @almacen_maquinaria         = AlmacenMaquinaria.find(:all, :order => "nombre")
    @marca = MarcaMaquinaria.find(:all, :conditions => "activo = true", :order => "nombre")
    @modelo = Modelo.find(:all, :conditions => "activo = true", :order => "nombre")
    @almacen_maquinaria_sucursal = AlmacenMaquinariaSucursal.find(:all, :conditions=>["activo = true and almacen_maquinaria_id = ?", @catalogo.almacen_maquinaria_id],:order=>"nombre")
    @moneda_activa = ParametroGeneral.first.moneda_id
    contrato = ContratoMaquinariaEquipo.find(@catalogo.contrato_maquinaria_equipo_id)
    @naturaleza = contrato.naturaleza
    if contrato.naturaleza == 'I'
      @pais = Pais.find(:all)
      @view_contrato = true
    end

    render :update do |page|
      page.form_reset
      page.hide "row_#{@catalogo.id}"
      page.insert_html :after, "row_#{@catalogo.id}", :partial => 'edit'
      page.show "row_#{@catalogo.id}_edit"
    end
  end

  def save_edit
    @catalogo = Catalogo.find(params[:id])
    if @catalogo.update_attributes(params[:catalogo])
      @catalogo.usuario_ultima_actualizacion_id = @usuario.id
      @catalogo.save
      message = "#{I18n.t('Sistema.Body.Vistas.General.el').capitalize} #{I18n.t('Sistema.Body.Vistas.General.item')} #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      render :update do |page|
        page.hide 'error'
        page.remove "row_#{@catalogo.id}"
        page.insert_html :after, "row_#{@catalogo.id}_edit", :partial => 'row', :locals=>{ :even_odd => 0 }
        page.remove "row_#{@catalogo.id}_edit"
        page.show "row_#{@catalogo.id}"
        page.visual_effect :highlight, "row_#{@catalogo.id}", :duration => 0.6
        page.replace_html 'message', message
        page.show 'message'
      end 
    else
      render :update do |page|
        page.form_error "row_#{@catalogo.id}"
        page.<< "varEnviado = false;"
      end
    end
  end
  
  def cancel_edit
    @catalogo = Catalogo.find(params[:id])
    render :update do |page|
      page.form_reset
      page.remove "row_#{@catalogo.id}_edit"
      page.show "row_#{@catalogo.id}"
    end
  end
  
  def cancel_new
    render :update do |page|
      page.form_reset
      page.show 'button_new'
      page.replace_html 'form_new', ""
      page.hide 'form_new'
    end
  end
  
  def delete
    @catalogo = Catalogo.find(params[:id])
    form_delete @catalogo
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Controladores.Catalogo.FormTitles.form_title')
    @form_title_record   =  I18n.t('Sistema.Body.Controladores.Catalogo.FormTitles.form_title_record')
    @form_title_records  = I18n.t('Sistema.Body.Controladores.Catalogo.FormTitles.form_title_records')
    @form_entity         = 'catalogo'
    @width_layout        = '1000'
    @records_by_page     = 50
  end

end
