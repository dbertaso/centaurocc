# encoding: utf-8
class Visitas::CondicionesAcuiculturaController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :view, :cancel_view]
  
def index	
  @visitas = SeguimientoVisita.find(params[:id])
  list  
end
	
def list
  @visitas = SeguimientoVisita.find(params[:id])
  @condiciones_acuicultura = CondicionesAcuicultura.find(:all, :conditions => ['solicitud_id = ?', @visitas.solicitud_id])
  params['sort'] = "espejo_agua" unless params['sort']
  
  conditions = "solicitud_id = #{@visitas.solicitud_id}"
  @list = CondicionesAcuicultura.search(conditions, params[:page], params[:sort])
  @total=@list.count
  form_list
end
		
def new
  fill_condiciones_acuicultura    
  @condiciones_acuicultura = CondicionesAcuicultura.new
  @visitas = SeguimientoVisita.find(params[:id])    
  @condiciones_acuicultura.solicitud_id=@visitas.solicitud_id
  form_new @condiciones_acuicultura
end
  
def cancel_new
  form_cancel_new
end
  
def save_new
  @visitas = SeguimientoVisita.find(params[:id])
  @condiciones_acuicultura = CondicionesAcuicultura.new(params[:condiciones_acuicultura])
  @condiciones_acuicultura.seguimiento_visita_id = @visitas.id
  @condiciones_acuicultura.solicitud_id = @visitas.solicitud_id
  form_save_new @condiciones_acuicultura
end
  
def delete
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  form_ajaxdelete @condiciones_acuicultura    
end
  
def edit
  fill_condiciones_acuicultura
  @visitas = SeguimientoVisita.find(params[:id])
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  form_edit @condiciones_acuicultura
end

def save_edit
  @id_condiciones_acuicultura=params[:id_condiciones_acuicultura]
  @visitas = SeguimientoVisita.find(params[:id])
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  form_save_edit @condiciones_acuicultura
end
  
def cancel_edit 
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  @visitas = SeguimientoVisita.find(params[:id])
  form_cancel_edit @condiciones_acuicultura
end


def view
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  form_view @condiciones_acuicultura
end

def cancel_view
  @condiciones_acuicultura = CondicionesAcuicultura.find(params[:id_condiciones_acuicultura])
  @visitas = SeguimientoVisita.find(params[:id])
  form_cancel_view @condiciones_acuicultura
end


protected
def common
  super
  @visitas = SeguimientoVisita.find(params[:id])
  @form_title =  I18n.t('Sistema.Body.Controladores.VisitaDescripcionesEspesificas.FormTitles.form_title')
  @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaCondicionesAcuicultura.FormTitles.form_title_record')
  @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaCondicionesAcuicultura.FormTitles.form_title_records')
  @form_entity = 'condiciones_acuicultura'
  @form_identity_field = 'espejo_agua'
  @width_layout = '1080'
  @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"
end



def fill_condiciones_acuicultura
  @tipo_especie  = TipoEspecieAcuicultura.find(:all, :order=>'nombre')
  @proveedor_marino = ProveedorMarino.find(:all, :order=>'nombre')
end


end
