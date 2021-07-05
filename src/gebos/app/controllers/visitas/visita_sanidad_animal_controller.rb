# encoding: utf-8
class Visitas::VisitaSanidadAnimalController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[ :tabs, :save_new_vacunacion, :delete_vacunacion]
    
  def index
    @visitas = SeguimientoVisita.find(params[:id])
  end
	
  def edit
    @visitas = SeguimientoVisita.find(params[:id])
    @manejo_instalaciones = ManejoInstalaciones.find_by_seguimiento_visita_id(params[:id])
    if @manejo_instalaciones.nil?
      @manejo_instalaciones = ManejoInstalaciones.new(:seguimiento_visita_id =>params[:id])
    end
    @sanidad_animal = SanidadAnimal.find_by_seguimiento_visita_id(params[:id])
    @vacunas = Vacunacion.new
    if @sanidad_animal.nil?
      @vacunacion_list = []
      @sanidad_animal = SanidadAnimal.new(:seguimiento_visita_id =>params[:id])
    else
      @vacunacion_list = Vacunacion.find(:all, :conditions=>"sanidad_animal_id = #{@sanidad_animal.id}")
    end
    fill_tipo_vacunas
  end

  def cancel_edit
    @visitas = SeguimientoVisita.find(params[:id])
    form_cancel_edit @visitas
  end

  def save_edit
    @manejo_instalaciones = ManejoInstalaciones.find_by_seguimiento_visita_id(params[:id]) 
    if @manejo_instalaciones.nil?
      @manejo_instalaciones = ManejoInstalaciones.new(:seguimiento_visita_id =>params[:id])
    end
    @sanidad_animal = SanidadAnimal.find_by_seguimiento_visita_id(params[:id])
    if @sanidad_animal.nil?
      @sanidad_animal = SanidadAnimal.new(:seguimiento_visita_id =>params[:id])
    end
    @sanidad_animal.save
    
    instalaciones = params[:manejo_instalaciones]

    success = true
#    success &&= initialize_vacunacions
    success &&=  @sanidad_animal.update_attributes(params[:sanidad_animal])


    success &&= @manejo_instalaciones.validar_manejo(instalaciones)
    if success
      @manejo_instalaciones.update_attributes(params[:manejo_instalaciones])

      if @manejo_instalaciones.save
        flash[:notice] = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.Messages.se_actualizo_manejo_instalacion')
        render :update do |page|
          page.redirect_to :action=>'edit', :id=>@manejo_instalaciones.seguimiento_visita_id, :popup=>params[:popup]
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

  
  #VACUNAS
  #"==================================================
  def save_new_vacunacion
    errores = Vacunacion.create_new(params[:vacunacion], params[:sanidad_animal_id])
    if errores == true
      fill_tipo_vacunas
      @sanidad_animal = SanidadAnimal.find(params[:sanidad_animal_id])
      @vacunas = Vacunacion.new
      @vacunacion_list = Vacunacion.find(:all, :conditions=>["sanidad_animal_id = ?", params[:sanidad_animal_id]])
      render :update do |page|
        page.hide 'errorExplanation'
        page.replace_html 'visita_sanidad_animal', :partial => 'vacunas'
        page.replace_html 'message', I18n.t('Sistema.Body.General.guardar')
        page.show 'visita_sanidad_animal'
        page.show 'message'
        page.<< "window.scrollTo(0,200);"
      end
    else
      render :update do |page|
        page.hide 'message'
        page.replace_html 'errorExplanation',"<h2>#{I18n.t('Sistema.Body.General.ocurrio_error')}</h2><p><UL>#{errores}</UL></p>"
        page.show 'errorExplanation'
        page.<< "document.getElementById('agregar_vacuna').style.display= '';"

      end
     
    end
  end

  def delete_vacunacion
    Vacunacion.delete(params[:id])
    fill_tipo_vacunas
    @sanidad_animal = SanidadAnimal.find(params[:sanidad_animal_id])
    @vacunas = Vacunacion.new
    @vacunacion_list = Vacunacion.find(:all, :conditions=>["sanidad_animal_id = ?", params[:sanidad_animal_id]])
    render :update do |page|
      page.hide 'errorExplanation'
      page.replace_html 'visita_sanidad_animal', :partial => 'vacunas'
      page.replace_html 'message', "#{I18n.t('Sistema.Body.General.la')} #{I18n.t('Sistema.Body.Vistas.Vacunacion.Etiquetas.vacunacion')} #{I18n.t('Sistema.Body.Controladores.Mensajes.eliminacion')}"
      page.show 'visita_sanidad_animal'
      page.show 'message'
    end
  end
  
  
  protected
  def common
    super
    accion = params[:action]
    if accion =="delete_vacunacion" || accion == "save_new_vacunacion"
      @sanidad_animal = SanidadAnimal.find(params[:sanidad_animal_id])
      @visitas = SeguimientoVisita.find(@sanidad_animal.seguimiento_visita_id)
    else
      @visitas = SeguimientoVisita.find(params[:id])
    end
    @form_title = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.VisitaSanidadAnimal.FormTitles.form_title_records')
    @form_entity = 'manejo_instalaciones'
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
