# encoding: utf-8
class Basico::CondicionesAnalisisCreditoController < FormAjaxTabsController

  def index
      @condicionamientos_narrativa_libre = CondicionamientosNarrativaLibre.find(:first)
  end

  def cancel_new
    form_cancel_new
  end

  def save_edit
      @condicionamientos_narrativa_libre = CondicionamientosNarrativaLibre.find(:first)

      if (@condicionamientos_narrativa_libre.nil?)
        @condicionamientos_narrativa_libre = CondicionamientosNarrativaLibre.new(params[:condicionamientos_narrativa_libre])
        value =@condicionamientos_narrativa_libre.save
      else
        value = @condicionamientos_narrativa_libre.update_attributes(params[:condicionamientos_narrativa_libre])
      end

    if value 
        flash[:notice] = I18n.t('Sistema.Body.Controladores.CondicionesAnalisisCredito.Mensajes.notice')
        new_option = {:action=>'index'}
        render :update do |page|
        page.redirect_to new_option
        end
    else
      render :update do |page|
        page.form_error
      end
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.CondicionesAnalisisCredito.Header.form_title')
    @form_title_records = I18n.t('Sistema.Body.Vistas.CondicionesAnalisisCredito.Header.form_title')
    @form_entity = 'condicionamientos_narrativa_libre'
    @form_identity_field = 'monto_credito_recomendado'
    @width_layout = '1000'
  end

end