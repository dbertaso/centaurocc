# encoding: utf-8

#
# autor: Luis Rojas
# clase: Solicitudes::SrasController
# descripción: Migración a Rails 3
#
class Solicitudes::DecisionController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:viable_click, :sector_change, :sub_sector_change, :save_new]

  def edit
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_rubro_sugerido_list = SolicitudRubroSugerido.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
    @viable = @solicitud.decision_final
    @sector_list = Sector.find(:all, :order=>'nombre')
    sub_sector(@sector_list[0].id)
  end

  def viable_click
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_rubro_sugerido_list = SolicitudRubroSugerido.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
    @viable = params[:viable]
    @sector_list = Sector.find(:all, :order=>'nombre')
    sub_sector(@sector_list[0].id)
    render :update do |page|
      page.replace_html 'view-viable', :partial => 'view_viable'
      page.show 'view-viable'
    end
  end

  def sector_change
    sub_sector(params[:sector_id])
    render :update do |page|
      page.replace_html 'sub-sector-select', :partial => 'sub_sector_select'.html_safe
      page.replace_html 'rubro-select', :partial => 'rubro_select'.html_safe
      page.show 'sub-sector-select'
      page.show 'rubro-select'
    end
  end

  def sub_sector_change
    rubro(params[:sub_sector_id])
    render :update do |page|
      page.replace_html 'rubro-select', :partial => 'rubro_select'
      page.show 'rubro-select'
    end
  end
  
  def save_new
    @solicitud = Solicitud.find(params[:solicitud_id])
    @solicitud_rubro_sugerido = SolicitudRubroSugerido.new
    errores = @solicitud_rubro_sugerido.create_new(params)
    if errores == true
      @sector_list = Sector.find(:all, :order=>'nombre')
      sub_sector(@sector_list[0].id)
      @solicitud_rubro_sugerido_list = SolicitudRubroSugerido.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
      @viable = false
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'view-viable', :partial => 'view_viable'
        page.replace_html 'message', "Datos del rubro sugerido se guardaron con éxito"
        page.show 'view-viable'
        page.show 'message'
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation','<h2>Ha ocurrido un error</h2><p><UL>' << errores << '</UL></p>'
        page.show 'errorExplanation'
        page.<< "window.scrollTo(0,0);document.getElementById('agregar').style.display= '';"
      end
    end
  end
  
  def save_edit
    @solicitud = Solicitud.find(params[:solicitud_id])
    form_save_edit @solicitud, :value=>@solicitud.save_viable(params[:solicitud]),
      :params=> { :solicitud_id => @solicitud.id }
  end
  
  def delete
    @solicitud = Solicitud.find(params[:solicitud_id])
    solicitud_rubro_sugerido = SolicitudRubroSugerido.find(params[:id])
    solicitud_rubro_sugerido.destroy
    @sector_list = Sector.find(:all, :order=>'nombre')
    sub_sector(@sector_list[0].id)
    @solicitud_rubro_sugerido_list = SolicitudRubroSugerido.find(:all, :conditions=>['solicitud_id = ?', @solicitud.id])
    @viable = false
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'view-viable', :partial => 'view_viable'
      page.replace_html 'message', "#{I18n.t('Sistema.Body.Vistas.General.datos_rubro_sugerido')} #{I18n.t('Sistema.Body.Controladores.Mensaje.eliminacion')}"
      page.show 'view-viable'
      page.show 'message'
    end
  end
  
  protected
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.Vistas.General.registro')} #{I18n.t('Sistema.Body.Vistas.General.de')} #{I18n.t('Sistema.Body.Vistas.General.informe_recomendacion')}"
    @form_title_record = "#{I18n.t('Sistema.Body.Vistas.General.solicitud')} #{I18n.t('Sistema.Body.Vistas.General.numero')}"
    @form_title_records = 'Solicitudes'
    @form_entity = 'solicitud_desicion'
    @form_identity_field = 'numero'
    @width_layout = '920'
  end

  private
  def sub_sector(id)
    unless id.blank?
      @sub_sector_list = SubSector.find(:all, :conditions=>['activo = true and sector_id = ?', id], :order=>'nombre')
    end
    rubro(nil)
  end

  def rubro(id)
    unless id.nil?
      @rubro_list = Rubro.find(:all, :conditions=>['activo = true and sub_sector_id = ?', id], :order => 'nombre')
    else
      @rubro_list = Rubro.find(:all, :conditions=>['activo = true and sub_sector_id = ?', 0], :order => 'nombre')
    end
  end
  
end