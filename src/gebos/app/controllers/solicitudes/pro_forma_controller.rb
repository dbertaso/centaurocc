# encoding: UTF-8
#
# autor: Luis Rojas
# clase: Solicitudes::ProFormaController
# descripción: Migración a Rails 3
#
class Solicitudes::ProFormaController < FormTabsController

  layout 'form_basic'
  
  def index
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => "estatus = 'P' and solicitud_id = #{@solicitud.id}")
    @maquinaria_total = SolicitudMaquinaria.count(:conditions => "solicitud_id = #{@solicitud.id} and estatus = 'P' and proforma_id is null")
		list
	end

  def list
    params['sort'] = "numero" unless params['sort']
    @conditions = "solicitud_id = #{params[:solicitud_id]}"
    @list = Proforma.search(@conditions, params[:page], params['sort'])
    @total=@list.count

    form_list
  end
	
  def new
    @proforma = Proforma.new
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_maquinaria = SolicitudMaquinaria.find(:all, :conditions => "solicitud_id = #{@solicitud.id} and estatus = 'P' and proforma_id is null", :order => 'tipo_maquinaria_id')
    @casa_proveedora_select = CasaProveedora.find(:all, :conditions => "activo = true", :order => "nombre")
  end
  
  def save_new
    @solicitud = Solicitud.find(params[:solicitud_id])
    @proforma = Proforma.new(params[:proforma])
    @proforma.usuario_id = @usuario.id
    @proforma.solicitud_id = @solicitud.id
    if @proforma.save_new(params) == true
      flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.proforma')} #{@proforma.numero} #{I18n.t('Sistema.Body.Controladores.Mensaje.creacion')}"
      render :update do |page|
        page.redirect_to :action=>'index', :solicitud_id => @solicitud.id, :popup=>true
      end
    else
      render :update do |page|
        page.form_error
      end
      return
    end
  end
  
  def delete
    @proforma = Proforma.find(params[:id])
    result = @proforma.eliminar(@proforma.id)
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      @solicitud_maquinaria_list = SolicitudMaquinaria.find(:all, :conditions => "estatus = 'P' and solicitud_id = #{@proforma.solicitud_id}")
      render :update do |page|
        page.form_delete @proforma, 'proforma'
        page.replace_html 'lista_maq', :partial => 'lista_maq'
      end
    end
  end
  
  def edit
    @proforma = Proforma.find(params[:id])
    @solicitud_maquinaria = SolicitudMaquinaria.find(:all, :conditions => "solicitud_id = #{@proforma.solicitud_id} and estatus = 'P' and (proforma_id = #{@proforma.id} or proforma_id is null)", :order => 'tipo_maquinaria_id')
    @casa_proveedora_select = CasaProveedora.find(:all, :conditions => "activo = true", :order => "nombre")
    @ids = ""
    @solicitud_maquinaria.each{|m|
      unless m.proforma_id.nil?
        @ids << "#{m.id},"
      end
    }
  end
  
  def save_edit
    @proforma = Proforma.find(params[:id])
    @proforma.usuario_id = @usuario.id
    if @proforma.save_edit(params) == true
      flash[:notice] = "#{I18n.t('Sistema.Body.Vistas.General.la').capitalize} #{I18n.t('Sistema.Body.Vistas.General.proforma')} #{@proforma.numero} #{I18n.t('Sistema.Body.Controladores.Mensaje.modificacion')}"
      render :update do |page|
        page.redirect_to :action=>'index', :solicitud_id => @proforma.solicitud_id, :popup=>true
      end
    else
      render :update do |page|
        page.form_error
      end
      return
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.General.proforma')
    @form_title_record = I18n.t('Sistema.Body.Vistas.General.proforma')
    @form_title_records = I18n.t('Sistema.Body.Vistas.General.proforma')
    @form_entity = 'proforma'
    @form_identity_field = 'numero'
    @width_layout = '990'
  end

end
