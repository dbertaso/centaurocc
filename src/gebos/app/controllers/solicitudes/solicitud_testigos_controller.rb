# encoding: utf-8

#
# autor: 
# clase: Solicitudes::SolicitudTestigosController
# descripción: Migración a Rails 3
#


class Solicitudes::SolicitudTestigosController < FormAjaxController
#layout 'solicitudes/solicitud_testigos'

  def index
    @solicitud_id = params[:solicitud_id]
    list
  end

  def list
    @solicitud_id = params[:solicitud_id]
    params['sort'] = "nombre_testigo" unless params['sort']
    @list = SolicitudTestigos.find(:all,:conditions=>"solicitud_id = #{@solicitud_id}",:order => params['sort'])
    cond="oficina_id = #{session[:oficina]} and activo=true"
    @list_abogado_ofic = Abogado.find(:all,:conditions=>[cond], :order => 'nombre ASC')
    form_list
  end

  def new
    @solicitud_id = params[:solicitud_id]
    @solicitud_testigos = SolicitudTestigos.new   
    form_new @solicitud_testigos
  end

  def save_new
    params[:solicitud_testigos][:solicitud_id] = params[:solicitud_id]    
    params[:solicitud_testigos][:cedula_testigo] = params[:tipo].to_s + params[:solicitud_testigos][:cedula_testigo].to_s unless params[:solicitud_testigos][:cedula_testigo]==''        
    @solicitud_testigos = SolicitudTestigos.new(params[:solicitud_testigos])    
    form_save_new @solicitud_testigos
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @solicitud_testigos = SolicitudTestigos.find(params[:id])
    form_delete @solicitud_testigos
  end
  
  def edit
    @solicitud_testigos = SolicitudTestigos.find(params[:id])
    @solicitud_testigos.cedula_testigo=params[:tipo] + params[:solicitud_testigos][:cedula_testigo] 

    form_edit @solicitud_testigos
  end
  
  def save_edit
    @solicitud_testigos = SolicitudTestigos.find(params[:id])
    @solicitud_testigos.nombre_testigo = params[:solicitud_testigos][:nombre_testigo]
    @solicitud_testigos.cedula_testigo = params[:solicitud_testigos][:cedula_testigo]
    form_save_edit @solicitud_testigos
  end

  def cancel_edit
    @solicitud_testigos = SolicitudTestigos.find(params[:id])
    form_cancel_edit @solicitud_testigos
  end

  protected
  def common
   super
    @form_title = I18n.t('Sistema.Body.Controladores.SolicitudTestigos.FormTitles.form_title',:numero=>Solicitud.find(params[:solicitud_id]).numero) #'Testigos para la Nota de Autenticación del Tramite Nro. ' << Solicitud.find(params[:solicitud_id]).numero.to_s
    @form_title_records = I18n.t('Sistema.Body.Controladores.SolicitudTestigos.FormTitles.form_title_records') #'Testigos'
    @form_title_record = I18n.t('Sistema.Body.Controladores.SolicitudTestigos.FormTitles.form_title_record') #'Testigo'
    @form_entity = 'solicitud_testigos'
    @form_identity_field = 'nombre_testigo'
    
  
  end
  
end
