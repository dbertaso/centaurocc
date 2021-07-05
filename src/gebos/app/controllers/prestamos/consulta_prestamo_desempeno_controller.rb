class Prestamos::ConsultaPrestamoDesempenoController < FormTabsController

  layout 'form_basic'

  def view

    @prestamo = Prestamo.find(params[:id])

    unless @prestamo.nil?

      @performance = PerformanceCobranzas.find_by_prestamo_id_and_cliente_id(@prestamo.id, @prestamo.cliente_id)

    end


  end


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ConsultaPrestamoDesempeno.FormTitles.form_title')
    @form_entity = 'prestamo'
    @form_identity_field = 'numero'
    @width_layout = '1200'
  end
end
