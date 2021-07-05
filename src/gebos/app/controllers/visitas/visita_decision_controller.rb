# encoding: utf-8
class Visitas::VisitaDecisionController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :change_decision ]
  
  def index
  end
	
  def edit
    @visitas = SeguimientoVisita.find(params[:id])
    @seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(params[:id])
    @decision_visita = DecisionVisita.find_by_seguimiento_visita_id(params[:id])
    if @decision_visita.nil?
      @decision_visita = DecisionVisita.new(:seguimiento_visita_id =>params[:id])
      @decision = 'false'
    else
      @decision = @decision_visita.recomienda_generar_desembolso.to_s
    end
    fill
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end

  def save_edit
    @seguimiento_cultivo = SeguimientoCultivo.find_by_seguimiento_visita_id(params[:id])
    @decision_visita = DecisionVisita.find_by_seguimiento_visita_id(params[:id])
    if @decision_visita.nil?
      @decision_visita = DecisionVisita.new(:seguimiento_visita_id =>params[:id])
    end
    success = true
    success &&= @decision_visita.validar_casos_medidas(params)
    if success
      if @decision_visita.seguimiento_visita.solicitud.sub_sector.nemonico=="VE" && params[:decision_visita][:recomienda_generar_desembolso]=='true'
        success &&= @seguimiento_cultivo.validar_recomendar(params)
      end
      if success
        @decision_visita.update_attributes(params[:decision_visita])
        if @decision_visita.save
          @decision_visita.validar_recomendacion

          render :update do |page|
            page.replace_html 'messages', I18n.t('Sistema.Body.Controladores.VisitaDecision.Messages.decision_se_actualizo')
            page.hide 'error'
            page.show 'messages'
            page.redirect_to :action=>'edit', :id=>@decision_visita.seguimiento_visita_id, :popup=>params[:popup], :siniestro_checked=>params[:siniestro_checked]
          end
        else
          render :update do |page|
            page.hide 'messages'
            page.form_error
          end
          return false
        end
      else
        render :update do |page|
          page.hide 'messages'
          page.form_error
        end
        return false
      end
    else
      render :update do |page|
        page.hide 'messages'
        page.form_error
      end
      return false

    end
  end


  def presenta_siniestro_click

      logger.info "presenta siniestro " << params[:val].to_s << " id " << params[:id].to_s
    @visitas = SeguimientoVisita.find(params[:id])


      if params[:val]=="false"
          @tengo_siniestro="0"
          tipo="?siniestro_checked=0"
         if @visitas.solicitud.sub_sector.nemonico=="AN" 
             siniestro_partial='sin_siniestro_pastizales_potreros'

         elsif @visitas.solicitud.sub_sector.nemonico=="VE" 
             siniestro_partial='sin_siniestro_seguimiento_cultivo'

         elsif @visitas.solicitud.sub_sector.nemonico=="AC" 
             siniestro_partial='sin_siniestro_condiciones_acuicultura'

         elsif @visitas.solicitud.sub_sector.nemonico=="PE" 

             siniestro_partial='sin_siniestro_control_visitas_pesca'
         elsif @visitas.solicitud.sub_sector.nemonico=="MA" 

             siniestro_partial='sin_siniestro_control_visitas_maquinaria'
         end 

      else
         @tengo_siniestro="1"
          tipo="?siniestro_checked=1"
         if @visitas.solicitud.sub_sector.nemonico=="AN" 
             siniestro_partial='con_siniestro_pastizales_potreros'
             mensajito="Lo sentimos, no posee pastizales potreros ni semovientes" if ( @visitas.pastizales_potreros.nil?  &&  @visitas.semovientes.nil? )

         elsif @visitas.solicitud.sub_sector.nemonico=="VE" 
             siniestro_partial='con_siniestro_seguimiento_cultivo'
             mensajito="Lo sentimos, no posee seguimiento de cultivo" if @visitas.seguimiento_cultivo.nil?

         elsif @visitas.solicitud.sub_sector.nemonico=="AC" 
             siniestro_partial='con_siniestro_condiciones_acuicultura'
             mensajito='*'
         elsif @visitas.solicitud.sub_sector.nemonico=="PE" 

             siniestro_partial='con_siniestro_control_visitas_pesca'
             mensajito='*'
         elsif @visitas.solicitud.sub_sector.nemonico=="MA" 

             siniestro_partial='con_siniestro_control_visitas_maquinaria'
             mensajito='*'

         end 

      end


      render :update do |page|
        #page.call 'actualizar_form',params[:id],tipo
        page.replace_html 'tabs', :partial => siniestro_partial
        page.replace_html 'mensajito', mensajito unless mensajito=='*' 
      end

  end



  def change_decision
    @decision = params[:decision].to_s
    @visitas = SeguimientoVisita.find(params[:id])
logger.info"XXXXXXXXX==============PASO==============>>>>"
      render :update do |page|
        page.replace_html 'decision-div', :partial => 'decision'
      end
  end

 protected
  def common
    super
    @visitas = SeguimientoVisita.find(params[:id])
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaDecision.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaDecision.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaDecision.FormTitles.form_title_records')
    @form_entity = 'Decisión'
    @form_identity_field = 'id'
    @width_layout = '1080'
    @full_info = "#{@visitas.codigo_visita} #{I18n.t('Sistema.Body.Vistas.General.del')} #{I18n.t('Sistema.Body.General.solicitud')} #{@visitas.solicitud.numero} (#{@visitas.solicitud.nombre})"

  end

  def fill
    @caso_medida_select = CasoMedida.find(:all, :conditions=>'activo = true', :order=>'descripcion')
  end

end
