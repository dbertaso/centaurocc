# encoding: utf-8
class Visitas::VisitaProduccionLecheCarneController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[ :tabs ]
  
  def index

  end
	
  def edit
    @visitas = SeguimientoVisita.find(params[:id])
    @produccion_leche_carne = ProduccionLecheCarne.find_by_seguimiento_visita_id(params[:id])
    if @produccion_leche_carne.nil?
      @produccion_leche_carne = ProduccionLecheCarne.new(:seguimiento_visita_id =>params[:id])
    end
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end

  def save_edit
    @produccion_leche_carne = ProduccionLecheCarne.find_by_seguimiento_visita_id(params[:id]) 
    if @produccion_leche_carne.nil?
      @produccion_leche_carne = ProduccionLecheCarne.new(:seguimiento_visita_id =>params[:id])
    end
    
      @produccion_leche_carne.update_attributes(params[:produccion_leche_carne])

      if @produccion_leche_carne.save
        flash[:notice] = I18n.t('Sistema.Body.Controladores.VisitaProduccionLecheCarne.Messages.se_actualizo_produccion')
        render :update do |page|
          page.redirect_to :action=>'edit', :id=>@produccion_leche_carne.seguimiento_visita_id, :popup=>params[:popup]
        end
      else
        render :update do |page|
          page.form_error
        end
        return false
      end
  end

 protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaProduccionLecheCarne.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaProduccionLecheCarne.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaProduccionLecheCarne.FormTitles.form_title_records')
    @form_entity = 'produccion_leche_carne'
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